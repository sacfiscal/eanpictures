unit wsHorse;

interface

uses Horse, Horse.Jhonson, Horse.OctetStream, Horse.HandleException,
  System.SysUtils, System.Net.HttpClientComponent, System.Net.HttpClient,

  Database.Tipos;

type
  TConnectionDefDriverParams = Database.Tipos.TConnectionDefDriverParams;
  TConnectionDefParams = Database.Tipos.TConnectionDefParams;
  TConnectionDefPoolParams = Database.Tipos.TConnectionDefPoolParams;

  TWsHorse = class
  private
    FHorse: THorse;
    FPath: String;

    FDBParams: TConnectionDefParams;
    FDBDriverParams: TConnectionDefDriverParams;
    FDBPoolParams: TConnectionDefPoolParams;

    procedure AddMethods;

    procedure LoadDatabaseConfig;
  public
    constructor Create;
    function Port(Value: Integer): TWsHorse;
    function Path(Value: String): TWsHorse;
    function Active: Boolean;
    procedure Power;
    function removeacento(const ptext: string):string;
    function somentenumero(snum: string): string;
    procedure baixacosmos(const ean: string);

  end;

implementation

uses
  System.Classes,
  System.IOUtils,
  main.view,
  system.JSON,

  Database.Factory,
  Ean.Controllers.Registry;

{ TWsHorse }

function TWsHorse.Active: Boolean;
begin
 Result := FHorse.IsRunning;
end;

procedure TWsHorse.AddMethods;
begin
  Ean.Controllers.Registry.DoRegistry;

  with FHorse do
  begin

    Get('/api/version',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      var LVersao := TJsonObject.Create;
      LVersao.AddPair('horseVersion', FHorse.Version);
      Res.Send<TJsonObject>(LVersao);
    end);

    Get('/api/gtin/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LFile: String;
      LFileSend: TFileReturn;
      LStream: TFileStream;
      LDisposition: String;
    begin
      LFile := FPath + somentenumero(Req.Params.Items['id']) + '.png';

//      if fileexists(lfile) = false then baixacosmos(somentenumero(Req.Params.Items['id']));

      if mainview.MemoHistorico.lines.count > 10000 then
      mainview.MemoHistorico.lines.clear;
      if FileExists(LFile) then
      begin
        try
          LStream   := TFileStream.Create(LFile, fmOpenRead);
          LFileSend := TFileReturn.Create( TPath.GetFileName(LFile), LStream, False);
          Res.Send<TFileReturn>(LFileSend).Status(200);
          inc(cont200);

          mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue arquivo: '+lfile);
        finally
        end;
      end
      else
      begin
        //quando pede foto eu nao envio json no retorno para evitar erro na conversao do lado do cliente
        inc(cont404);

        mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Arquivo nao encontrado: '+lfile);
        Res.Send('').Status(404);
      end;
    end);

    Get('/api/fotoexiste/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LFile: String;
    begin
      LFile := FPath + somentenumero(Req.Params.Items['id']) + '.png';


      if mainview.MemoHistorico.lines.count > 10000 then
      mainview.MemoHistorico.lines.clear;
      if FileExists(LFile) then
      begin
        try
          Res.Send('Sim').Status(200);
          inc(cont200);

          mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Consulta Arquivo : '+lfile+' Sim');
        finally
        end;
      end
      else
      begin
        Res.Send('Nao').Status(200);
        inc(cont200);
        mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Consulta Arquivo : '+lfile+' Nao');
      end;
    end);

    Get('/api/fotoexistej/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LFile: String;
      wjson: tjsonobject;
    begin
      LFile := FPath + somentenumero(Req.Params.Items['id']) + '.png';


      if mainview.MemoHistorico.lines.count > 10000 then
      mainview.MemoHistorico.lines.clear;

      wjson:=tjsonobject.Create;


      if FileExists(LFile) then
      begin
        try
          wjson.AddPair(tjsonpair.Create('Status','200'));
          wjson.AddPair(tjsonpair.Create('Status_Desc','Foto encontrada: '+Req.Params.Items['id']));
          Res.Send<TJSONobject>(wjson).Status(200);;
//          Res.Send('Sim').Status(200);
          inc(cont200);

          mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Consulta Arquivo : '+lfile+' Sim');
        finally
        end;
      end
      else
      begin
        wjson.AddPair(tjsonpair.Create('Status','404'));
        wjson.AddPair(tjsonpair.Create('Status_Desc','Foto nao encontrada: '+Req.Params.Items['id']));
        Res.Send<TJSONobject>(wjson).Status(200);;
//        Res.Send('Nao').Status(200);
        inc(cont200);
        mainview.MemoHistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Consulta Arquivo : '+lfile+' Nao');
      end;
    end);

//***
    

