unit WsGTin.Model.Interfaces;

interface

uses
  System.Classes,
  System.Generics.Collection,

  WsGTin.Model.Entity.Produto;

type
  IWsGTinModelProduto = interface
    ['{0F7834A7-CB9A-46AD-B65D-6805561868D7}']
    function ObterProdutoPorEan(AEanCode: string): TWsGTinModelEntityProduto;
  end;

implementation

end.
