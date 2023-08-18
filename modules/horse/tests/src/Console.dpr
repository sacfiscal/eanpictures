program Console;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  Horse.Commons in '..\..\src\Horse.Commons.pas',
  Horse.Constants in '..\..\src\Horse.Constants.pas',
  Horse.Core.Group.Contract in '..\..\src\Horse.Core.Group.Contract.pas',
  Horse.Core.Group in '..\..\src\Horse.Core.Group.pas',
  Horse.Core in '..\..\src\Horse.Core.pas',
  Horse.Core.Route.Contract in '..\..\src\Horse.Core.Route.Contract.pas',
  Horse.Core.Route in '..\..\src\Horse.Core.Route.pas',
  Horse.Core.RouterTree in '..\..\src\Horse.Core.RouterTree.pas',
  Horse.Exception in '..\..\src\Horse.Exception.pas',
  Horse in '..\..\src\Horse.pas',
  Horse.Provider.Abstract in '..\..\src\Horse.Provider.Abstract.pas',
  Horse.Provider.Apache in '..\..\src\Horse.Provider.Apache.pas',
  Horse.Provider.CGI in '..\..\src\Horse.Provider.CGI.pas',
  Horse.Provider.Console in '..\..\src\Horse.Provider.Console.pas',
  Horse.Provider.Daemon in '..\..\src\Horse.Provider.Daemon.pas',
  ThirdParty.Posix.Syslog in '..\..\src\ThirdParty.Posix.Syslog.pas',
  Web.WebConst in '..\..\src\Web.WebConst.pas',
  Horse.Provider.VCL in '..\..\src\Horse.Provider.VCL.pas',
  Horse.Provider.ISAPI in '..\..\src\Horse.Provider.ISAPI.pas',
  Horse.WebModule in '..\..\src\Horse.WebModule.pas' {HorseWebModule: TWebModule},
  Horse.Proc in '..\..\src\Horse.Proc.pas',
  System.Classes,
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Tests.Api.Console in 'tests\Tests.Api.Console.pas',
  Controllers.Api in 'controllers\Controllers.Api.pas',
  Tests.Commons in 'tests\Tests.Commons.pas',
  Horse.Core.Param in '..\..\src\Horse.Core.Param.pas',
  Horse.Core.Param.Header in '..\..\src\Horse.Core.Param.Header.pas',
  Horse.Provider.IOHandleSSL in '..\..\src\Horse.Provider.IOHandleSSL.pas',
  Tests.Horse.Core.Param in 'tests\Tests.Horse.Core.Param.pas',
  Horse.Core.Param.Field in '..\..\src\Horse.Core.Param.Field.pas',
  Horse.Request in '..\..\src\Horse.Request.pas',
  Horse.Response in '..\..\src\Horse.Response.pas',
  Horse.Core.Param.Config in '..\..\src\Horse.Core.Param.Config.pas',
  Horse.Rtti.Helper in '..\..\src\Horse.Rtti.Helper.pas',
  Horse.Rtti in '..\..\src\Horse.Rtti.pas',
  Horse.Callback in '..\..\src\Horse.Callback.pas',
  Horse.Core.RouterTree.NextCaller in '..\..\src\Horse.Core.RouterTree.NextCaller.pas',
  Horse.Exception.Interrupted in '..\..\src\Horse.Exception.Interrupted.pas',
  Horse.Session in '..\..\src\Horse.Session.pas',
  Horse.Core.Param.Field.Brackets in '..\..\src\Horse.Core.Param.Field.Brackets.pas',
  Horse.Core.Files in '..\..\src\Horse.Core.Files.pas',
  Tests.Horse.Core.Files in 'tests\Tests.Horse.Core.Files.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  NunitLogger: ITestLogger;

begin
  ReportMemoryLeaksOnShutdown := True;
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    IsConsole := False;
    TDUnitX.CheckCommandLine;

    Runner := TDUnitX.CreateRunner;
    Runner.UseRTTI := True;

    Logger := TDUnitXConsoleLogger.Create(true);
    Runner.AddLogger(Logger);

    NunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    Runner.AddLogger(NunitLogger);
    Runner.FailsOnNoAsserts := False;

    Results := Runner.Execute;
    if (not Results.AllPassed) then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
//    if (TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause) then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
