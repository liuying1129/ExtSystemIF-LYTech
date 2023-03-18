unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, DBAccess, Uni, MemDS, Grids, DBGrids,
  Buttons,OracleUniProvider, ADODB,IniFiles,StrUtils, VirtualTable;

type
  TfrmMain = class(TForm)
    UniConnection1: TUniConnection;
    Panel1: TPanel;
    LabeledEdit1: TLabeledEdit;
    ADOConnection1: TADOConnection;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    DataSource1: TDataSource;
    VirtualTable1: TVirtualTable;
    Panel3: TPanel;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    Edit2: TEdit;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label3: TLabel;
    procedure LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure VirtualTable1AfterOpen(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure VirtualTable1AfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    procedure LoadGroupName(const comboBox:TcomboBox;const ASel:string);
    function MakeAdoDBConn:boolean;
    function MakeUniDBConn:boolean;
    procedure SingleRequestForm2Lis(const WorkGroup,His_Unid,patientname,sex,age,age_unit,deptname,check_doctor,RequestDate:String;const ABarcode,Surem1,checkid,SampleType,pkcombin_id:String);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses superobject, UfrmRequestInfo;

{$R *.dfm}

procedure RequestForm2Lis(const AAdoconnstr,ARequestJSON,CurrentWorkGroup:PChar);stdcall;external 'Request2Lis.dll';
function UnicodeToChinese(const AUnicodeStr:PChar):PChar;stdcall;external 'LYFunction.dll';
procedure WriteLog(const ALogStr: Pchar);stdcall;external 'LYFunction.dll';
function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//����
function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';

const
  CryptStr='lc';

  SELECT_LIS_COMBIN_ITEM='select ci.Id,ci.Name,ci.dept_DfValue '+
                          'from combinitem ci,HisCombItem hci '+
                          'where ci.Unid=hci.CombUnid and hci.ExtSystemId=''HIS'' '+
                          'and hci.HisItem=:HisItem';

procedure TfrmMain.LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  UniQryTemp22:TUniQuery;
  ADOTemp22:TADOQuery;

  iLJH:Integer;
  i:Integer;

  VTTemp:TVirtualTable;
begin
  if key<>13 then exit;

  if trim((Sender as TLabeledEdit).Text)='' then exit;

  (Sender as TLabeledEdit).Enabled:=false;//Ϊ�˷�ֹû��������ɨ����һ������

  UniQryTemp22:=TUniQuery.Create(nil);
  UniQryTemp22.Connection:=UniConnection1;
  UniQryTemp22.Close;
  UniQryTemp22.SQL.Clear;
  UniQryTemp22.SQL.Text:='select * from LIS_REQUEST where barcode='''+(Sender as TLabeledEdit).Text+''' ';
  UniQryTemp22.Open;

  (Sender as TLabeledEdit).Clear;

  LabeledEdit2.Text:=UniQryTemp22.fieldbyname('name').AsString;
  LabeledEdit3.Text:=UniQryTemp22.fieldbyname('sex').AsString;
  LabeledEdit4.Text:=UniQryTemp22.fieldbyname('age').AsString;
  Edit2.Text:=UniQryTemp22.fieldbyname('age_unit').AsString;
  LabeledEdit5.Text:=UniQryTemp22.fieldbyname('reqdept').AsString;
  LabeledEdit6.Text:=UniQryTemp22.fieldbyname('write_name').AsString;
  LabeledEdit7.Text:=UniQryTemp22.fieldbyname('barcode').AsString;
  LabeledEdit8.Text:=FormatDateTime('yyyy-mm-dd hh:nn:ss',UniQryTemp22.fieldbyname('write_time').AsDateTime);
  LabeledEdit11.Text:=UniQryTemp22.fieldbyname('REG_ID').AsString;

  for i:=0 to (DBGrid1.columns.count-1) do DBGrid1.columns[i].readonly:=False;
  VirtualTable1.Clear;

  while not UniQryTemp22.Eof do
  begin
    ADOTemp22:=TADOQuery.Create(nil);
    ADOTemp22.Connection:=ADOConnection1;
    ADOTemp22.Close;
    ADOTemp22.SQL.Clear;
    ADOTemp22.SQL.Text:=SELECT_LIS_COMBIN_ITEM;
    ADOTemp22.Parameters.ParamByName('HisItem').Value:=UniQryTemp22.fieldbyname('order_id').AsString;
    ADOTemp22.Open;
    while not ADOTemp22.Eof do
    begin
      VirtualTable1.Append;
      VirtualTable1.FieldByName('�ⲿϵͳ��Ŀ������').AsString:=UniQryTemp22.FieldByName('REQUEST_NO').AsString;
      VirtualTable1.FieldByName('HIS��Ŀ����').AsString:=UniQryTemp22.FieldByName('order_id').AsString;
      VirtualTable1.FieldByName('HIS��Ŀ����').AsString:=UniQryTemp22.FieldByName('ITEMNAME').AsString;
      VirtualTable1.FieldByName('LIS��Ŀ����').AsString:=ADOTemp22.FieldByName('Id').AsString;
      VirtualTable1.FieldByName('LIS��Ŀ����').AsString:=ADOTemp22.FieldByName('Name').AsString;
      VirtualTable1.FieldByName('��������').AsString:=UniQryTemp22.FieldByName('SPEC_TYPE').AsString;
      VirtualTable1.FieldByName('������').AsString:=ADOTemp22.FieldByName('dept_DfValue').AsString;
      VirtualTable1.FieldByName('������ĸ').AsString:=ComboBox2.Text;
      VirtualTable1.FieldByName('������').AsString:=Edit1.Text;
      VirtualTable1.Post;

      ADOTemp22.Next;
    end;
    ADOTemp22.Free;

    UniQryTemp22.Next;
  end;
  UniQryTemp22.Free;

  DBGrid1.columns[0].readonly:=True;
  DBGrid1.columns[1].readonly:=True;
  DBGrid1.columns[2].readonly:=True;
  DBGrid1.columns[3].readonly:=True;
  DBGrid1.columns[4].readonly:=True;
  DBGrid1.columns[5].readonly:=True;
  DBGrid1.columns[6].readonly:=True;

  BitBtn1.Enabled:=VirtualTable1.Active and(VirtualTable1.RecordCount>1)and(trim(VirtualTable1.fieldbyname('������ĸ').AsString)<>'')and(trim(VirtualTable1.fieldbyname('������').AsString)<>'');

  if (trim(VirtualTable1.fieldbyname('������ĸ').AsString)='')
   or(trim(VirtualTable1.fieldbyname('������').AsString)='')
   or(VirtualTable1.RecordCount=1)then
  begin
    VTTemp:=TVirtualTable.Create(nil);
    VTTemp.Assign(VirtualTable1);//clone���ݼ�
    VTTemp.Open;
    while not VTTemp.Eof do
    begin
      SingleRequestForm2Lis(
        VTTemp.fieldbyname('������').AsString,
        LabeledEdit11.Text,
        LabeledEdit2.Text,
        LabeledEdit3.Text,
        LabeledEdit4.Text,
        Edit2.Text,
        LabeledEdit5.Text,
        LabeledEdit6.Text,
        LabeledEdit8.Text,
        LabeledEdit7.Text,
        VTTemp.fieldbyname('�ⲿϵͳ��Ŀ������').AsString,
        VTTemp.fieldbyname('������ĸ').AsString+VTTemp.fieldbyname('������').AsString,
        VTTemp.fieldbyname('��������').AsString,
        VTTemp.fieldbyname('LIS��Ŀ����').AsString
      );

      VTTemp.Next;
    end;
    VTTemp.Close;
    VTTemp.Free;
  end;

  if TryStrToInt(Edit1.Text,iLJH) then Edit1.Text:=RightStr('0000'+IntToStr(iLJH+1),4);

  (Sender as TLabeledEdit).Enabled:=true;
  if (Sender as TLabeledEdit).CanFocus then (Sender as TLabeledEdit).SetFocus;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MakeUniDBConn;
  MakeAdoDBConn;
  
  SetWindowLong(Edit1.Handle, GWL_STYLE, GetWindowLong(Edit1.Handle, GWL_STYLE) or ES_NUMBER);//ֻ����������
  
  //���������VirtualTable�ֶ�
  VirtualTable1.IndexFieldNames:='������';//������������
  VirtualTable1.Open;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoadGroupName(ComboBox2,'SELECT COMMWORD FROM clinicchkitem WHERE ISNULL(COMMWORD,'''')<>'''' GROUP BY COMMWORD');
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
     
     comboBox.Items.Clear;//����ǰ�����comboBox��

     while not adotemp3.Eof do
     begin
      tempstr:=trim(adotemp3.Fields[0].AsString);

      comboBox.Items.Add(tempstr); //���ص�comboBox

      adotemp3.Next;
     end;
     adotemp3.Free;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  frmRequestInfo.ShowModal;
end;

function TfrmMain.MakeAdoDBConn: boolean;
var
  newconnstr,ss: string;
  Ini: tinifile;
  userid, password, datasource, initialcatalog: string;{, provider}
  ifIntegrated:boolean;//�Ƿ񼯳ɵ�¼ģʽ

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  datasource := Ini.ReadString('����LIS���ݿ�', '������', '');
  initialcatalog := Ini.ReadString('����LIS���ݿ�', '���ݿ�', '');
  ifIntegrated:=ini.ReadBool('����LIS���ݿ�','���ɵ�¼ģʽ',false);
  userid := Ini.ReadString('����LIS���ݿ�', '�û�', '');
  password := Ini.ReadString('����LIS���ݿ�', '����', '107DFC967CDCFAAF');
  Ini.Free;
  //======����password
  pInStr:=pchar(password);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(password,length(pDeStr));
  for i :=1  to length(pDeStr) do password[i]:=pDeStr[i-1];
  //==========

  newconnstr :='';
  newconnstr := newconnstr + 'user id=' + UserID + ';';
  newconnstr := newconnstr + 'password=' + Password + ';';
  newconnstr := newconnstr + 'data source=' + datasource + ';';
  newconnstr := newconnstr + 'Initial Catalog=' + initialcatalog + ';';
  newconnstr := newconnstr + 'provider=' + 'SQLOLEDB.1' + ';';
  //Persist Security Info,��ʾADO�����ݿ����ӳɹ����Ƿ񱣴�������Ϣ
  //ADOȱʡΪTrue,ADO.netȱʡΪFalse
  //�����лᴫADOConnection��Ϣ��TADOLYQuery,������ΪTrue
  newconnstr := newconnstr + 'Persist Security Info=True;';
  if ifIntegrated then
    newconnstr := newconnstr + 'Integrated Security=SSPI;';
  try
    ADOConnection1.Connected := false;
    ADOConnection1.ConnectionString := newconnstr;
    ADOConnection1.Connected := true;
    result:=true;
  except
  end;
  if not result then
  begin
    ss:='������'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '���ݿ�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '���ɵ�¼ģʽ'+#2+'CheckListBox'+#2+#2+'0'+#2+'���ø�ģʽ,���û�������������д'+#2+#3+
        '�û�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '����'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('����LIS���ݿ�','����LIS���ݿ�',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

function TfrmMain.MakeUniDBConn: boolean;
var
  ss: string;
  Ini: tinifile;
  userid, password, datasource, provider: string;

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  provider := Ini.ReadString('����HIS���ݿ�', '�����ṩ��', '');
  datasource := Ini.ReadString('����HIS���ݿ�', '������', '');
  userid := Ini.ReadString('����HIS���ݿ�', '�û�', '');
  password := Ini.ReadString('����HIS���ݿ�', '����', '107DFC967CDCFAAF');
  Ini.Free;
  //======����password
  pInStr:=pchar(password);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(password,length(pDeStr));
  for i :=1  to length(pDeStr) do password[i]:=pDeStr[i-1];
  //==========

  try
    UniConnection1.Connected := false;
    UniConnection1.ProviderName:=provider;
    UniConnection1.Server:=datasource;//'10.161.97.1:1521:orcl';
    UniConnection1.Username:=userid;
    UniConnection1.Password:=password;
    UniConnection1.SpecificOptions.Values['Direct']:='True';
    UniConnection1.LoginPrompt:=false;
    UniConnection1.Connect;
    result:=true;
  except
  end;
  if not result then
  begin
    ss:='�����ṩ��'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '������'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '�û�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '����'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('����HIS���ݿ�','����HIS���ݿ�',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

procedure TfrmMain.VirtualTable1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
   
  DBGrid1.Columns[0].Width:=30;//�ⲿϵͳ��Ŀ������
  DBGrid1.Columns[1].Width:=77;//HIS��Ŀ����
  DBGrid1.Columns[2].Width:=100;//HIS��Ŀ����
  DBGrid1.Columns[3].Width:=77;//LIS��Ŀ����
  DBGrid1.Columns[4].Width:=100;//LIS��Ŀ����
  DBGrid1.Columns[5].Width:=57;//��������
  DBGrid1.Columns[6].Width:=80;//������
  DBGrid1.Columns[7].Width:=55;//������ĸ
  DBGrid1.Columns[8].Width:=42;//������
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  VTTemp:TVirtualTable;
begin
  if not VirtualTable1.Active then exit;
  if VirtualTable1.RecordCount<=0 then exit;

  LabeledEdit1.Enabled:=false;//Ϊ�˷�ֹû��������ɨ����һ������
  (Sender as TBitBtn).Enabled:=false;//Ϊ�˷�ֹû�������ֵ������

  VTTemp:=TVirtualTable.Create(nil);
  VTTemp.Assign(VirtualTable1);//clone���ݼ�
  VTTemp.Open;
  while not VTTemp.Eof do
  begin
    SingleRequestForm2Lis(
      VTTemp.fieldbyname('������').AsString,
      LabeledEdit11.Text,
      LabeledEdit2.Text,
      LabeledEdit3.Text,
      LabeledEdit4.Text,
      Edit2.Text,
      LabeledEdit5.Text,
      LabeledEdit6.Text,
      LabeledEdit8.Text,
      LabeledEdit7.Text,
      VTTemp.fieldbyname('�ⲿϵͳ��Ŀ������').AsString,
      VTTemp.fieldbyname('������ĸ').AsString+VTTemp.fieldbyname('������').AsString,
      VTTemp.fieldbyname('��������').AsString,
      VTTemp.fieldbyname('LIS��Ŀ����').AsString
    );

    VTTemp.Next;
  end;
  VTTemp.Close;
  VTTemp.Free;

  LabeledEdit1.Enabled:=true;
  if LabeledEdit1.CanFocus then LabeledEdit1.SetFocus; 
  (Sender as TBitBtn).Enabled:=true;
end;

procedure TfrmMain.SingleRequestForm2Lis(const WorkGroup, His_Unid, patientname, sex,
  age, age_unit, deptname, check_doctor, RequestDate, ABarcode, Surem1,
  checkid, SampleType, pkcombin_id: String);
var
  ObjectYZMZ:ISuperObject;
  ArrayYZMX:ISuperObject;
  ObjectJYYZ:ISuperObject;
  ArrayJYYZ:ISuperObject;
  BigObjectJYYZ:ISuperObject;
begin
  if trim(WorkGroup)='' then exit;
  if trim(pkcombin_id)='' then exit;

  ArrayYZMX:=SA([]);

  ObjectYZMZ:=SO;
  ObjectYZMZ.S['������'] := checkid;
  ObjectYZMZ.S['LIS�����Ŀ����'] := pkcombin_id;
  ObjectYZMZ.S['�����'] := ABarcode;
  ObjectYZMZ.S['�ⲿϵͳ��Ŀ������'] := Surem1;
  ObjectYZMZ.S['��������'] := SampleType;

  ArrayYZMX.AsArray.Add(ObjectYZMZ);
  ObjectYZMZ:=nil;

  ObjectJYYZ:=SO;
  ObjectJYYZ.S['��������']:=patientname;
  if sex='1' then ObjectJYYZ.S['�����Ա�']:='��'
    else if sex='2' then ObjectJYYZ.S['�����Ա�']:='Ů'
      else ObjectJYYZ.S['�����Ա�']:='δ֪';
  if age_unit='Y' then ObjectJYYZ.S['��������']:=age+'��'
    else if age_unit='M' then ObjectJYYZ.S['��������']:=age+'��'
      else if age_unit='D' then ObjectJYYZ.S['��������']:=age+'��'
        else ObjectJYYZ.S['��������']:=age+age_unit;
  ObjectJYYZ.S['�������']:=deptname;
  ObjectJYYZ.S['����ҽ��']:=check_doctor;
  ObjectJYYZ.S['��������']:=RequestDate;
  ObjectJYYZ.S['�ⲿϵͳΨһ���']:=His_Unid;
  ObjectJYYZ.O['ҽ����ϸ']:=ArrayYZMX;
  ArrayYZMX:=nil;

  ArrayJYYZ:=SA([]);
  ArrayJYYZ.AsArray.Add(ObjectJYYZ);
  ObjectJYYZ:=nil;

  BigObjectJYYZ:=SO;
  BigObjectJYYZ.S['JSON����Դ']:='HIS';
  BigObjectJYYZ.O['����ҽ��']:=ArrayJYYZ;
  ArrayJYYZ:=nil;

  RequestForm2Lis(PChar(AnsiString(ADOConnection1.ConnectionString)),UnicodeToChinese(PChar(AnsiString(BigObjectJYYZ.AsJson))),'');
  BigObjectJYYZ:=nil;
end;

procedure TfrmMain.VirtualTable1AfterScroll(DataSet: TDataSet);
var
  adotemp11:tadoquery;
begin
  //������ĸ������
  if not DataSet.Active then exit;
  if DataSet.RecordCount<=0 then exit;

  dbgrid1.Columns[7].PickList.Clear;
  dbgrid1.Columns[7].DropDownRows:=26;

  adotemp11:=tadoquery.Create(nil);
  adotemp11.Connection:=ADOConnection1;
  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:='SELECT COMMWORD FROM clinicchkitem WHERE ISNULL(COMMWORD,'''')<>'''' GROUP BY COMMWORD';
  adotemp11.Open;
  while not adotemp11.Eof do
  begin
    dbgrid1.Columns[7].PickList.add(adotemp11.fieldbyname('COMMWORD').AsString);
    adotemp11.Next;
  end;
  adotemp11.Free;
end;

end.
