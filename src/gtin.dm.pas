unit gtin.dm;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  Data.DB,
  MidasLib,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,

  gtin.consts;

//Ao compilar mudar aqui. definir em qual db conectar.

{$DEFINE DB_FIREBIRD}
//{$DEFINE DB_MYSQL}

const
   PATH_COSMOS = 'comos\';

type
  TDM = class(TDataModule)
    DBConnectFirebird: TFDConnection;
    DBConnectMySQL: TFDConnection;
    PhysFBDriverLink: TFDPhysFBDriverLink;
    PhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    DB    : TFDConnection;
    FPath : String;

    function OpenQry(Value : String) : TDataSet;

    function QryGTIN(Version: TVersion; Value : String) : TDataSet;
    function QryFotos(Value : String) : TDataSet;
    function QryUndMedida(Version: TVersion; Value : String) : TDataSet;

    function GTIN_01(IsAlpha : Boolean; Value : TDataSet) : TObject;
    function GTIN_02(IsAlpha : Boolean; Value : TDataSet) : TObject;
  public
    { Public declarations }

    function Path(Value : String) : TDM;

    function GetGTIN(Version : TVersion; Value : String) : TObject;
    function GetGTIN_Nome(Version : TVersion; Value : String) : String;
    function GetGTIN_Unid_Med_Nome(Version : TVersion; Value : String) : String;
    function GetGTIN_Unid_Med(Version : TVersion; Value : String) : TObject;

    class function FilePhoto(Value : String) : String;

  end;

//var
//  DM: TDM;

implementation

uses gtin.utils,
     gtin.classes;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
   {$IFDEF DEBUG}
   DBConnectFirebird.Params.Values['Port'] := '3051';
   {$ENDIF}

   DB := {$IFDEF DB_FIREBIRD} DBConnectFirebird {$ELSE} DBConnectMySQL {$ENDIF};
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
   DB.Connected := False;
   //DB.Disconnect;
end;

class function TDM.FilePhoto(Value: String): String;
var F1, F2 : String;
begin
   Result := '';
   F1 := Value;
   F2 := ExtractFilePath(F1) + PATH_COSMOS + ExtractFileName(F1);

   If FileExists(F1) Then
      Result := F1
   Else If FileExists(F2) Then
      Result := F2;
end;

function TDM.GetGTIN(Version: TVersion; Value: String): TObject;
var DS : TDataSet;
begin
   Value := TUtils.NumberOnly(Value);
   DS    := QryGTIN(Version,Value);
   Try
     Result := nil;
     Case Version Of
        TVersion.v01 : Result := GTIN_01(True ,DS);
        TVersion.v02 : Result := GTIN_02(False,DS);
     End;
   Finally
     FreeAndNil(DS);
   End;
end;

function TDM.GetGTIN_Nome(Version: TVersion; Value: String): String;
var DS : TDataSet;
begin
   Value := TUtils.NumberOnly(Value);
   DS    := QryGTIN(Version,Value);
   Try
     Result := DS.FieldByName('NOME').AsString;
     {
     Case Version Of
        TVersion.v01 : Result := DS.FieldByName('NOME').AsString;
        TVersion.v02 : Result := DS.FieldByName('DESCRICAO').AsString;
     End;
     }
   Finally
     FreeAndNil(DS);
   End;
end;

function TDM.GetGTIN_Unid_Med(Version: TVersion; Value: String): TObject;
var DS : TDataSet;
    R  : TObject;
    U1 : TUnid_01;
    U : TUnid;
    L : TList<TUnid>;
begin
   Result := nil;

   R  := nil;
   DS := QryUndMedida(Version,Value);
   Try
     If DS.IsEmpty Then
        Exit;

     If (Version = TVersion.v01) Then
     Begin
        U1 := TUnid_01.Create;
        U1.Status      := '200';
        U1.Status_Desc := 'Ok';
        U1.ID          := TUtils.AlphaOnly(DS.FieldbyName('SIGLA').AsString);
        U1.Nome        := TUtils.AlphaOnly(DS.FieldbyName('NOME').AsString);

        R := U1;
     End;

     If (Version = TVersion.v02) Then
     Begin
        L := TObjectList<TUnid>.Create;
        While (not DS.Eof) Do
        Begin
           U := TUnid.Create;
           U.Short       := DS.FieldbyName('SIGLA').AsString;
           U.Description := DS.FieldbyName('NOME').AsString;

           L.Add(U);

           DS.Next;
        End;
        R := L;
     End;
   Finally
     FreeAndNil(DS);
   End;

   Result := R;
end;

function TDM.GetGTIN_Unid_Med_Nome(Version: TVersion; Value: String): String;
var DS : TDataSet;
begin
   DS := QryUndMedida(Version,Value);
   Try
     Result := DS.FieldByName('NOME').AsString;
   Finally
     FreeAndNil(DS);
   End;
