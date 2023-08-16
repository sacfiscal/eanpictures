unit WsGTin.Controllers.Registry;

interface

uses
  Horse,
  Horse.Exception;

procedure DoRegistry;

implementation

uses
  WsGTin.Controllers.Produto,
  WsGTin.Controllers.UnidadeMedida;

procedure DoRegistry;
begin
  WsGTin.Controllers.Produto.Registry;
  WsGTin.Controllers.UnidadeMedida.Registry;
end;

end.