//****

    Get('/api/desc/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var wjson: tjsonobject;
    begin
      if Req.Params.Items['id'] <> '' then
      begin
        if mainview.MemoHistorico.lines.count > 10000 then
        mainview.MemoHistorico.lines.clear;

        var LSql := #13#10
        + 'SELECT cp.ean, cp.nome, cp.ncm, cp.cest_codigo, cp.embalagem,  '
        + '       cp.quantidade_embalagem, cp.marca, cp.categoria '
        + 'FROM base_produtos.cad_produtos cp '
        + 'where ean = :ean '
        ;

        var ds := TDatabaseFactory.New.SQL
          .SQL(Lsql)
          .ParamList
            .AddString('ean', Req.Params.Items['id'])
            .&End
          .Open();

        if not ds.IsEmpty then
        begin
          try
            wjson:=tjsonobject.Create;
            wjson.AddPair(tjsonpair.Create('Status','200'));
            wjson.AddPair(tjsonpair.Create('Status_Desc','Ok'));
            wjson.AddPair(tjsonpair.Create('Nome',removeacento(ds.FieldByName('nome').asstring)));
            wjson.AddPair(tjsonpair.Create('Ncm',removeacento(ds.FieldByName('ncm').asstring)));
            wjson.AddPair(tjsonpair.Create('Cest_Codigo',removeacento(ds.FieldByName('cest_codigo').asstring)));
            wjson.AddPair(tjsonpair.Create('Embalagem',removeacento(ds.FieldByName('embalagem').asstring)));
            wjson.AddPair(tjsonpair.Create('QuantidadeEmbalagem',removeacento(ds.FieldByName('quantidade_embalagem').asstring)));
            wjson.AddPair(tjsonpair.Create('Marca',removeacento(ds.FieldByName('marca').asstring)));
            wjson.AddPair(tjsonpair.Create('Categoria',removeacento(ds.FieldByName('categoria').asstring)));
//              wjson.AddPair(tjsonpair.Create('Peso',removeacento(ds.FieldByName('peso').asstring)));
            wjson.AddPair(tjsonpair.Create('Peso',''));
//              wjson.AddPair(tjsonpair.Create('id_categoria',removeacento(ds.FieldByName('id_categoria').asstring)));
            wjson.AddPair(tjsonpair.Create('id_categoria',''));
//              wjson.AddPair(tjsonpair.Create('tributacao',removeacento(ds.FieldByName('tributacao').asstring)));
            wjson.AddPair(tjsonpair.Create('tributacao',''));
            Res.Send<TJSONobject>(wjson).Status(200);;

            inc(cont200);
            mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+
              timetostr(now)+'| Entregue json: '+Req.Params.Items['id']+ '|' +ds.FieldByName('nome').asstring);
          finally
          end;
        end
        else
        begin
          try
            wjson:=tjsonobject.Create;
            wjson.AddPair(tjsonpair.Create('Status','404'));
            wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para o ean: '+Req.Params.Items['id']));
            Res.Send<TJSONobject>(wjson).Status(404);;

            inc(cont404);
            mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);
          finally
          end;
        end;
      end
      else
      begin
        try
          wjson:=tjsonobject.Create;
          wjson.AddPair(tjsonpair.Create('Status','404'));
          wjson.AddPair(tjsonpair.Create('Status_Desc','Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789'));
          Res.Send<TJSONobject>(wjson).Status(404);;

          inc(cont404);
          mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);
        finally
        end;
      end;
    end);

    //************

    Get('/api/desc200/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var wjson: tjsonobject;
    begin
      if Req.Params.Items['id'] <> '' then
      begin
        if mainview.MemoHistorico.lines.count > 10000 then
        mainview.MemoHistorico.lines.clear;

        var LSql := #13#10
        + 'SELECT cp.ean, cp.nome, cp.ncm, cp.cest_codigo, cp.embalagem,  '
        + '       cp.quantidade_embalagem, cp.marca, cp.categoria '
        + 'FROM base_produtos.cad_produtos cp '
        + 'where ean = :ean '
        ;

        var ds := TDatabaseFactory.New.SQL
          .SQL(Lsql)
          .ParamList
            .AddString('ean', Req.Params.Items['id'])
            .&End
          .Open();

        if not ds.IsEmpty then
        begin
          try
            wjson:=tjsonobject.Create;
            wjson.AddPair(tjsonpair.Create('Status','200'));
            wjson.AddPair(tjsonpair.Create('Status_Desc','Ok'));
            wjson.AddPair(tjsonpair.Create('Nome',removeacento(ds.FieldByName('nome').asstring)));
            wjson.AddPair(tjsonpair.Create('Ncm',removeacento(ds.FieldByName('ncm').asstring)));
            wjson.AddPair(tjsonpair.Create('Cest_Codigo',removeacento(ds.FieldByName('cest_codigo').asstring)));
            wjson.AddPair(tjsonpair.Create('Embalagem',removeacento(ds.FieldByName('embalagem').asstring)));
            wjson.AddPair(tjsonpair.Create('QuantidadeEmbalagem',removeacento(ds.FieldByName('quantidade_embalagem').asstring)));
            wjson.AddPair(tjsonpair.Create('Marca',removeacento(ds.FieldByName('marca').asstring)));
            wjson.AddPair(tjsonpair.Create('Categoria',removeacento(ds.FieldByName('categoria').asstring)));
//              wjson.AddPair(tjsonpair.Create('Peso',removeacento(ds.FieldByName('peso').asstring)));
            wjson.AddPair(tjsonpair.Create('Peso',''));
//              wjson.AddPair(tjsonpair.Create('id_categoria',removeacento(ds.FieldByName('id_categoria').asstring)));
            wjson.AddPair(tjsonpair.Create('id_categoria',''));
//              wjson.AddPair(tjsonpair.Create('tributacao',removeacento(ds.FieldByName('tributacao').asstring)));
            wjson.AddPair(tjsonpair.Create('tributacao',''));
            Res.Send<TJSONobject>(wjson).Status(200);;

            inc(cont200);
            mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+
              timetostr(now)+'| Entregue json: '+Req.Params.Items['id']+ '|' +ds.FieldByName('nome').asstring);
          finally
          end;
        end
        else
        begin
          try
            wjson:=tjsonobject.Create;
            wjson.AddPair(tjsonpair.Create('Status','404'));
            wjson.AddPair(tjsonpair.Create('Status_Desc','404'));
            wjson.AddPair(tjsonpair.Create('Nome','404'));
            wjson.AddPair(tjsonpair.Create('Ncm','404'));
            wjson.AddPair(tjsonpair.Create('Cest_Codigo','404'));
            wjson.AddPair(tjsonpair.Create('Embalagem','404'));
            wjson.AddPair(tjsonpair.Create('QuantidadeEmbalagem','0'));
            wjson.AddPair(tjsonpair.Create('Marca','404'));
            wjson.AddPair(tjsonpair.Create('Categoria','404'));
            wjson.AddPair(tjsonpair.Create('Peso','0'));
            wjson.AddPair(tjsonpair.Create('id_categoria','0'));
            wjson.AddPair(tjsonpair.Create('tributacao','404'));
            Res.Send<TJSONobject>(wjson).Status(200);;

            inc(cont404);
            mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);
          finally
          end;
        end;
      end
      else
      begin
        try
          wjson:=tjsonobject.Create;
          wjson.AddPair(tjsonpair.Create('Status','404'));
          wjson.AddPair(tjsonpair.Create('Status_Desc','Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789'));
          Res.Send<TJSONobject>(wjson).Status(404);;

          inc(cont404);
          mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);

        finally
        end;
      end;
    end);
    //************


    Get('/api/desc_ini/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var oini: tstringlist;
    var wjson: tjsonobject;
    begin
      if Req.Params.Items['id'] <> '' then
      begin
        if mainview.MemoHistorico.lines.count > 10000 then
        mainview.MemoHistorico.lines.clear;

        var LSql := #13#10
        + 'SELECT cp.ean, cp.nome, cp.ncm, cp.cest_codigo, cp.embalagem,  '
        + '       cp.quantidade_embalagem, cp.marca, cp.categoria '
        + 'FROM base_produtos.cad_produtos cp '
        + 'where ean = :ean '
        ;

        var ds := TDatabaseFactory.New.SQL
          .SQL(Lsql)
          .ParamList
            .AddString('ean', Req.Params.Items['id'])
            .&End
          .Open();

        if not ds.IsEmpty then
        begin
          try
            oini:=TStringList.Create;
            oini.Add('[GENERAL]');
            oini.Add('Nome='+removeacento(ds.FieldByName('nome').asstring));
            oini.Add('Ncm='+removeacento(ds.FieldByName('ncm').asstring));
            oini.Add('Cest_Codigo='+removeacento(ds.FieldByName('cest_codigo').asstring));
            oini.Add('Embalagem='+removeacento(ds.FieldByName('embalagem').asstring));
            oini.Add('QuantidadeEmbalagem='+removeacento(ds.FieldByName('quantidade_embalagem').asstring));
            oini.Add('Marca='+removeacento(ds.FieldByName('marca').asstring));
            oini.Add('Categoria='+removeacento(ds.FieldByName('categoria').asstring));
            oini.Add('Peso='+'');
//              oini.Add('id_categoria='+removeacento(ds.FieldByName('id_categoria').asstring));
            oini.Add('id_categoria='+'');
//              oini.Add('tributacao'+removeacento(ds.FieldByName('tributacao').asstring));
            oini.Add('tributacao='+'');
            Res.Send(oini.TEXT).Status(200);

            freeandnil(oini);

            inc(cont200);
            mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+
              timetostr(now)+'| Entregue INI: '+Req.Params.Items['id']+ '|' +ds.FieldByName('nome').asstring);
          finally
          end;
        end
        else
        begin
          try
            wjson:=tjsonobject.Create;
            wjson.AddPair(tjsonpair.Create('Status','404'));
            wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para o ean: '+Req.Params.Items['id']));
            Res.Send<TJSONobject>(wjson).Status(404);;

            inc(cont404);
            mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);
          finally
          end;
        end;
      end
      else
      begin
        try
          wjson:=tjsonobject.Create;
          wjson.AddPair(tjsonpair.Create('Status','404'));
          wjson.AddPair(tjsonpair.Create('Status_Desc','Necessario enviar o codigo da mercadoria. Ex: www.eanpictures.com.br:9000/api/descricao/789789789789'));
          Res.Send<TJSONobject>(wjson).Status(404);;

          inc(cont404);
          mainview.memohistorico.lines.add(inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);

        finally
        end;
      end;
    end);

    //************
  end;
