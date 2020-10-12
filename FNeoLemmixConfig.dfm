object FormNXConfig: TFormNXConfig
  Left = 192
  Top = 125
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'NeoLemmix Configuration'
  ClientHeight = 433
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    273
    433)
  PixelsPerInch = 96
  TextHeight = 13
  object NXConfigPages: TPageControl
    Left = 0
    Top = 0
    Width = 273
    Height = 394
    ActivePage = TabSheet5
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    ExplicitHeight = 378
    object TabSheet1: TTabSheet
      Caption = 'General'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 350
      object lblUserName: TLabel
        Left = 7
        Top = 16
        Width = 54
        Height = 13
        Caption = 'Your name:'
      end
      object GroupBox4: TGroupBox
        Left = 7
        Top = 263
        Width = 249
        Height = 67
        Caption = 'Replay Options'
        TabOrder = 4
        object cbAutoSaveReplay: TCheckBox
          Left = 12
          Top = 16
          Width = 217
          Height = 17
          Caption = 'Automatically Save Successful Replays'
          TabOrder = 0
          OnClick = OptionChanged
        end
        object cbReplayAutoName: TCheckBox
          Left = 12
          Top = 34
          Width = 225
          Height = 17
          Caption = 'Use Timestamped Replay Names'
          TabOrder = 1
          OnClick = OptionChanged
        end
      end
      object GroupBox1: TGroupBox
        Left = 7
        Top = 200
        Width = 249
        Height = 57
        Caption = 'Internet Options'
        TabOrder = 3
        object cbEnableOnline: TCheckBox
          Left = 16
          Top = 16
          Width = 153
          Height = 17
          Caption = 'Enable Online Features'
          TabOrder = 0
          OnClick = cbEnableOnlineClick
        end
        object cbUpdateCheck: TCheckBox
          Left = 16
          Top = 34
          Width = 169
          Height = 17
          Caption = 'Enable Update Check'
          TabOrder = 1
          OnClick = OptionChanged
        end
      end
      object btnHotkeys: TButton
        Left = 7
        Top = 48
        Width = 249
        Height = 42
        Caption = 'Configure Hotkeys'
        TabOrder = 1
        OnClick = btnHotkeysClick
      end
      object btnReplayCheck: TButton
        Left = 7
        Top = 96
        Width = 249
        Height = 42
        Caption = 'Mass Replay Check'
        TabOrder = 2
        OnClick = btnReplayCheckClick
      end
      object ebUserName: TEdit
        Left = 71
        Top = 13
        Width = 185
        Height = 21
        TabOrder = 0
      end
      object btnStyles: TButton
        Left = 7
        Top = 144
        Width = 249
        Height = 42
        Caption = 'Style Manager'
        TabOrder = 5
        OnClick = btnStylesClick
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Interface'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 350
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 249
        Height = 57
        Caption = 'Input Options'
        TabOrder = 0
        object cbNoAutoReplay: TCheckBox
          Left = 12
          Top = 16
          Width = 225
          Height = 17
          Caption = 'Don'#39't Replay After Backwards Frameskips'
          TabOrder = 0
          OnClick = OptionChanged
        end
        object cbPauseAfterBackwards: TCheckBox
          Left = 12
          Top = 34
          Width = 153
          Height = 17
          Caption = 'Pause After Backwards Skip'
          TabOrder = 1
          OnClick = OptionChanged
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 68
        Width = 249
        Height = 96
        Caption = 'Interface Options'
        TabOrder = 1
        object cbNoBackgrounds: TCheckBox
          Left = 12
          Top = 16
          Width = 153
          Height = 17
          Caption = 'Disable Background Images'
          TabOrder = 0
          OnClick = OptionChanged
        end
        object cbEdgeScrolling: TCheckBox
          Left = 12
          Top = 50
          Width = 221
          Height = 17
          Caption = 'Enable Edge Scrolling and Trap Cursor'
          TabOrder = 2
          OnClick = OptionChanged
        end
        object cbSpawnInterval: TCheckBox
          Left = 12
          Top = 68
          Width = 153
          Height = 17
          Caption = 'Use Spawn Interval'
          TabOrder = 3
          OnClick = OptionChanged
        end
        object cbHideShadows: TCheckBox
          Left = 12
          Top = 33
          Width = 153
          Height = 17
          Caption = 'Hide Skill Shadows'
          TabOrder = 1
          OnClick = OptionChanged
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 167
        Width = 249
        Height = 196
        Caption = 'Graphics Options'
        TabOrder = 2
        object Label1: TLabel
          Left = 11
          Top = 20
          Width = 30
          Height = 13
          Caption = 'Zoom:'
        end
        object cbZoom: TComboBox
          Left = 56
          Top = 16
          Width = 177
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 0
          Text = '1x Zoom'
          OnChange = OptionChanged
          Items.Strings = (
            '1x Zoom')
        end
        object cbLinearResampleMenu: TCheckBox
          Left = 12
          Top = 120
          Width = 205
          Height = 17
          Caption = 'Use Smooth Resampling In Menus'
          TabOrder = 1
          OnClick = OptionChanged
        end
        object cbLinearResampleGame: TCheckBox
          Left = 12
          Top = 136
          Width = 205
          Height = 17
          Caption = 'Use Smooth Resampling In Game'
          TabOrder = 2
          OnClick = OptionChanged
        end
        object cbFullScreen: TCheckBox
          Left = 12
          Top = 40
          Width = 205
          Height = 17
          Caption = 'Full Screen'
          TabOrder = 3
          OnClick = cbFullScreenClick
        end
        object cbMinimapHighQuality: TCheckBox
          Left = 12
          Top = 168
          Width = 153
          Height = 17
          Caption = 'High Quality Minimap'
          TabOrder = 4
          OnClick = OptionChanged
        end
        object cbIncreaseZoom: TCheckBox
          Left = 12
          Top = 104
          Width = 205
          Height = 17
          Caption = 'Increase Zoom On Small Levels'
          TabOrder = 5
          OnClick = OptionChanged
        end
        object cbCompactSkillPanel: TCheckBox
          Left = 12
          Top = 152
          Width = 153
          Height = 17
          Caption = 'Compact Skill Panel'
          TabOrder = 6
          OnClick = OptionChanged
        end
        object cbHighResolution: TCheckBox
          Left = 12
          Top = 88
          Width = 205
          Height = 17
          Caption = 'High Resolution'
          TabOrder = 7
          OnClick = OptionChanged
        end
        object cbResetWindowSize: TCheckBox
          Left = 12
          Top = 72
          Width = 205
          Height = 17
          Caption = 'Reset Window Size'
          TabOrder = 8
          OnClick = OptionChanged
        end
        object cbResetWindowPosition: TCheckBox
          Left = 12
          Top = 56
          Width = 205
          Height = 17
          Caption = 'Reset Window Position'
          TabOrder = 9
          OnClick = OptionChanged
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Audio'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 350
      object Label3: TLabel
        Left = 24
        Top = 45
        Width = 31
        Height = 13
        Caption = 'Sound'
      end
      object Label5: TLabel
        Left = 24
        Top = 75
        Width = 28
        Height = 13
        Caption = 'Music'
      end
      object Label6: TLabel
        Left = 16
        Top = 16
        Width = 42
        Height = 13
        Caption = 'Volume'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 16
        Top = 112
        Width = 104
        Height = 13
        Caption = 'Post-Level Jingles'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object tbSoundVol: TTrackBar
        Left = 64
        Top = 40
        Width = 177
        Height = 33
        Max = 100
        Frequency = 10
        TabOrder = 0
        OnChange = SliderChange
      end
      object tbMusicVol: TTrackBar
        Left = 64
        Top = 70
        Width = 177
        Height = 33
        Max = 100
        Frequency = 10
        TabOrder = 1
        OnChange = SliderChange
      end
      object cbSuccessJingle: TCheckBox
        Left = 28
        Top = 136
        Width = 129
        Height = 17
        Caption = 'Success'
        TabOrder = 2
        OnClick = OptionChanged
      end
      object cbFailureJingle: TCheckBox
        Left = 28
        Top = 160
        Width = 129
        Height = 17
        Caption = 'Failure'
        TabOrder = 3
        OnClick = OptionChanged
      end
    end
  end
  object btnOK: TButton
    Left = 24
    Top = 400
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
    ExplicitTop = 384
  end
  object btnCancel: TButton
    Left = 104
    Top = 400
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    ExplicitTop = 384
  end
  object btnApply: TButton
    Left = 184
    Top = 400
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Apply'
    TabOrder = 3
    OnClick = btnApplyClick
    ExplicitTop = 384
  end
end
