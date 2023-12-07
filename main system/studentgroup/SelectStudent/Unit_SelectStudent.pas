unit Unit_SelectStudent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, jpeg, unit_login, unit_createStudent, Unit_CreateReport,
  Unit_ReportComment, unit_signup, DB, ADODB;

type
  TfrmSelectStudent = class(TForm)
    ImgBackground: TImage;
    cboSelectClass: TComboBox;
    cboSelectStudent: TComboBox;
    cboSelectYear: TComboBox;
    dbgrdUserClassData: TDBGrid;
    lblYear: TLabel;
    lbledtStudent_FirstName: TLabeledEdit;
    lbledtStudent_LastName: TLabeledEdit;
    cboChangeYear: TComboBox;
    cboChangeClass: TComboBox;
    btnUpdateStudent: TButton;
    cboSelectGender: TComboBox;
    btnDeleteStudent: TButton;
    btnDeleteReport: TButton;
    lblSelectStudent: TLabel;
    dsStudentReportList: TDataSource;
    qryStudentReportList: TADOQuery;
    qrySelectStudent: TADOQuery;
    qryExecuteStudent: TADOQuery;
    procedure cboSelectClassChange(Sender: TObject);
    procedure cboSelectYearChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboSelectStudentChange(Sender: TObject);
    procedure cboChangeYearChange(Sender: TObject);
    procedure btnUpdateStudentClick(Sender: TObject);
    procedure btnDeleteReportClick(Sender: TObject);
    procedure btnDeleteStudentClick(Sender: TObject);
    procedure dbgrdUserClassDataDblClick(Sender: TObject);
  private
    studentSelect:TStudentInfo;
  public

  end;

var
  frmSelectStudent: TfrmSelectStudent;

implementation

uses Unit_SelectClass;

{$R *.dfm}

procedure TfrmSelectStudent.cboSelectClassChange(Sender: TObject);
begin
  frmCreateReport.SelectClass(cboSelectStudent, frmSelectStudent, cboSelectClass.Text, cboSelectYear.Text);
  studentSelect.resetSelectedStudent;
end;

procedure TfrmSelectStudent.cboSelectYearChange(Sender: TObject);
begin
  cboSelectStudent.Clear; //deletes any previous students in the combo box
  cboSelectClass.Clear; //deletes any previous classes in the combo box
  try
    frmcreatestudent.selectClasses(frmSelectStudent.cboSelectClass,frmSelectStudent.cboselectYear); // finds the classes in relation to it
  except //if user inputs invalid value, it resets the combo box
    cboselectyear.Text:='Select Year...';
    cboselectclass.Clear;
  end;
  //resets all values
  cboselectstudent.clear;
  cboselectstudent.itemindex:=-1;
  cboselectstudent.text:='Select Student..';
  cboselectclass.itemindex:=-1;
  cboselectclass.text:='Class...';
  studentSelect.resetSelectedStudent;
end;

procedure TfrmSelectStudent.FormCreate(Sender: TObject);
begin
  studentSelect := TStudentInfo.Create;
end;

procedure TfrmSelectStudent.cboSelectStudentChange(Sender: TObject);
begin
  //write all student details to form
  studentSelect.writeSelectedStudent(cboSelectStudent.ItemIndex, cboSelectClass.Text, cboSelectYear.Text);
  lbledtStudent_FirstName.Text := studentSelect.getdata[2];
  lbledtStudent_LastName.Text := studentSelect.getdata[3];
  cboSelectGender.ItemIndex := cboSelectGender.Items.IndexOf(studentSelect.getData[4]);
  cboChangeYear.text := studentSelect.getData[5];
  frmcreatestudent.selectClasses(frmSelectStudent.cbochangeClass,frmSelectStudent.cbochangeYear); // finds the classes in relation to it
  cboChangeClass.ItemIndex := cboChangeClass.Items.IndexOf(studentSelect.getdata[6]);

  //Display students reports
  with qryStudentReportList do
  begin
    SQL.Text := 'select RptID, Subject, DateCreated, Grade from Report where sdtID = ' + studentSelect.getdata[1] + ';';
    Open;
  end;
