unit FSuperLemmixConfig;

interface

uses
  GameControl, GameSound, LemStrings, FEditHotkeys, LemmixHotkeys, Math,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Vcl.WinXCtrls, Vcl.ExtCtrls;

type
  TFormNXConfig = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    NXConfigPages: TPageControl;
    Graphics: TTabSheet;
    TabSheet1: TTabSheet;
    lblUserName: TLabel;
    lblIngameSaveReplay: TLabel;
    lblPostviewSaveReplay: TLabel;
    gbReplayNamingOptions: TGroupBox;
    cbAutoSaveReplay: TCheckBox;
    cbAutoSaveReplayPattern: TComboBox;
    cbIngameSaveReplayPattern: TComboBox;
    cbPostviewSaveReplayPattern: TComboBox;
    btnHotkeys: TButton;
    ebUserName: TEdit;
    cbAutoReplay: TCheckBox;
    cbPauseAfterBackwards: TCheckBox;
    cbSpawnInterval: TCheckBox;
    cbNoBackgrounds: TCheckBox;
    cbEdgeScrolling: TCheckBox;
    cbClassicMode: TCheckbox;
    cbHideShadows: TCheckBox;
    cbHideHelpers: TCheckBox;
    Label3: TLabel;
    Label5: TLabel;
    tbSoundVol: TTrackBar;
    tbMusicVol: TTrackBar;
    cbDisableTestplayMusic: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    cbZoom: TComboBox;
    cbLinearResampleMenu: TCheckBox;
    cbFullScreen: TCheckBox;
    cbMinimapHighQuality: TCheckBox;
    cbIncreaseZoom: TCheckBox;
    cbHighResolution: TCheckBox;
    cbResetWindowSize: TCheckBox;
    cbResetWindowPosition: TCheckBox;
    cbPanelZoom: TComboBox;
    btnResetWindow: TButton;
    rgExitSound: TRadioGroup;
    cbShowMinimap: TCheckBox;
    cbReplayAfterRestart: TCheckBox;
    cbTurboFF: TCheckBox;
    gbMenuSounds: TGroupBox;
    cbPostviewJingles: TCheckBox;
    rgGameLoading: TRadioGroup;
    cbMenuSounds: TCheckBox;
    cbColourCycle: TCheckBox;
    cbHideSkillQ: TCheckBox;
    gbReplayOptions: TGroupBox;
    gbSkillPanelOptions: TGroupBox;
    cbShowButtonHints: TCheckBox;
    procedure btnApplyClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnHotkeysClick(Sender: TObject);
    procedure OptionChanged(Sender: TObject);
    procedure SliderChange(Sender: TObject);
    procedure cbFullScreenClick(Sender: TObject);
    procedure cbAutoSaveReplayClick(Sender: TObject);
    procedure cbReplayPatternEnter(Sender: TObject);
    procedure cbClassicModeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnResetWindowClick(Sender: TObject);
    procedure cbShowMinimapClick(Sender: TObject);
  private
    fIsSetting: Boolean;
    fResetWindowSize: Boolean;
    fResetWindowPosition: Boolean;

    procedure SetFromParams;
    procedure SaveToParams;

    procedure SetZoomDropdown(aValue: Integer = -1);
    procedure SetPanelZoomDropdown(aValue: Integer = -1);
    procedure SetCheckboxes;
    function GetResetWindowSize: Boolean;
    function GetResetWindowPosition: Boolean;

    procedure SetReplayPatternDropdown(aBox: TComboBox; aPattern: String);
    function GetReplayPattern(aBox: TComboBox): String;
  public
    procedure SetGameParams;
    property ResetWindowSize: Boolean read GetResetWindowSize;
    property ResetWindowPosition: Boolean read GetResetWindowPosition;
  end;

var
  FormNXConfig: TFormNXConfig;

implementation

uses
  GameBaseScreenCommon, // For EXTRA_ZOOM_LEVELS constant
  GameMenuScreen; // For disabling the MassReplayCheck button if necessary.

