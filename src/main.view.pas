unit main.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  main.control, Vcl.Grids, Vcl.ValEdit;

type
  TMainView = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    btnPower: TBitBtn;
    btnSaveConfig: TBitBtn;
    Panel2: TPanel;
    vlEditor: TValueListEditor;
    gbLog: TGroupBox;
    mmLog: TMemo;
    btnTest: TBitBtn;
    btnClear: TBitBtn;
    pnl200: TPanel;
    pnl404: TPanel;
    Panel6: TPanel;
    lbl_200: TLabel;
    lbl200: TLabel;
    lbl_404: TLabel;
    lbl404: TLabel;
    lbl_db: TLabel;
    BitBtn1: TBitBtn;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnPowerClick(Sender: TObject);
    procedure btnSaveConfigClick(Sender: TObject);
    procedure mmLogChange(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FControl : TMainControl;

    procedure OnLog(Value : String);

    procedure LoadConfigFile;
    procedure SaveConfigFile;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;
  Cont404, Cont200 : Int64;

implementation

uses gtin.consts,
     gtin.utils,
     gtin.dm;

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
   FControl := TMainControl.Create;
   FControl.Log(OnLog);

   LoadConfigFile;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
   FreeAndNil(FControl);
end;

procedure TMainView.btnSaveConfigClick(Sender: TObject);
begin
   SaveConfigFile;
end;

procedure TMainView.btnTestClick(Sender: TObject);
var D : TDM;
    O : TObject;
begin
   D := TDM.Create(Self);

   mmLog.Lines.Clear;

   O := D.GetGTIN(TVersion.v01,'7894900011517');
   Try
     mmLog.Lines.Add('-> GTIN - Versão 01');
     mmLog.Lines.Add('------------');
     mmLog.Lines.Add('');
     mmLog.Lines.Add( TUtils.ToJSonString<TObject>(O,True) );
     mmLog.Lines.Add('');
   Finally
     FreeAndNil(O);
   End;

   O := D.GetGTIN(TVersion.v02,'7894900011517');
   Try
     mmLog.Lines.Add('-> GTIN - Versão 02');
     mmLog.Lines.Add('------------');
     mmLog.Lines.Add('');
     mmLog.Lines.Add( TUtils.ToJSonString<TObject>(O,True) );
     mmLog.Lines.Add('');
   Finally
     FreeAndNil(O);
   End;

   O := D.GetGTIN_Unid_Med(TVersion.v02,'');
   Try
     mmLog.Lines.Add('-> Unidade Medida - Versão 02');
     mmLog.Lines.Add('------------');
     mmLog.Lines.Add('');
     mmLog.Lines.Add( TUtils.ToJSonString<TObject>(O,True) );
     mmLog.Lines.Add('');
   Finally
     FreeAndNil(O);
   End;

   FreeAndNil(O);
end;

procedure TMainView.btnClearClick(Sender: TObject);
begin
   AtomicIncrement(Cont200,- Cont200);
   AtomicIncrement(Cont404,- Cont404);
   mmLog.Clear;
end;

procedure TMainView.btnPowerClick(Sender: TObject);
begin
   FControl.Config.Assign( vlEditor.Strings );
   FControl.Power;

   btnPower.Caption := 'Stop';
   If not FControl.Active Then
      btnPower.Caption := 'Start';
end;

procedure TMainView.LoadConfigFile;
begin
   vlEditor.Strings.Assign( FControl.Config );
end;

procedure TMainView.mmLogChange(Sender: TObject);
begin
   lbl200.Caption := FormatFloat('000',Cont200);
   lbl404.Caption := FormatFloat('000',Cont404);
end;

procedure TMainView.OnLog(Value: String);
begin
   mmLog.Lines.BeginUpdate;
   Try
     If (mmLog.Lines.Count > 10000) Then
        mmLog.Lines.Clear;

     mmLog.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss',Now) +' | '+ Value);

   Finally
     mmLog.Lines.EndUpdate;
   End;
end;

procedure TMainView.SaveConfigFile;
begin
   FControl.SaveConfig( vlEditor.Strings );
   LoadConfigFile;
end;

end.
