unit KonstantenUnit1;

interface

const
  cStrFirma         = 'Baumann';
  cStrTitel         = 'Titel';
  cStrEinstellungen = 'Einstellungen';
  cStrFehlermeldung = 'Meldung';

  cIIdle            = 0;
  cILeseKurz        = 1;
  cILeseLange       = 2;
  cILeseExtrem      = 4;  // je ein eindeutiges BIT belegen, damit man odern kann

  cStrFarbe         = 'Farbe';
  cStrText          = 'Text';
  cStrSchriftGroesse= 'SchriftGroesse';
  cStrLinie         = 'Rahmendicke';
  cStrAbstand       = 'Abstand';

type
  TConfigStruktur = record
    Ident,
    Default,
    Info : string;
  end;

const
  i_max         = 6;
  DefaultConfig : array[0..i_max-1] of TConfigStruktur =
    (
    ( Ident:cStrTitel; Default:'Template'; Info:'Titel der Anwendung' ),
    ( Ident:cStrFarbe; Default:'red'; Info: 'Farbe des Rahmens und der Schrift' ),
    ( Ident:cStrText;  Default:'I ♥ Buckenhofen'; Info:'Text im Bild' ),
    ( Ident:cStrSchriftGroesse; Default:'10'; Info:'Schriftgröße' ),
    ( Ident:cStrLinie; Default:'3'; Info:'Dicke des Rahmens' ),
    ( Ident:cStrAbstand; Default:'5'; Info:'Abstand des Rahmens vom Rand' )
    );


implementation

end.
