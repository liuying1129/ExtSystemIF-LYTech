unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, DBAccess, Uni, MemDS, Grids, DBGrids,
  Buttons,OracleUniProvider, ADODB,IniFiles;

type
  TfrmMain = class(TForm)
    UniConnection1: TUniConnection;
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
    LabeledEdit8: TLabeledEdit;
    SpeedButton1: TSpeedButton;
    procedure LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadGroupName(const comboBox:TcomboBox;const ASel:string);
    function MakeAdoDBConn:boolean;
    function MakeUniDBConn:boolean;
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
  
procedure TfrmMain.LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ObjectYZMZ:ISuperObject;
  ArrayYZMX:ISuperObject;
  ObjectJYYZ:ISuperObject;
  ArrayJYYZ:ISuperObject;
  BigObjectJYYZ:ISuperObject;

  UniQryTemp22:TUniQuery;
  ADOTemp22:TADOQuery;
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
  LabeledEdit4.Text:=UniQryTemp22.fieldbyname('age').AsString+UniQryTemp22.fieldbyname('age_unit').AsString;
  LabeledEdit5.Text:=UniQryTemp22.fieldbyname('reqdept').AsString;
  LabeledEdit6.Text:=UniQryTemp22.fieldbyname('write_name').AsString;
  LabeledEdit7.Text:=UniQryTemp22.fieldbyname('barcode').AsString;
  LabeledEdit8.Text:=UniQryTemp22.fieldbyname('write_time').AsString;

  Memo1.Lines.Clear;
  while not UniQryTemp22.Eof do
  begin
    Memo1.Lines.Add('【HIS组合项目代码】'+UniQryTemp22.fieldbyname('order_id').AsString+';【HIS组合项目名称】'+UniQryTemp22.fieldbyname('itemname').AsString+';【体检号】'+UniQryTemp22.fieldbyname('reg_id').AsString+';【外部系统项目申请编号】'+UniQryTemp22.fieldbyname('request_no').AsString);

    ADOTemp22:=TADOQuery.Create(nil);
    ADOTemp22.Connection:=ADOConnection1;
    ADOTemp22.Close;
    ADOTemp22.SQL.Clear;
    ADOTemp22.SQL.Text:='select ci.Id,ci.Name '+
                        'from combinitem ci,HisCombItem hci '+
                        'where ci.Unid=hci.CombUnid and hci.ExtSystemId=''HIS'' '+
                        'and hci.HisItem='''+UniQryTemp22.fieldbyname('order_id').AsString+''' ';
    ADOTemp22.Open;
    ArrayYZMX:=SA([]);
    while not ADOTemp22.Eof do
    begin
      Memo1.Lines.Add('LIS对应的组合项目【'+ADOTemp22.fieldbyname('Id').AsString+'】'+ADOTemp22.fieldbyname('Name').AsString);

      ObjectYZMZ:=SO;
      ObjectYZMZ.S['LIS组合项目代码'] := ADOTemp22.fieldbyname('Id').AsString;
      ObjectYZMZ.S['条码号'] := UniQryTemp22.fieldbyname('barcode').AsString;
      ObjectYZMZ.S['外部系统项目申请编号'] := UniQryTemp22.fieldbyname('request_no').AsString;

      ArrayYZMX.AsArray.Add(ObjectYZMZ);
      ObjectYZMZ:=nil;
      
      ADOTemp22.Next;
    end;
    ADOTemp22.Free;

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
    RequestForm2Lis(PChar(AnsiString(ADOConnection1.ConnectionString)),UnicodeToChinese(PChar(AnsiString(BigObjectJYYZ.AsJson))),PChar(ComboBox1.Text));
    BigObjectJYYZ:=nil;

    UniQryTemp22.Next;
  end;
  UniQryTemp22.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MakeUniDBConn;
  MakeAdoDBConn;
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

end.
