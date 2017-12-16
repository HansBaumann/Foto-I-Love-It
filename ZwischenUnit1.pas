unit ZwischenUnit1;

interface

uses
  System.SysUtils, System.Classes;

type
  TZwischenModul1 = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    function GetValue(str_Ident: string): string;
    procedure SetValue(str_Ident: string; const Value: string);
    { Private-Deklarationen }
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
  end;

var
  ZwischenModul1: TZwischenModul1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses ArbeitsUnit1;

{$R *.dfm}

procedure TZwischenModul1.DataModuleCreate(Sender: TObject);
begin
  ArbeitsModul1 := TArbeitsModul1.Create( Self );
end;

function TZwischenModul1.GetValue(str_Ident: string): string;
begin
  Result := ArbeitsModul1.Value[str_Ident];
end;

procedure TZwischenModul1.SetValue(str_Ident: string; const Value: string);
begin
  ArbeitsModul1.Value[str_Ident] := Value;
end;

end.
