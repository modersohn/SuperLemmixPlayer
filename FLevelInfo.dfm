object LevelInfoPanel: TLevelInfoPanel
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'LevelInfoPanel'
  ClientHeight = 80
  ClientWidth = 94
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblTemplate: TLabel
    Left = 51
    Top = 17
    Width = 49
    Height = 13
    Caption = 'lemming'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object btnClose: TButton
    Left = 8
    Top = 46
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 0
    Visible = False
  end
  object imgTemplate: TImage32
    Left = 8
    Top = 8
    Width = 32
    Height = 32
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 1
    Visible = False
  end
end
