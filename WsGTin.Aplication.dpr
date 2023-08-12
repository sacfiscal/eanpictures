program WsGTin.Aplication;

uses
  Vcl.Forms,
  main.view in 'src\main.view.pas' {MainView},
  wsHorse in 'src\wsHorse.pas',
  main.control in 'src\main.control.pas',
  Ean.Controllers.Registry in 'src\controllers\Ean.Controllers.Registry.pas',
  Ean.Controllers.Produto in 'src\controllers\Ean.Controllers.Produto.pas',
  Ean.Controllers.UnidadeMedida in 'src\controllers\Ean.Controllers.UnidadeMedida.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  application.Run;
end.
