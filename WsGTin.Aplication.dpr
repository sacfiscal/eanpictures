program WsGTin.Aplication;

uses
  Vcl.Forms,
  main.view in 'src\main.view.pas' {MainView},
  wsHorse in 'src\wsHorse.pas',
  main.control in 'src\main.control.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  application.Run;
end.
