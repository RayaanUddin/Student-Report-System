unit unit_createStudent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ExtCtrls, unit_login, unit_signup;

type
  TfrmCreateStudent = class(TForm)
  published
    lbledtStudent_FirstName: TLabeledEdit;
    lbledtStudent_LastName: TLabeledEdit;
    cboSelectYear: TComboBox;
    cboSelectClass: TComboBox;
    qryCreateStudent: TADOQuery;
    btnCreateStudent: TButton;
    cboSelectGender: TComboBox;
    lblYear: TLabel;
    procedure cboSelectYearChange(Sender: TObject);
    procedure btnCreateStudentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure selectClasses(cboClass, cboYear: TObject); //used in Create Report
    function getClassYear(year:string):string; //used in Select Student
  end;

var
  frmCreateStudent: TfrmCreateStudent;

implementation

uses unit_createClass;

{$R *.dfm}

//Works out the year selected by user
function TfrmCreateStudent.getClassYear(year:string):string;
begin
  year := year[Length(year)];
  if (StrToInt(year)<7)then
    year:=IntToStr(StrToInt(year)+10);
  getClassYear:=year;
end;

procedure TfrmCreateStudent.selectClasses(cboClass, cboYear: TObject);
var i:Integer;
begin
  qryCreateStudent.SQL.Text := 'Select name from class where year='+getClassYear(TComboBox(cboYear).text)+' and stfID='+inttostr(info.staffID)+';';
  TComboBox(cboclass).Clear;
  qryCreateStudent.Open;
  for i:=1 to qryCreateStudent.recordcount do
  begin
    TComboBox(cboclass).Items.Add(qryCreateStudent.fieldbyname('name').AsString);
    qryCreateStudent.Next;
  end;
  qryCreateStudent.Close;
end;

procedure TfrmCreateStudent.cboSelectYearChange(Sender: TObject);
var i:Integer;
begin
  try
    selectClasses(cboSelectClass,cboselectyear);
  except
    cboselectyear.Text:='Select Year...';
    cboselectclass.Clear;
  end;
end;

procedure writeStudent;
var classID:String;
begin
  //Getting ClassID of the selected class
  frmCreateStudent.qrycreatestudent.SQL.Text := 'Select classID from class where year='+frmCreateStudent.getClassYear(frmCreateStudent.cboSelectYear.Text)+' and stfID='+inttostr(info.staffID)+' and name='+quotedStr(frmCreateStudent.cboselectclass.Text)+';';
  frmCreateStudent.qryCreateStudent.Open;
  ClassID := frmCreateStudent.qryCreateStudent.fieldbyname('classID').AsString;
  frmCreateStudent.qryCreateStudent.Close;

  //checking if student already exists in class (NOTE: there can be students with same first and last name, user needs to be informed)
  frmCreateStudent.qrycreatestudent.SQL.Text := 'Select FirstName, LastName from student where classID='+classID+' and FirstName='+quotedStr(frmCreateStudent.lbledtStudent_FirstName.Text)+' and LastName='+quotedStr(frmCreateStudent.lbledtStudent_LastName.Text)+' and Gender='+quotedStr(frmCreateStudent.cboSelectGender.text)+';';
  frmCreateStudent.qryCreateStudent.Open;
  if (frmCreateStudent.qryCreateStudent.RecordCount>0)then
  begin
    showmessage('Already Exists...');
    frmCreateStudent.qryCreateStudent.Close;
    end
  else
  begin
    //adding values to student_Table
    frmCreateStudent.qryCreateStudent.SQL.Text := 'insert into student(FirstName, LastName,Gender, ClassID) values ('+quotedStr(frmSignup.FirstLetterUppercase(frmCreateStudent.lbledtStudent_FirstName.Text))+','+quotedStr(frmSignup.FirstLetterUppercase(frmCreateStudent.lbledtStudent_LastName.Text))+','+quotedStr(frmCreateStudent.cboSelectGender.text)+','+classID+');';
    frmCreateStudent.qryCreateStudent.ExecSQL;
    showmessage('Student Created');
  end;
end;

procedure TfrmCreateStudent.btnCreateStudentClick(Sender: TObject);
begin
  if not((lbledtStudent_FirstName.Text = '') or (lbledtStudent_LastName.Text = '') or (cboSelectGender.ItemIndex = -1) or (cboSelectYear.ItemIndex = -1) or (cboSelectClass.ItemIndex = -1) or (cboSelectGender.ItemIndex = -1))then
  begin
    if ((frmSignup.stringisAlpha(lbledtStudent_FirstName.Text))and(frmSignup.stringisAlpha(lbledtStudent_LastName.Text)))then
      writeStudent
    else
      ShowMessage('invalid name');
  end
  else
    ShowMessage('fill in all values');
end;

procedure TfrmCreateStudent.FormCreate(Sender: TObject);
begin
  frmcreateclass.cboSelectYear.Update;
end;

end.