end;

procedure TfrmSelectStudent.cboChangeYearChange(Sender: TObject);
begin

  try
    frmcreatestudent.selectClasses(frmSelectStudent.cboChangeClass,frmSelectStudent.cboChangeYear); // finds the classes in relation to it
  except //if user inputs invalid value, it resets the combo box
    cboChangeyear.Text:='Select Year...';
    cboChangeclass.Clear;
  end;
  //reset class values
  cboChangeclass.itemindex:=-1;
  cboChangeclass.text:='Class...';
end;

procedure TfrmSelectStudent.btnUpdateStudentClick(Sender: TObject);
var ClassID:string;
begin
  // Make sure student is selected first
  if not((cboSelectStudent.ItemIndex = -1) or (cboChangeClass.ItemIndex = -1) or (lbledtStudent_FirstName.text = '') or
  (lbledtStudent_LastName.text = '') or (cboSelectGender.ItemIndex = -1))then
  begin
    if ((frmSignup.stringisAlpha(lbledtStudent_FirstName.Text))and(frmSignup.stringisAlpha(lbledtStudent_LastName.Text)))then
    begin
      with qrySelectStudent do
      begin
        SQL.Text := 'select classID from class where Name = '+quotedStr(cbochangeclass.text)+' and Year = '+frmCreateStudent.getclassyear(cboChangeYear.Text)+
        ' and stfID = '+inttostr(info.StaffID)+';';
        Open;
        ClassID := FieldByName('classID').AsString;
        Close;
        sql.Text := 'select sdtid from student where FirstName = '+quotedStr(lbledtStudent_FirstName.text)+' and LastName = '+quotedStr(lbledtStudent_LastName.text)+
        ' and Gender = '+quotedStr(cboSelectGender.Text)+' and classID = '+classID+';';
        Open;
        // checks if there is already a student, which exists, with the values the student being updated with.
        if (recordcount > 0)then
          showmessage('Student with same identity already exists in that class...')
        else
        begin
          Close;
          SQL.Text := 'update Student set FirstName = '+quotedStr(lbledtStudent_FirstName.text)+', LastName = '+quotedStr(lbledtStudent_LastName.text)+
          ', Gender = '+quotedStr(cboSelectGender.Text)+', classID = '+classID+' where SdtID = '+studentselect.getData[1]+';';
          ExecSQL;
          showmessage('Student updated...');
        end;
      end;
    end
    else
      ShowMessage('Invalid Name');
  end
  else
    ShowMessage('Complete the form...');
end;

procedure TfrmSelectStudent.btnDeleteReportClick(Sender: TObject);
begin
  try
    // attempts to delete selected report
    with qryExecuteStudent do
    begin
      sql.Text := 'delete from [Report Comments] where rptid ='+vartostr(qryStudentReportList['RptID'])+';';
      execsql;
      sql.Text := 'delete from report where rptid ='+vartostr(qryStudentReportList['RptID'])+';';
      execsql;
    end;
    showmessage('Report deleted!');

    // Reloads the Report Table
    with qryStudentReportList do
    begin
      SQL.Text := 'select RptID, Subject, DateCreated, Grade from Report where sdtID = ' + studentSelect.getdata[1] + ';';
      Open;
    end;
  except
    // if report wasn't selected, traps the error and outputs a message
    ShowMessage('Select report first...');
  end;
end;

procedure TfrmSelectStudent.btnDeleteStudentClick(Sender: TObject);
var i:integer;
begin
  try
    frmSelectClass.DeleteStudentReports(studentSelect.getdata[1]);
    qryExecuteStudent.sql.Text := 'delete from Student where sdtid ='+studentSelect.getdata[1]+';';
    qryExecuteStudent.execsql;
    showmessage('Student deleted!');
    frmSelectStudent.Close;
  except
    ShowMessage('Select a student...');
  end;
end;

// Opens the report
procedure TfrmSelectStudent.dbgrdUserClassDataDblClick(Sender: TObject);
begin
  frmReportComment.displayReport(vartostr(qryStudentReportList['RptID']));
  frmReportComment.show;
end;

end.
