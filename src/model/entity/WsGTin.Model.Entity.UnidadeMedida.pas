unit WsGTin.Model.Entity.UnidadeMedida;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TWsGTinModelEntityUnidadeMedida = class
  private
    FId: string;
    FNome: string;
  public
    property Id: string read FId write FId;
    property Nome: string read FNome write FNome;
  end;

implementation

end.
