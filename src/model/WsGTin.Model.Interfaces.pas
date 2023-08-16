unit WsGTin.Model.Interfaces;

interface

uses
  System.Classes,
  System.Generics.Collections,

  WsGTin.Model.Entity.Produto;

type
  IWsGTinModelProduto = interface
    ['{0F7834A7-CB9A-46AD-B65D-6805561868D7}']
    function ObterProdutoPorEan(AEanCode: string): TWsGTinModelEntityProduto;
  end;

  IWsGTinModelFactory = interface
    ['{B60DB98D-433B-4E91-91D2-7C831E599C2B}']
    function Produto: IWsGTinModelProduto;
  end;

implementation

end.
