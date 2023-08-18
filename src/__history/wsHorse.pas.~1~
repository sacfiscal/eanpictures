unit wsHorse;

interface

uses Horse, Horse.Jhonson, Horse.OctetStream, Horse.HandleException,
  System.SysUtils, System.Net.HttpClientComponent, System.Net.HttpClient;

type
  TWsHorse = class
  private
    FHorse: THorse;
    FPath: String;
    procedure AddMethods;
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
  System.Classes, System.IOUtils, main.view, main.basedados, system.JSON;

{ TWsHorse }

function TWsHorse.Active: Boolean;
begin
 Result := FHorse.IsRunning;
end;

procedure TWsHorse.AddMethods;
begin
  with FHorse do
  begin
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

    Get('/api/descricao/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var wjson: tjsonobject;
    begin
      if Req.Params.Items['id'] <> '' then
      begin
        if basedados.fdConnection1.Connected= false then
        basedados.fdConnection1.Connected:=true;

        if mainview.MemoHistorico.lines.count > 10000 then
        mainview.MemoHistorico.lines.clear;

        with BaseDados.fdquery1 do
        begin
          close;
          sql.Clear;
//          sql.Add('select nome, ncm, cest_codigo, embalagem, quantidade_embalagem, marca, categoria, tributacao from cad_produtos where ean = :ean');
          sql.Add('select nome, ncm, cest_codigo, embalagem, quantidade_embalagem, marca, categoria from cad_produtos where ean = :ean');
          parambyname('ean').AsString:=Req.Params.Items['id'];
          open;
          if isempty = false then
          begin
            Res.Send(fieldbyname('nome').asstring).Status(200);
            inc(cont200);
            mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue descricao: '+Req.Params.Items['id']+ '|' +fieldbyname('nome').asstring);
          end
          else
          begin
            try
              wjson:=tjsonobject.Create;
              wjson.AddPair(tjsonpair.Create('Status','404'));
              wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para o ean: '+Req.Params.Items['id']));
              Res.Send<TJSONobject>(wjson).Status(404);;
              inc(cont404);
              mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);
            finally
            end;
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
          mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada para o ean: '+Req.Params.Items['id']);
        finally
        end;
      end;

    end);

    Get('/api/um2/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var wjson: tjsonobject;
    begin
      if Req.Params.Items['id'] <> '' then
      begin
        if mainview.MemoHistorico.lines.count > 10000 then
        mainview.MemoHistorico.lines.clear;

        if basedados.fdConnection1.Connected= false then
        basedados.fdConnection1.Connected:=true;

        with BaseDados.fdquery1 do
        begin
          close;
          sql.Clear;
          sql.Add('select nome from unidade_medida where id = :id');
          parambyname('id').AsString:=Req.Params.Items['id'];
          open;
          if isempty = false then
          begin
            Res.Send(fieldbyname('nome').asstring).Status(200);
            inc(cont200);
            mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue descricao unidade medida: '+Req.Params.Items['id']+ '|' +fieldbyname('nome').asstring);
          end
          else
          begin
            try
              wjson:=tjsonobject.Create;
              wjson.AddPair(tjsonpair.Create('Status','404'));
              wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para a unidade de medida: '+Req.Params.Items['id']));
              Res.Send<TJSONobject>(wjson).Status(404);;

              inc(cont404);
              mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada a unidade de meida: '+Req.Params.Items['id']);
            finally
            end;
          end;
        end;
      end
      else
      begin
        try
          wjson:=tjsonobject.Create;
          wjson.AddPair(tjsonpair.Create('Status','404'));
          wjson.AddPair(tjsonpair.Create('Status_Desc','Necessario enviar o codigo da unidade de medida. Ex: www.eanpictures.com.br:9000/api/um/M3'));
          Res.Send<TJSONobject>(wjson).Status(404);;

          inc(cont404);
          mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada a unidade de meida: '+Req.Params.Items['id']);

        finally
        end;
      end;
    end);

