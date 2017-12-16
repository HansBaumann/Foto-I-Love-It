program FotoILove;

uses
  System.StartUpCopy,
  FMX.Forms,
  MeineAnsichtsUnit1 in 'MeineAnsichtsUnit1.pas' {HauptForm},
  ZwischenUnit1 in 'ZwischenUnit1.pas' {ZwischenModul1: TDataModule},
  ArbeitsUnit1 in 'ArbeitsUnit1.pas' {ArbeitsModul1: TDataModule},
  KonstantenUnit1 in 'KonstantenUnit1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(THauptForm, HauptForm);
  Application.Run;
end.
