unit Ean.Controllers.Produto;

interface

uses
  Horse,
  Horse.Exception,
  System.JSON,
  Database.Factory;

procedure Registry;
//procedure ConfigSwagger;

implementation

function RemoveAcento(const ptext: string):string;
type
  usaascii20127 = type ansistring(20127);
begin
  result := string(usaascii20127(ptext));
end;

procedure GetDescricaoProduto(Req: THorseRequest; Res: THorseResponse);
var wjson: tjsonobject;
begin
  if Req.Params.Items['id'] <> '' then
  begin
//    if mainview.MemoHistorico.lines.count > 10000 then
//    mainview.MemoHistorico.lines.clear;

    var ds:= TDatabaseFactory.New.SQL
      .SQL('select nome, ncm, cest_codigo, embalagem, quantidade_embalagem, marca, categoria from cad_produtos where ean = :ean')
      .ParamList
        .AddString('ean', Req.Params.Items['id'])
        .&End
      .Open;

    if ds.IsEmpty = false then
    begin
      Res.Send(ds.FieldByName('nome').asstring).Status(200);
//      inc(cont200);
//      mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue descricao: '+
//        Req.Params.Items['id']+ '|' +ds.FieldByName('nome').AsString);
    end
    else
    begin
      try
        wjson:=tjsonobject.Create;
        wjson.AddPair(tjsonpair.Create('Status','404'));
        wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para o ean: '+Req.Params.Items['id']));
        Res.Send<TJSONobject>(wjson).Status(404);;
//        inc(cont404);
//        mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+
//          timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);
      finally
      end;
    end;
  end
  else
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','404'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789'));
      Res.Send<TJSONobject>(wjson).Status(404);;

//      inc(cont404);
//      mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);
    finally
    end;
  end;

end

procedure Registry;
begin
  THorse
    .Get('/api/descricao/:id', GetDescricaoProduto)
  ;
end;

end.
