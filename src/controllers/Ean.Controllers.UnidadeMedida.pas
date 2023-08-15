unit Ean.Controllers.UnidadeMedida;

interface

uses
  Horse,
  Horse.Exception;

procedure Registry;

implementation

uses
  System.JSON,
  Database.Factory;

function RemoveAcento(const ptext: string):string;
type
  usaascii20127 = type ansistring(20127);
begin
  result := string(usaascii20127(ptext));
end;

procedure GetDescricaoUnidadeMedida(Req: THorseRequest; Res: THorseResponse);
var wjson: tjsonobject;
begin
 var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da unidade de medida. Ex: www.eanpictures.com.br:9000/api/um/M3')
    .AsString;

  {if mainview.MemoHistorico.lines.count > 10000 then
      mainview.MemoHistorico.lines.clear;} // Alterar para estratégia de Log no Console

  var ds := TDatabaseFactory.New.SQL
    .SQL('select nome from unidade_medida where id = :id')
    .ParamList
      .AddString('id', LId)
      .&End
    .Open;

  if not ds.IsEmpty then
  begin
    Res.Send(ds.FieldByName('nome').asstring).Status(200);
//  inc(cont200);
//  mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+
//  timetostr(now)+'| Entregue descricao unidade medida: '+LId+ '|' +
//    ds.FieldByName('nome').asstring);
  end
  else
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','404'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para a unidade de medida: '+LId));
      Res.Send<TJSONobject>(wjson).Status(404);;

//    inc(cont404);
//    mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada a unidade de meida: '+LId);
    finally
    end;
  end;
end;

procedure GetUnidadeMedida(Req: THorseRequest; Res: THorseResponse);
var wjson: tjsonobject;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da unidade de medida. Ex: www.eanpictures.com.br:9000/api/um/M3')
    .AsString;

  var ds := TDatabaseFactory.New.SQL
    .SQL('select id, nome from unidade_medida where id = :id')
    .ParamList
      .AddString('id', LId)
      .&End
    .Open();

  if not ds.IsEmpty then
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','200'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Ok'));
      wjson.AddPair(tjsonpair.Create('id',removeacento(ds.FieldByName('id').AsString)));
      wjson.AddPair(tjsonpair.Create('nome',removeacento(ds.FieldByName('nome').AsString)));
      Res.Send<TJSONobject>(wjson).Status(200);;

//        inc(cont200);
//        mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue descricao unidade medida: '+
//          LId+ '|' +ds.fieldbyname('nome').asstring);

    finally
    end;
  end
  else
  begin
    try
      wjson:=tjsonobject.Create;
      wjson.AddPair(tjsonpair.Create('Status','404'));
      wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para a unidade de medida: '+LId));
      Res.Send<TJSONobject>(wjson).Status(404);;

//        inc(cont404);
//        mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada a unidade de meida: '+LId);
    finally
    end;
  end;
end;

procedure Registry;
begin
   THorse
     .Get('/api/um2/:id', GetDescricaoUnidadeMedida)
     .Get('/api/um/:id', GetUnidadeMedida)
   ;
end;

end.
