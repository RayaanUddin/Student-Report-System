unit Unit_UpdateSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, unit_signup, DB, ADODB, unit_login, unit_menu;

type
  TfrmUpdateSetting = class(TForm)
    btnIncrementClasses: TButton;
    btnLogout: TButton;
    procedure btnIncrementClassesClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
  published
    logo_header: TImage;
    edtEmail: TEdit;
    edtfName: TEdit;
    edtlName: TEdit;
    edtpassword: TEdit;
    btnUpdate: TLabel;
    qryUpdateSetting: TADOQuery;
    btnDeleteAccount: TButton;
    qryDeleteAccount: TADOQuery;
    procedure btnUpdateMouseEnter(Sender: TObject);
    procedure btnUpdateMouseLeave(Sender: TObject);
    procedure edtpasswordClick(Sender: TObject);
    procedure edtEmailorNameClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteAccountClick(Sender: TObject);
  end;

var
  frmUpdateSetting: TfrmUpdateSetting;

implementation

{$R *.dfm}

procedure TfrmUpdateSetting.btnUpdateMouseEnter(Sender: TObject);
begin
  btnUpdate.Font.Color:= RGB(119,143,143);
end;

procedure TfrmUpdateSetting.btnUpdateMouseLeave(Sender: TObject);
begin
  btnUpdate.Font.Color:= clWhite;
end;

procedure TfrmUpdateSetting.edtpasswordClick(Sender: TObject);
begin
  if (edtpassword.Text='new password')then
    edtpassword.Text := '';
end;

procedure TfrmUpdateSetting.edtEmailorNameClick(Sender: TObject);
begin
  if (edtpassword.Text='')then
    edtpassword.Text := 'new password';
end;

function getLgnIDusingStfID(staffID:string):string;
var loginID:string;
begin
  with frmUpdateSetting.qryUpdateSetting do
  begin
    SQL.Text:='select lgnID from staff where stfID='+inttostr(info.staffID)+';';
    Open;
    LoginID:=FieldByName('LgnID').AsString;
    Close;
  end;
  getLgnIDusingStfID:=loginID;
end;

procedure TfrmUpdateSetting.btnUpdateClick(Sender: TObject);
var loginID, salt:string;
begin
  if not((edtfName.Text = '') or (edtlName.Text = '') or (edtpassword.Text ='') or (edtEmail.Text = '') or (edtpassword.Text ='new password'))then
  begin
    if (frmSignup.verifyName_and_Password(edtfName.Text, edtlName.Text, edtpassword.Text))then
    begin
      if (frmSignup.IsValidEmail(edtEmail.Text))then
      begin
        LoginID:=getLgnIDusingStfID(IntToStr(info.staffID));
        qryUpdateSetting.SQL.Text:='select lgnID from login where email='+quotedStr(edtemail.Text)+';';
        qryUpdateSetting.Open;
        if not((qryUpdateSetting.RecordCount<>0)and(qryUpdateSetting.FieldByName('lgnID').AsString<>loginID))then
        begin
          salt := frmSignup.generatesalt(Length(edtpassword.Text));
          qryupdatesetting.SQL.Text:='update Staff set FirstName='+quotedStr(frmSignup.FirstLetterUppercase(edtfname.Text))+', LastName='+quotedStr(frmSignup.FirstLetterUppercase(edtlname.Text))+' where StfID='+inttostr(info.staffID)+';';
          qryUpdateSetting.ExecSQL;
          qryupdatesetting.SQL.Text:='update Login set Email='+quotedStr(edtemail.Text)+', password='+quotedStr(frmSignup.hash(salt,edtpassword.Text))+', salt='+quotedStr(salt)+' where LgnID='+loginID+';';
          qryUpdateSetting.ExecSQL;
          showmessage('Account Updated');
        end
        else
          ShowMessage('Account with email address already exists...');
      end
      else
        ShowMessage('invalid email address');
    end;
  end
  else
    ShowMessage('fill in the form...');
end;

procedure deleteAllReports(staffID:string);
var reportCount, i:integer;
begin
  with frmUpdateSetting.qryUpdateSetting do
  begin
    SQL.Text := 'SELECT Report.RptID FROM Staff INNER JOIN (Class INNER JOIN (Student INNER JOIN Report ON Student.SdtID = Report.SdtID) ON Class.classID = Student.classID) ON Staff.StfID = Class.StfID WHERE Staff.StfID = '+staffID+';';
    Open;
    reportCount := recordcount;
  end;
  for i:= 1 to reportCount do
  begin
    with frmUpdateSetting do
    begin
      qryDeleteAccount.SQL.text:='DELETE * FROM [report comments] where rptID='+qryupdatesetting.fieldbyname('RptID').asstring+';';
      qryDeleteAccount.ExecSQL;
      qryUpdateSetting.Next;
    end;
  end;
  frmUpdateSetting.qryUpdateSetting.close;

  with frmUpdateSetting.qryUpdateSetting do
  begin
    SQL.Text := 'SELECT Student.SdtID FROM (Staff INNER JOIN Class ON Staff.StfID = Class.StfID) INNER JOIN Student ON Class.classID = Student.classID  WHERE Staff.StfID = '+staffID+';';
    Open;
    reportCount := recordcount;
  end;
  for i:= 1 to reportCount do
  begin
    with frmUpdateSetting do
    begin
      qryDeleteAccount.SQL.text:='DELETE * FROM report where SdtID='+qryupdatesetting.fieldbyname('SdtID').asstring+';';
      qryDeleteAccount.ExecSQL;
      qryUpdateSetting.Next;
    end;
  end;
  frmUpdateSetting.qryUpdateSetting.close;
