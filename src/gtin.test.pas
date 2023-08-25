unit gtin.test;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm3 = class(TForm)
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses gtin.classes,
     gtin.utils;

{$R *.dfm}

procedure TForm3.BitBtn1Click(Sender: TObject);
var O : gtin.classes.TGTIN;
    P : gtin.classes.TPicture;
begin
   O := TGTIN.Create;

   O.Code               := '7894900011517';
   O.Description        := 'REFRIG COCA COLA PET 2L';

   O.Status.Code        := '200';
   O.Status.Description := 'Ok. GTIN com dados fixo';

   O.Unid.Description   := 'Unidade';

   O.Packaging.Height   := 20;
   O.Packaging.Width    := 5;
   O.Packaging.Quantity := 2.250;
   O.Packaging.Weight   := 1.1234;
   O.Packaging.Length   := 1.5678;


   O.Tributes.NCM       := '22021000';
   O.Tributes.CEST      := '00000000';
   O.Tributes.CBS       := 12.3456;
   O.Tributes.IBS       := 7.8901;

   O.Others.Category    := 'Bebidas';
   O.Others.Producer    := 'Coca-Cola LTDA';
   O.Others.Observation := 'Refrigerante de cola';
   O.Others.DataSheet   := '1 - Bebida não alcoolica'+ sLineBreak +
                           '2 - Embalagem de plástico';
   O.Others.Web         := 'https://www.coca-cola.com.br/';

   P := gtin.classes.TPicture.Create;
   P.Path := 'https://www.coca-cola.com.br/share/thumb-site.png';
   O.PictureAdd(P);

   P := gtin.classes.TPicture.Create;
   P.Path := 'https://media.cotabest.com.br/media/sku/refrigerante-pet-2-litros-coca-cola-un-1d5188ce75.jpg';
   O.PictureAdd(P);

   Memo1.Text := TUtils.ToJSonString<TGTIN>(O,True);
end;

end.
