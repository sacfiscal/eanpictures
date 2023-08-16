unit WsGTin.Model.Entity.Produto;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TWsGTinModelEntityProduto = class
  private
    FEan: string;
    FNome: string;
    FNcm: Integer;
    FValor: Double;
    FAvg: Double;
    FEx: Integer;
    FMarca: string;
    FPais: string;
    FCategoria: string;
    FValorMedio: Double;
    FAtualizado: Integer;
    FFoto: string;
    FCestCodigo: string;
    FDhUpdate: TDateTime;
    FErro: Integer;
    FEmbalagem: string;
    FQuantidadeEmabalagem: Double;
    FTributacao: string;
    FProdutoAcento: string;
  public
    property Ean: string read FEan write FEan;
    property Nome: string read FNome write FNome;
    property Ncm: Integer read FNcm write FNcm;
    property Valor: Double read FValor write FValor;
    property Avg: Double read FAvg write FAvg;
    property Ex: Integer read FEx write FEx;
    property Marca: string read FMarca write FMarca;
    property Pais: string read FPais write FPais;
    property Categoria: string read FCategoria write FCategoria;
    property ValorMedio: Double read FValorMedio write FValorMedio;
    property Atualizado: Integer read FAtualizado write FAtualizado;
    property Foto: string read FFoto write FFoto;
    property CestCodigo: string read FCestCodigo write FCestCodigo;
    property DhUpdate: TDateTime read FDhUpdate write FDhUpdate;
    property Erro: Integer read FErro write FErro;
    property Embalagem: string read FEmbalagem write FEmbalagem;
    property QuantidadeEmabalagem: Double read FQuantidadeEmabalagem write FQuantidadeEmabalagem;
    property Tributacao: string read FTributacao write FTributacao;
    property ProdutoAcento: string read FProdutoAcento write FProdutoAcento;
  end;

  TWsGTinModelEntityProdutoLista = TObjectList<TWsGTinModelEntityProduto>;

implementation

end.
