object frmMain: TfrmMain
  Left = 269
  Top = 127
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26465#30721#25195#25551' - '#23545#25509#33713#22495'PEIS'
  ClientHeight = 467
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 690
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 12
      Top = 15
      Width = 39
      Height = 13
      Caption = #24037#20316#32452
    end
    object LabeledEdit1: TLabeledEdit
      Left = 386
      Top = 12
      Width = 170
      Height = 21
      EditLabel.Width = 131
      EditLabel.Height = 13
      EditLabel.Caption = #25195#25551#25110#36755#20837#26465#30721'('#22238#36710')'
      LabelPosition = lpLeft
      TabOrder = 0
      OnKeyDown = LabeledEdit1KeyDown
    end
    object ComboBox1: TComboBox
      Left = 55
      Top = 12
      Width = 150
      Height = 21
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 690
    Height = 208
    Align = alTop
    TabOrder = 1
    object LabeledEdit2: TLabeledEdit
      Left = 184
      Top = 25
      Width = 60
      Height = 21
      Color = clMenu
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #22995#21517
      ReadOnly = True
      TabOrder = 0
    end
    object LabeledEdit3: TLabeledEdit
      Left = 248
      Top = 25
      Width = 40
      Height = 21
      Color = clMenu
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #24615#21035
      ReadOnly = True
      TabOrder = 1
    end
    object LabeledEdit4: TLabeledEdit
      Left = 304
      Top = 25
      Width = 50
      Height = 21
      Color = clMenu
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #24180#40836
      ReadOnly = True
      TabOrder = 2
    end
    object LabeledEdit5: TLabeledEdit
      Left = 360
      Top = 25
      Width = 80
      Height = 21
      Color = clMenu
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #30003#35831#31185#23460
      ReadOnly = True
      TabOrder = 3
    end
    object LabeledEdit6: TLabeledEdit
      Left = 448
      Top = 25
      Width = 60
      Height = 21
      Color = clMenu
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #30003#35831#21307#29983
      ReadOnly = True
      TabOrder = 4
    end
    object LabeledEdit7: TLabeledEdit
      Left = 8
      Top = 25
      Width = 170
      Height = 21
      Color = clMenu
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #26465#30721
      ReadOnly = True
      TabOrder = 5
    end
    object Memo1: TMemo
      Left = 8
      Top = 62
      Width = 673
      Height = 125
      Color = clMenu
      ReadOnly = True
      TabOrder = 6
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 249
    Width = 690
    Height = 218
    Align = alClient
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 688
      Height = 175
      Align = alClient
      Color = clMenu
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
    end
    object Panel4: TPanel
      Left = 1
      Top = 176
      Width = 688
      Height = 41
      Align = alBottom
      TabOrder = 1
      object BitBtn1: TBitBtn
        Left = 24
        Top = 8
        Width = 113
        Height = 25
        Caption = #26174#31034#25152#26377#30003#35831#21333
        TabOrder = 0
        OnClick = BitBtn1Click
      end
    end
  end
  object UniConnection1: TUniConnection
    Left = 650
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = UniQuery1
    Left = 32
    Top = 280
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 613
    Top = 8
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Yklissa123;Persist Security Info=Tr' +
      'ue;User ID=sa;Initial Catalog=YkLis;Data Source=202.96.1.105'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 581
    Top = 8
  end
  object UniQuery1: TUniQuery
    Connection = UniConnection1
    Left = 66
    Top = 280
  end
end