end;

procedure deleteAllStudents(staffID:string);
var classCount,i:Integer;
begin
  with frmUpdateSetting.qryUpdateSetting do
  begin
    SQL.Text := 'select classID FROM class where stfID='+staffID+';';
    Open;
    classCount := recordcount;
  end;
  for i:= 1 to classCount do
  begin
    with frmUpdateSetting do
    begin
      qryDeleteAccount.SQL.text:='DELETE * FROM student where classID='+qryupdatesetting.fieldbyname('classID').asstring+';';
      qryDeleteAccount.ExecSQL;
      qryUpdateSetting.Next;
    end;
  end;
  frmUpdateSetting.qryUpdateSetting.close;
end;

procedure deleteAllClasses(staffID:string);
begin
  with frmUpdateSetting.qryDeleteAccount do
  begin
    SQL.text:='DELETE * FROM class where stfID='+inttostr(info.StaffID)+';';
    ExecSQL;
  end;
end;

procedure deleteAccountDetails(staffID:string);
var loginID:string;
begin
  loginID:=getLgnIDusingStfID(staffID);
  with frmUpdateSetting.qryDeleteAccount do
  begin
    SQL.Text:='DELETE * FROM staff where stfID='+inttostr(info.StaffID)+';';
    ExecSQL;
    SQL.Text:='DELETE * FROM login where lgnID='+loginID+';';
    ExecSQL;
  end;
  Showmessage('deleted, restart system...');
  frmLogin.Close;
end;
procedure TfrmUpdateSetting.btnDeleteAccountClick(Sender: TObject);
var i,count:Integer;
  loginID:string;
begin
  case MessageDlg('Confirm Deleting Account with all data...', mtConfirmation, [mbYes, mbNo], 0) of
    mrYes:
    begin
      deleteAllReports(IntToStr(info.StaffID));
      deleteAllStudents(IntToStr(info.StaffID));
      deleteAllClasses(IntToStr(info.StaffID));
      deleteAccountDetails(IntToStr(info.StaffID));
    end;
    mrNo:
    begin
      ShowMessage('cancelled');
    end;
  end;
end;

procedure TfrmUpdateSetting.btnIncrementClassesClick(Sender: TObject);
begin
  case MessageDlg('Incrementing all classes by one will result in current Y11 and Y13s being deleted...', mtConfirmation, [mbYes, mbNo], 0) of
    mrYes:
    begin
      with qryupdatesetting do
      begin
        sql.text := 'DELETE [Report Comments].*  '+
        'FROM (Staff INNER JOIN (Class INNER JOIN Student ON Class.classID = Student.classID) '+
        'ON Staff.StfID = Class.StfID) INNER JOIN (Report INNER JOIN [Report Comments] ON '+
        'Report.RptID = [Report Comments].RptID) ON Student.SdtID = Report.SdtID '+
        'WHERE ((Class.Year=11 Or Class.Year=13) AND (Staff.stfID='+inttostr(info.StaffID)+'));';
        ExecSQL;

        sql.text := 'DELETE Report.* '+
        'FROM (Staff INNER JOIN (Class INNER JOIN Student ON Class.classID = Student.classID) '+
        'ON Staff.StfID = Class.StfID) INNER JOIN Report ON Student.SdtID = Report.SdtID '+
        'WHERE (((Class.Year)=11 Or (Class.Year)=13) AND (Staff.stfID='+inttostr(info.StaffID)+'));';
        ExecSQL;

        sql.text := 'DELETE Student.* '+
        'FROM Staff INNER JOIN (Class INNER JOIN Student ON Class.classID = Student.classID) '+
        'ON Staff.StfID = Class.StfID '+
        'WHERE (((Class.Year)=11 Or (Class.Year)=13) AND (Staff.stfID='+inttostr(info.StaffID)+'));';
        ExecSQL;

        sql.text := 'DELETE Class.* '+
        'FROM Staff INNER JOIN Class ON Staff.StfID = Class.StfID '+
        'WHERE (((Class.Year)=11 Or (Class.Year)=13) AND (Staff.stfID='+inttostr(info.StaffID)+'));';
        ExecSQL;

        sql.text := 'UPDATE Staff INNER JOIN Class ON Staff.StfID = Class.StfID SET Class.[Year]'+
        ' = [class].[year]+1 where Staff.stfID='+inttostr(info.StaffID)+';';
        ExecSQL;
        showmessage('all classes have been incremented');
      end;

    end;
    mrNo:
    begin
      ShowMessage('cancelled');
    end;
  end;
end;

procedure TfrmUpdateSetting.btnLogoutClick(Sender: TObject);
var myFile : TextFile;
   text   : string;
begin
  frmUpdateSetting.Close;
  with frmLogin do
  begin
    edtEmail.Text := 'email';
    edtpassword.Text := 'password';
    edtpassword.PasswordChar := #0;
    Show;
    if FileExists('Data.txt') then
    begin
      AssignFile(myFile, 'Data.txt');
      ReWrite(myFile);
      WriteLn(myFile, 'Empty');
      CloseFile(myFile);
    end;
  end;
  frmMainMenu.Hide;
end;

end.
