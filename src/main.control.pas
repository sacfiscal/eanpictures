unit main.control;

interface

uses System.Classes, System.SysUtils, System.IOUtils, wsHorse;

type
  TMainControl = class
  private
    FWS         : TWsHorse;
    FConfig     : TStrings;
    FFileConfig : String;

    function GetWs : TWsHorse;
    procedure LoadConfig;
    function GetConfigParams(Key: String): String;
    property WS : TWsHorse Read GetWs;
  public
    Constructor Create;
    Destructor Destroy; Override;

    property Config : TStrings Read FConfig;

    procedure Power;
    procedure Log(Value : TProc<String>);

    procedure SaveConfig(Values: TStrings);
    function Active: Boolean;
  end;

implementation

{ TMainControl }

function TMainControl.Active: Boolean;
begin
   Result := WS.Active;
end;

constructor TMainControl.Create;
begin
   FWS         := nil;

   FConfig     := TStringList.Create;
   FFileConfig := TPath.GetDirectoryName(ParamStr(0)) + '\config.ini';

   LoadConfig;
end;

destructor TMainControl.Destroy;
begin
   If Assigned(FWS) Then
      FreeAndNil(FWS);

   FreeAndNil(FConfig);

   inherited;
end;

function TMainControl.GetConfigParams(Key: String): String;
begin
   Result := Config.Values[Key];
end;

function TMainControl.GetWs: TWsHorse;
begin
   If not Assigned(FWS) then
      FWS := TWsHorse.Create;
   Result := FWS;
end;

procedure TMainControl.LoadConfig;
begin
   If FileExists( FFileConfig ) Then
   Begin
      Config.LoadFromFile( FFileConfig );
      Exit;
   End;

   Config.AddPair('Path', TPath.GetDirectoryName(FFileConfig) + '\files\' );
   Config.AddPair('Port', '9000' );
   Config.SaveToFile( FFileConfig );
end;

procedure TMainControl.Log(Value: TProc<String>);
begin
   WS.Log(Value);
end;

procedure TMainControl.SaveConfig(Values: TStrings);
begin
   Config.Assign(Values);
   Config.SaveToFile( FFileConfig );
end;

procedure TMainControl.Power;
begin
   If (not Active) Then
   Begin
      WS.Port( GetConfigParams('Port').ToInteger )
        .Path( GetConfigParams('Path') );
   End;
   WS.Power;
end;

end.
