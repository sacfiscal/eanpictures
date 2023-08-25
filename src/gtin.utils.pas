unit gtin.utils;

interface

uses System.Classes, System.SysUtils,
     System.JSON, System.JSON.Serializers, System.JSON.Types,
     System.Net.HttpClientComponent, System.Net.HttpClient;

type
   TUtils = Class
   Public
     Class function NumberOnly(Value : String) : String;
     Class function AlphaOnly(Value : String) : String; Overload;
     Class function AlphaOnly(IsAlpha : Boolean; Value : String) : String; Overload;

     Class function DownloadFile(Value : String) : TStream; Overload;
     Class function DownloadFile(Value : String; FileName : TFileName) : TFileName; Overload;

     Class function ToJSonString<T : Class>(Value : TObject; IsIndented : Boolean = False; IsHtml : Boolean = True) : String;
     Class function ToJSonValue<T : Class>(Value : TObject) : TJSONValue;
     Class function ToValueJSon<T : Class>(Value : String) : T;
   End;

implementation

{ TUtils }

class function TUtils.AlphaOnly(Value: String): String;
type
   StrAscii20127 = type Ansistring(20127);
begin
   Result := String(StrAscii20127(Value));
end;

class function TUtils.DownloadFile(Value : String): TStream;
var Http : TNetHTTPClient;
begin
   Result := nil;
   If Value.IsEmpty Then
      Exit;

   Result := TMemoryStream.Create;

   Http := TNetHTTPClient.Create(nil);
   Try
     Http.Name            := 'httpClient_';
     Http.AcceptEncoding  := 'raw';
     Http.UserAgent       := 'Embarcadero URI Client/1.0';
     Http.SecureProtocols := [THTTPSecureProtocol.TLS12];

     Result.CopyFrom(IHTTPResponse(Http.Get(Value)).ContentStream);
   Finally
     FreeAndNil(Http);
   End;
end;

class function TUtils.AlphaOnly(IsAlpha: Boolean; Value: String): String;
begin
   Result := Value;
   If IsAlpha Then
      Result := AlphaOnly(Result);
end;

class function TUtils.DownloadFile(Value: String;
  FileName: TFileName): TFileName;
var S : TMemoryStream;
begin
   S := TMemoryStream(DownloadFile(Value));
   If not Assigned(S) Then
      Exit;

   Try
     S.SaveToFile(FileName);
   Finally
     FreeAndNil(S);
   End;
end;

class function TUtils.NumberOnly(Value: String): String;
var I : Integer;
begin
   Result := '';
   For I := Low(Value) to High(Value) Do
      If (Value[I] in ['0' .. '9']) Then
         Result := Result + Value[I];
end;

class function TUtils.ToJSonString<T>(Value: TObject; IsIndented, IsHtml : Boolean) : String;
var J : TJsonSerializer;
begin
   J := TJsonSerializer.Create;
   Try
     J.Formatting           := TJsonFormatting.None;
     J.DateFormatHandling   := TJsonDateFormatHandling.Iso;
     J.DateTimeZoneHandling := TJsonDateTimeZoneHandling.Utc;

     If IsIndented Then
        J.Formatting := TJsonFormatting.Indented;

     If IsHtml Then
        J.StringEscapeHandling := TJsonStringEscapeHandling.EscapeHtml;

     Result := J.Serialize(Value);
   Finally
     FreeAndNil(J);
   End;
end;

class function TUtils.ToJSonValue<T>(Value: TObject): TJSONValue;
var S : String;
begin
   S      := ToJSonString<T>(Value);
   Result := TJSONObject.ParseJSONValue(S);
end;

class function TUtils.ToValueJSon<T>(Value: String): T;
var J : TJsonSerializer;
    S : String;
begin
   Result := nil;
   If S.IsEmpty Or (S = 'null') Then
      Exit;

   J := TJsonSerializer.Create;
   Try
     J.Formatting           := TJsonFormatting.None;
     J.DateFormatHandling   := TJsonDateFormatHandling.Iso;
     J.DateTimeZoneHandling := TJsonDateTimeZoneHandling.Utc;
     J.StringEscapeHandling := TJsonStringEscapeHandling.EscapeHtml;
     Try
       Result := J.Deserialize<T>(S);
     Except
       FreeAndNil(Result);
     End;
   Finally
     FreeAndNil(J);
   End;
end;

end.
