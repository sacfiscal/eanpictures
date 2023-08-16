program WsGTin.Aplication;

uses
  Vcl.Forms,
  main.view in 'src\main.view.pas' {MainView},
  wsHorse in 'src\wsHorse.pas',
  main.control in 'src\main.control.pas',
  WsGTin.Controllers.Registry in 'src\controllers\WsGTin.Controllers.Registry.pas',
  WsGTin.Controllers.Produto in 'src\controllers\WsGTin.Controllers.Produto.pas',
  WsGTin.Controllers.UnidadeMedida in 'src\controllers\WsGTin.Controllers.UnidadeMedida.pas',
  WsGTin.Model.Interfaces in 'src\model\WsGTin.Model.Interfaces.pas',
  WsGTin.Model.Entity.Produto in 'src\model\entity\WsGTin.Model.Entity.Produto.pas',
  WsGTin.Model.Produto in 'src\model\WsGTin.Model.Produto.pas',
  WsGTin.Model.Factory in 'src\model\WsGTin.Model.Factory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  application.Run;
end.
