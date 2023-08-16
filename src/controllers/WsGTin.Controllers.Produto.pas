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

  WsGTin.Model.Factory;

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

procedure GetDescricao200Produto(Req: THorseRequest; Res: THorseResponse);
var wjson: tjsonobject;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789')
    .AsString;

  var LSql := #13#10
  + 'SELECT cp.ean, cp.nome, cp.ncm, cp.cest_codigo, cp.embalagem,  '
  + '       cp.quantidade_embalagem, cp.marca, cp.categoria '
  + 'FROM base_produtos.cad_produtos cp '
  + 'where ean = :ean '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(Lsql)
    .ParamList
      .AddString('ean', LId)
      .&End
    .Open();

  if not ds.IsEmpty then
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','200'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Ok'));
      wjson.AddPair(tjsonpair.Create('Nome',removeacento(ds.FieldByName('nome').asstring)));
      wjson.AddPair(tjsonpair.Create('Ncm',removeacento(ds.FieldByName('ncm').asstring)));
      wjson.AddPair(tjsonpair.Create('Cest_Codigo',removeacento(ds.FieldByName('cest_codigo').asstring)));
      wjson.AddPair(tjsonpair.Create('Embalagem',removeacento(ds.FieldByName('embalagem').asstring)));
      wjson.AddPair(tjsonpair.Create('QuantidadeEmbalagem',removeacento(ds.FieldByName('quantidade_embalagem').asstring)));
      wjson.AddPair(tjsonpair.Create('Marca',removeacento(ds.FieldByName('marca').asstring)));
      wjson.AddPair(tjsonpair.Create('Categoria',removeacento(ds.FieldByName('categoria').asstring)));
//    wjson.AddPair(tjsonpair.Create('Peso',removeacento(ds.FieldByName('peso').asstring)));
      wjson.AddPair(tjsonpair.Create('Peso',''));
//    wjson.AddPair(tjsonpair.Create('id_categoria',removeacento(ds.FieldByName('id_categoria').asstring)));
      wjson.AddPair(tjsonpair.Create('id_categoria',''));
//    wjson.AddPair(tjsonpair.Create('tributacao',removeacento(ds.FieldByName('tributacao').asstring)));
      wjson.AddPair(tjsonpair.Create('tributacao',''));
      Res.Send<TJSONobject>(wjson).Status(200);;

//    inc(cont200);
//    mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+
//     timetostr(now)+'| Entregue json: '+LId+ '|' +ds.FieldByName('nome').asstring);
    finally
    end;
  end
  else
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','404'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','404'));
      wjson.AddPair(tjsonpair.Create('Nome','404'));
      wjson.AddPair(tjsonpair.Create('Ncm','404'));
      wjson.AddPair(tjsonpair.Create('Cest_Codigo','404'));
      wjson.AddPair(tjsonpair.Create('Embalagem','404'));
      wjson.AddPair(tjsonpair.Create('QuantidadeEmbalagem','0'));
      wjson.AddPair(tjsonpair.Create('Marca','404'));
      wjson.AddPair(tjsonpair.Create('Categoria','404'));
      wjson.AddPair(tjsonpair.Create('Peso','0'));
      wjson.AddPair(tjsonpair.Create('id_categoria','0'));
      wjson.AddPair(tjsonpair.Create('tributacao','404'));
      Res.Send<TJSONobject>(wjson).Status(200);;

//    inc(cont404);
//    mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+LId);
    finally
    end;
  end;
end;

procedure GetDescricaoProduto(Req: THorseRequest; Res: THorseResponse);
var wjson: tjsonobject;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789')
    .AsString;

//if mainview.MemoHistorico.lines.count > 10000 then
//    mainview.MemoHistorico.lines.clear;

  var ds := TDatabaseFactory.New.SQL
    .SQL('select nome, ncm, cest_codigo, embalagem, quantidade_embalagem, marca, categoria from cad_produtos where ean = :ean')
    .ParamList
      .AddString('ean', LId)
      .&End
    .Open;

  if ds.IsEmpty = false then
  begin
    Res.Send(ds.FieldByName('nome').asstring).Status(200);
//  inc(cont200);
//  mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue descricao: '+
//  LId+ '|' +ds.FieldByName('nome').AsString);
  end
  else
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','404'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para o ean: '+LId));
      Res.Send<TJSONobject>(wjson).Status(404);;
//    inc(cont404);
//    mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+
//      timetostr(now)+'| Descricao nao encontrada para o ean: '+LId);
    finally
    end;
  end;
end;

procedure GetProduto(Req: THorseRequest; Res: THorseResponse);
var wjson: tjsonobject;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789')
    .AsString;

  //    if mainview.MemoHistorico.lines.count > 10000 then
