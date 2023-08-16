unit WsGTin.Model.Produto;

interface

uses
  System.Classes,

  WsGTin.Model.Interfaces,
  WsGTin.Model.Entity.Produto;

type
  TWsGTinModelProduto = class(TInterfacedObject, IWsGTinModelProduto)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TWsGTinModelProduto;

    { IWsGTinModelProduto }
    function ObterProdutoPorEan(AEanCode: string): TWsGTinModelEntityProduto;
  end;

implementation

{ TWsGTinModelProduto }

constructor TWsGTinModelProduto.Create;
begin

end;

destructor TWsGTinModelProduto.Destroy;
begin

  inherited;
end;

class function TWsGTinModelProduto.New: TWsGTinModelProduto;
begin
  Result := Self.Create;
end;

function TWsGTinModelProduto.ObterProdutoPorEan(
  AEanCode: string): TWsGTinModelEntityProduto;
begin

end;

end.
