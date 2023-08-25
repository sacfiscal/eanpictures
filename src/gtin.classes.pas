unit gtin.classes;

interface

uses System.SysUtils, System.Classes,
     System.JSON.Serializers;

type
   TGTIN_01 = Class
   Private
     [JsonNameAttribute('Status')]
     FStatus : String;

     [JsonNameAttribute('Status_Desc')]
     FStatus_Desc : String;

     [JsonNameAttribute('GTIN')]
     FGTIN       : String;

     [JsonNameAttribute('Nome')]
     FNome       : String;

     [JsonNameAttribute('Ncm')]
     FNCM        : String;

     [JsonNameAttribute('Cest_Codigo')]
     FCEST       : String;

     [JsonNameAttribute('Embalagem')]
     FEmbalagem  : String;

     [JsonNameAttribute('QuantidadeEmbalagem')]
     FQuantidadeEmbalagem  : String;

     [JsonNameAttribute('Marca')]
     FMarca      : String;

     [JsonNameAttribute('id_categoria')]
     FID_Categoria  : String;

     [JsonNameAttribute('Categoria')]
     FCategoria  : String;

     [JsonNameAttribute('Peso')]
     FPeso       : String;

     [JsonNameAttribute('tributacao')]
     FTributacao : String;

   Public
     property Status              : String  Read FStatus              Write FStatus;
     property Status_Desc         : String  Read FStatus_Desc         Write FStatus_Desc;

     property GTIN                : String  Read FGTIN                Write FGTIN;
     property Nome                : String  Read FNome                Write FNome;
     property NCM                 : String  Read FNCM                 Write FNCM;
     property CEST                : String  Read FCEST                Write FCEST;
     property Embalagem           : String  Read FEmbalagem           Write FEmbalagem;
     property QuantidadeEmbalagem : String  Read FQuantidadeEmbalagem Write FQuantidadeEmbalagem;
     property Marca               : String  Read FMarca               Write FMarca;
     property Id_Categoria        : String  Read FID_Categoria        Write FID_Categoria;
     property Categoria           : String  Read FCategoria           Write FCategoria;
     property Peso                : String  Read FPeso                Write FPeso;
     property Tributacao          : String  Read FTributacao          Write FTributacao;
   End;

   TUnid_01 = Class
   Private
     [JsonNameAttribute('Status')]
     FStatus : String;

     [JsonNameAttribute('Status_Desc')]
     FStatus_Desc : String;

     [JsonName('ID')]
     FID       : String;

     [JsonName('Nome')]
     FNome : String;
   Public
     property Status      : String  Read FStatus              Write FStatus;
     property Status_Desc : String  Read FStatus_Desc         Write FStatus_Desc;
     property ID          : String  Read FID                  Write FID;
     property Nome        : String  Read FNome                Write FNome;
   End;

   TStatus = Class
   Private
     [JsonName('Code')]
     FCode        : String;

     [JsonName('Description')]
     FDescription : String;
   Public
     property Code        : String Read FCode        Write FCode;
     property Description : String Read FDescription Write FDescription;
   End;

   TPicture = Class
   Private
     [JsonName('Path')]
     FPath : String;

     [JsonName('Base64')]
     FBase64 : String;

     [JsonName('MD5')]
     FMD5  : String;
   Public
     property Path   : String Read FPath   Write FPath;
     property Base64 : String Read FBase64 Write FBase64;
     property MD5    : String Read FMD5    Write FMD5;
   End;

   TPictures = TArray<TPicture>;

   TUnid = Class
   Private
     [JsonName('Short')]
     FShort       : String;

     [JsonName('Description')]
     FDescription : String;
   Public
     property Short       : String Read FShort       Write FShort;
     property Description : String Read FDescription Write FDescription;
   End;

   TPackaging = Class
   Private
     [JsonName('Description')]
     FDescription : String;

     [JsonName('Height')]
     FHeight   : Extended;

     [JsonName('Width')]
     FWidth    : Extended;

     [JsonName('Quantity')]
     FQuantity : Extended;

     [JsonName('Weight')]
     FWeight   : Extended;

     [JsonName('Length')]
     FLength   : Extended;
   Public
     property Description : String   Read FDescription Write FDescription;
     property Height      : Extended Read FHeight      Write FHeight;
     property Width       : Extended Read FWidth       Write FWidth;
     property Quantity    : Extended Read FQuantity    Write FQuantity;
     property Weight      : Extended Read FWeight      Write FWeight;
     property Length      : Extended Read FLength      Write FLength;
   End;

   TTributes = Class
   Private
     [JsonName('NCM')]
     FNCM  : String;

     [JsonName('CEST')]
     FCEST : String;

     [JsonName('CBS')]
     FCBS  : Extended;

     [JsonName('IBS')]
     FIBS  : Extended;
   Public
     property NCM  : String   Read FNCM  Write FNCM;
     property CEST : String   Read FCEST Write FCEST;
     property CBS  : Extended Read FCBS  Write FCBS;
     property IBS  : Extended Read FIBS  Write FIBS;
   End;

   TOthers = Class
   Private
     [JsonName('Category')]
     FCategory : String;

     [JsonName('Producer')]
     FProducer : String;

     [JsonName('Observation')]
     FObservation : String;

     [JsonName('Datasheet')]
     FDataSheet : String;

     [JsonName('Web')]
     FWeb : String;
   Public
     property Category    : String Read FCategory    Write FCategory;
     property Producer    : String Read FProducer    Write FProducer;
     property Observation : String Read FObservation Write FObservation;
     property DataSheet   : String Read FDataSheet   Write FDataSheet;
     property Web         : String Read FWeb         Write FWeb;
   End;

   TGTIN_02 = Class
   Private
     [JsonName('Code')]
     FCode        : String;

     [JsonName('Description')]
     FDescription : String;

     [JsonName('Unid')]
     FUnid        : TUnid;

     [JsonName('Packaging')]
     FPackaging   : TPackaging;

     [JsonName('Tributes')]
     FTributes    : TTributes;

     [JsonName('Others')]
     FOthers      : TOthers;

     [JsonName('Pictures')]
     FPictures    : TArray<TPicture>;

     [JsonName('Status')]
     FStatus      : TStatus;

     procedure PictureClear;

   Public
     Constructor Create;
     Destructor  Destroy; Override;

     procedure PictureAdd(Value : TPicture);

     property Code        : String           Read FCode        Write FCode;
     property Description : String           Read FDescription Write FDescription;
     property Unid        : TUnid            Read FUnid;
     property Packaging   : TPackaging       Read FPackaging;
     property Tributes    : TTributes        Read FTributes;
     property Others      : TOthers          Read FOthers;
     property Pictures    : TArray<TPicture> Read FPictures;

     property Status      : TStatus          Read FStatus;

     function IsPictures : Boolean;
   End;

implementation

{ TEAN }

procedure TGTIN_02.PictureAdd(Value: TPicture);
begin
   SetLength(FPictures,High(FPictures) + 2);
   FPictures[High(FPictures)] := Value;
end;

procedure TGTIN_02.PictureClear;
var I : Integer;
    O : TObject;
begin
   For I := High(FPictures) Downto Low(FPictures) Do
   Begin
      O := FPictures[I];
      FreeAndNil(O);
   End;
   SetLength(FPictures,0);
end;

constructor TGTIN_02.Create;
begin
   FStatus    := TStatus.Create;
   FUnid      := TUnid.Create;
   FPackaging := TPackaging.Create;
   FTributes  := TTributes.Create;
   FOthers    := TOthers.Create;
   SetLength(FPictures,0);
end;

destructor TGTIN_02.Destroy;
begin
   FreeAndNil(FStatus);
   FreeAndNil(FUnid);
   FreeAndNil(FPackaging);
   FreeAndNil(FTributes);
   FreeAndNil(FOthers);

   PictureClear;

   inherited;
end;

function TGTIN_02.IsPictures: Boolean;
begin
   Result := (High(FPictures) > 0);
end;

end.
