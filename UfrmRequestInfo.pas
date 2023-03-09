unit UfrmRequestInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, Grids, DBGrids, MemDS,
  DBAccess, Uni, ComCtrls;

type
  TfrmRequestInfo = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    UniQuery1: TUniQuery;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UniQuery1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
function  frmRequestInfo: TfrmRequestInfo;

implementation

uses UfrmMain;

var
  ffrmRequestInfo: TfrmRequestInfo;
  
{$R *.dfm}

function  frmRequestInfo: TfrmRequestInfo;
begin
  if ffrmRequestInfo=nil then ffrmRequestInfo:=TfrmRequestInfo.Create(application.mainform);
  result:=ffrmRequestInfo;
end;

procedure TfrmRequestInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmRequestInfo=self then ffrmRequestInfo:=nil;
end;

procedure TfrmRequestInfo.BitBtn1Click(Sender: TObject);
var
  ssName,ssBarcode:String;
begin
  ssName:='';
  ssBarcode:='';
  
  if trim(LabeledEdit1.Text)<>'' then ssName:=' and name='''+LabeledEdit1.Text+''' ';
  if trim(LabeledEdit2.Text)<>'' then ssBarcode:=' and barcode='''+LabeledEdit2.Text+''' ';

  UniQuery1.Close;
  UniQuery1.SQL.Clear;
  UniQuery1.SQL.Text:='select * from LIS_REQUEST where write_time between :DateTimePicker1 and :DateTimePicker2'+ssName+ssBarcode;
  UniQuery1.ParamByName('DateTimePicker1').Value:=DateTimePicker1.DateTime;
  UniQuery1.ParamByName('DateTimePicker2').Value:=DateTimePicker2.DateTime;
  UniQuery1.Open;
end;

procedure TfrmRequestInfo.FormShow(Sender: TObject);
begin
  UniQuery1.Connection:=frmMain.UniConnection1;
  
  DateTimePicker1.Date:=Date;
  DateTimePicker2.Date:=Date;
end;

procedure TfrmRequestInfo.UniQuery1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
  
  dbgrid1.Columns[0].Width:=60;
  dbgrid1.Columns[1].Width:=42;//ÐÕÃû
  dbgrid1.Columns[2].Width:=30;
  dbgrid1.Columns[3].Width:=30;
  dbgrid1.Columns[4].Width:=30;
  dbgrid1.Columns[5].Width:=72;
  dbgrid1.Columns[6].Width:=72;
  dbgrid1.Columns[7].Width:=60;
  dbgrid1.Columns[8].Width:=40;
  dbgrid1.Columns[9].Width:=42;
  dbgrid1.Columns[10].Width:=80;
  dbgrid1.Columns[11].Width:=80;
  dbgrid1.Columns[12].Width:=80;
  dbgrid1.Columns[13].Width:=80;
  dbgrid1.Columns[14].Width:=80;
end;

initialization
  ffrmRequestInfo:=nil;

end.
