unit unit_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, DB, ADODB, unit_signup, shellAPI;

type

  TfrmLogin = class(TForm)
    chkSaveLoginDetails: TCheckBox;
  published
    logo_header: TImage;
    edtEmail: TEdit;
    edtpassword: TEdit;
    con_database: TADOConnection;
    qryLogin: TADOQuery;
    lblerror: TLabel;
    lblsignUP: TLabel;
    btnLogin: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnLoginMouseLeave(Sender: TObject);
    procedure btnLoginMouseEnter(Sender: TObject);
    procedure lblcloseClick(Sender: TObject);
    procedure lblsignUPClick(Sender: TObject);
    procedure edtpasswordClick(Sender: TObject);
    procedure edtEmailClick(Sender: TObject);
  end;
type TUserData = record
    FirstName,LastName,Email,Password:string;
    StaffID:Integer;
  end;
var
  frmLogin: TfrmLogin;
  info:TUserData;

implementation

uses unit_menu;

{$R *.dfm}

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  lblerror.caption:='';
  con_database.Connected := True;
end;

procedure databaseLogin;
var hashedpassword, salt:string;
   myFile : TextFile;
   text   : string;
begin
  frmLogin.qryLogin.SQL.Text := 'SELECT staff.StfID, Login.Email, Login.Password,login.salt, staff.firstname, staff.lastname FROM Login inner join staff on (login.LgnID = staff.LgnID) where email = '+quotedstr(frmLogin.edtemail.text)+';';
  frmLogin.qryLogin.Open;
  if (frmLogin.qryLogin.RecordCount=0)then
  begin
    frmLogin.lblerror.caption:='Email not found';
    frmLogin.lblerror.Visible := True;
  end
  else
  begin
    salt := frmLogin.qryLogin.fieldbyname('salt').AsString;
    hashedpassword := frmSignup.hash(salt, frmLogin.edtpassword.Text);
    if (frmLogin.qryLogin.fieldbyname('password').AsString = hashedpassword)then        //user will only have max one account
    begin
      if (frmLogin.chkSaveLoginDetails.Checked) then
      begin
        AssignFile(myFile, 'Data.txt');
        ReWrite(myFile);
        WriteLn(myFile, frmLogin.edtemail.text);
        WriteLn(myFile, frmLogin.qryLogin.fieldbyname('password').AsString);
        CloseFile(myFile);
      end;
      info.FirstName:=frmLogin.qryLogin.fieldbyname('firstname').AsString;
      info.LastName:=frmLogin.qryLogin.fieldbyname('lastname').AsString;
      info.Email:=frmLogin.qryLogin.fieldbyname('email').AsString;
      info.password:=frmLogin.qryLogin.fieldbyname('password').AsString;
      info.StaffID:=frmLogin.qryLogin.fieldbyname('StfID').AsInteger;
      frmMainMenu.lblProfileName.Caption := info.Firstname+' '+info.lastname;
      frmMainMenu.Top := frmLogin.Top;
      frmMainMenu.left := frmLogin.left;
      frmmainmenu.Show;
      frmlogin.Hide;
    end
    else
    begin
      frmLogin.lblerror.Caption:='incorrect password';
      frmLogin.lblerror.Visible := True;
      frmLogin.edtpassword.Text := 'password';
      frmLogin.edtpassword.PasswordChar := #0;
    end;
  end;
  frmLogin.qryLogin.close;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if not((edtEmail.Text = '')or (edtpassword.Text = '')or(edtEmail.Text = 'email')or (edtpassword.Text = 'password')) then
    databaseLogin
  else
    ShowMessage('complete the form...');
end;

procedure TfrmLogin.lblcloseClick(Sender: TObject);
begin
  frmLogin.Close;
end;

procedure TfrmLogin.lblsignUPClick(Sender: TObject);
begin
  //keep same pos
  frmSignup.Top := frmLogin.Top;
  frmSignup.left := frmLogin.left;

  frmSignup.Show;
  frmLogin.Hide;
end;

//making email and password text dissapper
procedure TfrmLogin.edtpasswordClick(Sender: TObject);
begin
  if ((edtpassword.Text = 'password')and(edtpassword.passwordchar=#0))then
  begin
    edtpassword.Text := '';
    edtpassword.PasswordChar := '*';
  end
  else
    edtpassword.PasswordChar := '*';
  if((edtemail.Text =''))then
    edtemail.Text := 'email';
end;


procedure TfrmLogin.edtEmailClick(Sender: TObject);
begin
  if (edtemail.Text = 'email')then
    edtemail.Text := '';
  if((edtpassword.Text =''))then
  begin
    edtpassword.Text := 'password';
    edtpassword.PasswordChar := #0;
  end;
end;

// changing color of btnLogin to indicate that the mouse is ontop
procedure TfrmLogin.btnLoginMouseLeave(Sender: TObject);
begin
  btnLogin.Font.Color:= clWhite;
end;

procedure TfrmLogin.btnLoginMouseEnter(Sender: TObject);
var max:Integer;
begin
  btnLogin.Font.Color:= RGB(119,143,143);
end;

end.