//    mainview.MemoHistorico.lines.clear;

  var LSql := #13#10
  + 'SELECT cp.ean, cp.nome, cp.ncm, cp.cest_codigo, cp.embalagem,  '
  + '       cp.quantidade_embalagem, cp.marca, cp.categoria '
  + 'FROM base_produtos.cad_produtos cp '
  + 'where ean = :ean '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(Lsql)
    .ParamList
      .AddString('ean', LId)
      .&End
    .Open();

  if not ds.IsEmpty then
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','200'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Ok'));
      wjson.AddPair(tjsonpair.Create('Nome',removeacento(ds.FieldByName('nome').asstring)));
      wjson.AddPair(tjsonpair.Create('Ncm',removeacento(ds.FieldByName('ncm').asstring)));
      wjson.AddPair(tjsonpair.Create('Cest_Codigo',removeacento(ds.FieldByName('cest_codigo').asstring)));
      wjson.AddPair(tjsonpair.Create('Embalagem',removeacento(ds.FieldByName('embalagem').asstring)));
      wjson.AddPair(tjsonpair.Create('QuantidadeEmbalagem',removeacento(ds.FieldByName('quantidade_embalagem').asstring)));
      wjson.AddPair(tjsonpair.Create('Marca',removeacento(ds.FieldByName('marca').asstring)));
      wjson.AddPair(tjsonpair.Create('Categoria',removeacento(ds.FieldByName('categoria').asstring)));
//              wjson.AddPair(tjsonpair.Create('Peso',removeacento(ds.FieldByName('peso').asstring)));
      wjson.AddPair(tjsonpair.Create('Peso',''));
//              wjson.AddPair(tjsonpair.Create('id_categoria',removeacento(ds.FieldByName('id_categoria').asstring)));
      wjson.AddPair(tjsonpair.Create('id_categoria',''));
//              wjson.AddPair(tjsonpair.Create('tributacao',removeacento(ds.FieldByName('tributacao').asstring)));
      wjson.AddPair(tjsonpair.Create('tributacao',''));
      Res.Send<TJSONobject>(wjson).Status(200);;

//        inc(cont200);
//        mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+
//          timetostr(now)+'| Entregue json: '+LId+ '|' +ds.FieldByName('nome').asstring);
    finally
    end;
  end
  else
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','404'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para o ean: '+LId));
      Res.Send<TJSONobject>(wjson).Status(404);;

//        inc(cont404);
//        mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+LId);
    finally
    end;
  end;
end;

procedure GetProdutoINI(Req: THorseRequest; Res: THorseResponse);
var oini: tstringlist;
var wjson: tjsonobject;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789')
    .AsString;

//  if mainview.MemoHistorico.lines.count > 10000 then
//    mainview.MemoHistorico.lines.clear;

  var LSql := #13#10
  + 'SELECT cp.ean, cp.nome, cp.ncm, cp.cest_codigo, cp.embalagem,  '
  + '       cp.quantidade_embalagem, cp.marca, cp.categoria '
  + 'FROM base_produtos.cad_produtos cp '
  + 'where ean = :ean '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(Lsql)
    .ParamList
      .AddString('ean', LId)
      .&End
    .Open();

  if not ds.IsEmpty then
  begin
    try
      oini:=TStringList.Create;
      oini.Add('[GENERAL]');
      oini.Add('Nome='+removeacento(ds.FieldByName('nome').asstring));
      oini.Add('Ncm='+removeacento(ds.FieldByName('ncm').asstring));
      oini.Add('Cest_Codigo='+removeacento(ds.FieldByName('cest_codigo').asstring));
      oini.Add('Embalagem='+removeacento(ds.FieldByName('embalagem').asstring));
      oini.Add('QuantidadeEmbalagem='+removeacento(ds.FieldByName('quantidade_embalagem').asstring));
      oini.Add('Marca='+removeacento(ds.FieldByName('marca').asstring));
      oini.Add('Categoria='+removeacento(ds.FieldByName('categoria').asstring));
      oini.Add('Peso='+'');
//    oini.Add('id_categoria='+removeacento(ds.FieldByName('id_categoria').asstring));
      oini.Add('id_categoria='+'');
//    oini.Add('tributacao'+removeacento(ds.FieldByName('tributacao').asstring));
      oini.Add('tributacao='+'');
      Res.Send(oini.TEXT).Status(200);

      freeandnil(oini);

//    inc(cont200);
//    mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+
//      timetostr(now)+'| Entregue INI: '+LId+ '|' +ds.FieldByName('nome').asstring);
    finally
    end;
  end
  else
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','404'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para o ean: '+LId));
      Res.Send<TJSONobject>(wjson).Status(404);;

//    inc(cont404);
//    mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+LId);
    finally
    end;
  end;
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
    .Get('/api/descricao/:id', GetDescricaoProduto)
    .Get('/api/desc200/:id', GetDescricao200Produto)
    .Get('/api/desc/:id', GetProduto)
    .Get('/api/desc_ini/:id', GetProdutoINI)
    .Get('/api/fotoexiste/:id', GetProdutoFotoExiste)
    .Get('/api/gtin/:id', GetProdutoGTIN)
  ;
end;

end.
