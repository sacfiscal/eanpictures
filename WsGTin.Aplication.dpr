program WsGTin.Aplication;

uses
  Vcl.Forms,
  gtin.classes in 'src\gtin.classes.pas',
  gtin.consts in 'src\gtin.consts.pas',
  gtin.dm in 'src\gtin.dm.pas' {DM: TDataModule},
  gtin.utils in 'src\gtin.utils.pas',
  main.control in 'src\main.control.pas',
  main.view in 'src\main.view.pas' {MainView},
  wsHorse in 'src\wsHorse.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
