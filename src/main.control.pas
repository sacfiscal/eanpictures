unit main.control;

interface

uses
  wsHorse, System.Classes;

type
  TMainControl = class
  private
    FWS: TWsHorse;
    FConfig: TStrings;
    FFileConfig: String;
    function GetWs: TWsHorse;
    procedure LoadConfig;
    function GetConfigParams(Key: String): String;
    property WS: TWsHorse read GetWs;

    class var MainControl: TMainControl;
  public
    constructor Create;
    destructor Destroy;
    procedure Power;
    procedure SaveConfig(Values: TStrings);
    property Config: TStrings read FConfig;
    function Active: Boolean;

    function GetPath: String;
    function GetPort: Integer;

    class function GetInstance: TMainControl;
    class destructor UnInitialize;
  end;

implementation

uses
  System.IOUtils, System.SysUtils;

{ TMainControl }

function TMainControl.Active: Boolean;
begin
  Result := WS.Active;
end;

constructor TMainControl.Create;
begin
  FConfig := TStringList.Create;

  FFileConfig := TPath.GetDirectoryName(ParamStr(0))+'\config.ini';
  LoadConfig;
end;

destructor TMainControl.Destroy;
begin
  FConfig.Free;
end;

function TMainControl.GetConfigParams(Key: String): String;
begin
  result := Config.Values[Key];
end;

class function TMainControl.GetInstance: TMainControl;
begin
  if MainControl = nil
  then MainControl := TMainControl.Create;

  Result := MainControl;
end;

function TMainControl.GetPath: String;
begin
  Result := GetConfigParams('Path');
end;

function TMainControl.GetPort: Integer;
begin
  Result := StrToIntDef(GetConfigParams('Port'), 9000);
end;

function TMainControl.GetWs: TWsHorse;
begin
  if not Assigned(FWS)  then
     FWS := TWsHorse.Create;
  Result := FWS;
end;

procedure TMainControl.LoadConfig;
begin
  if FileExists( FFileConfig )  then
     Config.LoadFromFile( FFileConfig )
  else
      begin
        Config.AddPair('Path', TPath.GetDirectoryName(FFileConfig) + '\files\' );
        Config.AddPair('Port', '9000' );
        Config.SaveToFile( FFileConfig );
      end;
end;

procedure TMainControl.SaveConfig(Values: TStrings);
begin
  Config.Assign(Values);
  Config.SaveToFile( FFileConfig );
end;

class destructor TMainControl.UnInitialize;
begin
  if MainControl <> nil
  then FreeAndNil(MainControl);
end;

procedure TMainControl.Power;
begin
  if not Active then
  begin
    WS.Port( Self.GetPort )
      .Path( Self.GetPath )
  end;
  WS.Power;
end;

end.
