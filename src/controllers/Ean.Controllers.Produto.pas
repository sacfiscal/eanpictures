unit Ean.Controllers.Produto;

interface

uses
  Horse,
  Horse.Exception;

procedure Registry;
//procedure ConfigSwagger;

implementation

function RemoveAcento(const ptext: string):string;
type
  usaascii20127 = type ansistring(20127);
begin
  result := string(usaascii20127(ptext));
end;

procedure Registry;
begin

end;

end.