const
  PRESET_REPLAY_PATTERNS: array[0..6] of String =
  (
    '{GROUP}_{GROUPPOS}__{TIMESTAMP}|{TITLE}__{TIMESTAMP}',
    '{TITLE}__{TIMESTAMP}',
    '{GROUP}_{GROUPPOS}__{TITLE}__{TIMESTAMP}|{TITLE}__{TIMESTAMP}',
    '{USERNAME}__{GROUP}_{GROUPPOS}__{TIMESTAMP}|{USERNAME}__{TITLE}__{TIMESTAMP}',
    '{USERNAME}__{TITLE}__{TIMESTAMP}',
    '{USERNAME}__{GROUP}_{GROUPPOS}__{TITLE}__{TIMESTAMP}|{USERNAME}__{TITLE}__{TIMESTAMP}',
    '*{USERNAME}__{TITLE}__{TIMESTAMP}'
  );

{$R *.dfm}

function TFormNXConfig.GetResetWindowSize: Boolean;
begin
  Result := fResetWindowSize and not GameParams.FullScreen;
end;

function TFormNXConfig.GetReplayPattern(aBox: TComboBox): String;
begin
  if aBox.ItemIndex = -1 then
    Result := aBox.Text
  else
    Result := PRESET_REPLAY_PATTERNS[aBox.ItemIndex];
end;

function TFormNXConfig.GetResetWindowPosition: Boolean;
begin
  Result := fResetWindowPosition and not GameParams.FullScreen;
end;

procedure TFormNXConfig.SetGameParams;
begin
  SetFromParams;
end;

procedure TFormNXConfig.SetReplayPatternDropdown(aBox: TComboBox;
  aPattern: String);
var
  i: Integer;
begin
  for i := 0 to aBox.Items.Count-1 do
    if PRESET_REPLAY_PATTERNS[i] = aPattern then
    begin
      aBox.ItemIndex := i;
      Exit;
    end;

  aBox.ItemIndex := -1;
  aBox.Text := aPattern;
end;

procedure TFormNXConfig.SetZoomDropdown(aValue: Integer = -1);
var
  i: Integer;
  MaxZoom: Integer;
begin
  cbZoom.Items.Clear;

  MaxZoom := Min(
                   (Screen.Width div 320) + EXTRA_ZOOM_LEVELS,
                   (Screen.Height div 200) + EXTRA_ZOOM_LEVELS
                );

  if cbHighResolution.Checked then
    MaxZoom := Max(1, MaxZoom div 2);

  for i := 1 to MaxZoom do
    cbZoom.Items.Add(IntToStr(i) + 'x Zoom');

  if aValue < 0 then
    aValue := GameParams.ZoomLevel - 1;

  cbZoom.ItemIndex := Max(0, Min(aValue, cbZoom.Items.Count - 1));
end;

procedure TFormNXConfig.SetPanelZoomDropdown(aValue: Integer);
var
  i: Integer;
  MaxWidth: Integer;
  MaxZoom: Integer;
begin
  cbPanelZoom.Items.Clear;

  if GameParams.FullScreen or cbFullScreen.Checked then
    MaxWidth := Screen.Width
  else
    MaxWidth := GameParams.MainForm.ClientWidth;

  if cbShowMinimap.Checked then
    begin
      MaxZoom := Max(MaxWidth div 444, 1);
    end else begin
      MaxZoom := Max(MaxWidth div 336, 1);
    end;

  if cbHighResolution.Checked then
    MaxZoom := Max(1, MaxZoom div 2);

  for i := 1 to MaxZoom do
    cbPanelZoom.Items.Add(IntToStr(i) + 'x Zoom');

  if aValue < 0 then
    aValue := GameParams.PanelZoomLevel - 1;

  cbPanelZoom.ItemIndex := Max(0, Min(aValue, cbPanelZoom.Items.Count - 1));
end;

procedure TFormNXConfig.btnApplyClick(Sender: TObject);
begin
  SaveToParams;
end;

procedure TFormNXConfig.btnOKClick(Sender: TObject);
begin
  SaveToParams;
  if GameParams.MenuSounds then SoundManager.PlaySound(SFX_OK);
  ModalResult := mrOK;
end;

procedure TFormNXConfig.btnResetWindowClick(Sender: TObject);
begin
  cbResetWindowSize.Checked := True;
  cbResetWindowPosition.Checked := True;
end;

