unit Ean.Controllers.Registry;

interface

uses
  Horse,
  Horse.Exception;

procedure DoRegistry;

implementation

uses
  Ean.Controllers.Produto,
  Ean.Controllers.UnidadeMedida;

procedure DoRegistry;
begin
  Ean.Controllers.Produto.Registry;
  Ean.Controllers.UnidadeMedida.Registry;
end;

end.
