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

uses
  Horse,
  Horse.Exception,

  Database.Factory;

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
  var LSql := #13#10
  + 'SELECT * '
  + 'FROM base_produtos.cad_produtos cp '
  + 'where ean = :ean '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(Lsql)
    .ParamList
      .AddString('ean', AEanCode)
      .&End
    .Open();

  if ds.IsEmpty
  then raise EHorseException.New
    .&Unit(Self.UnitName)
    .Status(THTTPStatus.NotFound)
    .Error('Não foi possível encontrar o produto pelo EAN informado');

  Result := TWsGTinModelEntityProduto.Create;

  Result.Ean := ds.FieldByName('ean').AsString;
  Result.Nome := ds.FieldByName('nome').AsString;
  Result.Ncm := ds.FieldByName('ncm').AsInteger;
  Result.Valor := ds.FieldByName('valor').AsFloat;
  Result.Avg := ds.FieldByName('avg').AsFloat;
  Result.Ex := ds.FieldByName('ex').AsInteger;
  Result.Marca := ds.FieldByName('marca').AsString;
  Result.Pais := ds.FieldByName('pais').AsString;
  Result.Categoria := ds.FieldByName('categoria').AsString;
  Result.ValorMedio := ds.FieldByName('valor_medio').AsFloat;
  Result.Atualizado := ds.FieldByName('atualizado').AsInteger;
  Result.Foto := ds.FieldByName('link_foto').AsString;
  Result.CestCodigo := ds.FieldByName('cest_codigo').AsString;
  Result.DhUpdate := ds.FieldByName('dh_update').AsDateTime;
  Result.Erro := ds.FieldByName('erro').AsInteger;
  Result.Embalagem := ds.FieldByName('embalagem').AsString;
  Result.QuantidadeEmabalagem := ds.FieldByName('quantidade_embalagem').AsFloat;
  Result.Tributacao := ds.FieldByName('tributacao').AsString;
  Result.ProdutoAcento := ds.FieldByName('produto_acento').AsString;
end;

end.
