unit unit_menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ADODB, ExtCtrls;

type YearArr = array[1..7] of string;

type
  TfrmMainMenu = class(TForm)
    tmrClose: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrCloseTimer(Sender: TObject);
  published
    lblProfileName: TLabel;
    ImgMainMenu: TImage;
    btnCreateStudent: TLabel;
    btnSelectStudent: TLabel;
    btnCreateClass: TLabel;
    btnSelectClass: TLabel;
    btnCreateReport: TLabel;
    imgSettings: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCreateClassClick(Sender: TObject);
    procedure btnSelectClassClick(Sender: TObject);
    procedure btnCreateStudentClick(Sender: TObject);
    procedure btnMouseEnter(Sender: TObject);
    procedure btnMouseLeave(Sender: TObject);
    procedure btnSelectStudentClick(Sender: TObject);
    procedure btnCreateReportClick(Sender: TObject);
    procedure imgSettingsClick(Sender: TObject);
  public
    function selectYear(qry,frm:Tobject):yearArr; //used to display all years from database in create student and create report
  private
    autologin:Boolean;
end;

var
  frmMainMenu: TfrmMainMenu;

implementation

uses unit_login, unit_createClass, unit_createStudent,
    Unit_UpdateSetting, unit_CreateReport, unit_selectclass, Unit_SelectStudent;

{$R *.dfm}

procedure changeWindowPos(sender:Tobject);
begin
  Tform(sender).Left := (screen.Width - Tform(sender).ClientWidth) div 2;
  Tform(sender).Top := (screen.Height - Tform(sender).ClientHeight) div 2;
end;

function Tfrmmainmenu.selectYear(qry, frm:Tobject):yearArr;
var i:integer;
  arr:yearArr;
begin
  with TForm(frm) do
  begin
    TADOQuery(qry).SQL.Text:='select year from class where StfID = '+inttostr(info.staffID)+' group by year order by year;';
    TADOQuery(qry).Open;
    for i:=1 to TADOQuery(qry).recordcount do
    begin
      arr[i]:= 'Year '+ TADOQuery(qry).fieldbyname('year').AsString;
      TADOQuery(qry).Next;
    end;
    TADOQuery(qry).Close;
    selectyear:=arr;
  end;
end;

procedure TfrmMainMenu.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmlogin.close;
end;

//Changes Color, lets user know that its a button
procedure TfrmMainMenu.btnMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := RGB(119,143,143);
end;

procedure TfrmMainMenu.btnMouseLeave(Sender: TObject);
var l:Boolean;
begin
    TLabel(Sender).Font.Color := clWhite;
end;

//Create student button - label component used as a button
procedure TfrmMainMenu.btnCreateStudentClick(Sender: TObject);
var i:Integer;
  arr:yearArr;
begin
  arr := selectyear(frmCreateStudent.qryCreateStudent, frmcreatestudent);
  frmcreatestudent.cboSelectyear.Clear;
  for i:=1 to length(arr) do
  begin
    if (arr[i]='') then
      break
    else
      frmCreateStudent.cboSelectYear.items.Add(arr[i]);
  end;
  frmCreateStudent.ShowModal;
end;


//Select student button - label component used as a button
procedure TfrmMainMenu.btnSelectStudentClick(Sender: TObject);
var i:integer;
  arr:yearArr;
begin
  FreeAndNil(frmselectstudent);
  frmSelectStudent := TfrmSelectStudent.Create(frmselectstudent);
  arr := selectyear(frmSelectStudent.qrySelectStudent, frmSelectStudent);
  changeWindowPos(frmselectstudent);
  frmSelectStudent.cboSelectyear.Clear;
  for i:=1 to length(arr) do
  begin
    if (arr[i]='') then
      break
    else
    begin
      frmSelectStudent.cboSelectYear.items.Add(arr[i]);
      frmSelectStudent.cboChangeYear.items.Add(arr[i]);
    end;
  end;

  //open form
  frmSelectStudent.ShowModal;
end;

//Create Class button - label component used as a button
procedure TfrmMainMenu.btnCreateClassClick(Sender: TObject);
begin
  //open form
  frmCreateClass.ShowModal;
end;

//Select Class button - label component used as a button
procedure TfrmMainMenu.btnSelectClassClick(Sender: TObject);
begin
  //open form
  frmSelectClass.qryUserClassData.SQL.Text := 'select ClassID, name, year from class where stfID='+inttostr(info.StaffID)+';';
  frmSelectClass.qryUserClassData.Open;
  frmSelectClass.ShowModal;
end;

//Create Report button - label component used as a button
procedure TfrmMainMenu.btnCreateReportClick(Sender: TObject);
var i:Integer;
  arr:yearArr;
begin
  FreeAndNil(frmCreateReport);
  frmCreateReport := TfrmCreateReport.Create(frmCreateReport);
  changeWindowPos(frmCreateReport);
  with frmCreateReport do
  begin
    arr := selectyear(qryCreateReport_Select, frmcreatereport);
    cboSelectyear.Clear;
    for i:=1 to length(arr) do
    begin
      if (arr[i]='') then
        break
      else
        cboSelectYear.items.Add(arr[i]);
    end;
    questionToDisplay(questionCount);
    ShowModal;
  end;
end;

//update user details button - label component used as a button
procedure TfrmMainMenu.imgSettingsClick(Sender: TObject);
begin
  //open form
  with frmUpdateSetting do
  begin
    edtfName.Text:= info.FirstName;
    edtlName.Text:= info.LastName;
    edtEmail.Text:= info.Email;
    ShowModal;
  end;
end;

procedure TfrmMainMenu.FormCreate(Sender: TObject);
var myFile : TextFile;
   text   : string;
begin
  if FileExists('Data.txt') then
  begin
    AssignFile(myFile, 'Data.txt');
    Reset(myFile);
    ReadLn(myFile, text);
    if (text <> 'Empty') then
    begin
      frmLogin.qryLogin.SQL.Text := 'SELECT staff.StfID, Login.Email, Login.Password,login.salt, staff.firstname, staff.lastname FROM Login inner join staff on (login.LgnID = staff.LgnID) where email = '+quotedstr(text)+';';
      frmLogin.qryLogin.Open;
      ReadLn(myFile, text);
      if (frmLogin.qryLogin.fieldbyname('password').AsString = text)then        //user will only have max one account
      begin
        autologin := True;
        info.FirstName:=frmLogin.qryLogin.fieldbyname('firstname').AsString;
        info.LastName:=frmLogin.qryLogin.fieldbyname('lastname').AsString;
        info.Email:=frmLogin.qryLogin.fieldbyname('email').AsString;
        info.password:=frmLogin.qryLogin.fieldbyname('password').AsString;
        info.StaffID:=frmLogin.qryLogin.fieldbyname('StfID').AsInteger;
        frmMainMenu.lblProfileName.Caption := info.Firstname+' '+info.lastname;
        frmMainMenu.Top := frmLogin.Top;
        frmMainMenu.left := frmLogin.left;
        frmmainmenu.Show;
      end;
    end;
    CloseFile(myFile);
  end;
  // Try to open the Test.txt file for writing to
   AssignFile(myFile, 'Test.txt');
   ReWrite(myFile);

  // Write a couple of well known words to this file
   WriteLn(myFile, 'Hello');
   WriteLn(myFile, 'World');

  // Close the file
   CloseFile(myFile);

end;

procedure TfrmMainMenu.tmrCloseTimer(Sender: TObject);
begin
  if (autologin) then
    frmlogin.Hide;
  tmrClose.Enabled := false;
end;

end.