end;

constructor TWsHorse.Create;
begin
  LoadDatabaseConfig;

  FHorse := THorse.Create;
  with FHorse do
  begin
    Use(Jhonson);
    Use(OctetStream);
    Use(HandleException);
  end;
  AddMethods;
end;

procedure TWsHorse.LoadDatabaseConfig;
begin
  FDBParams.ConnectionDefName := 'bd_teste';
  FDBParams.Database := 'base_produtos';
  FDBParams.UserName := 'sacfiscal';
  FDBParams.Password := 'Abc123abcc#';
  FDBParams.Server := '127.0.0.1';
  FDBParams.Port := 3306;

  FDBDriverParams.DriverID := 'MySQL';
  FDBDriverParams.DriverDefName := 'MYSQL_DRIVER';
  FDBDriverParams.VendorLib := 'C:\#DEV\#Projetos\eanpictures4D\Win32\Debug\libmysql.dll';

  FDBParams.LocalConnection := False;
  FDBPoolParams.Pooled := True;

  FDBPoolParams.PoolMaximumItems := 50;
  FDBPoolParams.PoolCleanupTimeout := 30000;
  FDBPoolParams.PoolExpireTimeout := 60000;

  TDatabaseFactory.New
    .Conexao
      .SetConnectionDefDriverParams(FDBDriverParams)
      .SetConnectionDefParams(FDBParams)
      .SetConnectionDefPoolParams(FDBPoolParams)
    .IniciaPoolConexoes;
