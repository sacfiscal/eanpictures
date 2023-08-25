unit wsHorse;

interface

uses System.Classes, System.SysUtils, System.IOUtils,
     System.Generics.Collections, System.JSON,
     Horse, Horse.Jhonson, Horse.OctetStream, Horse.HandleException;

// http://localhost:9000/api/desc/78932609
// http://localhost:9000/api/desc/7894900011517
// http://localhost:9000/api/desc_ini/7894900011517

//http://localhost:9000/api/v2/gtin/7894900011517

type
  TWsHorse = class
  private
    FHorse : THorse;
    FPath  : String;
    FLog   : TProc<String>;

    procedure DoLog(Value : String);
    function  DoCount(Value : Boolean) : Integer;

    procedure DoStatus(Req : THorseRequest; Res : THorseResponse; Status : Integer; MensStatus, Mens, MensLog : String);

    procedure Gtin(Req : THorseRequest; Res : THorseResponse; Next : TProc);

    procedure FotoExiste(Req : THorseRequest; Res : THorseResponse; Next : TProc);
    procedure FotoExisteJson(Req : THorseRequest; Res : THorseResponse; Next : TProc);

    procedure Descricao(Req : THorseRequest; Res : THorseResponse; Next : TProc);
    procedure DescricaoJSon(Req : THorseRequest; Res : THorseResponse; Next : TProc);
    procedure DescricaoJSon200(Req : THorseRequest; Res : THorseResponse; Next : TProc);
    procedure DescricaoIni(Req : THorseRequest; Res : THorseResponse; Next : TProc);

    procedure UnidadeMedidaNome(Req : THorseRequest; Res : THorseResponse; Next : TProc);
    procedure UnidadeMedidaJSon(Req : THorseRequest; Res : THorseResponse; Next : TProc);

    procedure V2Gtin(Req : THorseRequest; Res : THorseResponse; Next : TProc);
    procedure V2UnidadeMedida(Req : THorseRequest; Res : THorseResponse; Next : TProc);

    procedure AddMethods;

  public
    Constructor Create;
    Destructor Destroy; Override;

    function Port(Value : Integer) : TWsHorse;
    function Path(Value : String) : TWsHorse;
    function Log(Value : TProc<String>) : TWsHorse;

    function Active: Boolean;

    procedure Power;
  end;

implementation

uses gtin.consts,
     gtin.utils,
     gtin.Classes,
     gtin.dm,
     main.view;

{ TWsHorse }

function TWsHorse.Active: Boolean;
begin
   Result := FHorse.IsRunning;
end;

procedure TWsHorse.AddMethods;
begin
   FHorse.Get('/api/gtin/:id'       , Gtin);

   FHorse.Get('/api/fotoexiste/:id' , FotoExiste);
   FHorse.Get('/api/fotoexistej/:id', FotoExisteJson);

   FHorse.Get('/api/descricao/:id'  , Descricao);
   FHorse.Get('/api/desc/:id'       , DescricaoJSon);
   FHorse.Get('/api/desc200/:id'    , DescricaoJSon200);
   FHorse.Get('/api/desc_ini/:id'   , DescricaoIni);

   FHorse.Get('/api/um/:id'         , UnidadeMedidaJSon);
   FHorse.Get('/api/um2/:id'        , UnidadeMedidaNome);

   FHorse.Get('/api/v2/gtin/:id'    , V2Gtin);
   FHorse.Get('/api/v2/um/'         , V2UnidadeMedida);
   FHorse.Get('/api/v2/um/:id'      , V2UnidadeMedida);
end;

Constructor TWsHorse.Create;
begin
   FLog   := nil;
   FPath  := '';

   FHorse := THorse.Create;
   FHorse.Use(Jhonson);
   FHorse.Use(OctetStream);
   FHorse.Use(HandleException);

   AddMethods;
end;

procedure TWsHorse.Descricao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LID, S : String;
    D : TDM;
begin
   LID := TUtils.NumberOnly(Req.Params.Items['id']);

   If LID.IsEmpty Then
   Begin
      DoStatus(Req,Res,404,'404',
               'Necessario enviar o GTIN. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789',
               '| Descricao | Descricao nao encontrada para o ean: '+ LID);
      Exit;
   End;

   D := TDM.Create(nil);
   Try
     S := D.GetGTIN_Nome(TVersion.v01,LID);
     If S.IsEmpty Then
     Begin
        DoStatus(Req,Res,404,'404',
                 'Descricao nao encontrada para o ean: '+ LID,
                 '| Descricao | Descricao nao encontrada para o ean: '+ LID);
        Exit;
     End;

     Res.Send(S)
        .Status(200);

     DoStatus(Req,Res,0,'200','','| Descricao | Entregue descricao: '+ LID +' | ' + S);
   Finally
     FreeAndNil(D);
   End;