//***
    Get('/api/um/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var wjson: tjsonobject;
    begin

      if Req.Params.Items['id'] <> '' then
      begin
        if mainview.MemoHistorico.lines.count > 10000 then
        mainview.MemoHistorico.lines.clear;

        if basedados.fdConnection1.Connected= false then
        basedados.fdConnection1.Connected:=true;

        with BaseDados.fdquery1 do
        begin
          close;
          sql.Clear;
          sql.Add('select id, nome from unidade_medida where id = :id');
          parambyname('id').AsString:=Req.Params.Items['id'];
          open;
          if isempty = false then
          begin
            try
              wjson:=tjsonobject.Create;
              wjson.AddPair(tjsonpair.Create('Status','200'));
              wjson.AddPair(tjsonpair.Create('Status_Desc','Ok'));
              wjson.AddPair(tjsonpair.Create('id',removeacento(fieldbyname('id').asstring)));
              wjson.AddPair(tjsonpair.Create('nome',removeacento(fieldbyname('nome').asstring)));
              Res.Send<TJSONobject>(wjson).Status(200);;

              inc(cont200);
              mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue descricao unidade medida: '+Req.Params.Items['id']+ '|' +fieldbyname('nome').asstring);

            finally
            end;
          end
          else
          begin
            try
              wjson:=tjsonobject.Create;
              wjson.AddPair(tjsonpair.Create('Status','404'));
              wjson.AddPair(tjsonpair.Create('Status_Desc','Descricao nao encontrada para a unidade de medida: '+Req.Params.Items['id']));
              Res.Send<TJSONobject>(wjson).Status(404);;

              inc(cont404);
              mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada a unidade de meida: '+Req.Params.Items['id']);
            finally
            end;
          end;
        end;
      end
      else
      begin
        try
          wjson:=tjsonobject.Create;
          wjson.AddPair(tjsonpair.Create('Status','404'));
          wjson.AddPair(tjsonpair.Create('Status_Desc','Necessario enviar o codigo da unidade de medida. Ex: www.eanpictures.com.br:9000/api/um/M3'));
          Res.Send<TJSONobject>(wjson).Status(404);;

          inc(cont404);
          mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont404)+'|'+datetostr(date)+'|'+timetostr(now)+'| Descricao nao encontrada a unidade de meida: '+Req.Params.Items['id']);

        finally
        end;
      end;
    end);

