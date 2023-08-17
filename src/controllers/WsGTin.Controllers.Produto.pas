unit WsGTin.Controllers.Produto;

interface

uses
  Horse,
  Horse.Exception,
  Horse.OctetStream,

  System.SysUtils,
  System.JSON,
  System.Classes,
  System.IOUtils,

  Database.Factory,

  main.control,

  WsGTin.Model.Factory,

  Horse.JsonInterceptor.Helpers;

procedure Registry;
//procedure ConfigSwagger;

implementation

var LPath: String = '';

function RemoveAcento(const ptext: string):string;
type
  usaascii20127 = type ansistring(20127);
begin
  result := string(usaascii20127(ptext));
end;

function SomenteNumero(snum: string): string;
var s1, s2: string;
  i: integer;
begin
  s1 := snum;
  s2 := '';
  for i := 1 to length(s1) do
    if s1[i] in ['0' .. '9'] then
    s2:=s2 + s1[i];
  result:=s2;
end;

procedure GetProduto(Req: THorseRequest; Res: THorseResponse);
begin
  var LEanCode := Req.Params.Field('ean')
    .Required
    .RequiredMessage('Necessario enviar o codigo ean da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789')
    .AsString;

  var LProduto := TWsGTinModelFactory.New
    .Produto
    .ObterProdutoPorEan(LEanCode);

  Res.Send(TJson.ObjectToJsonObject(LProduto));
end;

procedure GetProdutoFotoExiste(Req: THorseRequest; Res: THorseResponse);
var
  LFile: String;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789')
    .AsString;

  LFile := TMainControl.GetInstance.GetPath + somentenumero(LId) + '.png';

//  if mainview.MemoHistorico.lines.count > 10000 then
//  mainview.MemoHistorico.lines.clear;
  if FileExists(LFile) then
  begin
    Res.Send('Sim').Status(200);

//  inc(cont200);
//  mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Consulta Arquivo : '+lfile+' Sim');
  end
  else
  begin
    Res.Send('Nao').Status(200);

//  inc(cont200);
//  mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Consulta Arquivo : '+lfile+' Nao');
  end;
end;

procedure GetProdutoFoto(Req: THorseRequest; Res: THorseResponse);
var
  LFile: String;
  wjson: tjsonobject;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789')
    .AsString;

  LFile := TMainControl.GetInstance.GetPath + somentenumero(Lid) + '.png';

//  if mainview.MemoHistorico.lines.count > 10000 then
//  mainview.MemoHistorico.lines.clear;

  wjson:=tjsonobject.Create;

  if FileExists(LFile) then
  begin
    try
      wjson.AddPair(tjsonpair.Create('Status','200'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Foto encontrada: '+LId));
      Res.Send<TJSONobject>(wjson).Status(200);;
//    Res.Send('Sim').Status(200);

//    inc(cont200);
//    mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Consulta Arquivo : '+lfile+' Sim');
    finally
    end;
  end
  else
  begin
    wjson.AddPair(tjsonpair.Create('Status','404'));
    wjson.AddPair(tjsonpair.Create('Status_Desc','Foto nao encontrada: '+LId));
    Res.Send<TJSONobject>(wjson).Status(200);;
//  Res.Send('Nao').Status(200);
//  inc(cont200);
//  mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Consulta Arquivo : '+lfile+' Nao');
  end;
end;

procedure GetProdutoGTIN(Req: THorseRequest; Res: THorseResponse);
var
  LFile: String;
  LFileSend: TFileReturn;
  LStream: TFileStream;
  LDisposition: String;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789')
    .AsString;

  LFile := TMainControl.GetInstance.GetPath + SomenteNumero(LId) + '.png';

//if fileexists(lfile) = false then baixacosmos(somentenumero(LId));

//if mainview.MemoHistorico.lines.count > 10000 then
//mainview.MemoHistorico.lines.clear;

  if FileExists(LFile) then
  begin
    try
      LStream   := TFileStream.Create(LFile, fmOpenRead);
      LFileSend := TFileReturn.Create( TPath.GetFileName(LFile), LStream, False);
      Res.Send<TFileReturn>(LFileSend).Status(200);

//      inc(cont200);
//      mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue arquivo: '+lfile);
    finally
    end;
  end
  else
  begin
    //quando pede foto eu nao envio json no retorno para evitar erro na conversao do lado do cliente
//    inc(cont404);
//
//    mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Arquivo nao encontrado: '+lfile);
    Res.Send('').Status(404);
  end;
end;

procedure Registry;
begin
  THorse
    .Get('/api/produto/:ean', GetProduto)

    // TODO: Essas rotas deverão ser removidas e adotar estratégia de static files
    .Get('/api/fotoexiste/:id', GetProdutoFotoExiste)
    .Get('/api/gtin/:id', GetProdutoGTIN)
  ;
end;

end.