procedure TFormNXConfig.SetFromParams;
begin
  fIsSetting := true;

  try
    // --- Page 1 (Global Options) --- //

    ebUserName.Text := GameParams.UserName;

    // Checkboxes
    cbAutoSaveReplay.Checked := GameParams.AutoSaveReplay;
    cbAutoSaveReplayPattern.Enabled := GameParams.AutoSaveReplay;
    SetReplayPatternDropdown(cbAutoSaveReplayPattern, GameParams.AutoSaveReplayPattern);
    SetReplayPatternDropdown(cbIngameSaveReplayPattern, GameParams.IngameSaveReplayPattern);
    SetReplayPatternDropdown(cbPostviewSaveReplayPattern, GameParams.PostviewSaveReplayPattern);

    // --- Page 2 (Interface Options) --- //
    // Checkboxes
    cbPauseAfterBackwards.Checked := GameParams.PauseAfterBackwardsSkip;
    cbAutoReplay.Checked := GameParams.AutoReplayMode;
    cbReplayAfterRestart.Checked := GameParams.ReplayAfterRestart;
    cbNoBackgrounds.Checked := GameParams.NoBackgrounds;
    cbColourCycle.Checked := GameParams.ColourCycle;
    cbShowButtonHints.Checked := GameParams.ShowButtonHints;
    cbClassicMode.Checked := GameParams.ClassicMode;
    cbHideShadows.Checked := GameParams.HideShadows;
    cbHideHelpers.Checked := GameParams.HideHelpers;
    cbHideSkillQ.Checked := GameParams.HideSkillQ;
    cbEdgeScrolling.Checked := GameParams.EdgeScroll;
    cbSpawnInterval.Checked := GameParams.SpawnInterval;

    cbFullScreen.Checked := GameParams.FullScreen;
    cbResetWindowSize.Enabled := not GameParams.FullScreen;
    cbResetWindowSize.Checked := false;
    cbResetWindowPosition.Enabled := not GameParams.FullScreen;
    cbResetWindowPosition.Checked := false;
    cbHighResolution.Checked := GameParams.HighResolution; // Must be done before SetZoomDropdown
    cbIncreaseZoom.Checked := GameParams.IncreaseZoom;
    cbLinearResampleMenu.Checked := GameParams.LinearResampleMenu;
    cbMinimapHighQuality.Checked := GameParams.MinimapHighQuality;

    cbShowMinimap.Checked := GameParams.ShowMinimap;
    cbTurboFF.Checked := GameParams.TurboFF;

    // Zoom Dropdown
    SetZoomDropdown;
    SetPanelZoomDropdown;

    // --- Page 3 (Audio Options) --- //
    if SoundManager.MuteSound then
      tbSoundVol.Position := 0
    else
      tbSoundVol.Position := SoundManager.SoundVolume;
    if SoundManager.MuteMusic then
      tbMusicVol.Position := 0
    else
      tbMusicVol.Position := SoundManager.MusicVolume;

    cbDisableTestplayMusic.Checked := GameParams.DisableMusicInTestplay;
    cbPostviewJingles.Checked := GameParams.PostviewJingles;
    cbMenuSounds.Checked := GameParams.MenuSounds;

    btnApply.Enabled := false;
  finally
    fIsSetting := false;
  end;
end;

