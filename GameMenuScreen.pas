{$include lem_directives.inc}

unit GameMenuScreen;

{-------------------------------------------------------------------------------
  The main menu dos screen.
-------------------------------------------------------------------------------}

interface

uses
  PngInterface, SharedGlobals,
  Windows, Classes, Controls, Graphics, MMSystem, Forms, SysUtils, ShellApi,
  PngImage, FNeoLemmixConfig,
  GR32, GR32_Image, GR32_Layers,
  UFastStrings,
  UMisc, Dialogs,
  LemCore, LemTypes, LemStrings, LemDosStructures, LemRendering, LemLevel, LemDosStyle, LemGame,
  GameControl, GameBaseScreen, GamePreviewScreen, GameLevelCodeScreen;

type
  {-------------------------------------------------------------------------------
    these are the images we need for the menuscreen.
  -------------------------------------------------------------------------------}
  TGameMenuBitmap = (
    gmbLogo,
    gmbPlay,         // 1st row, 1st button
    gmbLevelCode,    // 1st row, 2nd button
    gmbMusic,        // 1st row, 3d button
    gmbSection,      // 1st row, 4th button
    gmbExit,         // 2nd row, 1st button
    gmbNavigation,   // 2nd row, 2nd button
    gmbMusicNote,    // drawn in gmbMusic
    gmbFXSound,      // drawn in gmbMusic
    gmbGameSection1, // mayhem/havoc    drawn in gmbSection
    gmbGameSection2, // taxing/wicked   drawn in gmbSection
    gmbGameSection3, // tricky/wild     drawn in gmbSection
    gmbGameSection4, // fun/crazy       drawn in gmbSection
    gmbGameSection5, // .../tame        drawn in gmbSection
    gmbGameSection6,
    gmbGameSection7,
    gmbGameSection8,
    gmbGameSection9,
    gmbGameSection10,
    gmbGameSection11,
    gmbGameSection12,
    gmbGameSection13,
    gmbGameSection14,
    gmbGameSection15
  );

const
  {-------------------------------------------------------------------------------
    Positions at which the images of the menuscreen are drawn
  -------------------------------------------------------------------------------}
  GameMenuBitmapPositions: array[TGameMenuBitmap] of TPoint = (
    (X:8;    Y:10),                   // gmbLogo
    (X:136;   Y:120),                  // gmbPlay
    (X:264;  Y:120),                  // gmbLevelCode
    (X:136;  Y:196),
    (X:392;  Y:120),                  // gmbSection
    (X:392;  Y:196),
    (X:264;  Y:196),                  // gmbNavigation
    (X:200 + 27;    Y:196 + 26),      // gmbMusicNote
    (X:200 + 27;    Y:196 + 26),      // gmbFXSign,
    (X:392 + 32;    Y:120 + 24),      // gmbSection1
    (X:392 + 32;    Y:120 + 24),      // gmbSection2
    (X:392 + 32;    Y:120 + 24),      // gmbSection3
    (X:392 + 32;    Y:120 + 24),      // gmbSection4
    (X:392 + 32;    Y:120 + 24),      // gmbSection5
    (X:392 + 32;    Y:120 + 24),       // gmbSection6
    (X:392 + 32;    Y:120 + 24),
    (X:392 + 32;    Y:120 + 24),
    (X:392 + 32;    Y:120 + 24),
    (X:392 + 32;    Y:120 + 24),
    (X:392 + 32;    Y:120 + 24),
    (X:392 + 32;    Y:120 + 24),
    (X:392 + 32;    Y:120 + 24),
    (X:392 + 32;    Y:120 + 24),
    (X:392 + 32;    Y:120 + 24)
  );

  YPos_ProgramText = 272;
  YPos_Credits = 350 - 16;

  Reel_Width = 34 * 16;
  Reel_Height = 16;

  Font_Width = 16;


type
  TStringAnimationInfo = record
  end;

  TGameMenuScreen = class(TGameBaseScreen)
  private
  { enumerated menu bitmap elements }
    BitmapElements : array[TGameMenuBitmap] of TBitmap32;
  { music }
