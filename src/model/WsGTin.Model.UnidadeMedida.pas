unit WsGTin.Model.UnidadeMedida;

interface

uses
  System.Classes,
  System.Generics.Collections,

  WsGTin.Model.Interfaces,
  WsGTin.Model.Entity.UnidadeMedida;

type
  TWsGTinModelUnidadeMedida = class(TInterfacedObject, IWsGTinModelUnidadeMedida)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IWsGTinModelUnidadeMedida;

    { IWsGTinModelUnidadeMedida }
    function ObterUnidadeMedida(AId: string): TWsGTinModelEntityUnidadeMedida;
  end;


implementation

uses
  Horse,
  Horse.Exception,

  Database.Factory;

{ TWsGTinModelUnidadeMedida }

constructor TWsGTinModelUnidadeMedida.Create;
begin

end;

destructor TWsGTinModelUnidadeMedida.Destroy;
begin

  inherited;
end;

class function TWsGTinModelUnidadeMedida.New: IWsGTinModelUnidadeMedida;
begin
  Result := Self.Create;
end;

function TWsGTinModelUnidadeMedida.ObterUnidadeMedida(
  AId: string): TWsGTinModelEntityUnidadeMedida;
begin
  var ds := TDatabaseFactory.New.SQL
    .SQL('select * from unidade_medida where id = :id')
    .ParamList
      .AddString('id', AId)
      .&End
    .Open;

  if ds.IsEmpty
  then raise EHorseException.New
    .&Unit(Self.UnitName)
    .Status(THTTPStatus.NotFound)
    .Error('Não foi possível encontrar a unidade de medida pelo ID informado');

  Result := TWsGTinModelEntityUnidadeMedida.Create;
  Result.Id := ds.FieldByName('id').AsString;
  Result.Nome := ds.FieldByName('nome').AsString;
end;

end.
