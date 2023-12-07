unit unit_signup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Mask, DB, ADODB, Math;

type
  TfrmSignup = class(TForm)
    chkhidepassword: TCheckBox;
    procedure chkhidepasswordClick(Sender: TObject);
  published
    logo_header: TImage;
    edtEmail: TEdit;
    edtpassword: TEdit;
    edtfName: TEdit;
    btnSignup: TLabel;
    edtlName: TEdit;
    qrySignup: TADOQuery;
    procedure btnSignupClick(Sender: TObject);
    procedure btnSignupMouseEnter(Sender: TObject);
    procedure btnSignupMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtEmailClick(Sender: TObject);
    procedure edtfNameClick(Sender: TObject);
    procedure edtlNameClick(Sender: TObject);
    procedure edtpasswordClick(Sender: TObject);
  public
    function stringisAlpha(name:string):Boolean; //used in create student and create class
    function verifyName_and_Password(fname,lname,password:string):Boolean; //used in update settings
    function IsValidEmail(email: string): boolean; //used in update settings
    function FirstLetterUppercase(temp:string):string; //used in multiple areas
    function hash(salt, mypassword:string):string; //used in login and signup
    function generatesalt(passlength:Integer):string; // used in update and signup
  end;

var
  frmSignup: TfrmSignup;

implementation

uses unit_login;

{$R *.dfm}

Function ReverseString(AText: string): string;
var
    i,j:integer;
begin
  setlength(result,length(atext));
  i:=1; j:=length(atext);
  while (i<=j) do
    begin
      result[i]:=atext[j-i+1];
      inc(i);
    end;
end;

// Generates salt for hashing
function TfrmSignup.generatesalt(passlength:Integer):string;
var i, gensalt:Integer;
  salt:string;
begin
  for i:=1 to 50-passlength do
  begin
    randomize;
    gensalt:=randomrange(32,127);
    salt:= salt + chr(gensalt);
  end;
  Result := salt;
end;

//hashes the password using a pregenerated salt
function TfrmSignup.hash(salt, mypassword:string):string;
var i, passlength, myresult, indexval, denhashedinteger:  integer;
  saltedPassword, hashedpassword, exclusivedata, revpassword,denhashedpassword: string;
  addcharacter:char;
begin
  passlength:= length(mypassword);
  saltedpassword := mypassword+ salt;
  revpassword := reversestring(mypassword);
  exclusivedata :='';
  hashedpassword:='';
  denhashedpassword :='';

  for i:=0 to 49 do
  begin
    indexval:= (i mod passlength) + 1;
    addcharacter := revpassword[indexval];
    exclusivedata := exclusivedata + addcharacter;
  end;

  for i:=1 to 50 do
  begin
    denhashedinteger:= (ord(exclusivedata[i]) XOR ord(saltedpassword[i]));
    denhashedpassword:= denhashedpassword + chr(denhashedinteger);
  end;

  for i := 1 to 50 do
  begin
    myresult:=  ord(denhashedpassword[i]);
    hashedpassword := hashedpassword + InttoHex(myresult,2);
  end;

  Result := hashedpassword;
end;

function isintinstr(search:string):Boolean;
var i,j:Integer;
  found:Boolean;
const numbers = ['0'..'9'];
begin
  for i:=1 to Length(search) do
  begin
    if (Search[i] in numbers)then
      found := True;
  end;
  isintinstr := found;
end;

function TfrmSignup.FirstLetterUppercase(temp:string):string;
begin
  temp := lowercase(temp);
  temp[1] := upcase(temp[1]);
  FirstLetterUppercase := temp;
end;

function TfrmSignup.stringisAlpha(name:string):Boolean;
const
  charslist = ['A'..'Z', 'a'..'z'];
var i:Integer;
  problem:Boolean;
begin
  problem:=false;//default value is false
  for i:=1 to Length(name) do
  begin
    if not((name[i] in charsList))then
      problem:=true;
  end;
  stringisAlpha:=not(problem);
end;