//    MusicSetting   : TGameMusicSetting;
  { section }
    CurrentSection : Integer; // game section
    LastSection    : Integer; // last game section
  { credits }
    LeftLemmingAnimation   : TBitmap32;
    RightLemmingAnimation  : TBitmap32;
    Reel                   : TBitmap32;
    ReelBuffer             : TBitmap32;
    CanAnimate             : Boolean;
  { credits animation counters }
    FrameTimeMS            : Cardinal;
    PrevTime               : Cardinal;
    ReadingPauseMS         : Cardinal; //
    ReelLetterBoxCount     : Integer; // the number of letterboxes on the reel (34)
    Pausing                : Boolean;
    UserPausing            : Boolean;
    PausingDone            : Boolean; // the current text has been paused
//    Credits                : TStringList;
//    LastCredit             : Integer;
//    CompleteCreditString   : string;
    CreditList             : TStringList;
    CreditIndex            : Integer;
    CreditString          : string;
    TextX           : Integer;
    TextPauseX      : Integer; // if -1 then no pause
    TextGoneX       : Integer;

    CurrentFrame           : Integer;
//    PausePosition          : Integer;
    ReelShift              : Integer;
  { internal }
    procedure DrawBitmapElement(aElement: TGameMenuBitmap);
    procedure SetSoundOptions(aOptions: TGameSoundOptions);
    procedure SetSection(aSection: Integer);
    procedure NextSection(Forwards: Boolean);
    procedure NextSoundSetting;
    procedure DrawWorkerLemmings(aFrame: Integer);
    procedure DrawReel;//(aReelShift, aTextX: Integer);
    procedure SetNextCredit;
    procedure DumpLevels;
    procedure DumpImages;
    procedure LoadOneLevel;
    procedure DoTestStuff; //what a great name. it's a function I have here for testing things.
    procedure PerformUpdateCheck;
    procedure DoMassReplayCheck;
  { eventhandlers }
    procedure Form_KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Form_MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Img_MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Application_Idle(Sender: TObject; var Done: Boolean);
    function BuildText(intxt: Array of char): String;
  protected
  { overrides }
    procedure PrepareGameParams(Params: TDosGameParams); override;
    procedure BuildScreen; override;
    procedure CloseScreen(aNextScreen: TGameScreenType); override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  LemNeoOnline;

{ TGameMenuScreen }

procedure TGameMenuScreen.DoTestStuff;
{$ifdef exp}
var
  MainVer, SubVer, MinorVer: Integer;
  S: String;
{$endif}
begin
// Any random test code can go here. Since it's for testing purposes, I've
// added a conditional define so it doesn't get included in release versions.
{$ifdef exp}
  if GetLatestNeoLemmixVersion(NxaPlayer, MainVer, SubVer, MinorVer) then
  begin
    S := 'V' + IntToStr(MainVer) + '.' + IntToStr(SubVer) + 'n';
    if MinorVer > 1 then
    begin
      S := S + '-' + chr(64+MinorVer);
    end;
    ShowMessage('Latest version reported as: ' + S);
  end else
    ShowMessage('Version check fail.');
{$endif}
end;

procedure TGameMenuScreen.PerformUpdateCheck;
var
  MainVer, SubVer, MinorVer: Integer;
begin
  // Checks if the latest version according to NeoLemmix Website is more recent than the
  // one currently running. If running an experimental version, also checks if it's the
  // exact same version (as it would be a stable release).
  GameParams.DoneUpdateCheck := true;
  if not (GameParams.EnableOnline and GameParams.CheckUpdates) then Exit;
  if GetLatestNeoLemmixVersion(NxaPlayer, MainVer, SubVer, MinorVer) then
  begin
    if (MainVer > Cur_MainVer)
    or ((MainVer = Cur_MainVer) and (SubVer > Cur_SubVer))
    or ((MainVer = Cur_MainVer) and (SubVer = Cur_SubVer) and (MinorVer > Cur_MinorVer))
    {$ifdef exp}or ((MainVer = Cur_MainVer) and (SubVer = Cur_SubVer) and (MinorVer = Cur_MinorVer)){$endif} then
      if MessageDlg('Update available: NeoLemmix V' + NumericalVersionToStringVersion(MainVer, SubVer, MinorVer) + #13 +
                    'Go to the NeoLemmix website?', mtCustom, [mbYes, mbNo], 0) = mrYes then
      begin
        ShellExecute(handle,'open',PChar('http://www.neolemmix.com/neolemmix.html'), '','',SW_SHOWNORMAL);
        CloseScreen(gstExit);
      end;
  end;
