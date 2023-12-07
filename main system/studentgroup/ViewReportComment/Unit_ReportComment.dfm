object frmReportComment: TfrmReportComment
  Left = 116
  Top = 523
  BorderStyle = bsDialog
  Caption = 'Report Comment'
  ClientHeight = 250
  ClientWidth = 500
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    500
    250)
  PixelsPerInch = 96
  TextHeight = 13
  object lblSdtName: TLabel
    Left = 392
    Top = 168
    Width = 96
    Height = 23
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'lblSdtName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblSdtAttendance: TLabel
    Left = 296
    Top = 24
    Width = 81
    Height = 13
    Caption = 'lblSdtattendance'
  end
  object lblSdtPunctuality: TLabel
    Left = 296
    Top = 8
    Width = 48
    Height = 13
    Caption = 'puntuality'
  end
  object lblSdtSubject: TLabel
    Left = 8
    Top = 8
    Width = 76
    Height = 29
    Caption = 'subject'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblSdtGrade: TLabel
    Left = 408
    Top = 8
    Width = 75
    Height = 23
    Caption = 'Grade: X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnExport: TButton
    Left = 304
    Top = 200
    Width = 161
    Height = 41
    Caption = 'Export As PDF'
    TabOrder = 0
    OnClick = btnExportClick
  end
  object MemoReportComment: TMemo
    Left = 8
    Top = 40
    Width = 481
    Height = 121
    Lines.Strings = (
      'Comment goes here'
      '')
    TabOrder = 1
    OnChange = MemoReportCommentChange
  end
  object btnCopyMemoReportComment: TButton
    Left = 32
    Top = 200
    Width = 161
    Height = 41
    Caption = 'Copy Comment'
    TabOrder = 2
    OnClick = btnCopyMemoReportCommentClick
  end
  object btnSave: TButton
    Left = 8
    Top = 168
    Width = 113
    Height = 25
    Caption = 'Save Comment'
    TabOrder = 3
    Visible = False
    OnClick = btnSaveClick
  end
  object qryfrmReportComment_Select: TADOQuery
    Connection = frmLogin.con_database
    Parameters = <>
    Left = 224
    Top = 200
  end
end
