unit utils.bibliotecas;

interface

uses
  interfaces.bibliotecas;

type
  TBibliotecas = class(TInterfacedObject, ibibliotecas)
  private
  public
    constructor Create;
    destructor Destroy; override;
    class function new: ibibliotecas;
    function SomenteNumero(snum: string): string;
    function removeacento(const ptext: string):string;
  end;

implementation

{ TBibliotecas }

constructor TBibliotecas.Create;
begin

end;

destructor TBibliotecas.Destroy;
begin

  inherited;
end;

class function TBibliotecas.new: ibibliotecas;
begin
  result := Self.Create;
end;

function TBibliotecas.removeacento(const ptext: string): string;
type
  usaascii20127 = type ansistring(20127);
begin
  result:=string(usaascii20127(ptext));
end;

function TBibliotecas.SomenteNumero(snum: string): string;
var
  s1, s2: string;
  i: integer;
begin
  s1 := snum;
  s2 := '';
  for i := 1 to length(s1) do
    if s1[i] in ['0' .. '9'] then
      s2 := s2 + s1[i];
  result := s2;
end;

end.