end;

procedure TGameMenuScreen.DrawBitmapElement(aElement: TGameMenuBitmap);
{-------------------------------------------------------------------------------
  Draw bitmap at appropriate place on the screen.
-------------------------------------------------------------------------------}
var
  P: TPoint;
begin
  P := GameMenuBitmapPositions[aElement];
  // adjust gmbMusic to right, gmbExit to left, if no talismans
  // and don't draw gmbNavigation at all
  if GameParams.Talismans.Count = 0 then
    case aElement of
      gmbMusic: P.X := P.X + 64;
      gmbExit: P.X := P.X - 64;
      gmbNavigation: Exit;
    end;
  BitmapElements[aElement].DrawTo(ScreenImg.Bitmap, P.X, P.Y);
end;

procedure TGameMenuScreen.BuildScreen;
{-------------------------------------------------------------------------------
  extract bitmaps from the lemmingsdata and draw
-------------------------------------------------------------------------------}
var
  Mainpal: TArrayOfColor32;
  Tmp: TBitmap32;
  i: Integer;
  LoadImageStream: TMemoryStream;
  GrabRect: TRect;

  procedure LoadScrollerGraphics;
  var
    TempBMP: TBitmap32;
    SourceRect: TRect;
  begin
    try
      MainDatExtractor.ExtractBitmapByName(Tmp, 'scroller_segment.png');
      TempBMP := TBitmap32.Create;
      MainDatExtractor.ExtractBitmapByName(TempBMP, 'scroller_lemmings.png');
      SourceRect := Rect(0, 0, 48, 256);
      LeftLemmingAnimation.SetSize(48, 256);
      RightLemmingAnimation.SetSize(48, 256);
      TempBmp.DrawTo(LeftLemmingAnimation, 0, 0, SourceRect);
      SourceRect.Right := SourceRect.Right + 48;
      SourceRect.Left := SourceRect.Left + 48;
      TempBmp.DrawTo(RightLemmingAnimation, 0, 0, SourceRect);
      TempBmp.Free; 
    except
      MainDatExtractor.ExtractAnimation(LeftLemmingAnimation, 4, $C780, 48, 16, 16, 19, MainPal);
      MainDatExtractor.ExtractAnimation(RightLemmingAnimation, 4, $13980, 48, 16, 16, 19, MainPal);
      MainDatExtractor.ExtractBitmap(Tmp, 4, $1AB80, 16, 16, 19, MainPal);
    end;
  end;
