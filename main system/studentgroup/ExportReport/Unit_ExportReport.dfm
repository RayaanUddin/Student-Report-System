object frmExportReport: TfrmExportReport
  Left = 739
  Top = 402
  BorderStyle = bsDialog
  Caption = 'Save As...'
  ClientHeight = 238
  ClientWidth = 235
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblLocation: TLabel
    Left = 16
    Top = 16
    Width = 209
    Height = 33
    Caption = 'Choose a location'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object dirlstSave: TDirectoryListBox
    Left = 16
    Top = 72
    Width = 201
    Height = 105
    ItemHeight = 16
    TabOrder = 0
  end
  object drvcbbSave: TDriveComboBox
    Left = 16
    Top = 56
    Width = 201
    Height = 19
    DirList = dirlstSave
    TabOrder = 1
  end
  object lbledtFileName: TLabeledEdit
    Left = 16
    Top = 208
    Width = 97
    Height = 24
    EditLabel.Width = 83
    EditLabel.Height = 23
    EditLabel.Caption = 'File Name'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -19
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object save: TButton
    Left = 128
    Top = 184
    Width = 89
    Height = 49
    Caption = 'save'
    TabOrder = 3
    OnClick = saveClick
  end
end