end;

function TDM.GTIN_01(IsAlpha : Boolean; Value: TDataSet): TObject;
var O : TGTIN_01;
begin
   O := TGTIN_01.Create;
   Result := O;

   O.Status      := '200';
   O.Status_Desc := 'Ok';

   If Value.IsEmpty Then
   Begin
      O.Status      := '400';
      O.Status_Desc := 'EAN nao encontrado';

      Exit;
   End;

   O.GTIN                := Value.FieldByName('EAN').AsString;
   O.NCM                 := Value.FieldByName('NCM').AsString;
   O.CEST                := Value.FieldByName('CEST_CODIGO').AsString;
   O.Nome                := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('NOME').AsString);
   O.Embalagem           := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('EMBALAGEM').AsString);
   O.QuantidadeEmbalagem := Value.FieldByName('QUANTIDADE_EMBALAGEM').AsString;
   O.Marca               := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('MARCA').AsString);
   O.Id_Categoria        := Value.FieldByName('ID_CATEGORIA').AsString;
   O.Categoria           := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('CATEGORIA').AsString);
   O.Peso                := Value.FieldByName('PESO').AsString;
   O.Tributacao          := Value.FieldByName('TRIBUTACAO').AsString;
end;

function TDM.GTIN_02(IsAlpha : Boolean; Value: TDataSet): TObject;
var O : gtin.classes.TGTIN_02;
    P : gtin.classes.TPicture;
    DS : TDataSet;
begin
   O      := TGTIN_02.Create;
   Result := O;

   O.Status.Code        := '200';
   O.Status.Description := 'Ok';

   If Value.IsEmpty Then
   Begin
      O.Status.Code        := '400';
      O.Status.Description := 'EAN nao encontrado';

      Exit;
   End;

   O.Code                  := Value.FieldByName('GTIN').AsString;
   O.Description           := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('NOME').AsString);

   O.Unid.Short            := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('U_SIGLA').AsString);
   O.Unid.Description      := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('U_NOME').AsString);

   O.Packaging.Description := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('E_NOME').AsString);
   O.Packaging.Height      := Value.FieldByName('E_ALTURA').AsExtended;
   O.Packaging.Width       := Value.FieldByName('E_LARGURA').AsExtended;;
   O.Packaging.Quantity    := Value.FieldByName('E_QUANTIDADE').AsExtended;;
   O.Packaging.Weight      := Value.FieldByName('E_COMPRIMENTO').AsExtended;;
   O.Packaging.Length      := Value.FieldByName('E_PESO').AsExtended;;

   O.Tributes.NCM          := Value.FieldByName('NCM').AsString;
   O.Tributes.CEST         := Value.FieldByName('CEST').AsString;;
   O.Tributes.CBS          := Value.FieldByName('CBS').AsExtended;
   O.Tributes.IBS          := Value.FieldByName('IBS').AsExtended;

   O.Others.Category       := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('CATEGORIA').AsString);
   O.Others.Producer       := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('FABRICANTE').AsString);
   O.Others.Observation    := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('OBSERVACAO').AsString);
   O.Others.DataSheet      := TUtils.AlphaOnly(IsAlpha, Value.FieldByName('FICHA_TECNICA').AsString);
   O.Others.Web            := Value.FieldByName('WEB').AsString;

   DS := QryFotos(Value.FieldByName('ID').AsString);
   While (not DS.EOF) Do
   Begin
      P := gtin.classes.TPicture.Create;
      P.Path := DS.FieldByName('PATH').AsString;
      O.PictureAdd(P);
   End;

   If (not O.IsPictures) And (not FilePhoto(FPath + O.Code + '.png').IsEmpty) Then
   Begin
      P := gtin.classes.TPicture.Create;
      P.Path := 'www.eanpictures.com.br:9000/api/gtin/'+ O.Code;
      O.PictureAdd(P);
   End;
end;

function TDM.OpenQry(Value: String): TDataSet;
var Qry : TFDQuery;
begin
   Qry := TFDQuery.Create(Self);
   Qry.Connection := DB;

   Qry.Close;
   Qry.SQL.Text := Value;
   Qry.Open;

   Result := Qry;
end;

function TDM.Path(Value: String): TDM;
begin
   Result := Self;
   FPath  := Value;
end;

function TDM.QryFotos(Value: String): TDataSet;
var S : String;
begin
   S := ' SELECT F.PATH          '+ sLineBreak +
        ' FROM FOTO F            '+ sLineBreak +
        ' WHERE (F.PRODUTO = %s) ';
   S := Format(S,[Value]);

   Result := OpenQry(S);
end;

