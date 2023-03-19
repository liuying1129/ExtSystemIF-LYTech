unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, DBAccess, Uni, MemDS, Grids, DBGrids,
  Buttons,OracleUniProvider, ADODB,IniFiles,StrUtils, VirtualTable,
  ActnList, DosMove;

type
  TfrmMain = class(TForm)
    UniConnection1: TUniConnection;
    Panel1: TPanel;
    LabeledEdit1: TLabeledEdit;
    ADOConnection1: TADOConnection;
    SpeedButton1: TSpeedButton;
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
    ActionList1: TActionList;
    Action1: TAction;
    CheckBox1: TCheckBox;
    DosMove1: TDosMove;
    procedure LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure VirtualTable1AfterOpen(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
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
function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//解密
function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';

const
  CryptStr='lc';

function GetNextValue(CurValue: string): string;//与LIS主程序的同名函数一样
VAR
  iCurValue,i:INTEGER;
  rCurValue,sCurValue:STRING;
begin
    RESULT:='';
    for i :=length(CurValue) downto 1 do
    begin
      if not(CurValue[i] in ['0'..'9']) then
      begin
        if i=length(CurValue) then //最后一个字符为非数字
        begin
          exit;
        end;
        iCurValue:=strtoint(copy(CurValue,i+1,length(CurValue)-i));
        inc(iCurValue);
        rCurValue:=Format('%.'+inttostr(length(CurValue)-i)+'d', [iCurValue]);//iMaxFieldValue
        sCurValue:=copy(CurValue,1,i);
        result:=sCurValue + rCurValue;
        exit;
      end else
      begin
        if i=1 then //全部为数字的情况
        begin
          iCurValue:=strtoint(CurValue);
          inc(iCurValue);
          rCurValue:=Format('%.'+inttostr(length(CurValue))+'d', [iCurValue]);//iMaxFieldValue
          result:= rCurValue;
          exit;
        end;
      end;
    end;
end;

function GetFirstValue(CurValue: string): string;//与LIS主程序的同名函数一样
VAR
  rCurValue,sCurValue:STRING;
  i:integer;
begin
    RESULT:='';
    for i :=length(CurValue) downto 1 do
    begin
      if not(CurValue[i] in ['0'..'9']) then
      begin
        if i=length(CurValue) then //最后一个字符为非数字
        begin
          exit;
        end;
        rCurValue:=Format('%.'+inttostr(length(CurValue)-i)+'d', [1]);//iMaxFieldValue
        sCurValue:=copy(CurValue,1,i);
        result:=sCurValue + rCurValue;
        exit;
      end else
      begin
        if i=1 then //全部为数字的情况
        begin
          rCurValue:=Format('%.'+inttostr(length(CurValue))+'d', [1]);//iMaxFieldValue
          result:= rCurValue;
          exit;
        end;
      end;
    end;
end;
  
function GetMaxCheckId(const ACombin_ID:string;const AServerDate:tdate):string;//与LIS主程序的同名函数一样
var
  ini:tinifile;
  CheckDate,CheckId:string;
  sList:TStrings;
  i:integer;
begin
  result:='';
  
  if trim(ACombin_ID)='' then exit;

  ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  CheckDate:=ini.ReadString(ACombin_ID,'检查日期','');
  CheckId:=ini.ReadString(ACombin_ID,'联机号','');
  ini.Free;
  CheckId:=StringReplace(CheckId,'，',',',[rfReplaceAll,rfIgnoreCase]);
  sList:=TStringList.Create;
  ExtractStrings([','],[],PChar(CheckId),sList);
  CheckId:='';
  if datetostr(AServerDate)=CheckDate then
  begin
    for i :=0  to sList.Count-1 do
    begin
      CheckId:=CheckId+GetNextValue(sList[i])+',';
    end;
  end
  else begin
    for i :=0  to sList.Count-1 do
    begin
      CheckId:=CheckId+GetFirstValue(sList[i])+',';
    end;
  end;
  sList.Free;
  if(CheckId<>'')and(CheckId[length(CheckId)]=',')then CheckId:=copy(CheckId,1,length(CheckId)-1);
    
  result:=CheckId;
end;
  
procedure TfrmMain.LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  UniQryTemp22:TUniQuery;
  ADOTemp22:TADOQuery;

  i:Integer;

  VTTemp:TVirtualTable;

  ini:TIniFile;

  PreWorkGroup:String;//该变量作用:仅保存工作组第一条记录的联机号
begin
  if key<>13 then exit;

  if trim((Sender as TLabeledEdit).Text)='' then exit;

  PreWorkGroup:='上一个工作组';//初始化为实际情况不可能出现的工作组名称即可

  (Sender as TLabeledEdit).Enabled:=false;//为了防止没处理完又扫描下一个条码

  UniQryTemp22:=TUniQuery.Create(nil);
  UniQryTemp22.Connection:=UniConnection1;
  UniQryTemp22.Close;
  UniQryTemp22.SQL.Clear;
  UniQryTemp22.SQL.Text:='select * from LIS_REQUEST where barcode=:barcode';
  UniQryTemp22.ParamByName('barcode').Value:=(Sender as TLabeledEdit).Text;
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

  VirtualTable1.Clear;
  for i:=0 to (DBGrid1.columns.count-1) do DBGrid1.columns[i].readonly:=False;

  while not UniQryTemp22.Eof do
  begin
    ADOTemp22:=TADOQuery.Create(nil);
    ADOTemp22.Connection:=ADOConnection1;
    ADOTemp22.Close;
    ADOTemp22.SQL.Clear;
    ADOTemp22.SQL.Text:='select ci.Id,ci.Name,ci.dept_DfValue '+
                        'from combinitem ci,HisCombItem hci '+
                        'where ci.Unid=hci.CombUnid and hci.ExtSystemId=''HIS'' '+
                        'and hci.HisItem=:HisItem';
    ADOTemp22.Parameters.ParamByName('HisItem').Value:=UniQryTemp22.fieldbyname('order_id').AsString;
    ADOTemp22.Open;
    while not ADOTemp22.Eof do
    begin
      VirtualTable1.Append;
      VirtualTable1.FieldByName('外部系统项目申请编号').AsString:=UniQryTemp22.FieldByName('REQUEST_NO').AsString;
      VirtualTable1.FieldByName('HIS项目代码').AsString:=UniQryTemp22.FieldByName('order_id').AsString;
      VirtualTable1.FieldByName('HIS项目名称').AsString:=UniQryTemp22.FieldByName('ITEMNAME').AsString;
      VirtualTable1.FieldByName('LIS项目代码').AsString:=ADOTemp22.FieldByName('Id').AsString;
      VirtualTable1.FieldByName('LIS项目名称').AsString:=ADOTemp22.FieldByName('Name').AsString;
      VirtualTable1.FieldByName('工作组').AsString:=ADOTemp22.FieldByName('dept_DfValue').AsString;
      VirtualTable1.FieldByName('样本类型').AsString:=UniQryTemp22.FieldByName('SPEC_TYPE').AsString;
      VirtualTable1.FieldByName('联机号').AsString:=GetMaxCheckId(ADOTemp22.FieldByName('dept_DfValue').AsString,Date);
      VirtualTable1.Post;

      ADOTemp22.Next;
    end;
    ADOTemp22.Free;

    UniQryTemp22.Next;
  end;
  UniQryTemp22.Free;

  for i:=0 to (DBGrid1.columns.count-2) do DBGrid1.columns[i].readonly:=True;//仅保留最后1列(联机号)可编辑

  if CheckBox1.Checked then
  begin
    VTTemp:=TVirtualTable.Create(nil);
    VTTemp.Assign(VirtualTable1);//clone数据集
    VTTemp.Open;
    while not VTTemp.Eof do
    begin
      SingleRequestForm2Lis(
        VTTemp.fieldbyname('工作组').AsString,
        LabeledEdit11.Text,
        LabeledEdit2.Text,
        LabeledEdit3.Text,
        LabeledEdit4.Text,
        Edit2.Text,
        LabeledEdit5.Text,
        LabeledEdit6.Text,
        LabeledEdit8.Text,
        LabeledEdit7.Text,
        VTTemp.fieldbyname('外部系统项目申请编号').AsString,
        VTTemp.fieldbyname('联机号').AsString,
        VTTemp.fieldbyname('样本类型').AsString,
        VTTemp.fieldbyname('LIS项目代码').AsString
      );

      //保存当前联机号
      if (trim(VTTemp.fieldbyname('工作组').AsString)<>'')and(VTTemp.fieldbyname('工作组').AsString<>PreWorkGroup) then
      begin
        PreWorkGroup:=VTTemp.fieldbyname('工作组').AsString;
        ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
        ini.WriteDate(VTTemp.fieldbyname('工作组').AsString,'检查日期',Date);
        ini.WriteString(VTTemp.fieldbyname('工作组').AsString,'联机号',VTTemp.fieldbyname('联机号').AsString);
        ini.Free;
      end;
      //==============

      VTTemp.Next;
    end;
    VTTemp.Close;
    VTTemp.Free;
  end;

  (Sender as TLabeledEdit).Enabled:=true;
  if (Sender as TLabeledEdit).CanFocus then (Sender as TLabeledEdit).SetFocus;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MakeUniDBConn;
  MakeAdoDBConn;

  //设计期设置VirtualTable字段
  VirtualTable1.IndexFieldNames:='工作组,样本类型';//按工作组、样本类型排序
  VirtualTable1.Open;
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
  ifIntegrated:boolean;//是否集成登录模式

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  datasource := Ini.ReadString('连接LIS数据库', '服务器', '');
  initialcatalog := Ini.ReadString('连接LIS数据库', '数据库', '');
  ifIntegrated:=ini.ReadBool('连接LIS数据库','集成登录模式',false);
  userid := Ini.ReadString('连接LIS数据库', '用户', '');
  password := Ini.ReadString('连接LIS数据库', '口令', '107DFC967CDCFAAF');
  Ini.Free;
  //======解密password
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
  //Persist Security Info,表示ADO在数据库连接成功后是否保存密码信息
  //ADO缺省为True,ADO.net缺省为False
  //程序中会传ADOConnection信息给TADOLYQuery,故设置为True
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
    ss:='服务器'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '数据库'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '集成登录模式'+#2+'CheckListBox'+#2+#2+'0'+#2+'启用该模式,则用户及口令无需填写'+#2+#3+
        '用户'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '口令'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('连接LIS数据库','连接LIS数据库',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
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
  provider := Ini.ReadString('连接HIS数据库', '数据提供者', '');
  datasource := Ini.ReadString('连接HIS数据库', '服务器', '');
  userid := Ini.ReadString('连接HIS数据库', '用户', '');
  password := Ini.ReadString('连接HIS数据库', '口令', '107DFC967CDCFAAF');
  Ini.Free;
  //======解密password
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
    ss:='数据提供者'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '服务器'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '用户'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '口令'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('连接HIS数据库','连接HIS数据库',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

procedure TfrmMain.VirtualTable1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
   
  DBGrid1.Columns[0].Width:=30;//外部系统项目申请编号
  DBGrid1.Columns[1].Width:=77;//HIS项目代码
  DBGrid1.Columns[2].Width:=100;//HIS项目名称
  DBGrid1.Columns[3].Width:=77;//LIS项目代码
  DBGrid1.Columns[4].Width:=100;//LIS项目名称
  DBGrid1.Columns[5].Width:=80;//工作组
  DBGrid1.Columns[6].Width:=57;//样本类型
  DBGrid1.Columns[7].Width:=90;//联机号
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  VTTemp:TVirtualTable;
  ini:TIniFile;

  PreWorkGroup:String;//该变量作用:仅保存工作组第一条记录的联机号
begin
  if not VirtualTable1.Active then exit;
  if VirtualTable1.RecordCount<=0 then exit;

  PreWorkGroup:='上一个工作组';//初始化为实际情况不可能出现的工作组名称即可

  LabeledEdit1.Enabled:=false;//为了防止没处理完又扫描下一个条码
  BitBtn1.Enabled:=false;//为了防止没处理完又点击导入//因定义了ShortCut,故不能使用(Sender as TBitBtn)

  VTTemp:=TVirtualTable.Create(nil);
  VTTemp.Assign(VirtualTable1);//clone数据集
  VTTemp.Open;
  while not VTTemp.Eof do
  begin
    SingleRequestForm2Lis(
      VTTemp.fieldbyname('工作组').AsString,
      LabeledEdit11.Text,
      LabeledEdit2.Text,
      LabeledEdit3.Text,
      LabeledEdit4.Text,
      Edit2.Text,
      LabeledEdit5.Text,
      LabeledEdit6.Text,
      LabeledEdit8.Text,
      LabeledEdit7.Text,
      VTTemp.fieldbyname('外部系统项目申请编号').AsString,
      VTTemp.fieldbyname('联机号').AsString,
      VTTemp.fieldbyname('样本类型').AsString,
      VTTemp.fieldbyname('LIS项目代码').AsString
    );

    //保存当前联机号
    if (trim(VTTemp.fieldbyname('工作组').AsString)<>'')and(VTTemp.fieldbyname('工作组').AsString<>PreWorkGroup) then
    begin
      PreWorkGroup:=VTTemp.fieldbyname('工作组').AsString;
      ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
      ini.WriteDate(VTTemp.fieldbyname('工作组').AsString,'检查日期',Date);
      ini.WriteString(VTTemp.fieldbyname('工作组').AsString,'联机号',VTTemp.fieldbyname('联机号').AsString);
      ini.Free;
    end;
    //==============

    VTTemp.Next;
  end;
  VTTemp.Close;
  VTTemp.Free;

  LabeledEdit1.Enabled:=true;
  if LabeledEdit1.CanFocus then LabeledEdit1.SetFocus; 
  BitBtn1.Enabled:=true;//因定义了ShortCut,故不能使用(Sender as TBitBtn)
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
  ObjectYZMZ.S['联机号'] := checkid;
  ObjectYZMZ.S['LIS组合项目代码'] := pkcombin_id;
  ObjectYZMZ.S['条码号'] := ABarcode;
  ObjectYZMZ.S['外部系统项目申请编号'] := Surem1;
  ObjectYZMZ.S['样本类型'] := SampleType;

  ArrayYZMX.AsArray.Add(ObjectYZMZ);
  ObjectYZMZ:=nil;

  ObjectJYYZ:=SO;
  ObjectJYYZ.S['患者姓名']:=patientname;
  if sex='1' then ObjectJYYZ.S['患者性别']:='男'
    else if sex='2' then ObjectJYYZ.S['患者性别']:='女'
      else ObjectJYYZ.S['患者性别']:='未知';
  if age_unit='Y' then ObjectJYYZ.S['患者年龄']:=age+'岁'
    else if age_unit='M' then ObjectJYYZ.S['患者年龄']:=age+'月'
      else if age_unit='D' then ObjectJYYZ.S['患者年龄']:=age+'天'
        else ObjectJYYZ.S['患者年龄']:=age+age_unit;
  ObjectJYYZ.S['申请科室']:=deptname;
  ObjectJYYZ.S['申请医生']:=check_doctor;
  ObjectJYYZ.S['申请日期']:=RequestDate;
  ObjectJYYZ.S['外部系统唯一编号']:=His_Unid;
  ObjectJYYZ.O['医嘱明细']:=ArrayYZMX;
  ArrayYZMX:=nil;

  ArrayJYYZ:=SA([]);
  ArrayJYYZ.AsArray.Add(ObjectJYYZ);
  ObjectJYYZ:=nil;

  BigObjectJYYZ:=SO;
  BigObjectJYYZ.S['JSON数据源']:='HIS';
  BigObjectJYYZ.O['检验医嘱']:=ArrayJYYZ;
  ArrayJYYZ:=nil;

  RequestForm2Lis(PChar(AnsiString(ADOConnection1.ConnectionString)),UnicodeToChinese(PChar(AnsiString(BigObjectJYYZ.AsJson))),'');
  BigObjectJYYZ:=nil;
end;

procedure TfrmMain.CheckBox1Click(Sender: TObject);
begin
  BitBtn1.Enabled:=not (Sender as TCheckBox).Checked;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  ConfigIni:tinifile;
begin
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  configini.WriteBool('Interface','ifDirect2LIS',CheckBox1.Checked);{记录是否扫描后直接导入LIS}

  configini.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  configini:tinifile;
begin
  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  CheckBox1.Checked:=configini.ReadBool('Interface','ifDirect2LIS',false);{记录是否扫描后直接导入LIS}

  configini.Free;
  
  BitBtn1.Enabled:=not CheckBox1.Checked;
end;

end.
