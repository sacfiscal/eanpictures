unit WsGTin.Controllers.UnidadeMedida;

interface

uses
  Horse,
  Horse.Exception;

procedure Registry;

implementation

uses
  System.JSON,
  Database.Factory,

  WsGtin.Model.Factory,
  Horse.JsonInterceptor.Helpers;

procedure GetUnidadeMedida(Req: THorseRequest; Res: THorseResponse);
var wjson: tjsonobject;
begin
  var LId := Req.Params.Field('id')
    .Required
    .RequiredMessage('Necessario enviar o codigo da unidade de medida. Ex: www.eanpictures.com.br:9000/api/um/M3')
    .AsString;

  var LUnidadeMedida := TWsGTinModelFactory.New
    .UnidadeMedida
    .ObterUnidadeMedida(LId);

  Res.Send(TJson.ObjectToJsonObject(LUnidadeMedida));

  LUnidadeMedida.Free;
end;

procedure Registry;
begin
   THorse
     .Get('/api/unidade-medida/:id', GetUnidadeMedida)
   ;
end;

end.