procedure TFormNXConfig.SaveToParams;
begin

  // --- Page 1 (Global Options) --- //

  GameParams.UserName := ebUserName.Text;

  // Checkboxes
  GameParams.AutoSaveReplay := cbAutoSaveReplay.Checked;
  GameParams.AutoSaveReplayPattern := GetReplayPattern(cbAutoSaveReplayPattern);
  GameParams.IngameSaveReplayPattern := GetReplayPattern(cbIngameSaveReplayPattern);
  GameParams.PostviewSaveReplayPattern := GetReplayPattern(cbPostviewSaveReplayPattern);

  GameParams.NextUnsolvedLevel := rgGameLoading.ItemIndex = 0;
  GameParams.LastActiveLevel := rgGameLoading.ItemIndex = 1;

  // --- Page 2 (Interface Options) --- //
  // Checkboxes
  GameParams.PauseAfterBackwardsSkip := cbPauseAfterBackwards.Checked;
  GameParams.AutoReplayMode := cbAutoReplay.Checked;
  GameParams.ReplayAfterRestart := cbReplayAfterRestart.Checked;

  GameParams.NoBackgrounds := cbNoBackgrounds.Checked;
  GameParams.ColourCycle := cbColourCycle.Checked;
  GameParams.ShowButtonHints := cbShowButtonHints.Checked;
  GameParams.ClassicMode := cbClassicMode.Checked;
  GameParams.HideShadows := cbHideShadows.Checked;
  GameParams.HideHelpers := cbHideHelpers.Checked;
  GameParams.HideSkillQ := cbHideSkillQ.Checked;
  GameParams.EdgeScroll := cbEdgeScrolling.Checked;
  GameParams.SpawnInterval := cbSpawnInterval.Checked;

  GameParams.FullScreen := cbFullScreen.Checked;
  fResetWindowSize := cbResetWindowSize.Checked;
  fResetWindowPosition := cbResetWindowPosition.Checked;
  GameParams.HighResolution := cbHighResolution.Checked;
  GameParams.IncreaseZoom := cbIncreaseZoom.Checked;
  GameParams.LinearResampleMenu := cbLinearResampleMenu.Checked;
  GameParams.MinimapHighQuality := cbMinimapHighQuality.Checked;

  GameParams.ShowMinimap := cbShowMinimap.Checked;
  GameParams.TurboFF := cbTurboFF.Checked;

  // Zoom Dropdown
  GameParams.ZoomLevel := cbZoom.ItemIndex + 1;
  GameParams.PanelZoomLevel := cbPanelZoom.ItemIndex + 1;

  // --- Page 3 (Audio Options) --- //
  SoundManager.MuteSound := tbSoundVol.Position = 0;
  if tbSoundVol.Position <> 0 then
    SoundManager.SoundVolume := tbSoundVol.Position;
  SoundManager.MuteMusic := tbMusicVol.Position = 0;
  if tbMusicVol.Position <> 0 then
    SoundManager.MusicVolume := tbMusicVol.Position;

  GameParams.DisableMusicInTestplay := cbDisableTestplayMusic.Checked;

  GameParams.PreferYippee := rgExitSound.ItemIndex = 0;
  GameParams.PreferBoing := rgExitSound.ItemIndex = 1;

  GameParams.PostviewJingles := cbPostviewJingles.Checked;
  GameParams.MenuSounds := cbMenuSounds.Checked;

  btnApply.Enabled := false;
end;

procedure TFormNXConfig.btnHotkeysClick(Sender: TObject);
var
  HotkeyForm: TFLemmixHotkeys;
begin
  HotkeyForm := TFLemmixHotkeys.Create(self);
  HotkeyForm.HotkeyManager := GameParams.Hotkeys;
  HotkeyForm.ShowModal;
  HotkeyForm.Free;
end;

//procedure TFormNXConfig.btnStylesClick(Sender: TObject);
//var
  //F: TFManageStyles;
  //OldEnableOnline: Boolean;
//begin
  //OldEnableOnline := GameParams.EnableOnline;
  //GameParams.EnableOnline := cbEnableOnline.Checked; // Behave as checkbox indicates; but don't break the Cancel button.
  //F := TFManageStyles.Create(self);
  //try
    //F.ShowModal;
  //finally
    //F.Free;
   // GameParams.EnableOnline := OldEnableOnline;
  //end;
//end;

procedure TFormNXConfig.OptionChanged(Sender: TObject);
var
  NewZoom: Integer;
  NewPanelZoom: Integer;
begin
  if not fIsSetting then
  begin
    NewZoom := -1;
    NewPanelZoom := -1;

    if Sender = cbHighResolution then
    begin
      if cbHighResolution.Checked then
      begin
        NewZoom := cbZoom.ItemIndex div 2;
        NewPanelZoom := cbPanelZoom.ItemIndex div 2;
      end else begin
        NewZoom := cbZoom.ItemIndex * 2 + 1;
        NewPanelZoom := cbZoom.ItemIndex * 2 + 1;
      end;

      // If going from {low res, 3x panel zoom w/minimap} to hi-res, we need to reset window
      if cbShowMinimap.Checked and not GameParams.FullScreen then
      begin
        cbResetWindowPosition.Checked := True;
        cbResetWindowSize.Checked := True;
        cbResetWindowPosition.Enabled := False;
        cbResetWindowSize.Enabled := False;
      end;
    end;

    if (Sender = cbFullScreen) and not GameParams.FullScreen then
      NewPanelZoom := cbPanelZoom.ItemIndex;

    if NewZoom >= 0 then SetZoomDropdown(NewZoom);
    if NewPanelZoom >= 0 then SetPanelZoomDropdown(NewPanelZoom);

    btnApply.Enabled := true;
  end;
