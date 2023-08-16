unit WsGTin.Model.Factory;

interface

uses
  System.Classes,

   WsGTin.Model.Interfaces;

type
  TWsGTinModelFactory = class(TInterfacedObject, IWsGTinModelFactory)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TWsGTinModelFactory;

    { IWsGTinModelProduto }
    function Produto: IWsGTinModelProduto;
  end;

implementation

uses
  WsGTin.Model.Produto;

{ TWsGTinModelFactory }

constructor TWsGTinModelFactory.Create;
begin

end;

destructor TWsGTinModelFactory.Destroy;
begin

  inherited;
end;

class function TWsGTinModelFactory.New: TWsGTinModelFactory;
begin
  Result := Self.Create;
end;

function TWsGTinModelFactory.Produto: IWsGTinModelProduto;
begin
  Result := TWsGTinModelProduto.New;
end;

end.
