unit controller.Method;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Horse.OctetStream,
  utils.bibliotecas,
  interfaces.bibliotecas;

procedure Registry(App: Thorse);
procedure Getgtin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Getfotoexiste(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Getfotoexistej(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Getdescricao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetUnidadeMedida(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry(App: Thorse);
begin
  App.Get('/api/gtin/:id', Getgtin)
     .Get('/api/fotoexiste/:id', Getfotoexiste)
     .Get('/api/descricao/:id', Getdescricao)
     .Get('/api/um/:id', GetUnidadeMedida);
end;

procedure Getgtin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LFile: String;
  LFileSend: TFileReturn;
  LStream: TFileStream;
  LDisposition: String;
  FPath: string;
begin
  LFile := FPath + TBibliotecas.new.SomenteNumero(Req.Params.Items['id']
    ) + '.png';

  if FileExists(LFile) then
  begin
    LStream := TFileStream.Create(LFile, fmOpenRead);
    LFileSend := TFileReturn.Create(TPath.GetFileName(LFile), LStream, False);
    Res.Send<TFileReturn>(LFileSend).Status(200);
    // inc(cont200);

    // Req.RawWebRequest.RemoteAddr + ' | ' +
    // inttostr(cont200) + '|' + datetostr(date) + '|' + timetostr(now) +
    // '| Entregue arquivo: ' + LFile);
  end
  else
  begin
    Res.Send('Não localizaou o registro').Status(400);
  end;
end;

procedure Getfotoexiste(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
Res.Send('GetFotosexiste').Status(200);
end;

procedure Getfotoexistej(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Getfotoexistej').Status(200);
end;

procedure Getdescricao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Getdescricao').Status(200);
end;

procedure GetUnidadeMedida(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('GetUnidadeMedida').Status(200);
end;


end.
