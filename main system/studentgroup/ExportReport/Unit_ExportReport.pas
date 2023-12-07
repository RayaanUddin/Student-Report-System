unit Unit_ExportReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, FileCtrl, synPdf, unit_login;

type
  TfrmExportReport = class(TForm)
  published
    dirlstSave: TDirectoryListBox;
    lblLocation: TLabel;
    drvcbbSave: TDriveComboBox;
    lbledtFileName: TLabeledEdit;
    save: TButton;
    procedure saveClick(Sender: TObject);
end;
var
  frmExportReport: TfrmExportReport;

implementation

uses Unit_ReportComment;

{$R *.dfm}

procedure TfrmExportReport.saveClick(Sender: TObject);
  var pdf:TPdfDocumentGDI;
      page:TpdfPage;
      i:integer;
begin
  //create PDF with auther being the system
  pdf:=TpdfdocumentGDI.create();
  pdf.info.author:='GraveneyReportSystem';
  page:=pdf.addpage;
  page.PageLandscape := true; //make page landscape

  //Create a horizontal line from 80px below page
  pdf.VCLCanvas.MoveTo(0,80);
  pdf.VCLCanvas.LineTo(pdf.VCLCanvassize.cx,80);

  //IN HEADING...
  //..write Graveney school in the middle
  pdf.vclcanvas.font.Size := 45;
  pdf.VCLCanvas.TextOut((pdf.VCLCanvassize.cx - pdf.VCLCanvas.TextWidth('Graveney School'))div 2,5,'Graveney School');

  //..write Student Name on Left
  pdf.vclcanvas.font.Size := 20;
  pdf.VCLCanvas.TextOut(5,10 ,'student: '+frmReportComment.studentName);
  pdf.VCLCanvas.TextOut(5,45 ,'Class: '+frmReportComment.classNameYr);

  //..write report info
  pdf.vclcanvas.font.Size := 15;
  pdf.VCLCanvas.TextOut(pdf.VCLCanvassize.cx - (pdf.VCLCanvas.TextWidth('Attendance: ') + 50),5 ,'Attendance: '+frmReportComment.attendance);
  pdf.VCLCanvas.TextOut(pdf.VCLCanvassize.cx - (pdf.VCLCanvas.TextWidth('Attendance: ') + 50),30 ,'Punctuality: '+frmReportComment.punctuality);
  pdf.VCLCanvas.TextOut(pdf.VCLCanvassize.cx - (pdf.VCLCanvas.TextWidth('Attendance: ') + 50),55 ,'Grade: '+frmReportComment.grade);

  //Below heading...
  //..write subject and teacher name
  pdf.VCLCanvas.Font.Size := 30;
  pdf.VCLCanvas.TextOut(15,100 ,frmReportComment.subject+': '+info.firstname+ ' '+info.lastName);

  //..write Report Comment
  pdf.vclcanvas.font.Size := 15;
  for i:=1 to frmreportcomment.memoreportcomment.Lines.Count do
  begin
     pdf.VCLCanvas.TextOut(25,140+i*20 ,frmreportcomment.memoreportcomment.Lines.Strings[i-1]);
  end;

  //..write Date on bottom
  pdf.VCLCanvas.Font.Size := 20;
  pdf.VCLCanvas.TextOut(pdf.VCLCanvasSize.cx - (pdf.VCLCanvas.TextWidth('DD/MM/YYYY')+10) , pdf.VCLCanvasSize.cy - 30, frmReportComment.dateCreated);

  //save the file
  pdf.SaveToFile(dirlstSave.DirLabel.caption + lbledtFileName.text+'.pdf'); //stores file in the location select by the user using dirlstsave
  showmessage('saved'); //lets the user know if the file has been saved
  pdf.Free;
  frmExportReport.Close;
end;

end.
