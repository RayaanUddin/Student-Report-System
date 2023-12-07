object frmCreateStudent: TfrmCreateStudent
  Left = 420
  Top = 315
  BorderStyle = bsDialog
  Caption = 'Create Student'
  ClientHeight = 220
  ClientWidth = 245
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblYear: TLabel
    Left = 56
    Top = 88
    Width = 41
    Height = 25
    AutoSize = False
    Caption = 'Year:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object lbledtStudent_FirstName: TLabeledEdit
    Left = 104
    Top = 8
    Width = 121
    Height = 27
    EditLabel.Width = 87
    EditLabel.Height = 19
    EditLabel.Caption = 'First Name: '
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    LabelPosition = lpLeft
    ParentFont = False
    TabOrder = 0
  end
  object lbledtStudent_LastName: TLabeledEdit
    Left = 104
    Top = 48
    Width = 121
    Height = 27
    EditLabel.Width = 85
    EditLabel.Height = 19
    EditLabel.Caption = 'Last Name: '
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    LabelPosition = lpLeft
    ParentFont = False
    TabOrder = 1
  end
  object cboSelectYear: TComboBox
    Left = 104
    Top = 88
    Width = 121
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 19
    MaxLength = 7
    ParentFont = False
    TabOrder = 2
    Text = 'Select Year..'
    OnChange = cboSelectYearChange
  end
  object cboSelectClass: TComboBox
    Left = 152
    Top = 128
    Width = 73
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 19
    ParentFont = False
    TabOrder = 3
    Text = 'Class...'
  end
  object btnCreateStudent: TButton
    Left = 56
    Top = 160
    Width = 137
    Height = 41
    Caption = 'Create Student'
    TabOrder = 4
    OnClick = btnCreateStudentClick
  end
  object cboSelectGender: TComboBox
    Left = 16
    Top = 128
    Width = 89
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 19
    ParentFont = False
    TabOrder = 5
    Text = 'Gender...'
    Items.Strings = (
      'Male'
      'Female')
  end
  object qryCreateStudent: TADOQuery
    Connection = frmLogin.con_database
    Parameters = <>
    Left = 200
    Top = 168
  end
end
