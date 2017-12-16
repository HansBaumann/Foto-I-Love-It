unit MeineAnsichtsUnit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, ZwischenUnit1,
  KonstantenUnit1, System.ImageList, FMX.ImgList, FMX.Layouts, FMX.ListBox,
  FMX.Edit, FMX.StdActns, FMX.MediaLibrary.Actions;

type
  THauptForm = class(TForm)
    ActionList1: TActionList;
    PreviousTabAction1: TPreviousTabAction;
    TitleAction: TControlAction;
    NextTabAction1: TNextTabAction;
    TopToolBar: TToolBar;
    btnBack: TSpeedButton;
    ToolBarLabel: TLabel;
    btnNext: TSpeedButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    BottomToolBar: TToolBar;
    Image1: TImage;
    ListBox1: TListBox;
    ImageList1: TImageList;
    Button1: TButton;
    StyleBook1: TStyleBook;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    WindowClose1: TWindowClose;
    Timer1: TTimer;
    Button5: TButton;
    ShowShareSheetAction1: TShowShareSheetAction;
    TabItem3: TTabItem;
    Image2: TImage;
    Panel1: TPanel;
    Edit1: TEdit;
    EditButton1: TEditButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TitleActionUpdate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure ListBox1Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure ShowShareSheetAction1BeforeExecute(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure EditButton1Click(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
    procedure BotSchaftZahl ( i : Integer );
    procedure BotSchaftText ( strInhalt : string );
    procedure AendereBild;
    procedure StarteParameter;
  public
    { Public declarations }
  end;

var
  HauptForm: THauptForm;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.iPhone4in.fmx IOS}

uses
  System.UIConsts
  , System.Messaging
  ;

procedure THauptForm.TabControl1Change(Sender: TObject);
var
  u: Boolean;
begin
  u := TabControl1.ActiveTab=TabItem1;
  PreviousTabAction1.Enabled := not u;
  PreviousTabAction1.Visible := not u;
  NextTabAction1.Enabled := u;
end;

procedure THauptForm.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  Image2.Bitmap.Assign( Image );
  AendereBild;
end;

procedure THauptForm.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  Image2.Bitmap.Assign( Image );
  AendereBild;
end;

procedure THauptForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  StarteParameter;
end;

procedure THauptForm.TitleActionUpdate(Sender: TObject);
begin
  if Sender is TCustomAction then
  begin
    if TabControl1.ActiveTab <> nil then
      TCustomAction(Sender).Text := TabControl1.ActiveTab.Text
    else
      TCustomAction(Sender).Text := '';
  end;
end;

procedure THauptForm.AendereBild;
var
  s: string;
  cl: TAlphaColor;
  MyRect: TRectF;
  i_rand, i_dicke : Integer;
  i_FontSize: Integer;
begin

  if not Image2.Bitmap.IsEmpty then
  try
    Image1.Bitmap.Assign( Image2.Bitmap );

    s := ZwischenModul1.Value[cStrFarbe];
    try
      cl := StringToAlphaColor(s);
    except
      cl := TAlphaColorRec.White;
    end;
    s := ZwischenModul1.Value[cStrText]+#13#10;

    if not TryStrToInt( ZwischenModul1.Value[cStrLinie], i_dicke ) then
      i_dicke := 5;
    if not TryStrToInt( ZwischenModul1.Value[cStrSchriftGroesse], i_FontSize ) then
      i_FontSize := 10;

    if not TryStrToInt( ZwischenModul1.Value[cStrAbstand], i_rand ) then
      i_rand := 10;

    MyRect := TRectF.Create(i_rand, i_rand, Image1.Bitmap.Width-i_rand, Image1.Bitmap.Height-i_rand );

    Image1.Bitmap.Canvas.BeginScene;

    // draws on the rectangle specified by MyRect the area from MyBitmap specified by MyRect
    Image1.Bitmap.Canvas.Fill.Color := cl;
    Image1.Bitmap.Canvas.Font.Size := i_FontSize;
    Image1.Bitmap.Canvas.StrokeThickness := i_dicke;
    Image1.Bitmap.Canvas.Stroke.Color := cl;
    Image1.Bitmap.Canvas.DrawRectSides(MyRect, 50,50, AllCorners, 1, AllSides, TCornerType.Round );
    Image1.Bitmap.Canvas.FillText( MyRect, s, false, 1, [], TTextAlign.Center, TTextAlign.Trailing );

    // updates the bitmap to show the arc
    Image1.Bitmap.Canvas.EndScene;

    Image1.Repaint;
  except

  end;

end;

procedure THauptForm.BotSchaftText(strInhalt: string);
var
  sl: TStringList;
  i: Integer;
  s: string;
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
      ListBox1.Items.BeginUpdate;
      try
        ListBox1.Items.Text := sl.Text;
      except on E: Exception do
      end;
      ListBox1.Items.EndUpdate;
      if sl.IndexOfName(cStrTitel)>=0 then
        ToolBarLabel.Text := sl.Values[cStrTitel];
    end;
  end
  else
    ShowMessage( strInhalt );
end;

procedure THauptForm.BotSchaftZahl(i: Integer);
begin
  ShowMessage( i.ToString );
end;

procedure THauptForm.Button1Click(Sender: TObject);
begin
  ZwischenModul1.Value[Label1.Text] := Edit1.Text;
  AendereBild;
end;

procedure THauptForm.Edit1KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key=13 then
    Button1Click ( Sender );
end;

procedure THauptForm.EditButton1Click(Sender: TObject);
begin
  Button1Click ( Sender );
end;

procedure THauptForm.FormCreate(Sender: TObject);
var
  MessageManager: TMessageManager;
  SubscriptionId1: Integer;
  SubscriptionId2: Integer;
begin
  { This defines the default active tab at runtime }
  TabControl1.First(TTabTransition.None);

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

  if (ParamCount>0) then
  begin
    Timer1.Enabled := True;
  end;

end;

procedure THauptForm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) and (TabControl1.TabIndex <> 0) then
  begin
    TabControl1.First;
    Key := 0;
  end;
end;

procedure THauptForm.Image1DblClick(Sender: TObject);
begin
//  Image1.Repaint;
  AendereBild;
end;

procedure THauptForm.ListBox1Click(Sender: TObject);
var
  i: Integer;
begin
  i := ListBox1.ItemIndex;
  if i>=0 then
  begin
    Label1.Text := ListBox1.Items.Names[i];
    Edit1.Text := ListBox1.Items.ValueFromIndex[i];
  end;
end;

procedure THauptForm.Panel1Resize(Sender: TObject);
var
  i: Single;
begin
  i := Label1.Width;
  i := i-2*Edit1.Position.X;
  Edit1.Width := i;
end;

procedure THauptForm.ShowShareSheetAction1BeforeExecute(Sender: TObject);
begin
  if not Image1.Bitmap.IsEmpty then
    ShowShareSheetAction1.Bitmap.Assign(Image1.Bitmap);
end;

procedure THauptForm.StarteParameter;
var
  s: string;
  i: Integer;
begin
  if Image1.Bitmap.IsEmpty and (ParamCount>0) then
  begin
    s := '';
    for i := 1 to ParamCount do
    begin
      if s='' then
        s := ParamStr(i)
      else
        s := s+' '+ParamStr(i)
    end;
  end;

  if (s<>'') and FileExists(s) then
  begin
    try
      Image2.Bitmap.LoadFromFile( s );
      AendereBild;
    except on E: Exception do
    end;
  end;
end;

end.
