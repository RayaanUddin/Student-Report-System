program GraveneyReportSystem;

uses
  Forms,
  unit_login in '..\Login\unit_login.pas' {frmLogin},
  unit_signup in '..\Signup\unit_signup.pas' {frmSignup},
  unit_menu in '..\Main Menu\unit_menu.pas' {frmMainMenu},
  unit_createClass in '..\Classgroup\Create Class\unit_createClass.pas' {frmCreateClass},
  unit_createStudent in '..\studentgroup\Create Student\unit_createStudent.pas' {frmCreateStudent},
  Unit_SelectClass in '..\Classgroup\Select Class\Unit_SelectClass.pas' {frmSelectClass},
  Unit_UpdateSetting in '..\UpdateSetting\Unit_UpdateSetting.pas' {frmUpdateSetting},
  Unit_CreateReport in '..\ReportCreate\Unit_CreateReport.pas' {frmCreateReport},
  Unit_ReportComment in '..\studentgroup\ViewReportComment\Unit_ReportComment.pas' {frmReportComment},
  Unit_ExportReport in '..\studentgroup\ExportReport\Unit_ExportReport.pas' {frmExportReport},
  SynPdf in '..\Syn\SynPdf.pas',
  mORMotReport in '..\Syn\mORMotReport.pas',
  SynCommons in '..\Syn\SynCommons.pas',
  SynCrypto in '..\Syn\SynCrypto.pas',
  SynGdiPlus in '..\Syn\SynGdiPlus.pas',
  SynLZ in '..\Syn\SynLZ.pas',
  SynTable in '..\Syn\SynTable.pas',
  SynZip in '..\Syn\SynZip.pas',
  Unit_SelectStudent in '..\studentgroup\SelectStudent\Unit_SelectStudent.pas' {frmSelectStudent};

{$R *.res}
procedure changeWindowPos(sender:Tobject);
begin
  Tform(sender).Left := (screen.Width - Tform(sender).ClientWidth) div 2;
  Tform(sender).Top := (screen.Height - Tform(sender).ClientHeight) div 2;
end;

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  changeWindowPos(frmlogin);
  Application.CreateForm(TfrmMainMenu, frmMainMenu);
  Application.CreateForm(TfrmReportComment, frmReportComment);
  Application.CreateForm(TfrmExportReport, frmExportReport);
  Application.CreateForm(TfrmSelectStudent, frmSelectStudent);
  Application.CreateForm(TfrmSignup, frmSignup);
  Application.CreateForm(TfrmCreateClass, frmCreateClass);
  Application.CreateForm(TfrmCreateStudent, frmCreateStudent);
  Application.CreateForm(TfrmSelectClass, frmSelectClass);
  Application.CreateForm(TfrmUpdateSetting, frmUpdateSetting);
  Application.CreateForm(TfrmCreateReport, frmCreateReport);
  changeWindowPos(frmReportComment);
  changeWindowPos(frmSelectClass);
  changeWindowpos(frmUpdateSetting);
  changeWindowpos(frmCreateStudent);
  changeWindowPos(frmCreateClass);
  changeWindowPos(frmCreateReport);
  Application.Run;
end.
