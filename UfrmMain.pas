unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, DBAccess, Uni, MemDS, Grids, DBGrids,
  Buttons,OracleUniProvider, ADODB;

type
  TfrmMain = class(TForm)
    UniConnection1: TUniConnection;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    Panel1: TPanel;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    ComboBox1: TComboBox;
    ADOConnection1: TADOConnection;
    Panel2: TPanel;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    Memo1: TMemo;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    Panel4: TPanel;
    BitBtn1: TBitBtn;
    UniQuery1: TUniQuery;
    procedure LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadGroupName(const comboBox:TcomboBox;const ASel:string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses superobject;

{$R *.dfm}

procedure RequestForm2Lis(const AAdoconnstr,ARequestJSON,CurrentWorkGroup:PChar);stdcall;external 'Request2Lis.dll';
function UnicodeToChinese(const AUnicodeStr:PChar):PChar;stdcall;external 'LYFunction.dll';
procedure WriteLog(const ALogStr: Pchar);stdcall;external 'LYFunction.dll';

const
  LIS_CONNSTR='Provider=SQLOLEDB.1;Password=Yklissa123;Persist Security Info=True;User ID=sa;Initial Catalog=YkLis;Data Source=202.96.1.105';

procedure TfrmMain.LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ObjectYZMZ:ISuperObject;
  ArrayYZMX:ISuperObject;
  ObjectJYYZ:ISuperObject;
  ArrayJYYZ:ISuperObject;
  BigObjectJYYZ:ISuperObject;

  UniQryTemp22:TUniQuery;
begin
  if key<>13 then exit;

  if trim(ComboBox1.Text)='' then
  begin
    MessageDlg('请先选择将要导入的工作组!',mtWarning,[MBOK],0);
    exit;
  end;

  UniQryTemp22:=TUniQuery.Create(nil);
  UniQryTemp22.Connection:=UniConnection1;
  UniQryTemp22.Close;
  UniQryTemp22.SQL.Clear;
  UniQryTemp22.SQL.Text:='select * from LIS_REQUEST where barcode='''+(Sender as TLabeledEdit).Text+''' ';
  UniQryTemp22.Open;

  (Sender as TLabeledEdit).Clear;
  if (Sender as TLabeledEdit).CanFocus then (Sender as TLabeledEdit).SetFocus; 

  LabeledEdit2.Text:=UniQryTemp22.fieldbyname('name').AsString;
  LabeledEdit3.Text:=UniQryTemp22.fieldbyname('sex').AsString;
  LabeledEdit4.Text:=UniQryTemp22.fieldbyname('age').AsString;
  LabeledEdit5.Text:=UniQryTemp22.fieldbyname('reqdept').AsString;
  LabeledEdit6.Text:=UniQryTemp22.fieldbyname('write_name').AsString;
  LabeledEdit7.Text:=UniQryTemp22.fieldbyname('barcode').AsString;

  Memo1.Lines.Clear;
  while not UniQryTemp22.Eof do
  begin
    Memo1.Lines.Add('HIS组合项目代码:'+UniQryTemp22.fieldbyname('order_id').AsString+'   HIS组合项目名称:'+UniQryTemp22.fieldbyname('itemname').AsString+'   体检号:'+UniQryTemp22.fieldbyname('reg_id').AsString+'   外部系统项目申请编号:'+UniQryTemp22.fieldbyname('request_no').AsString);

    ADOQuery1.Close;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Text:='select ci.Id '+
                        'from combinitem ci,HisCombItem hci '+
                        'where ci.Unid=hci.CombUnid and hci.ExtSystemId=''HIS'' '+
                        'and hci.HisItem='''+UniQryTemp22.fieldbyname('order_id').AsString+''' ';
    ADOQuery1.Open;
    ArrayYZMX:=SA([]);
    while not ADOQuery1.Eof do
    begin
      ObjectYZMZ:=SO;
      ObjectYZMZ.S['LIS组合项目代码'] := ADOQuery1.fieldbyname('Id').AsString;
      ObjectYZMZ.S['条码号'] := UniQryTemp22.fieldbyname('barcode').AsString;
      ObjectYZMZ.S['外部系统项目申请编号'] := UniQryTemp22.fieldbyname('request_no').AsString;

      ArrayYZMX.AsArray.Add(ObjectYZMZ);
      ObjectYZMZ:=nil;
      
      ADOQuery1.Next;
    end;

    ObjectJYYZ:=SO;
    ObjectJYYZ.S['患者姓名']:=UniQryTemp22.fieldbyname('name').AsString;
    if UniQryTemp22.fieldbyname('sex').AsString='1' then ObjectJYYZ.S['患者性别']:='男'
      else if UniQryTemp22.fieldbyname('sex').AsString='2' then ObjectJYYZ.S['患者性别']:='女'
        else ObjectJYYZ.S['患者性别']:='未知';
    if UniQryTemp22.fieldbyname('age_unit').AsString='Y' then ObjectJYYZ.S['患者年龄']:=UniQryTemp22.fieldbyname('age').AsString+'岁'
      else if UniQryTemp22.fieldbyname('age_unit').AsString='M' then ObjectJYYZ.S['患者年龄']:=UniQryTemp22.fieldbyname('age').AsString+'月'
        else if UniQryTemp22.fieldbyname('age_unit').AsString='D' then ObjectJYYZ.S['患者年龄']:=UniQryTemp22.fieldbyname('age').AsString+'天'
          else ObjectJYYZ.S['患者年龄']:=UniQryTemp22.fieldbyname('age').AsString+UniQryTemp22.fieldbyname('age_unit').AsString;
    ObjectJYYZ.S['申请科室']:=UniQryTemp22.fieldbyname('reqdept').AsString;
    ObjectJYYZ.S['申请医生']:=UniQryTemp22.fieldbyname('write_name').AsString;
    ObjectJYYZ.S['申请日期']:=FormatDateTime('yyyy-mm-dd hh:nn:ss',UniQryTemp22.fieldbyname('write_time').AsDateTime);
    ObjectJYYZ.S['外部系统唯一编号']:=UniQryTemp22.fieldbyname('reg_id').AsString;
    ObjectJYYZ.O['医嘱明细']:=ArrayYZMX;
    ArrayYZMX:=nil;

    ArrayJYYZ:=SA([]);
    ArrayJYYZ.AsArray.Add(ObjectJYYZ);
    ObjectJYYZ:=nil;

    BigObjectJYYZ:=SO;
    BigObjectJYYZ.S['JSON数据源']:='HIS';
    BigObjectJYYZ.O['检验医嘱']:=ArrayJYYZ;
    ArrayJYYZ:=nil;

    //WriteLog(UnicodeToChinese(PChar(AnsiString(BigObjectJYYZ.AsJson))));
    RequestForm2Lis(LIS_CONNSTR,UnicodeToChinese(PChar(AnsiString(BigObjectJYYZ.AsJson))),PChar(ComboBox1.Text));
    BigObjectJYYZ:=nil;

    UniQryTemp22.Next;
  end;
  UniQryTemp22.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  UniConnection1.ProviderName:='Oracle';
  UniConnection1.Server:='10.161.97.1:1521:orcl';
  UniConnection1.Username:='LYPEIS';
  UniConnection1.Password:='lypeis';
  UniConnection1.SpecificOptions.Values['Direct']:='True';
  UniConnection1.LoginPrompt:=false;
  UniConnection1.Connect;

  UniQuery1.Connection:=UniConnection1;

  ADOConnection1.ConnectionString:=LIS_CONNSTR;
  ADOConnection1.LoginPrompt:=false;
  ADOConnection1.Connected:=true;

  ADOQuery1.Connection:=ADOConnection1;
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
  UniQuery1.Close;
  UniQuery1.SQL.Clear;
  UniQuery1.SQL.Text:='select * from LIS_REQUEST order by reg_id';
  UniQuery1.Open;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoadGroupName(ComboBox1,'select name from CommCode where TypeName=''检验组别'' AND SysName=''LIS'' group by name');
end;

procedure TfrmMain.LoadGroupName(const comboBox: TcomboBox;
  const ASel: string);
var
  adotemp3:tadoquery;
  tempstr:string;
begin
     adotemp3:=tadoquery.Create(nil);
     adotemp3.Connection:=ADOConnection1;
     adotemp3.Close;
     adotemp3.SQL.Clear;
     adotemp3.SQL.Text:=ASel;
     adotemp3.Open;
     
     comboBox.Items.Clear;//加载前先清除comboBox项

     while not adotemp3.Eof do
     begin
      tempstr:=trim(adotemp3.Fields[0].AsString);

      comboBox.Items.Add(tempstr); //加载到comboBox

      adotemp3.Next;
     end;
     adotemp3.Free;
end;

end.
