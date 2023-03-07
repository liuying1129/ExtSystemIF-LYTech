program ExtSystemIFLYTech;

uses
  Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  superobject in 'superobject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
