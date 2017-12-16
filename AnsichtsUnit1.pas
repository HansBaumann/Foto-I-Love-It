unit AnsichtsUnit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  System.Actions, FMX.ActnList, FMX.StdActns, System.ImageList, FMX.ImgList,
  FMX.Controls.Presentation, System.Rtti, FMX.Layouts, FMX.Grid, FMX.TabControl,
  FMX.ListBox, FMX.Objects, FMX.Edit, FMX.MediaLibrary.Actions;

type
  THauptform1 = class(TForm)
    Panel1: TPanel;
    ActionList1: TActionList;
    ImageList1: TImageList;
    FileExit1: TFileExit;
    Button1: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    ListBox1: TListBox;
    StyleBook1: TStyleBook;
    Image1: TImage;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    ActionShowSettings: TAction;
    FileHideApp1: TFileHideApp;
    ActionHilfe: TAction;
    Button2: TButton;
    Panel3: TPanel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    Image2: TImage;
    ActionOpen: TAction;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ActionShowSettingsExecute(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ActionHilfeExecute(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure ActionOpenExecute(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure BotSchaftZahl ( i : Integer );
    procedure BotSchaftText ( strInhalt : string );
    procedure AendereBild;
  public
    { Public-Deklarationen }
  end;

var
  Hauptform1: THauptform1;

implementation

{$R *.fmx}

uses ZwischenUnit1
  , System.Messaging
  , System.UIConsts
  , KonstantenUnit1
  , fmx.Platform
  , fmx.menus
  ;

procedure THauptform1.ActionHilfeExecute(Sender: TObject);
var
  i: Integer;
  s: string;
  k: TContainedAction;
  FMenuService: IFMXMenuService;
  kw : word;
  SState : TShiftState;
begin
  s := '';

  TPlatformServices.Current.SupportsPlatformService(IFMXMenuService, FMenuService);
  for i := 0 to ActionList1.ActionCount - 1 do
  begin
    k := ActionList1.Actions[i];
    if FMenuService <> nil then
    begin
      s := s+
      FMenuService.ShortCutToText(k.ShortCut)+^I;
    end;
    s := s+
      k.Caption + ^I + k.Hint+#13#10;
  end;

  ShowMessage( s );
end;

procedure THauptform1.ActionOpenExecute(Sender: TObject);
begin
  // open file
  if OpenDialog1.Execute then
  begin
    Image2.Bitmap.LoadFromFile( OpenDialog1.FileName );
    AendereBild;
  end;

end;

procedure THauptform1.ActionShowSettingsExecute(Sender: TObject);
begin
  TabItem2.Visible := True;
  TabControl1.ActiveTab := TabItem2;
end;

procedure THauptform1.AendereBild;
var
  s: string;
  cl: TAlphaColor;
  MyRect: TRectF;
begin
  s := ZwischenModul1.Value['Farbe'];
  try
    cl := StringToAlphaColor(s);
  except
    cl := TAlphaColorRec.White;
  end;
  s := ZwischenModul1.Value['Text'];

  MyRect := TRectF.Create(50, 50, Image2.Bitmap.Width-50, Image2.Bitmap.Height-50 );

  Image2.Bitmap.Canvas.BeginScene;

  // draws on the rectangle specified by MyRect the area from MyBitmap specified by MyRect
  Image2.Bitmap.Canvas.Fill.Color := cl;
  Image2.Bitmap.Canvas.StrokeThickness := 20;
  Image2.Bitmap.Canvas.Stroke.Color := cl;
  Image2.Bitmap.Canvas.DrawRectSides(MyRect, 50,50, AllCorners, 1, AllSides, TCornerType.Round );
  //Image2.Bitmap.Canvas.

  // updates the bitmap to show the arc
  Image2.Bitmap.Canvas.EndScene;

  Image2.Repaint;


end;

procedure THauptform1.BotSchaftText(strInhalt: string);
var
  sl: TStringList;
  i: Integer;
begin
  sl := TStringList.Create;
  sl.Text := trim(strInhalt);
  if sl.Count>0 then
  begin
    strInhalt := sl.Strings[0];
    sl.Delete(0);

    if strInhalt=cStrFehlermeldung then
    begin
      MessageDlg( sl.Text, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0 );
    end;

    if strInhalt=cStrEinstellungen then
    begin
      ListBox1.Items.Text := sl.Text;
      if sl.IndexOfName(cStrTitel)>=0 then
        Caption := sl.Values[cStrTitel];
    end;
  end
  else
    ShowMessage( strInhalt );
end;

procedure THauptform1.BotSchaftZahl(i: Integer);
begin
  ShowMessage( i.ToString );
end;

procedure THauptform1.Button2Click(Sender: TObject);
begin
  Panel3.Visible := not Panel3.Visible;
end;

procedure THauptform1.Button4Click(Sender: TObject);
begin
  if TabControl1.ActiveTab = TabItem1 then
    ActionShowSettingsExecute(Sender)
  else
    TabControl1.ActiveTab := TabItem1;
end;

procedure THauptform1.Edit1KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key=13 then
  begin
    SpeedButton1Click(Sender);
  end;
end;

procedure THauptform1.FormCreate(Sender: TObject);
var
  MessageManager: TMessageManager;
  SubscriptionId1: Integer;
  SubscriptionId2: Integer;
begin

  TabControl1.ActiveTab := TabItem1;
  TabItem2.Visible := False;
  Panel3.Visible := False;

  MessageManager := TMessageManager.DefaultManager;
  SubscriptionId1 := MessageManager.SubscribeToMessage(TMessage<Integer>, procedure(const Sender: TObject; const M: TMessage)
  begin
    BotschaftZahl((M as TMessage<Integer>).Value);
  end);
  SubscriptionId2 := MessageManager.SubscribeToMessage(TMessage<UnicodeString>, procedure(const Sender: TObject; const M: TMessage)
  begin
    BotschaftText((M as TMessage<UnicodeString>).Value );
  end);

  ZwischenModul1 := TZwischenModul1.Create( Self );
end;

procedure THauptform1.ListBox1Click(Sender: TObject);
var
  i: Integer;
begin
  i := ListBox1.ItemIndex;
  if i<0 then
  begin
    Edit1.Text := '';
    Label1.Text := '';
  end
  else
  begin
    Label1.Text := ListBox1.Items.Names[i];
    Edit1.Text := ListBox1.Items.ValueFromIndex[i];
  end;
end;

procedure THauptform1.SpeedButton1Click(Sender: TObject);
begin
  ZwischenModul1.Value[Label1.Text] := Edit1.Text;
end;

procedure THauptform1.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  Image1.Assign( Image );
end;

procedure THauptform1.TakePhotoFromLibraryAction1DidFinishTaking(
  Image: TBitmap);
begin
  Image1.Assign( Image );
end;

end.