function TDM.QryGTIN(Version: TVersion; Value: String): TDataSet;
var S, S1, S2 : String;
begin

   S1 := ' SELECT P.ID,                   '+ sLineBreak +
         '        P.EAN,                  '+ sLineBreak +
         '        P.NOME,                 '+ sLineBreak +
         '        P.NCM,                  '+ sLineBreak +
         '        P.CEST_CODIGO,          '+ sLineBreak +
         '        P.EMBALAGEM,            '+ sLineBreak +
         '        P.QUANTIDADE_EMBALAGEM, '+ sLineBreak +
         '        P.TRIBUTACAO,           '+ sLineBreak +
         '        P.MARCA,                '+ sLineBreak +
         '        P.CATEGORIA,            '+ sLineBreak +
         '        P.ID_CATEGORIA,         '+ sLineBreak +
         '        P.PESO                  '+ sLineBreak +
         ' FROM CAD_PRODUTOS P            '+ sLineBreak +
         ' WHERE (P.EAN = %S)             ';

   S2 := ' SELECT P.ID,                                       '+ sLineBreak +
         '        P.GTIN,                                     '+ sLineBreak +
         '        P.NOME,                                     '+ sLineBreak +
         '        P.DESCRICAO,                                '+ sLineBreak +
         '        P.PRECO,                                    '+ sLineBreak +
         '        P.CBS,                                      '+ sLineBreak +
         '        P.IBS,                                      '+ sLineBreak +
         '        P.PESO,                                     '+ sLineBreak +
         '        P.OBSERVACAO,                               '+ sLineBreak +
         '        P.FICHA_TECNICA,                            '+ sLineBreak +
         '        P.WEB,                                      '+ sLineBreak +
         '        U.SIGLA        AS U_SIGLA,                  '+ sLineBreak +
         '        U.NOME         AS U_NOME,                   '+ sLineBreak +
         '        C.CODIGO       AS CEST,                     '+ sLineBreak +
         '        N.CODIGO       AS NCM,                      '+ sLineBreak +
         '        F.NOME         AS FABRICANTE,               '+ sLineBreak +
         '        C1.NOME        AS CATEGORIA,                '+ sLineBreak +
         '        M.NOME         AS MARCA,                    '+ sLineBreak +
         '        E.NOME         AS E_NOME,                   '+ sLineBreak +
         '        E.QUANTIDADE   AS E_QUANTIDADE,             '+ sLineBreak +
         '        E.ALTURA       AS E_ALTURA,                 '+ sLineBreak +
         '        E.LARGURA      AS E_LARGURA,                '+ sLineBreak +
         '        E.COMPRIMENTO  AS E_COMPRIMENTO,            '+ sLineBreak +
         '        E.PESO         AS E_PESO                    '+ sLineBreak +
         ' FROM PRODUTO P                                     '+ sLineBreak +
         ' INNER JOIN UNIDADE    U  ON (U.ID  = P.UNIDADE)    '+ sLineBreak +
         ' LEFT  JOIN CEST       C  ON (C.ID  = P.CEST)       '+ sLineBreak +
         ' LEFT  JOIN NCM        N  ON (N.ID  = P.NCM)        '+ sLineBreak +
         ' LEFT  JOIN FABRICANTE F  ON (F.ID  = P.FABRICANTE) '+ sLineBreak +
         ' LEFT  JOIN CATEGORIA  C1 ON (C1.ID = P.CATEGORIA)  '+ sLineBreak +
         ' LEFT  JOIN MARCA      M  ON (M.ID  = P.MARCA)      '+ sLineBreak +
         ' LEFT  JOIN EMBALAGEM  E  ON (E.ID  = P.EMBALAGEM)  '+ sLineBreak +
         ' WHERE (P.GTIN = %s)                                ';

   S := S1;
   If (Version = TVersion.v02) Then
      S := S2;

   S := Format(S,[QuotedStr(Value)]);

   Result := OpenQry(S);
end;

function TDM.QryUndMedida(Version: TVersion; Value: String): TDataSet;
var S, S1, S2 : String;
begin

   S1 := ' SELECT U.ID,           '+ sLineBreak +
         '        U.SIGLA,        '+ sLineBreak +
         '        U.NOME          '+ sLineBreak +
         ' FROM UNIDADE_MEDIDA U  ';

   S2 := ' SELECT U.ID,           '+ sLineBreak +
         '        U.SIGLA,        '+ sLineBreak +
         '        U.NOME          '+ sLineBreak +
         ' FROM UNIDADE U         ';

   If not Value.IsEmpty Then
   Begin
      S1 := S1 + ' WHERE (U.SIGLA = %s) ';
      S2 := S2 + ' WHERE (U.SIGLA = %s) ';
   End;

   S := S1;
   If (Version = TVersion.v02) Then
      S := S2;

   S := Format(S,[QuotedStr(Value)]);

   Result := OpenQry(S);
end;

end.
