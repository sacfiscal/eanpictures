program WsGtin.Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  main.control in 'src\main.control.pas',
  WsGTin.Controllers.Produto in 'src\controllers\WsGTin.Controllers.Produto.pas',
  WsGTin.Controllers.Registry in 'src\controllers\WsGTin.Controllers.Registry.pas',
  WsGTin.Controllers.UnidadeMedida in 'src\controllers\WsGTin.Controllers.UnidadeMedida.pas',
  wsHorse in 'src\wsHorse.pas',
  WsGTin.Model.Factory in 'src\model\WsGTin.Model.Factory.pas',
  WsGTin.Model.Interfaces in 'src\model\WsGTin.Model.Interfaces.pas',
  WsGTin.Model.Produto in 'src\model\WsGTin.Model.Produto.pas',
  WsGTin.Model.UnidadeMedida in 'src\model\WsGTin.Model.UnidadeMedida.pas',
  WsGTin.Model.Entity.Produto in 'src\model\entity\WsGTin.Model.Entity.Produto.pas',
  WsGTin.Model.Entity.UnidadeMedida in 'src\model\entity\WsGTin.Model.Entity.UnidadeMedida.pas';

begin
  try
    TMainControl.GetInstance.Power;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