end;

procedure TWsHorse.DescricaoIni(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LID : String;
    O : TGTIN_01;
    D : TDM;
    S : TStringList;
begin
   LID := TUtils.NumberOnly(Req.Params.Items['id']);

   If LID.IsEmpty Then
   Begin
      DoStatus(Req,Res,404,'404',
               'Necessario enviar o GTIN. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789',
               '| DescricaoJSon | Descricao nao encontrada para o ean: '+ LID);
      Exit;
   End;

   D := TDM.Create(nil);
   Try
     O := TGTIN_01( D.GetGTIN(TVersion.v01,LID) );
     Try
       If O.GTIN.IsEmpty Then
       Begin
          DoStatus(Req,Res,404,'404',
                   'Descricao nao encontrada para o ean: '+ LID,
                   '| DescricaoJSon | Descricao nao encontrada para o ean: '+ LID);
          Exit;
       End;

       S := TStringList.Create;
       Try
         S.Add('[GENERAL]');
         S.Add('Nome='                + O.Nome);
         S.Add('Ncm='                 + O.NCM);
         S.Add('Cest_Codigo='         + O.CEST);
         S.Add('Embalagem='           + O.Embalagem);
         S.Add('QuantidadeEmbalagem=' + O.QuantidadeEmbalagem);
         S.Add('Marca='               + O.Marca);
         S.Add('Categoria='           + O.Categoria);
         S.Add('Peso='                + O.Peso);
         S.Add('id_categoria='        + O.Id_Categoria);
         S.Add('tributacao='          + O.Tributacao);

         Res.Send(S.Text).Status(200);
       Finally
         FreeAndNil(S);
       End;

       DoStatus(Req,Res,0,'200','','| DescricaoJSon | Entregue descricao: '+ LID +' | ' + O.Nome);
     Finally
       FreeAndNil(O);
     End;

   Finally
     FreeAndNil(D);
   End;
end;

procedure TWsHorse.DescricaoJSon(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LID : String;
    O : TGTIN_01;
    J : TJSONValue;
    D : TDM;
begin
   LID := TUtils.NumberOnly(Req.Params.Items['id']);

   If LID.IsEmpty Then
   Begin
      DoStatus(Req,Res,404,'404',
               'Necessario enviar o GTIN. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789',
               '| DescricaoJSon | Descricao nao encontrada para o ean: '+ LID);
      Exit;
   End;

   D := TDM.Create(nil);
   Try
     O := TGTIN_01( D.GetGTIN(TVersion.v01,LID) );
     Try
       If O.GTIN.IsEmpty Then
       Begin
          DoStatus(Req,Res,404,'404',
                   'Descricao nao encontrada para o ean: '+ LID,
                   '| DescricaoJSon | Descricao nao encontrada para o ean: '+ LID);
          Exit;
       End;

       J := TUtils.ToJSonValue<TGTIN_01>(O);
       Try
         Res.Send<TJSONValue>(J).Status(200);
       Finally
         //FreeAndNil(J); //Horse-> Da o Free no Content
       End;

       DoStatus(Req,Res,0,'200','','| DescricaoJSon | Entregue descricao: '+ LID +' | ' + O.Nome);
     Finally
       FreeAndNil(O);
     End;

   Finally
     FreeAndNil(D);
   End;
end;

procedure TWsHorse.DescricaoJSon200(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
   DescricaoJSon(Req, Res, Next);
end;

destructor TWsHorse.Destroy;
begin
   //FreeAndNil(FHorse);
   inherited;
end;

function TWsHorse.DoCount(Value: Boolean): Integer;
begin
   If Value Then
      Result := AtomicIncrement(Cont200)
   Else
      Result := AtomicIncrement(Cont404);
end;

procedure TWsHorse.DoLog(Value: String);
begin
   If Assigned(FLog) Then
      FLog(Value);
end;

procedure TWsHorse.FotoExiste(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LFile, LID : String;
begin
   LID   := TUtils.NumberOnly(Req.Params.Items['id']);
   LFile := TDM.FilePhoto(LID);

   If LFile.IsEmpty Then
   begin
      Res.Send('Nao')
         .Status(200);

      DoStatus(Req,Res,0,'200','','| FotoExiste | Arquivo consultado (Nao): '+ LID);

      Exit;
   End;

   Res.Send('Sim')
      .Status(200);

   DoStatus(Req,Res,0,'200','','| FotoExiste | Arquivo consultado (Sim): '+ LID);
end;

procedure TWsHorse.FotoExisteJson(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LFile, LID : String;
begin
   LID   := TUtils.NumberOnly(Req.Params.Items['id']);
   LFile := TDM.FilePhoto(LID);

   If LFile.IsEmpty Then
      DoStatus(Req,Res,200,'404','Foto encontrada (Nao): '+ LID,'| FotoExisteJson | Consulta arquivo (Nao): ')
   Else
      DoStatus(Req,Res,200,'200','Foto encontrada (Sim): '+ LID,'| FotoExisteJson | Consulta arquivo (Sim): '+ LFile);
end;

procedure TWsHorse.Gtin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LFile, LLink, LID : String;
    LFileSend : TFileReturn;
    LStream : TFileStream;
begin
   LID   := TUtils.NumberOnly(Req.Params.Items['id']);
   LFile := TDM.FilePhoto(LID);

   If LFile.IsEmpty Then
   Begin
      LFile := FPath + PATH_COSMOS + LID + '.png';

      LLink := 'https://cdn-cosmos.bluesoft.com.br/products/' + ExtractFileName(LFile);
      TUtils.DownloadFile(LLink, LFile);
      DoLog('Download : '+ LFile +' | '+ LLink);
   End;

   If not FileExists(LFile) Then
   Begin
      DoStatus(Req,Res,404,'404','','| Gtin | Arquivo nao encontrado: '+ LFile);
      Exit;
   End;

   LStream := TFileStream.Create(LFile, fmOpenRead);
   Try
     LFileSend := TFileReturn.Create( TPath.GetFileName(LFile), LStream, False);
     Try
       Res.Send<TFileReturn>(LFileSend)
          .Status(200);
     Finally
       //FreeAndNil(LFileSend); //Horse-> Da o Free no Content
     End;

     DoStatus(Req,Res,0,'200','','| Gtin | Upload : '+ LFile);
   Finally
     //FreeAndNil(LStream); //Horse-> Da o Free no Content
   End;
end;

function TWsHorse.Log(Value: TProc<String>): TWsHorse;
begin
   Result := Self;
   FLog   := Value;
end;

function TWsHorse.Port(Value: Integer): TWsHorse;
begin
   Result      := Self;
   FHorse.Port := Value;
end;

function TWsHorse.Path(Value: String): TWsHorse;
begin
   Result := Self;
   FPath  := Value;

   If (not DirectoryExists(FPath + PATH_COSMOS)) Then
      ForceDirectories(FPath + PATH_COSMOS);
end;

procedure TWsHorse.Power;
begin
   If FHorse.IsRunning Then
      FHorse.StopListen
   Else
      FHorse.Listen;
end;

procedure TWsHorse.UnidadeMedidaJSon(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LID : String;
    O : TUnid_01;
    J : TJSONValue;
    D : TDM;
begin
   LID := TUtils.NumberOnly(Req.Params.Items['id']);

   If LID.IsEmpty Then
   Begin
      DoStatus(Req,Res,404,'404',
               'Necessario enviar o codigo da unidade de medida. Ex: www.eanpictures.com.br:9000/api/um/M3',
               '| UnidadeMedidaNome | Descricao nao encontrada a unidade de medida: '+ LID);
      Exit;
   End;

   D := TDM.Create(nil);
   Try
     O := TUnid_01(D.GetGTIN_Unid_Med(TVersion.v01,LID));
     If not Assigned(O) Then
     Begin
        DoStatus(Req,Res,404,'404',
                 'Descricao nao encontrada para a unidade de medida: '+ LID,
                 '| UnidadeMedidaNome | Descricao nao encontrada a unidade de medida: '+ LID);
        Exit;
     End;

     Try
       J := TUtils.ToJSonValue<TUnid_01>(O);
       Try
         Res.Send<TJSONValue>(J).Status(200);
       Finally
         //FreeAndNil(J); //Horse-> Da o Free no Content
       End;

       DoStatus(Req,Res,0,'200','','| UnidadeMedidaNome | Entregue descricao unidade medida: '+ LID + ' | ' + O.Nome);
     Finally
       FreeAndNil(O);
     End;
   Finally
     FreeAndNil(D);
   End;
end;

procedure TWsHorse.UnidadeMedidaNome(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LID, S : String;
    D : TDM;
begin
   LID := TUtils.NumberOnly(Req.Params.Items['id']);

   If LID.IsEmpty Then
   Begin
      DoStatus(Req,Res,404,'404',
               'Necessario enviar o codigo da unidade de medida. Ex: www.eanpictures.com.br:9000/api/um/M3',
               '| UnidadeMedidaNome | Descricao nao encontrada a unidade de medida: '+ LID);
      Exit;
   End;

   D := TDM.Create(nil);
   Try
     S := D.GetGTIN_Unid_Med_Nome(TVersion.v01,LID);
     If S.IsEmpty Then
     Begin
        DoStatus(Req,Res,404,'404',
                 'Descricao nao encontrada para a unidade de medida: '+ LID,
                 '| UnidadeMedidaNome | Descricao nao encontrada a unidade de medida: '+ LID);
        Exit;
     End;

     Res.Send(S)
        .Status(200);

     DoStatus(Req,Res,0,'200','','| UnidadeMedidaNome | Entregue descricao unidade medida: '+ LID + ' | ' + S);
   Finally
     FreeAndNil(D);
   End;
end;

procedure TWsHorse.V2Gtin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LID : String;
    O : TGTIN_02;
    J : TJSONValue;
    D : TDM;
begin
   LID := TUtils.NumberOnly(Req.Params.Items['id']);

   If LID.IsEmpty Then
   Begin
      DoStatus(Req,Res,404,'404',
               'Necessario enviar o GTIN. Ex: www.eanpictures.com.br:9000/api/v2/gtin/789789789789',
               '| V2Gtin | GTIN : '+ LID);
      Exit;
   End;

   D := TDM.Create(nil).Path(FPath);
   Try
     O := TGTIN_02( D.GetGTIN(TVersion.v02,LID) );
     Try
       If O.Code.IsEmpty Then
       Begin
          DoStatus(Req,Res,404,'404',
                   'GTIN nao encontrada para o ean: '+ LID,
                   '| V2Gtin | GTIN : '+ LID);
          Exit;
       End;

       J := TUtils.ToJSonValue<TGTIN_02>(O);
       Try
         Res.Send<TJSONValue>(J).Status(200);
       Finally
         //FreeAndNil(J); //Horse-> Da o Free no Content
       End;

       DoStatus(Req,Res,0,'200','','| V2Gtin | GTIN: '+ LID +' | ' + O.Description);
     Finally
       FreeAndNil(O);
     End;

   Finally
     FreeAndNil(D);
   End;
end;

procedure TWsHorse.V2UnidadeMedida(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var LID : String;
    I, O : TObject;
    J : TJSONArray;
    D : TDM;
begin
   LID := '';
   If (Req.Params.Count <> 0) Then
      LID := UpperCase(TUtils.AlphaOnly(Req.Params.Items['id']));

   {
   If LID.IsEmpty Then
   Begin
      DoStatus(Req,Res,404,'404',
               'Necessario enviar o codigo da unidade de medida. Ex: www.eanpictures.com.br:9000/api/um/M3',
               '| UnidadeMedidaNome | Descricao nao encontrada a unidade de medida: '+ LID);
      Exit;
   End;
   }

   D := TDM.Create(nil);
   Try
     O := D.GetGTIN_Unid_Med(TVersion.v02,LID);
     {
     If not Assigned(O) Then
     Begin
        DoStatus(Req,Res,404,'404',
                 'Descricao nao encontrada para a unidade de medida: '+ LID,
                 '| UnidadeMedidaNome | Descricao nao encontrada a unidade de medida: '+ LID);
        Exit;
     End;
     }

     Try
       J := TJSONArray.Create;
       If Assigned(O) Then
          For I in TList<TUnid>(O) Do
             J.Add(TJSONObject(TUtils.ToJSonValue<TUnid>(I)));

       Try
         Res.Send<TJSONArray>(J).Status(200);
       Finally
         //FreeAndNil(J); //Horse-> Da o Free no Content
       End;

       DoStatus(Req,Res,0,'200','','| UnidadeMedidaNome | Unidade de Medida: '+ LID);
     Finally
       If Assigned(O) Then
          FreeAndNil(O);
     End;
   Finally
     FreeAndNil(D);
   End;
end;

procedure TWsHorse.DoStatus(Req: THorseRequest; Res: THorseResponse; Status : Integer; MensStatus, Mens, MensLog : String);
var J : TJSONObject;
    C : Integer;
Begin
   C := DoCount(MensStatus = '200');
   DoLog(Req.RawWebRequest.RemoteAddr +' | '+ FormatFloat('000',C) +' '+ MensLog);

   If (Status <= 0) Then
      Exit;

   J := TJSONObject.Create;
   Try
     J.AddPair('Status'     ,MensStatus)
      .AddPair('Status_Desc',Mens);

     Res.Send<TJSONobject>(J).Status(Status);
   Finally
     //FreeAndNil(J); //Horse-> Da o Free no Content
   End;
end;

end.
