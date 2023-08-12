object BaseDados: TBaseDados
  Left = 0
  Top = 0
  Caption = 'BaseDados'
  ClientHeight = 230
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object fdQuery1: TFDQuery
    Connection = FdConnection1
    Left = 208
    Top = 96
  end
  object FdConnection1: TFDConnection
    Params.Strings = (
      'Server=127.0.0.1'
      'User_Name=sacfiscal'
      'Password=Abc123abcc#'
      'Database=base_produtos'
      'DriverID=MySQL')
    ResourceOptions.AssignedValues = [rvAutoReconnect]
    ResourceOptions.AutoReconnect = True
    LoginPrompt = False
    Left = 123
    Top = 91
  end
end
