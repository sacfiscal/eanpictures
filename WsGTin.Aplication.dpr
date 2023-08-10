program WsGTin.Aplication;

uses
  Vcl.Forms,
  main.view in 'src\main.view.pas' {MainView},
  wsHorse in 'src\wsHorse.pas',
  main.control in 'src\main.control.pas',
  main.basedados in 'src\main.basedados.pas' {BaseDados};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.CreateForm(TBaseDados, BaseDados);
  application.Run;
end.
