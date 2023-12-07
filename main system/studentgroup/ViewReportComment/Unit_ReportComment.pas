unit Unit_ReportComment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, unit_login, DB, ADODB, unit_signup, ClipBrd, unit_ExportReport;

type
  TfrmReportComment = class(TForm)
    qryfrmReportComment_Select: TADOQuery;
    MemoReportComment: TMemo;
    lblSdtGrade: TLabel;
    btnCopyMemoReportComment: TButton;
    btnSave: TButton;
    procedure btnCopyMemoReportCommentClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure MemoReportCommentChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  published
    btnExport: TButton;
    lblSdtName: TLabel;
    lblSdtAttendance: TLabel;
    lblSdtPunctuality: TLabel;
    lblSdtSubject: TLabel;
  private
    pronoun:array[1..3] of string;
    comment:string;
    ID:string;
    procedure writePronouns(gender:string);
  public
    punctuality, attendance, grade, subject,studentFirstName, studentName, dateCreated, classNameYr:string;
    procedure displayReport(reportID:string);
  end;

var
  frmReportComment: TfrmReportComment;

implementation

{$R *.dfm}

procedure TfrmReportComment.writePronouns(gender:string); //Make sure to use Capital first Letter for Gender
begin
  if (gender = 'Male')then
  begin
    pronoun[1] := 'he';
    pronoun[2] := 'his';
    pronoun[3] := 'him';
  end
  else
  begin
    pronoun[1] := 'she';
    pronoun[2] := 'her';
    pronoun[3] := 'her';
  end;
end;

procedure TfrmReportComment.displayReport(reportID:string);
var gender:string;
  i:integer;
begin
  ID := reportID;
  qryfrmReportComment_select.SQL.Text := 'select Student.FirstName,Student.LastName, Student.Gender, Report.Attendance,'+
  ' Report.Grade, Report.Punctuality, Report.Subject, Report.DateCreated, Report.Comment, Class.Name, Class.Year '+
  'from Class inner join (Student inner join Report on Student.SdtID = Report.SdtID)'+
  ' on Class.classID = Student.classID where report.RptID = '+reportID+';';
  qryfrmReportComment_select.Open;
  punctuality := qryfrmReportComment_select.fieldbyname('punctuality').asstring;
  subject := qryfrmReportComment_select.fieldbyname('subject').asstring;
  attendance := qryfrmReportComment_select.fieldbyname('attendance').asstring;
  grade := qryfrmReportComment_select.fieldbyname('grade').asstring;
  studentName := qryfrmReportComment_select.fieldbyname('FirstName').asstring + ' ' + qryfrmReportComment_select.fieldbyname('LastName').asstring;
  dateCreated := qryfrmReportComment_select.fieldbyname('dateCreated').asstring;
  comment := qryfrmReportComment_select.fieldbyname('Comment').asstring;
  classNameYr := qryfrmReportComment_select.fieldbyname('year').AsString + qryfrmReportComment_select.fieldbyname('name').AsString;

  gender := qryfrmReportComment_select.fieldbyname('Gender').asstring;
  studentFirstName := qryfrmReportComment_select.fieldbyname('FirstName').asstring;

  lblsdtName.caption := qryfrmReportComment_select.fieldbyname('FirstName').asstring;
  lblSdtSubject.Caption := 'Subject: '+subject;
  lblSdtpunctuality.Caption := 'Punctuality: ' + punctuality;
  lblSdtAttendance.Caption := 'Attendance: ' + attendance;
  lblSdtgrade.Caption := 'Grade: ' + grade;

  writePronouns(gender);
  if (comment = '')then
  begin
    qryfrmReportComment_select.SQL.Text := 'select [Comment Bank].comment from [Comment Bank] '+
    'inner join [Report Comments] on [Comment Bank].cmbID = [Report Comments].CmbID where rptID = '+
    reportID+' order by [Report Comments].CmbID;';
    qryfrmReportComment_select.open;
    for i:=1 to qryfrmReportComment_select.RecordCount do
    begin
      comment := comment + ' ' + qryfrmReportComment_select.FieldByName('Comment').AsString;
      qryfrmReportComment_select.next;
    end;
  end;
  comment := stringReplace(comment, '{pronoun1}', pronoun[1], [rfReplaceAll]);
  comment := stringReplace(comment, '{pronoun2}', pronoun[2], [rfReplaceAll]);
  comment := stringReplace(comment, '{pronoun3}', pronoun[3], [rfReplaceAll]);
  comment := stringReplace(comment, '{name}', StudentFirstName, [rfReplaceAll, rfIgnoreCase]);
  comment := stringReplace(comment, '{Pronoun1}', frmsignup.FirstLetterUppercase(pronoun[1]), [rfReplaceAll]);
  comment := stringReplace(comment, '{Pronoun2}', frmsignup.FirstLetterUppercase(pronoun[2]), [rfReplaceAll]);
  comment := stringReplace(comment, '{Pronoun3}', frmsignup.FirstLetterUppercase(pronoun[3]), [rfReplaceAll]);
  memoReportComment.lines.Text := comment;
end;

procedure TfrmReportComment.btnCopyMemoReportCommentClick(Sender: TObject);
begin
  clipboard.AsText := memoReportComment.Lines.Text;
end;

procedure TfrmReportComment.btnExportClick(Sender: TObject);
begin
  frmExportReport.ShowModal;
end;

procedure TfrmReportComment.MemoReportCommentChange(Sender: TObject);
begin
  if (MemoReportComment.Text <> comment) then
    btnSave.Visible := True
  else
   btnSave.Visible := False;
end;

procedure TfrmReportComment.btnSaveClick(Sender: TObject);
begin
  comment := MemoReportComment.Text;
  comment := stringReplace(comment, pronoun[1], '{pronoun1}', [rfReplaceAll]);
  comment := stringReplace(comment, pronoun[2], '{pronoun2}', [rfReplaceAll]);
  comment := stringReplace(comment, pronoun[3], '{pronoun3}', [rfReplaceAll]);
  comment := stringReplace(comment, StudentFirstName, '{name}', [rfReplaceAll, rfIgnoreCase]);
  comment := stringReplace(comment, frmsignup.FirstLetterUppercase(pronoun[1]), '{Pronoun1}', [rfReplaceAll]);
  comment := stringReplace(comment, frmsignup.FirstLetterUppercase(pronoun[2]), '{Pronoun2}', [rfReplaceAll]);
  comment := stringReplace(comment, frmsignup.FirstLetterUppercase(pronoun[3]), '{Pronoun3}', [rfReplaceAll]);
  with qryfrmReportComment_select do
  begin
    SQL.Text := 'UPDATE Report SET Report.Comment = '+quotedStr(comment)+' where RptID = '+ID+';';
    ExecSQL;
  end;
  btnSave.Visible := false;
end;

end.
