object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'Servidor EanPictures 2.9 - Sac Fiscal | Firedac'
  ClientHeight = 571
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 41
    Align = alTop
    Caption = 'Server'
    TabOrder = 0
    ExplicitWidth = 1004
  end
  object Panel3: TPanel
    Left = 0
    Top = 530
    Width = 1008
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 529
    ExplicitWidth = 1004
    DesignSize = (
      1008
      41)
    object btnPower: TBitBtn
      Left = 862
      Top = 5
      Width = 142
      Height = 30
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Start'
      TabOrder = 0
      OnClick = btnPowerClick
      ExplicitLeft = 858
    end
    object btnSaveConfig: TBitBtn
      Left = 661
      Top = 5
      Width = 75
      Height = 30
      Anchors = []
      Caption = 'Save Config'
      TabOrder = 1
      OnClick = btnSaveConfigClick
      ExplicitLeft = 658
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 47
    Width = 1008
    Height = 482
    TabOrder = 2
    object Bevel1: TBevel
      Left = 1
      Top = 465
      Width = 1006
      Height = 16
      Align = alBottom
      ExplicitTop = 337
    end
    object Label1: TLabel
      Left = 4
      Top = 419
      Width = 147
      Height = 13
      Caption = 'Total de Resquests resolvidos:'
    end
    object Label2: TLabel
      Left = 4
      Top = 443
      Width = 117
      Height = 13
      Caption = 'Total de Resquests 404:'
    end
    object ValueListEditor1: TValueListEditor
      Left = 1
      Top = 1
      Width = 1006
      Height = 80
      Align = alTop
      TabOrder = 0
      ColWidths = (
        150
        850)
      RowHeights = (
        18
        18)
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 81
      Width = 1006
      Height = 336
      Align = alTop
      Caption = 'Hist'#243'rico'
      TabOrder = 1
      object MemoHistorico: TMemo
        Left = 2
        Top = 15
        Width = 1002
        Height = 319
        Align = alClient
        Lines.Strings = (
          'MemoOK')
        TabOrder = 0
        OnChange = MemoHistoricoChange
        ExplicitLeft = 1
        ExplicitTop = 14
      end
    end
    object Edit1: TEdit
      Left = 160
      Top = 416
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 160
      Top = 440
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'Edit1'
    end
  end
end