begin
(*  stretched := false;
//  screenimg.ScaleMode := smscale;
  screenimg.BitmapAlign := baCustom;
  screenimg.ScaleMode := smScale;
  screenimg.scale := 1.5; *)

  Tmp := TBitmap32.Create;
  ScreenImg.BeginUpdate;
  try
    MainPal := GetDosMainMenuPaletteColors32;
    InitializeImageSizeAndPosition(640, 350);
    ExtractBackGround;
    ExtractPurpleFont;

    MainDatExtractor.ExtractBitmap(BitmapElements[gmbLogo], 3, $134C0, 632, 94, 19, MainPal);
    MainDatExtractor.ExtractBitmap(BitmapElements[gmbPlay], 3, $35BE6, 120, 61, 19, MainPal);
    MainDatExtractor.ExtractBitmap(BitmapElements[gmbLevelCode], 3, $39FCF, 120, 61, 19, MainPal);
    MainDatExtractor.ExtractBitmap(BitmapElements[gmbMusic], 3, $3E3B8, 120, 61, 19, MainPal);
    MainDatExtractor.ExtractBitmap(BitmapElements[gmbSection], 3, $427A1, 120, 61, 19, MainPal);
    MainDatExtractor.ExtractBitmap(BitmapElements[gmbExit], 3, $46B8A, 120, 61, 19, MainPal);
    MainDatExtractor.ExtractBitmap(BitmapElements[gmbNavigation], 3, $4AF73, 120, 61, 19, MainPal);
    MainDatExtractor.ExtractBitmap(BitmapElements[gmbMusicNote], 3, $4F35C, 64, 31, 19, MainPal);
    MainDatExtractor.ExtractBitmap(BitmapElements[gmbFXSound], 3, $505C4, 64, 31, 19, MainPal);


    //@styledef
    for i := 1 to 15 do
        MainDatExtractor.ExtractBitmap(BitmapElements[TGameMenuBitmap(Integer(gmbGameSection1) + i - 1)], 5,
                                       ($1209 * (i - 1)), 72, 27, 19, MainPal);

    LoadScrollerGraphics;

    // a little oversize
    Reel.SetSize(ReelLetterBoxCount * 16 + 32, 16);
    for i := 0 to ReelLetterBoxCount - 1 + 4 do
      Tmp.DrawTo(Reel, i * 16, 0);

    // make sure the reelbuffer is the right size
    ReelBuffer.SetSize(ReelLetterBoxCount * 16, 16);

    // background
    TileBackgroundBitmap(0, 0);
    BackBuffer.Assign(ScreenImg.Bitmap); // save it

    // menu elements
    DrawBitmapElement(gmbLogo);
    DrawBitmapElement(gmbPlay);
    DrawBitmapElement(gmbLevelCode);
    DrawBitmapElement(gmbMusic);
    DrawBitmapElement(gmbSection);
    DrawBitmapElement(gmbExit);
    DrawBitmapElement(gmbNavigation);

    // re-capture the gmbSection, because we'll probably need to re-draw it later
    // to prevent writing over section graphics with other semitransparent ones
    //    (X:392;  Y:120),                  // gmbSection
    GrabRect := BitmapElements[gmbSection].BoundsRect;
    GrabRect.Right := GrabRect.Right + 392;
    GrabRect.Left := GrabRect.Left + 392;
    GrabRect.Bottom := GrabRect.Bottom + 120;
    GrabRect.Top := GrabRect.Top + 120;
    ScreenImg.Bitmap.DrawTo(BitmapElements[gmbSection], BitmapElements[gmbSection].BoundsRect, GrabRect);
    BitmapElements[gmbSection].DrawMode := dmOpaque;

    // program text
    DrawPurpleTextCentered(ScreenImg.Bitmap, BuildText(GameParams.SysDat.PackName) + #13 + BuildText(GameParams.SysDat.SecondLine) + #13 + 'NeoLemmix Player V' + PVersion, YPos_ProgramText);

    // credits animation
    DrawWorkerLemmings(0);
    DrawReel;//(0, TextX);

    // a bit weird place, but here we know the bitmaps are loaded
    SetSection(CurrentSection);
    SetSoundOptions(GameParams.SoundOptions);

    CanAnimate := True;
//    ScreenImg.Bitmap.ResamplerClassName := 'TDraftResampler';
  finally
    ScreenImg.EndUpdate;
    Tmp.Free;
  end;
end;

constructor TGameMenuScreen.Create(aOwner: TComponent);
var
  E: TGameMenuBitmap;
  Bmp: TBitmap32;
begin
  inherited Create(aOwner);

  CurrentSection := 0;

  // create bitmaps
  for E := Low(TGameMenuBitmap) to High(TGameMenuBitmap) do
  begin
    Bmp := TBitmap32.Create;
    BitmapElements[E] := Bmp;
    if not (E in [gmbMusicNote, gmbFXSound, gmbGameSection1, gmbGameSection2, gmbGameSection3, gmbGameSection4,
      gmbGameSection5, gmbGameSection6, gmbGameSection7, gmbGameSection8, gmbGameSection9, gmbGameSection10,
      gmbGameSection11, gmbGameSection12, gmbGameSection13, gmbGameSection14, gmbGameSection15])
    then Bmp.DrawMode := dmTransparent;
  end;

  LeftLemmingAnimation := TBitmap32.Create;
  LeftLemmingAnimation.DrawMode := dmTransparent;

  RightLemmingAnimation := TBitmap32.Create;
  RightLemmingAnimation.DrawMode := dmTransparent;

  Reel := TBitmap32.Create;
  ReelBuffer := TBitmap32.Create;
  CreditList := TStringList.Create;

  FrameTimeMS := 32;
  ReadingPauseMS := 1000;
  CreditList.Text := '';
  CreditIndex := -1;
  ReelLetterBoxCount := 34;
  SetNextCredit;
  CreditIndex := -1;

  // set eventhandlers
  OnKeyDown := Form_KeyDown;
  OnMouseDown := Form_MouseDown;
  ScreenImg.OnMouseDown := Img_MouseDown;
  Application.OnIdle := Application_Idle;
end;

destructor TGameMenuScreen.Destroy;
var
  E: TGameMenuBitmap;
begin
  for E := Low(TGameMenuBitmap) to High(TGameMenuBitmap) do
    BitmapElements[E].Free;

  LeftLemmingAnimation.Free;
  RightLemmingAnimation.Free;
  Reel.Free;
  ReelBuffer.Free;
  CreditList.Free;

  inherited Destroy;
end;

procedure TGameMenuScreen.Form_KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  ConfigDlg: TFormNXConfig;
begin
  if Shift = [] then
  begin
    case Key of
      VK_RETURN : CloseScreen(gstPreview);
      VK_F1     : CloseScreen(gstPreview);
      VK_F2     : CloseScreen(gstLevelCode);
      //VK_F3     : NextSoundSetting;
      VK_F3   : begin
                  ConfigDlg := TFormNXConfig.Create(self);
                  ConfigDlg.SetGameParams(GameParams);
                  ConfigDlg.NXConfigPages.TabIndex := 0;
                  ConfigDlg.ShowModal;
                  ConfigDlg.Free;

                  // Wise advice from Simon - save these things on exiting the
                  // config dialog, rather than waiting for a quit or a screen
                  // transition to save them.
                  GameParams.SaveSystem.SaveFile(@GameParams);
                  GameParams.SaveToIniFile;
                  GameParams.Hotkeys.SaveFile;
                end;
      //VK_F4     : CloseScreen(gstNavigation);
      VK_F4     : DumpLevels;
      VK_F5     : DumpImages;
      VK_F6     : if GameParams.Talismans.Count <> 0 then CloseScreen(gstTalisman);
      VK_F7     : DoMassReplayCheck;
      VK_F12    : DoTestStuff;
      VK_ESCAPE : CloseScreen(gstExit);
      VK_UP     : NextSection(True);
      VK_DOWN   : NextSection(False);

      //VK_SPACE  : UserPausing := not UserPausing;
    end;
  end;
end;

procedure TGameMenuScreen.LoadOneLevel;
var
  fOpenDlg: TOpenDialog;
begin
  fOpenDlg := TOpenDialog.Create(self);
  fOpenDlg.Title := 'Select a level';
  fOpenDlg.Filter := 'Lemmix / NeoLemmix Level Files|*.lvl';
  fOpenDlg.Options := [ofFileMustExist];
  if fOpenDlg.Execute then
  begin
    GameParams.LevelString := fOpenDlg.Filename;
    GameParams.OneLevelMode := true;
    CloseScreen(gstPreview);
  end else
    fOpenDlg.Free;
end;

procedure TGameMenuScreen.DumpImages;
var
  I: Integer;
begin
  if GameParams.SysDat.Options3 and 4 = 0 then Exit;
  I := MessageDlg('Dump all level images? Warning: This is very slow!', mtCustom, [mbYes, mbNo], 0);
  if I = mrYes then
  begin
    MessageDlg('The screen will go blank while dumping level images.' + CrLf + 'This is normal.', mtCustom, [mbOk], 0);
    GameParams.DumpMode := true;
    GameParams.WhichLevel := wlFirst;
    CloseScreen(gstPreview);
  end;
end;

procedure TGameMenuScreen.DumpLevels;
var
  I: Integer;
begin
  //if GameParams.SysDat.Options3 and 4 = 0 then Exit;
  if not (GameParams.Style.LevelSystem is TBaseDosLevelSystem) then exit;
  I := MessageDlg('Dump all level files? Warning: This may overwrite' + CrLf + 'LVL files currently present!', mtCustom, [mbYes, mbNo], 0);
  if I = mrYes then
    TBaseDosLevelSystem(GameParams.Style.LevelSystem).DumpAllLevels;
end;

procedure TGameMenuScreen.Form_MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseScreen(gstPreview);
end;

procedure TGameMenuScreen.Img_MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  if Button = mbLeft then
    CloseScreen(gstPreview);
end;

procedure TGameMenuScreen.NextSection(Forwards: Boolean);
var
  i : Integer;

    procedure Change;
    begin
      GameParams.ShownText := false;
      with GameParams.Info do
      begin
        dValid := True;
        dPack := 0;
        dSection := CurrentSection;
        dLevel := 0;
        GameParams.WhichLevel := wlLastUnlocked;
      end;
    end;

begin
  case Forwards of
    False:
      begin
        if CurrentSection > 0 then
        begin
          SetSection(CurrentSection - 1);
          Change;
        end else
          Exit;
      end;
    True:
      begin
        if CurrentSection = LastSection then Exit;

        with TBaseDosLevelSystem(GameParams.Style.LevelSystem) do
        begin
          i := CurrentSection + 1;
          SetSection(i);
          Change;
          Exit;
        end;

      end;
  end;
end;

procedure TGameMenuScreen.NextSoundSetting;
var
  Opt: TGameSoundOptions;
begin
  Opt := GameParams.SoundOptions;
  if Opt = [] then Include(Opt, gsoSound)
  else if Opt = [gsoSound] then Include(Opt, gsoMusic)
  else if Opt = [gsoMusic, gsoSound] then Opt := [];
  SetSoundOptions(Opt);
end;



procedure TGameMenuScreen.PrepareGameParams(Params: TDosGameParams);
var
  i: Integer;
  k: String;
begin
  inherited PrepareGameParams(Params);
  with GameParams do
  begin
    OneLevelMode := false;
    if (WhichLevel = wlFirst) then
    begin
      Style.LevelSystem.FindFirstLevel(Info);
      WhichLevel := wlSame;
    end;
    if (WhichLevel = wlLastUnlocked) then
    begin
      Style.LevelSystem.FindLastUnlockedLevel(Info);
      WhichLevel := wlSame;
    end;
    if (WhichLevel = wlNext) then
    begin
      Style.LevelSystem.FindNextLevel(Info);
      WhichLevel := wlSame;
    end;
  end;
  CurrentSection := Params.Info.dSection;
  LastSection := (Params.Style.LevelSystem as TBaseDosLevelSystem).GetSectionCount - 1;

  CreditList.Text := {$ifdef exp}'EXPERIMENTAL PLAYER RELEASE' + #13 +{$endif} BuildText(Params.SysDat.PackName) + #13;
  for i := 0 to 15 do
  begin
    k := BuildText(Params.SysDat.ScrollerTexts[i]);
    if k <> '' then
      CreditList.Text := CreditList.Text + k + #13;
  end;
  CreditList.Text := CreditList.Text + SCredits;
  SetNextCredit;

  if Assigned(GlobalGame) then
    GlobalGame.ReplayManager.Clear(true);
end;

function TGameMenuScreen.BuildText(intxt: Array of char): String;
var
  tstr : String;
  x : byte;
begin
  Result := '';
  tstr := '';
  for x := 0 to (SizeOf(intxt) - 1) do
  begin
    if (tstr <> '') or (intxt[x] <> ' ') then
    begin
      tstr := tstr + intxt[x];
    end;
  end;
  Result := trim(tstr);
end;

procedure TGameMenuScreen.SetSoundOptions(aOptions: TGameSoundOptions);
var
  Opt: TGameSoundOptions;
begin
  GameParams.SoundOptions := aOptions;
  Opt := GameParams.SoundOptions;
  {if Opt = [] then DrawBitmapElement(gmbMusic)
  else if Opt = [gsoSound] then DrawBitmapElement(gmbFXSound)
  else if Opt = [gsoMusic, gsoSound] then DrawBitmapElement(gmbMusicNote);}
end;

procedure TGameMenuScreen.SetSection(aSection: Integer);
begin
  CurrentSection := aSection;
  //@styledef
  DrawBitmapElement(gmbSection); // This allows for transparency in the gmbGameSectionN bitmaps
  case CurrentSection of
    0: DrawBitmapElement(gmbGameSection1);
    1: DrawBitmapElement(gmbGameSection2);
    2: DrawBitmapElement(gmbGameSection3);
    3: DrawBitmapElement(gmbGameSection4);
    4: DrawBitmapElement(gmbGameSection5);
    5: DrawBitmapElement(gmbGameSection6);
    6: DrawBitmapElement(gmbGameSection7);
    7: DrawBitmapElement(gmbGameSection8);
    8: DrawBitmapElement(gmbGameSection9);
    9: DrawBitmapElement(gmbGameSection10);
    10: DrawBitmapElement(gmbGameSection11);
    11: DrawBitmapElement(gmbGameSection12);
    12: DrawBitmapElement(gmbGameSection13);
    13: DrawBitmapElement(gmbGameSection14);
    14: DrawBitmapElement(gmbGameSection15);
  end;
end;

procedure TGameMenuScreen.DrawWorkerLemmings(aFrame: Integer);
var
  SrcRect, DstRect: TRect;
begin
  SrcRect := CalcFrameRect(LeftLemmingAnimation, 16, aFrame);
  DstRect := SrcRect;
  DstRect := ZeroTopLeftRect(DstRect);
  OffsetRect(DstRect, 0, YPos_Credits);
  BackBuffer.DrawTo(ScreenImg.Bitmap, DstRect, DstRect);
  LeftLemmingAnimation.DrawTo(ScreenImg.Bitmap, DstRect, SrcRect);

//  SrcRect := CalcFrameRect(RightLemmingAnimation, 16, 0);
  DstRect := SrcRect;
  DstRect := ZeroTopLeftRect(DstRect);
  OffsetRect(DstRect, 640 - 48, YPos_Credits);
  BackBuffer.DrawTo(ScreenImg.Bitmap, DstRect, DstRect);
  RightLemmingAnimation.DrawTo(ScreenImg.Bitmap, DstRect, SrcRect);
end;

procedure TGameMenuScreen.SetNextCredit;
var
  TextSize: Integer;
begin
  TextX := 33 * 16;

  if CreditList.Count = 0 then
  begin
    CreditString := '';
    Exit;
  end;

  Inc(CreditIndex);
  if CreditIndex > CreditList.Count - 1 then
    CreditIndex := 0;

  // set new string
  CreditString := CreditList[CreditIndex];
  Pausing := False;
  PausingDone := False;
  TextSize := Length(CreditString) * Font_Width;
  TextPauseX := (Reel_Width - TextSize) div 2;
  TextGoneX := -TextSize;// + 10 * Font_Width;
end;

procedure TGameMenuScreen.DrawReel;//(aReelShift, aTextX: Integer);
{-------------------------------------------------------------------------------
  Drawing of the moving credits. aShift = the reel shift which is wrapped every
  other 16 pixels to zero.
-------------------------------------------------------------------------------}
var
//  X: Integer;
  R: TRect;
//  S: string;
begin
//  X := 48;
  R := Reel.BoundsRect;
  R.Left := ReelShift;
  R.Right := R.Left + ReelLetterBoxCount * 16 ;


//  S := Copy(CurrentCreditString, aStringShift + 1, 50);
  // copy reel, draw text on it, draw to screen
//  ReelBuffer.Assign(Reel);


  Reel.DrawTo(ReelBuffer, ReelShift, 0);

(*
  DrawPurpleText(ReelBuffer,
//    Copy(CurrentCreditString, FirstChar, 50),
    '1234567890123456789012345678901234',
     aTextPosition, 0);//48, YPos_Credits);
*)

  DrawPurpleText(ReelBuffer, CreditString, TextX, 0);


//  DrawPurpleText(ReelBuffer, 'Scrolling credits...', 13 * 16, 0);
//  DrawPurpleText(ReelBuffer, 'Volker Oth, ccexplore and Mindless', 0, 0);


//  ReelBuffer.DrawTo(ScreenImg.Bitmap, 48, YPos_Credits, R);
  ReelBuffer.DrawTo(ScreenImg.Bitmap, 48, YPos_Credits);

//  ScreenImg.Update;

end;

procedure TGameMenuScreen.Application_Idle(Sender: TObject; var Done: Boolean);
{-------------------------------------------------------------------------------
  Animation of credits.
  - 34 characters fit into the reel.
  - text scolls from right to left. when one line is centered into the reel,
    scrolling is paused for a while.
-------------------------------------------------------------------------------}
var
  CurrTime: Cardinal;
begin
  if not GameParams.DoneUpdateCheck then
    PerformUpdateCheck;


  if not CanAnimate or ScreenIsClosing then
    Exit;
  Sleep(1);
  Done := False;
  CurrTime := TimeGetTime;
  if UserPausing then
    Exit;

  { check end reading pause }
  if Pausing then
  begin
    if CurrTime > PrevTime + ReadingPauseMS then
    begin
      PrevTime := CurrTime;
      Pausing := False;
      PausingDone := True; // we only pause once per text
    end;
    Exit;
  end;

  { update frames }
  if CurrTime > PrevTime + FrameTimeMS then
  begin
    PrevTime := CurrTime;

    { workerlemmings animation has 16 frames }
    Inc(CurrentFrame);
    if CurrentFrame >= 15 then
      CurrentFrame := 0;

    { text + reel }
    Dec(ReelShift, 4);
    if ReelShift <= - 16 then
      ReelShift := 0;

    Dec(TextX, 4);
    if TextX < TextGoneX then
    begin
      SetNextCredit;
      //TextX := 33 * 16;
    end;

    if not PausingDone then
    begin
      // if text can be centered then pause if we are there
      if TextPauseX >= 0 then
        if TextX <= TextPauseX then
          Pausing := True;
    end;

    DrawWorkerLemmings(CurrentFrame);
    DrawReel;//(ReelShift, TextX);

  end;
end;

procedure TGameMenuScreen.CloseScreen(aNextScreen: TGameScreenType);
begin
  if GameParams.ZoomLevel = 0 then
  begin
    GameParams.MainForm.BorderStyle := bsNone;
    GameParams.MainForm.WindowState := wsMaximized;
  end else begin
    GameParams.MainForm.BorderStyle := bsToolWindow;
    GameParams.MainForm.ClientWidth := 320 * GameParams.ZoomLevel;
    GameParams.MainForm.ClientHeight := 200 * GameParams.ZoomLevel;
    GameParams.MainForm.Left := (Screen.Width - GameParams.MainForm.Width) div 2;
    GameParams.MainForm.Top := (Screen.Height - GameParams.MainForm.Height) div 2;
  end;
  inherited CloseScreen(aNextScreen);
end;

procedure TGameMenuScreen.DoMassReplayCheck;
var
  SearchRec: TSearchRec;
  OpenDlg: TOpenDialog;
  TestPath: String;
begin
  if MessageDlg('Mass replay checking can take a very long time. Proceed?', mtcustom, [mbYes, mbNo], 0) = mrNo then Exit;
  GameParams.ReplayResultList.Clear;
  OpenDlg := TOpenDialog.Create(self);
  OpenDlg.InitialDir := AppPath + 'Replay\' + ChangeFileExt(ExtractFileName(GameFile), '');
  OpenDlg.Filter := 'NeoLemmix Replay (*.lrb)|*.lrb';
  OpenDlg.Options := [ofHideReadOnly, ofFileMustExist];
  if not OpenDlg.Execute then
  begin
    OpenDlg.Free;
    Exit;
  end;
  TestPath := ExtractFilePath(OpenDlg.FileName);
  if FindFirst(TestPath + '*.lrb', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      GameParams.ReplayResultList.Add(TestPath + SearchRec.Name);
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end else begin
    ShowMessage('No replays found!');
    Exit;
  end;

  GameParams.ReplayCheckIndex := -1;
  CloseScreen(gstPreview);
end;

end.