end;

procedure TFormNXConfig.cbAutoSaveReplayClick(Sender: TObject);
begin
  if not fIsSetting then
  begin
    cbAutoSaveReplayPattern.Enabled := cbAutoSaveReplay.Checked;
    OptionChanged(Sender);
  end;
end;

procedure TFormNXConfig.cbReplayPatternEnter(Sender: TObject);
var
  P: TComboBox;
begin
  if not (Sender is TComboBox) then Exit;
  P := TComboBox(Sender);

  if P.ItemIndex >= 0 then
    P.Text := PRESET_REPLAY_PATTERNS[P.ItemIndex];
end;

procedure TFormNXConfig.cbShowMinimapClick(Sender: TObject);
begin
  if not fIsSetting then
  begin
    if cbShowMinimap.Checked then
    begin
      cbMinimapHighQuality.Enabled := True;
    end else begin
      cbMinimapHighQuality.Checked := False;
      cbMinimapHighQuality.Enabled := False;
    end;

    if not GameParams.FullScreen then
    begin
      cbResetWindowPosition.State := cbChecked;
      cbResetWindowSize.State := cbChecked;
      cbResetWindowPosition.Enabled := False;
      cbResetWindowSize.Enabled := False;
    end;
  end;

  OptionChanged(Sender);
end;

procedure TFormNXConfig.FormCreate(Sender: TObject);
begin
  SetCheckboxes;
end;

// --- Classic Mode --- //
procedure TFormNXConfig.cbClassicModeClick(Sender: TObject);
begin
  OptionChanged(Sender);

  if cbClassicMode.Checked then
  begin
    cbHideShadows.Checked := true;
    cbHideHelpers.Checked := true;
    cbHideSkillQ.Checked := true;
    cbHideShadows.Enabled := false;
    cbHideHelpers.Enabled := false;
    cbHideSkillQ.Enabled := false;
  end else begin
    cbHideShadows.Checked := false;
    cbHideHelpers.Checked := false;
    cbHideSkillQ.Checked := false;
    cbHideShadows.Enabled := true;
    cbHideHelpers.Enabled := true;
    cbHideSkillQ.Enabled := true;
  end;
end;

procedure TFormNXConfig.SetCheckboxes;
  begin
    if GameParams.ClassicMode then
      begin
        cbHideShadows.Enabled := false;
        cbHideHelpers.Enabled := false;
        cbHideSkillQ.Enabled := false;
      end;

    if not GameParams.ShowMinimap then
      begin
        cbMinimapHighQuality.Checked := False;
        cbMinimapHighQuality.Enabled := False;
      end;

    if GameParams.NextUnsolvedLevel then rgGameLoading.ItemIndex := 0;
    if GameParams.LastActiveLevel then rgGameLoading.ItemIndex := 1;

    if GameParams.PreferYippee then rgExitSound.ItemIndex := 0;
    if GameParams.PreferBoing then rgExitSound.ItemIndex := 1;
  end;

procedure TFormNXConfig.cbFullScreenClick(Sender: TObject);
begin
  if not fIsSetting then
  begin
    OptionChanged(Sender);

    if cbFullScreen.Checked then
    begin
      cbResetWindowSize.Checked := false;
      cbResetWindowSize.Enabled := false;
      cbResetWindowPosition.Checked := false;
      cbResetWindowPosition.Enabled := false;
    end else begin
      cbResetWindowSize.Enabled := not GameParams.FullScreen;
      cbResetWindowSize.Checked := GameParams.FullScreen;
      cbResetWindowPosition.Enabled := not GameParams.FullScreen;
      cbResetWindowPosition.Checked := GameParams.FullScreen;
    end;
  end;
end;

procedure TFormNXConfig.SliderChange(Sender: TObject);
begin
  if not fIsSetting then
    btnApply.Enabled := true;
end;

end.