function TfrmSignup.verifyName_and_Password(fname,lname,password:string):Boolean;
var outcome:Boolean;
begin
  outcome:=false;
  if not((stringisAlpha(fname))and (stringisAlpha(lname)))then
    ShowMessage('invalid name')
  else if (Length(password) >=8) then
  begin
    if not(isintinstr(password))then
    begin
      ShowMessage('password must be greater than 8'+#13#10+'characters, and include a digit');
    end
    else
      outcome:=true;
  end
  else
  begin
      ShowMessage('password must be greater than 8'+#13#10+'characters, and include a digit');
  end;
  verifyName_and_Password := outcome;
end;


function TfrmSignup.IsValidEmail(email: string): boolean;
const
  charslist = ['_', '-', '.', '0'..'9', 'a'..'z'];
var
  FoundAt, lastpoint,valid : boolean;
  i, emailLen : integer;
  c : char;
begin
  emailLen := Length(email);
  FoundAt := false;
  lastpoint := false;
  valid := true;
  for i:=1 to emailLen do
  begin
    c := email[i];
    if c = '@' then
    begin
      if FoundAt then
        valid := false
      else
        FoundAt := true;
    end
    else if (c = '.') and foundAt then  // at least 1 . after arobasc
      lastpoint := true
    else if not(c in charslist) then  // valid chars
      valid := false;
  end;
  if not(lastpoint) or (email[emailLen] = '.')then  // no e.g .com, .. or finishes at .
    valid := false;
  IsValidEmail:=valid;
end;

function writeAccount(fname,lname,email,password:string):boolean;
var LgnID:Integer;
   salt:string;
begin
  salt:='';
  frmSignup.qrySignup.SQL.Text := 'Select LgnID from login where email='+quotedStr(email)+';';
  frmSignup.qrySignup.open;
  if (frmSignup.qrySignup.RecordCount=0)then
  begin
    frmSignup.qrySignup.close;
    salt := frmSignup.generatesalt(Length(password));
    frmSignup.qrySignup.SQL.Text := 'insert into login(email,password,salt) values ('+quotedStr(email)+','+ quotedStr(frmSignup.hash(salt,password))+', :saltpara );';
    frmSignup.qrySignup.Parameters.ParamByName('saltpara').DataType := ftString;
    frmSignup.qrySignup.Parameters.ParamByName('saltpara').value := salt;
    frmSignup.qrySignup.ExecSQL;
    frmSignup.qrySignup.SQL.Text := 'Select LgnID from login where email='+quotedStr(email)+';';
    frmSignup.qrySignup.open;
    LgnID := frmSignup.qrySignup.fieldbyname('LgnID').AsInteger;
    frmSignup.qrySignup.close;
    frmSignup.qrySignup.SQL.Text := 'insert into staff(LgnID,Firstname,Lastname) values ('+inttostr(LgnID)+','+quotedStr(fname)+','+ quotedStr(lname)+');';
    frmSignup.qrySignup.ExecSQL;
    ShowMessage('account created');
    writeAccount:=True;
  end
  else
  begin
    frmSignup.qrySignup.close;
    ShowMessage('account with email address already exists');
    writeAccount:=False;
  end;
end;

procedure TfrmSignup.btnSignupClick(Sender: TObject);
var i:integer;
  Temp:string;
begin
  if (verifyName_and_Password(edtfName.Text, edtlName.Text, edtpassword.Text))then
  begin
    if (IsValidEmail(edtEmail.Text))then
    begin
      if (writeaccount(FirstLetterUppercase(edtfName.Text), FirstLetterUppercase(edtlName.Text), edtEmail.Text, edtpassword.Text))then
      begin
        //keep same pos
        frmLogin.Top := frmSignup.Top;
        frmLogin.left := frmSignup.left;

        frmLogin.show;
        frmSignup.close;
      end;
    end
    else
      ShowMessage('invalid Email address');
  end;
end;

procedure TfrmSignup.btnSignupMouseEnter(Sender: TObject);
begin
  btnsignup.Font.Color:= RGB(119,143,143);
end;

procedure TfrmSignup.btnSignupMouseLeave(Sender: TObject);
begin
  btnSignup.Font.Color:= clWhite;
end;

procedure TfrmSignup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //keep same pos
  frmLogin.Top := frmSignup.Top;
  frmLogin.left := frmSignup.left;
  
  frmLogin.show;
end;

procedure TfrmSignup.edtEmailClick(Sender: TObject);
begin
  if (edtemail.Text = 'email')then
    edtemail.Text := '';
  if((edtpassword.Text =''))then
  begin
    edtpassword.Text := 'password';
    edtpassword.PasswordChar := #0;
  end;
  if((edtfname.Text =''))then
    edtfname.Text := 'first name';
  if((edtlname.Text =''))then
    edtlname.Text := 'last name';

end;

procedure TfrmSignup.edtfNameClick(Sender: TObject);
begin
  if (edtemail.Text = '')then
    edtemail.Text := 'email';
  if((edtpassword.Text =''))then
  begin
    edtpassword.Text := 'password';
    edtpassword.PasswordChar := #0;
  end;
  if((edtfname.Text ='first name'))then
    edtfname.Text := '';
  if((edtlname.Text =''))then
    edtlname.Text := 'last name';
end;

procedure TfrmSignup.edtlNameClick(Sender: TObject);
begin
  if (edtemail.Text = '')then
    edtemail.Text := 'email';
  if((edtpassword.Text =''))then
  begin
    edtpassword.Text := 'password';
    edtpassword.PasswordChar := #0;
  end;
  if((edtfname.Text =''))then
    edtfname.Text := 'first name';
  if((edtlname.Text ='last name'))then
    edtlname.Text := '';
end;

procedure TfrmSignup.edtpasswordClick(Sender: TObject);
begin
  if (edtemail.Text = '')then
    edtemail.Text := 'email';
  if((edtpassword.Text ='password'))then
  begin
    edtpassword.Text := '';
    if (chkhidepassword.Checked)then
      edtpassword.PasswordChar := '*';
  end;
  if((edtfname.Text =''))then
    edtfname.Text := 'first name';
  if((edtlname.Text =''))then
    edtlname.Text := 'last name';
end;

procedure TfrmSignup.chkhidepasswordClick(Sender: TObject);
begin
  if (chkhidepassword.Checked) and (edtpassword.Text <> 'password')then
    edtpassword.PasswordChar := '*';
end;

end.