//****

    Get('/api/desc/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var wjson: tjsonobject;
    begin
      if Req.Params.Items['id'] <> '' then
      begin
        if mainview.MemoHistorico.lines.count > 10000 then
        mainview.MemoHistorico.lines.clear;

        if basedados.fdConnection1.Connected= false then
        basedados.fdConnection1.Connected:=true;
        with BaseDados.fdquery1 do
        begin
          close;
          sql.Clear;
//          sql.Add('SELECT base_produtos.cad_produtos.ean, base_produtos.cad_produtos.nome, base_produtos.cad_produtos.peso,');
          sql.Add('SELECT base_produtos.cad_produtos.ean, base_produtos.cad_produtos.nome, ');
          sql.Add('base_produtos.cad_produtos.ncm, base_produtos.cad_produtos.cest_codigo, base_produtos.cad_produtos.embalagem, base_produtos.cad_produtos.quantidade_embalagem,');
//          sql.Add('base_produtos.cad_produtos.marca, base_produtos.cad_produtos.categoria, base_produtos.cad_produtos.id_categoria, base_produtos.cad_produtos.tributacao');
//          sql.Add('base_produtos.cad_produtos.marca, base_produtos.cad_produtos.categoria, base_produtos.cad_produtos.id_categoria');
          sql.Add('base_produtos.cad_produtos.marca, base_produtos.cad_produtos.categoria');
          sql.Add(' FROM base_produtos.cad_produtos');
          sql.Add('where ean = :ean');
          parambyname('ean').AsString:=Req.Params.Items['id'];
          open;

          if isempty = false then
          begin
            try
              wjson:=tjsonobject.Create;
              wjson.AddPair(tjsonpair.Create('Status','200'));
              wjson.AddPair(tjsonpair.Create('Status_Desc','Ok'));
              wjson.AddPair(tjsonpair.Create('Nome',removeacento(fieldbyname('nome').asstring)));
              wjson.AddPair(tjsonpair.Create('Ncm',removeacento(fieldbyname('ncm').asstring)));
              wjson.AddPair(tjsonpair.Create('Cest_Codigo',removeacento(fieldbyname('cest_codigo').asstring)));
              wjson.AddPair(tjsonpair.Create('Embalagem',removeacento(fieldbyname('embalagem').asstring)));
              wjson.AddPair(tjsonpair.Create('QuantidadeEmbalagem',removeacento(fieldbyname('quantidade_embalagem').asstring)));
              wjson.AddPair(tjsonpair.Create('Marca',removeacento(fieldbyname('marca').asstring)));
              wjson.AddPair(tjsonpair.Create('Categoria',removeacento(fieldbyname('categoria').asstring)));
//              wjson.AddPair(tjsonpair.Create('Peso',removeacento(fieldbyname('peso').asstring)));
              wjson.AddPair(tjsonpair.Create('Peso',''));
//              wjson.AddPair(tjsonpair.Create('id_categoria',removeacento(fieldbyname('id_categoria').asstring)));
              wjson.AddPair(tjsonpair.Create('id_categoria',''));
//              wjson.AddPair(tjsonpair.Create('tributacao',removeacento(fieldbyname('tributacao').asstring)));
              wjson.AddPair(tjsonpair.Create('tributacao',''));
              Res.Send<TJSONobject>(wjson).Status(200);;

              inc(cont200);
              mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue json: '+Req.Params.Items['id']+ '|' +fieldbyname('nome').asstring);
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

        if basedados.fdConnection1.Connected= false then
        basedados.fdConnection1.Connected:=true;
        with BaseDados.fdquery1 do
        begin
          close;
          sql.Clear;
          sql.Add('SELECT base_produtos.cad_produtos.ean, base_produtos.cad_produtos.nome, ');
//          sql.Add('SELECT base_produtos.cad_produtos.ean, base_produtos.cad_produtos.nome, base_produtos.cad_produtos.peso,');
          sql.Add('base_produtos.cad_produtos.ncm, base_produtos.cad_produtos.cest_codigo, base_produtos.cad_produtos.embalagem, base_produtos.cad_produtos.quantidade_embalagem,');
//          sql.Add('base_produtos.cad_produtos.marca, base_produtos.cad_produtos.categoria, base_produtos.cad_produtos.id_categoria, base_produtos.cad_produtos.tributacao');
//          sql.Add('base_produtos.cad_produtos.marca, base_produtos.cad_produtos.categoria, base_produtos.cad_produtos.id_categoria');
          sql.Add('base_produtos.cad_produtos.marca, base_produtos.cad_produtos.categoria');
          sql.Add(' FROM base_produtos.cad_produtos');
          sql.Add('where ean = :ean');
          parambyname('ean').AsString:=Req.Params.Items['id'];
          open;

          if isempty = false then
          begin
            try
              wjson:=tjsonobject.Create;
              wjson.AddPair(tjsonpair.Create('Status','200'));
              wjson.AddPair(tjsonpair.Create('Status_Desc','Ok'));
              wjson.AddPair(tjsonpair.Create('Nome',removeacento(fieldbyname('nome').asstring)));
              wjson.AddPair(tjsonpair.Create('Ncm',removeacento(fieldbyname('ncm').asstring)));
              wjson.AddPair(tjsonpair.Create('Cest_Codigo',removeacento(fieldbyname('cest_codigo').asstring)));
              wjson.AddPair(tjsonpair.Create('Embalagem',removeacento(fieldbyname('embalagem').asstring)));
              wjson.AddPair(tjsonpair.Create('QuantidadeEmbalagem',removeacento(fieldbyname('quantidade_embalagem').asstring)));
              wjson.AddPair(tjsonpair.Create('Marca',removeacento(fieldbyname('marca').asstring)));
              wjson.AddPair(tjsonpair.Create('Categoria',removeacento(fieldbyname('categoria').asstring)));
//              wjson.AddPair(tjsonpair.Create('Peso',removeacento(fieldbyname('peso').asstring)));
              wjson.AddPair(tjsonpair.Create('Peso',''));
//              wjson.AddPair(tjsonpair.Create('id_categoria',removeacento(fieldbyname('id_categoria').asstring)));
              wjson.AddPair(tjsonpair.Create('id_categoria',''));
//              wjson.AddPair(tjsonpair.Create('tributacao',removeacento(fieldbyname('tributacao').asstring)));
              wjson.AddPair(tjsonpair.Create('tributacao',''));
              Res.Send<TJSONobject>(wjson).Status(200);;

              inc(cont200);
              mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue json: '+Req.Params.Items['id']+ '|' +fieldbyname('nome').asstring);
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

        if basedados.fdConnection1.Connected= false then
        basedados.fdConnection1.Connected:=true;


        with BaseDados.fdquery1 do
        begin
          close;
          sql.Clear;
//          sql.Add('SELECT cad_produtos.ean, cad_produtos.nome, cad_produtos.peso,');
          sql.Add('SELECT cad_produtos.ean, cad_produtos.nome, ');
          sql.Add('cad_produtos.ncm, cad_produtos.cest_codigo, cad_produtos.embalagem, cad_produtos.quantidade_embalagem,');
//          sql.Add('cad_produtos.marca, cad_produtos.categoria, cad_produtos.id_categoria, cad_produtos.tributacao');
//          sql.Add('cad_produtos.marca, cad_produtos.categoria, cad_produtos.id_categoria');
          sql.Add('cad_produtos.marca, cad_produtos.categoria');
          sql.Add(' FROM cad_produtos');
          sql.Add('where ean = :ean');
          parambyname('ean').AsString:=Req.Params.Items['id'];
          open;

          if isempty = false then
          begin
            try
              oini:=TStringList.Create;
              oini.Add('[GENERAL]');
              oini.Add('Nome='+removeacento(fieldbyname('nome').asstring));
              oini.Add('Ncm='+removeacento(fieldbyname('ncm').asstring));
              oini.Add('Cest_Codigo='+removeacento(fieldbyname('cest_codigo').asstring));
              oini.Add('Embalagem='+removeacento(fieldbyname('embalagem').asstring));
              oini.Add('QuantidadeEmbalagem='+removeacento(fieldbyname('quantidade_embalagem').asstring));
              oini.Add('Marca='+removeacento(fieldbyname('marca').asstring));
              oini.Add('Categoria='+removeacento(fieldbyname('categoria').asstring));
              oini.Add('Peso='+'');
//              oini.Add('id_categoria='+removeacento(fieldbyname('id_categoria').asstring));
              oini.Add('id_categoria='+'');
//              oini.Add('tributacao'+removeacento(fieldbyname('tributacao').asstring));
              oini.Add('tributacao='+'');
              Res.Send(oini.TEXT).Status(200);

              freeandnil(oini);

              inc(cont200);
              mainview.memohistorico.lines.add(Req.RawWebRequest.RemoteAddr+' | '+inttostr(cont200)+'|'+datetostr(date)+'|'+timetostr(now)+'| Entregue INI: '+Req.Params.Items['id']+ '|' +fieldbyname('nome').asstring);
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
  FHorse := THorse.Create;
  with FHorse do
  begin
    Use(Jhonson);
    Use(OctetStream);
    Use(HandleException);
  end;
  AddMethods;
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
