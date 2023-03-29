object FormNXConfig: TFormNXConfig
  Left = 192
  Top = 125
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'SuperLemmix Configuration'
  ClientHeight = 400
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    275
    400)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 11
    Top = 371
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 97
    Top = 371
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object btnApply: TButton
    Left = 183
    Top = 371
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Apply'
    TabOrder = 2
    OnClick = btnApplyClick
  end
  object NXConfigPages: TPageControl
    Left = 0
    Top = 0
    Width = 275
    Height = 369
    ActivePage = Graphics
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'General'
      object lblUserName: TLabel
        Left = 13
        Top = 18
        Width = 56
        Height = 13
        Caption = 'Your name:'
      end
      object ReplayOptions: TGroupBox
        Left = 3
        Top = 114
        Width = 261
        Height = 167
        Caption = 'Replay Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object lblIngameSaveReplay: TLabel
          Left = 13
          Top = 71
          Width = 45
          Height = 13
          Caption = 'In-game:'
        end
        object lblPostviewSaveReplay: TLabel
          Left = 13
          Top = 115
          Width = 48
          Height = 13
          Caption = 'Postview:'
        end
        object cbAutoSaveReplay: TCheckBox
          Left = 13
          Top = 22
          Width = 72
          Height = 17
          Caption = 'Auto-save:'
          TabOrder = 0
          OnClick = cbAutoSaveReplayClick
        end
        object cbAutoSaveReplayPattern: TComboBox
          Left = 13
          Top = 44
          Width = 238
          Height = 21
          ItemIndex = 1
          TabOrder = 1
          Text = 'Title + Timestamp'
          OnChange = OptionChanged
          OnEnter = cbReplayPatternEnter
          Items.Strings = (
            'Position + Timestamp'
            'Title + Timestamp'
            'Position + Title + Timestamp'
            'Username + Position + Timestamp'
            'Username + Title + Timestamp'
            'Username + Position + Title + Timestamp')
        end
        object cbIngameSaveReplayPattern: TComboBox
          Left = 13
          Top = 88
          Width = 238
          Height = 21
          TabOrder = 2
          Text = 'Position + Timestamp'
          OnChange = OptionChanged
          OnEnter = cbReplayPatternEnter
          Items.Strings = (
            'Position + Timestamp'
            'Title + Timestamp'
            'Position + Title + Timestamp'
            'Username + Position + Timestamp'
            'Username + Title + Timestamp'
            'Username + Position + Title + Timestamp'
            '(Show file selector)')
        end
        object cbPostviewSaveReplayPattern: TComboBox
          Left = 13
          Top = 131
          Width = 238
          Height = 21
          TabOrder = 3
          Text = 'Position + Timestamp'
          OnChange = OptionChanged
          OnEnter = cbReplayPatternEnter
          Items.Strings = (
            'Position + Timestamp'
            'Title + Timestamp'
            'Position + Title + Timestamp'
            'Username + Position + Timestamp'
            'Username + Title + Timestamp'
            'Username + Position + Title + Timestamp'
            '(Show file selector)')
        end
      end
      object btnHotkeys: TButton
        Left = 15
        Top = 56
        Width = 238
        Height = 52
        Caption = 'Configure Hotkeys'
        TabOrder = 1
        OnClick = btnHotkeysClick
      end
      object ebUserName: TEdit
        Left = 75
        Top = 15
        Width = 178
        Height = 21
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Gameplay'
      ImageIndex = 4
      object cbEdgeScrolling: TCheckBox
        Left = 25
        Top = 10
        Width = 234
        Height = 17
        Caption = 'Activate Edge Scrolling and Trap Cursor'
        TabOrder = 7
        OnClick = OptionChanged
      end
      object cbNoAutoReplay: TCheckBox
        Left = 25
        Top = 33
        Width = 234
        Height = 17
        Caption = 'Replay After Backwards Frameskip'
        TabOrder = 1
        OnClick = OptionChanged
      end
      object cbPauseAfterBackwards: TCheckBox
        Left = 25
        Top = 56
        Width = 205
        Height = 17
        Caption = 'Pause After Backwards Frameskip'
        TabOrder = 5
        OnClick = OptionChanged
      end
      object cbSpawnInterval: TCheckBox
        Left = 25
        Top = 79
        Width = 205
        Height = 17
        Caption = 'Activate Spawn Interval Display'
        TabOrder = 6
        OnClick = OptionChanged
      end
      object ClassicMode: TGroupBox
        Left = 25
        Top = 127
        Width = 205
        Height = 186
        TabOrder = 0
        object cbHideShadows: TCheckBox
          Left = 27
          Top = 25
          Width = 190
          Height = 17
          Caption = 'Deactivate Skill Shadows'
          TabOrder = 0
          OnClick = OptionChanged
        end
        object cbHideClearPhysics: TCheckBox
          Left = 27
          Top = 48
          Width = 190
          Height = 17
          Caption = 'Deactivate Clear Physics'
          TabOrder = 1
          OnClick = OptionChanged
        end
        object cbHideAdvancedSelect: TCheckBox
          Left = 27
          Top = 71
          Width = 190
          Height = 17
          Caption = 'Deactivate Advanced Select'
          TabOrder = 2
          OnClick = OptionChanged
        end
        object cbHideFrameskipping: TCheckBox
          Left = 27
          Top = 94
          Width = 190
          Height = 17
          Caption = 'Deactivate Frameskipping'
          TabOrder = 3
          OnClick = OptionChanged
        end
        object cbHideHelpers: TCheckBox
          Left = 27
          Top = 117
          Width = 190
          Height = 17
          Caption = 'Deactivate Helper Overlays'
          TabOrder = 4
          OnClick = OptionChanged
        end
        object cbHideSkillQ: TCheckBox
          Left = 27
          Top = 140
          Width = 190
          Height = 17
          Caption = 'Deactivate Skill Queueing'
          TabOrder = 5
          OnClick = OptionChanged
        end
      end
      object btnClassicMode: TButton
        Left = 52
        Top = 108
        Width = 150
        Height = 38
        Hint = 
          'Classic Mode implements all of the features listed below for a m' +
          'ore traditional Lemmings experience!'#13#10'Deactivates Skill Shadows'#13 +
          #10'Deactivates Clear Physics'#13#10'Deactivates Advanced Select (Directi' +
          'onal, Walkers-only and Highlighted Lemming)'#13#10'Deactivates Framesk' +
          'ipping (including Slow-motion)'#13#10'Deactivates Helper graphics (inc' +
          'luding the Fall Distance ruler)'#13#10'Deactivates Skill Queuing'#13#10'(The' +
          ' above features can also be toggled individually, whilst the fol' +
          'lowing are exclusive to Classic Mode):'#13#10'Deactivates Assign-whils' +
          't-paused'#13#10'Deactivates Selected Lemming recolouring'#13#10'Deactivates ' +
          'jumping to Min/Max Release Rate'#13#10'Prefers Release Rate rather tha' +
          'n Spawn Interval for displaying hatch speed'#13#10'Limits Replay featu' +
          'res to saving and loading only from the level preview and postvi' +
          'ew screens.'#13#10'Enjoy!'
        Caption = 'Activate Classic Mode'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btnClassicModeClick
      end
      object btnDeactivateClassicMode: TButton
        Left = 52
        Top = 293
        Width = 150
        Height = 38
        Caption = 'Deactivate Classic Mode'
        TabOrder = 4
        OnClick = btnDeactivateClassicModeClick
      end
      object cbClassicMode: TCheckBox
        Left = 208
        Top = 118
        Width = 51
        Height = 17
        Caption = 'ACM'
        TabOrder = 2
        Visible = False
      end
    end
    object Graphics: TTabSheet
      Caption = 'Graphics'
      ImageIndex = 3
      object Label1: TLabel
        Left = 66
        Top = 16
        Width = 32
        Height = 13
        Caption = 'Zoom:'
      end
      object Label2: TLabel
        Left = 67
        Top = 43
        Width = 31
        Height = 13
        Caption = 'Panel:'
      end
      object cbZoom: TComboBox
        Left = 104
        Top = 13
        Width = 81
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = '1x Zoom'
        OnChange = OptionChanged
        Items.Strings = (
          '1x Zoom')
      end
      object cbPanelZoom: TComboBox
        Left = 104
        Top = 40
        Width = 81
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 1
        Text = '1x Zoom'
        OnChange = OptionChanged
        Items.Strings = (
          '1x Zoom')
      end
      object cbFullScreen: TCheckBox
        Left = 38
        Top = 72
        Width = 205
        Height = 17
        Caption = 'Full Screen'
        TabOrder = 2
        OnClick = cbFullScreenClick
      end
      object cbHighResolution: TCheckBox
        Left = 38
        Top = 95
        Width = 205
        Height = 17
        Caption = 'High Resolution'
        TabOrder = 6
        OnClick = OptionChanged
      end
      object cbIncreaseZoom: TCheckBox
        Left = 38
        Top = 118
        Width = 205
        Height = 17
        Caption = 'Increase Zoom On Small Levels'
        TabOrder = 4
        OnClick = OptionChanged
      end
      object cbLinearResampleMenu: TCheckBox
        Left = 38
        Top = 141
        Width = 205
        Height = 17
        Caption = 'Use Smooth Resampling In Menus'
        TabOrder = 5
        OnClick = OptionChanged
      end
      object gbMinimapOptions: TGroupBox
        Left = 24
        Top = 198
        Width = 219
        Height = 48
        Caption = 'Minimap Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object cbMinimapHighQuality: TCheckBox
          Left = 117
          Top = 20
          Width = 90
          Height = 17
          Caption = 'High Quality'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = OptionChanged
        end
        object cbShowMinimap: TCheckBox
          Left = 14
          Top = 20
          Width = 97
          Height = 17
          Caption = 'Show Minimap'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = cbShowMinimapClick
        end
      end
      object cbNoBackgrounds: TCheckBox
        Left = 38
        Top = 164
        Width = 205
        Height = 17
        Caption = 'Deactivate Background Images'
        TabOrder = 7
        OnClick = OptionChanged
      end
      object ResetWindow: TGroupBox
        Left = 24
        Top = 276
        Width = 219
        Height = 49
        TabOrder = 9
        object cbResetWindowPosition: TCheckBox
          Left = 14
          Top = 21
          Width = 97
          Height = 17
          Caption = 'Reset Position'
          TabOrder = 0
          OnClick = OptionChanged
        end
        object cbResetWindowSize: TCheckBox
          Left = 117
          Top = 21
          Width = 90
          Height = 17
          Caption = 'Reset Size'
          TabOrder = 1
          OnClick = OptionChanged
        end
      end
      object btnResetWindow: TButton
        Left = 65
        Top = 260
        Width = 135
        Height = 34
        Caption = 'Reset Window'
        TabOrder = 8
        OnClick = btnResetWindowClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Audio'
      ImageIndex = 3
      object Label3: TLabel
        Left = 17
        Top = 30
        Width = 34
        Height = 13
        Caption = 'Sound'
      end
      object Label5: TLabel
        Left = 21
        Top = 69
        Width = 30
        Height = 13
        Caption = 'Music'
      end
      object tbSoundVol: TTrackBar
        Left = 51
        Top = 26
        Width = 206
        Height = 33
        Max = 100
        Frequency = 10
        TabOrder = 0
        OnChange = SliderChange
      end
      object tbMusicVol: TTrackBar
        Left = 51
        Top = 65
        Width = 206
        Height = 33
        Max = 100
        Frequency = 10
        TabOrder = 1
        OnChange = SliderChange
      end
      object cbDisableTestplayMusic: TCheckBox
        Left = 37
        Top = 114
        Width = 193
        Height = 17
        Caption = 'Disable Music When Testplaying'
        TabOrder = 2
        OnClick = OptionChanged
      end
      object rgExitSound: TRadioGroup
        Left = 72
        Top = 156
        Width = 113
        Height = 81
        Caption = 'Choose Exit Sound'
        TabOrder = 3
      end
      object rbYippee: TRadioButton
        Left = 98
        Top = 180
        Width = 65
        Height = 17
        Caption = 'Yippee!'
        TabOrder = 4
        OnClick = OptionChanged
      end
      object rbBoing: TRadioButton
        Left = 98
        Top = 203
        Width = 65
        Height = 17
        Caption = 'Boing!'
        TabOrder = 5
        OnClick = OptionChanged
      end
    end
  end
end
