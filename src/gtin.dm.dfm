object DM: TDM
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 343
  Width = 410
  PixelsPerInch = 96
  object DBConnectFirebird: TFDConnection
    Params.Strings = (
      'Server=127.0.0.1'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Database=GTIN'
      'Port=3051'
      'DriverID=FB')
    ResourceOptions.AssignedValues = [rvAutoReconnect]
    ResourceOptions.AutoReconnect = True
    LoginPrompt = False
    Left = 51
    Top = 43
  end
  object DBConnectMySQL: TFDConnection
    Params.Strings = (
      'Server=127.0.0.1'
      'User_Name=sacfiscal'
      'Password=Abc123abcc#'
      'Database=base_produtos'
      'DriverID=MySQL')
    ResourceOptions.AssignedValues = [rvAutoReconnect]
    ResourceOptions.AutoReconnect = True
    LoginPrompt = False
    Left = 243
    Top = 43
  end
  object PhysFBDriverLink: TFDPhysFBDriverLink
    VendorLib = 'C:\WEBSERVICES\fbclient.dll'
    Left = 48
    Top = 104
  end
  object PhysMySQLDriverLink: TFDPhysMySQLDriverLink
    Left = 240
    Top = 104
  end
end
