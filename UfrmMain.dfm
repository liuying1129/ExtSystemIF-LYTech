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
    object SpeedButton1: TSpeedButton
      Left = 660
      Top = 11
      Width = 23
      Height = 22
      Hint = #26597#30475#33713#22495#30003#35831#21333
      Caption = #65311
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object Label2: TLabel
      Left = 9
      Top = 15
      Width = 39
      Height = 13
      Caption = #32852#26426#21495
    end
    object LabeledEdit1: TLabeledEdit
      Left = 294
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
    object ComboBox2: TComboBox
      Left = 51
      Top = 12
      Width = 38
      Height = 21
      DropDownCount = 26
      ItemHeight = 13
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 90
      Top = 12
      Width = 45
      Height = 21
      TabOrder = 2
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 41
    Width = 690
    Height = 426
    Align = alClient
    Caption = #26465#30721#20449#24687
    TabOrder = 1
    object Panel3: TPanel
      Left = 2
      Top = 15
      Width = 686
      Height = 58
      Align = alTop
      TabOrder = 0
      object LabeledEdit2: TLabeledEdit
        Left = 84
        Top = 26
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
        Left = 162
        Top = 26
        Width = 35
        Height = 21
        Color = clMenu
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #24615#21035
        ReadOnly = True
        TabOrder = 1
      end
      object LabeledEdit4: TLabeledEdit
        Left = 212
        Top = 26
        Width = 35
        Height = 21
        Color = clMenu
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #24180#40836
        ReadOnly = True
        TabOrder = 2
      end
      object LabeledEdit5: TLabeledEdit
        Left = 287
        Top = 26
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
        Left = 374
        Top = 26
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
        Left = 6
        Top = 26
        Width = 72
        Height = 21
        Color = clMenu
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #26465#30721
        ReadOnly = True
        TabOrder = 5
      end
      object LabeledEdit8: TLabeledEdit
        Left = 440
        Top = 26
        Width = 140
        Height = 21
        Color = clMenu
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = #30003#35831#26102#38388
        ReadOnly = True
        TabOrder = 6
      end
      object LabeledEdit11: TLabeledEdit
        Left = 587
        Top = 26
        Width = 92
        Height = 21
        Color = clMenu
        EditLabel.Width = 39
        EditLabel.Height = 13
        EditLabel.Caption = #20307#26816#21495
        ReadOnly = True
        TabOrder = 7
      end
      object Edit2: TEdit
        Left = 247
        Top = 26
        Width = 35
        Height = 21
        Color = clMenu
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 391
      Width = 686
      Height = 33
      Align = alBottom
      TabOrder = 1
      object Label1: TLabel
        Left = 152
        Top = 3
        Width = 384
        Height = 13
        Caption = #27880#65306'1'#12289#20462#25913#34920#26684#20013#30340#32852#26426#23383#27597#21450#32852#26426#21495#65292#20462#25913#24037#20316#32452#30340#31532#19968#26465#21363#21487
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 178
        Top = 18
        Width = 462
        Height = 13
        Caption = '2'#12289#25195#25551#26465#30721#21518#65292#22914#26524#25353#38062#19981#21487#29992#65292#34920#31034#24050#33258#21160#23548#20837#65307#21542#21017#65292#38656#28857#20987#25353#38062#36827#34892#23548#20837
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object BitBtn1: TBitBtn
        Left = 7
        Top = 4
        Width = 100
        Height = 25
        Caption = #23548#20837'LIS'
        TabOrder = 0
        OnClick = BitBtn1Click
      end
    end
    object DBGrid1: TDBGrid
      Left = 2
      Top = 73
      Width = 686
      Height = 318
      Align = alClient
      DataSource = DataSource1
      TabOrder = 2
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
    end
  end
  object UniConnection1: TUniConnection
    Left = 623
    Top = 8
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Yklissa123;Persist Security Info=Tr' +
      'ue;User ID=sa;Initial Catalog=YkLis;Data Source=202.96.1.105'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 591
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = VirtualTable1
    Left = 40
    Top = 211
  end
  object VirtualTable1: TVirtualTable
    AfterOpen = VirtualTable1AfterOpen
    AfterScroll = VirtualTable1AfterScroll
    FieldDefs = <
      item
        Name = #22806#37096#31995#32479#39033#30446#30003#35831#32534#21495
        DataType = ftString
        Size = 20
      end
      item
        Name = 'HIS'#39033#30446#20195#30721
        DataType = ftString
        Size = 50
      end
      item
        Name = 'HIS'#39033#30446#21517#31216
        DataType = ftString
        Size = 100
      end
      item
        Name = 'LIS'#39033#30446#20195#30721
        DataType = ftString
        Size = 50
      end
      item
        Name = 'LIS'#39033#30446#21517#31216
        DataType = ftString
        Size = 100
      end
      item
        Name = #26679#26412#31867#22411
        DataType = ftString
        Size = 50
      end
      item
        Name = #24037#20316#32452
        DataType = ftString
        Size = 50
      end
      item
        Name = #20202#22120#23383#27597
        DataType = ftString
        Size = 20
      end
      item
        Name = #32852#26426#21495
        DataType = ftString
        Size = 20
      end>
    Left = 72
    Top = 211
    Data = {
      030009001400CDE2B2BFCFB5CDB3CFEEC4BFC9EAC7EBB1E0BAC5010014000000
      00000B00484953CFEEC4BFB4FAC2EB01003200000000000B00484953CFEEC4BF
      C3FBB3C601006400000000000B004C4953CFEEC4BFB4FAC2EB01003200000000
      000B004C4953CFEEC4BFC3FBB3C601006400000000000800D1F9B1BEC0E0D0CD
      01003200000000000600B9A4D7F7D7E901003200000000000800D2C7C6F7D7D6
      C4B801001400000000000600C1AABBFABAC50100140000000000000000000000}
  end
end