end;

function TWsHorse.Port(Value: Integer): TWsHorse;
begin
  Result := Self;
  FHorse.Port := Value;
end;

function TWsHorse.Path(Value: String): TWsHorse;
begin
  Result := Self;
  FPath := Value;
end;

procedure TWsHorse.Power;
begin
  if FHorse.IsRunning
  then FHorse.StopListen
  else FHorse.Listen;
end;


function twshorse.removeacento(const ptext: string):string;
type
  usaascii20127 = type ansistring(20127);
begin
    result:=string(usaascii20127(ptext));
end;

function twshorse.somentenumero(snum: string): string;
var s1, s2: string;
  i: integer;
begin
  s1 := snum;
  s2 := '';
  for i := 1 to length(s1) do
    if s1[i] in ['0' .. '9'] then
    s2:=s2 + s1[i];
  result:=s2;
end;

procedure TWsHorse.baixacosmos(const ean: string);
var
  Pasta: String;
  i: Integer;
  //
  Client_: TNetHTTPClient;
  lfile: string;
begin
  //nao rodou no windows server
  LFile := FPath + 'Cosmos'+'\'+somentenumero(ean) + '.png';
  if directoryexists(FPath + 'Cosmos') = false then
  CreateDir(FPath + 'Cosmos');


  begin
    if EAN.Length > 0 then
      if not FileExists(lfile) then
      begin
        Client_ := TNetHTTPClient.Create(nil);
        Client_.Name := 'Client_';
        Client_.AcceptEncoding := 'raw';
        Client_.UserAgent := 'Embarcadero URI Client/1.0';
        Client_.SecureProtocols := [THTTPSecureProtocol.TLS12];
        //
        TMemoryStream(IHTTPResponse(Client_.Get('https://cdn-cosmos.bluesoft.com.br/products/' + EAN)).ContentStream).SaveToFile(lfile);
        //
        Client_.Free;

        mainview.MemoHistorico.lines.ADD('******Baixado arquivo direto da cosmos: '+lfile+' | '+'https://cdn-cosmos.bluesoft.com.br/products/' + EAN);

      end;

  end;
end;


end.
