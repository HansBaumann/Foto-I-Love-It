unit ArbeitsUnit1;

interface

uses
  System.SysUtils, System.Classes;

type
  TArbeitsModul1 = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    str_ConfigDatei : string;
    sl_ConfigWerte : TStringList;
    bool_ConfigGeaendert : boolean;
    procedure SendeText ( str_Titel, str_Inhalt : string );
    procedure SendeZahl ( i : integer );
    procedure ErzeugeConfigdatei;
    procedure SpeichereConfigdatei;
    procedure DefaultWerteChecken;
    function GetValue(str_Ident: string): string;
    procedure SetValue(str_Ident: string; const Value: string);
  public
    { Public-Deklarationen }
    {$REGION 'Value'}
    /// <summary>
    ///   Value reads and writes a Setting in INI File
    /// </summary>
    /// <param name="str_Ident : string">
    ///   Ident of Item
    /// </param>
    /// <param name="Value : string">
    ///   Value of the Item, readable and writeable
    /// </param>
    {$ENDREGION}
    property Value [ str_Ident : string ] : string read GetValue write SetValue;
  published
  end;

var
  ArbeitsModul1: TArbeitsModul1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.Messaging
  , System.IOUtils
  , KonstantenUnit1;

procedure TArbeitsModul1.DataModuleCreate(Sender: TObject);
begin
  bool_ConfigGeaendert := False;
  sl_ConfigWerte := TStringList.Create;
  str_ConfigDatei :=
      TPath.GetHomePath + TPath.DirectorySeparatorChar + cStrFirma + TPath.DirectorySeparatorChar
      +'config'+TPath.DirectorySeparatorChar
      + ChangeFileExt( ExtractFileName( ParamStr(0)), '.config' );
  if not FileExists(str_ConfigDatei) then
  begin
    ForceDirectories( ExtractFilePath( str_ConfigDatei ) );
    ErzeugeConfigdatei;
  end
  else
  try
    sl_ConfigWerte.LoadFromFile( str_ConfigDatei );
  except on E: Exception do
    SendeText( cStrFehlermeldung, E.Message );
  end;
  DefaultWerteChecken;

  SendeText( cStrEinstellungen, sl_ConfigWerte.Text );

end;

procedure TArbeitsModul1.SendeText(str_Titel, str_Inhalt: string);
var
  MessageManager: TMessageManager;
  Message: TMessage;
  str_text: string;
begin
  MessageManager := TMessageManager.DefaultManager;
  str_text := str_titel+#13#10+str_Inhalt;
  Message := TMessage<UnicodeString>.Create(str_text);
  MessageManager.SendMessage(NIL, Message);
end;

procedure TArbeitsModul1.SendeZahl(i: integer);
var
  MessageManager: TMessageManager;
  Message: TMessage;
  str_text: string;
begin
  MessageManager := TMessageManager.DefaultManager;
  Message := TMessage<Integer>.Create(i);
  MessageManager.SendMessage(NIL, Message);
end;

procedure TArbeitsModul1.SetValue(str_Ident: string; const Value: string);
begin
  sl_ConfigWerte.Values[str_Ident] := Value;
  bool_ConfigGeaendert := True;
  SendeText( cStrEinstellungen, sl_ConfigWerte.Text );
end;

procedure TArbeitsModul1.ErzeugeConfigdatei;
begin
  ForceDirectories( ExtractFilePath(str_ConfigDatei) );
  sl_ConfigWerte.Add('###############################################');
  sl_ConfigWerte.Add('## config-Datei erzeugt am '+FormatDateTime('dd.mm.yyyy',now));
  sl_ConfigWerte.Add('## von '+GetEnvironmentVariable('username') );
  sl_ConfigWerte.Add('###############################################');
  SpeichereConfigdatei;
end;

function TArbeitsModul1.GetValue(str_Ident: string): string;
begin
  Result := sl_ConfigWerte.Values[str_Ident];
end;

procedure TArbeitsModul1.SpeichereConfigdatei;
begin
  try
    sl_ConfigWerte.SaveToFile(str_ConfigDatei);
    bool_ConfigGeaendert := False;
  except
    on E: Exception do
  end;
end;

procedure TArbeitsModul1.DataModuleDestroy(Sender: TObject);
begin
  if bool_ConfigGeaendert then
    SpeichereConfigdatei;
end;

procedure TArbeitsModul1.DefaultWerteChecken;
var
  i: Integer;
  procedure Check ( cst : TConfigStruktur );
  begin
    if sl_ConfigWerte.Values[cst.Ident]='' then
    begin
      sl_ConfigWerte.Add('#'+cst.Ident+'='+cst.Info );
      sl_ConfigWerte.Add( cst.Ident +'='+ cst.Default );
      bool_ConfigGeaendert := True;
    end;
  end;
begin
  // defaultwerte speichern, falls die nicht vorhanden sind
  for i := 0 to i_max - 1 do
  begin
    Check( DefaultConfig[i] );
  end;
  if bool_ConfigGeaendert then
    SpeichereConfigdatei;
end;

end.
