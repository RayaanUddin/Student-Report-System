unit unit_createClass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, ADODB, unit_login, unit_signup;

type
  TfrmCreateClass = class(TForm)
  published
    lbledtFormclassName: TLabeledEdit;
    cboSelectYear: TComboBox;
    btnCreateClass: TButton;
    qryCreateClass: TADOQuery;
    lblYear: TLabel;
    procedure btnCreateClassClick(Sender: TObject);
  public
    function classExists(formclassName:string; year:Integer):boolean; //used in select class
    function verifyClassName(formclassName:string; year:Integer):boolean; //used in select class
  end;

var
  frmCreateClass: TfrmCreateClass;

implementation

{$R *.dfm}

function TfrmCreateClass.ClassExists(formclassName:string; year:Integer):boolean;
var res:Boolean;
begin
  frmcreateclass.qrycreateclass.SQL.Text := 'Select classID from class where name='+quotedStr(formclassName)+' and stfID='+inttostr(info.staffID)+' and year='+inttostr(year)+';';
  frmCreateClass.qryCreateClass.Open;
  if (frmCreateClass.qryCreateClass.RecordCount>0)then
    res:=True
  else
    res:=false;
  frmCreateClass.qryCreateClass.close;
  ClassExists := res;
end;

function TfrmCreateClass.verifyClassName(formclassName:string; year:Integer):boolean;
var res:Boolean;
begin
  res:= false;
  if (((Length(formclassName)=1) and (year>=7) and (year<=11))or((Length(formclassName)=3) and ((year=12) or (year=13))))then
  begin
    if (frmSignup.stringisAlpha(formclassName))then
      res:=True;
  end;
  verifyClassName := res;
end;

procedure writeclass(name:string;year,staffID:Integer);
begin
  frmcreateclass.qrycreateclass.SQL.Text := 'Insert into class(name, year,StfID) values('+quotedStr(name)+','+inttostr(year)+','+inttostr(staffID)+');';
  frmCreateClass.qryCreateClass.ExecSQL;
  ShowMessage('class created');
end;

procedure TfrmCreateClass.btnCreateClassClick(Sender: TObject);
  var alreadyExists, classNameVerified:Boolean;
    className:string;
    year:Integer;
begin
  className:= lbledtFormclassName.Text;
  year:= cboSelectYear.ItemIndex + 7;
  alreadyExists:= ClassExists(className, year);
  classNameVerified:= True; //verifyClassName(className,year);
  // This was updated, no class verification is needed by user, they dont like it (Mx Coad)
  if (cboSelectYear.ItemIndex = -1)or(className='')then
    ShowMessage('Fill in the values to create class...')
  else if(classNameVerified)then
  begin
    if (alreadyExists)then
      ShowMessage('class exists...')
    else
      writeClass(className,year,info.staffID);
  end
  else
    ShowMessage('Invalid class name');//invalid when doesnt follow graveney class rules

end;

end.
