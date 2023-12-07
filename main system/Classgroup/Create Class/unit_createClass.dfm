object frmCreateClass: TfrmCreateClass
  Left = 92
  Top = 158
  BorderStyle = bsDialog
  Caption = 'Create Class'
  ClientHeight = 150
  ClientWidth = 240
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblYear: TLabel
    Left = 24
    Top = 64
    Width = 49
    Height = 33
    AutoSize = False
    Caption = 'Year:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object lbledtFormclassName: TLabeledEdit
    Left = 128
    Top = 16
    Width = 81
    Height = 32
    CharCase = ecUpperCase
    EditLabel.Width = 106
    EditLabel.Height = 24
    EditLabel.BiDiMode = bdRightToLeftNoAlign
    EditLabel.Caption = 'Form Name:'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -19
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentBiDiMode = False
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    LabelPosition = lpLeft
    ParentFont = False
    TabOrder = 0
  end
  object cboSelectYear: TComboBox
    Left = 88
    Top = 64
    Width = 121
    Height = 32
    Hint = 'Select Year...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    ParentFont = False
    TabOrder = 1
    Text = 'Select Year...'
    Items.Strings = (
      'Year 7'
      'Year 8'
      'Year 9'
      'Year 10'
      'Year 11'
      'Year 12'
      'Year 13')
  end
  object btnCreateClass: TButton
    Left = 48
    Top = 104
    Width = 137
    Height = 33
    Caption = 'Create'
    TabOrder = 2
    OnClick = btnCreateClassClick
  end
  object qryCreateClass: TADOQuery
    Connection = frmLogin.con_database
    Parameters = <>
    Left = 8
    Top = 104
  end
end
