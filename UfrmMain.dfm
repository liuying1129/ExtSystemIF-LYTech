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
      Left = 222
      Top = 15
      Width = 39
      Height = 13
      Caption = #32852#26426#21495
    end
    object LabeledEdit1: TLabeledEdit
      Left = 481
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
    object ComboBox2: TComboBox
      Left = 264
      Top = 12
      Width = 32
      Height = 21
      DropDownCount = 26
      ItemHeight = 13
      TabOrder = 2
    end
    object Edit1: TEdit
      Left = 297
      Top = 12
      Width = 38
      Height = 21
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 690
    Height = 426
    Align = alClient
    TabOrder = 1
    object LabeledEdit2: TLabeledEdit
      Left = 180
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
      Left = 241
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
      Left = 283
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
      Left = 335
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
      Left = 417
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
      Height = 355
      Color = clMenu
      ReadOnly = True
      TabOrder = 6
    end
    object LabeledEdit8: TLabeledEdit
      Left = 479
      Top = 25
      Width = 140
      Height = 21
      Color = clMenu
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #30003#35831#26102#38388
      ReadOnly = True
      TabOrder = 7
    end
    object LabeledEdit9: TLabeledEdit
      Left = 621
      Top = 25
      Width = 60
      Height = 21
      Color = clMenu
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #26679#26412#31867#22411
      ReadOnly = True
      TabOrder = 8
    end
  end
  object UniConnection1: TUniConnection
    Left = 638
    Top = 116
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Yklissa123;Persist Security Info=Tr' +
      'ue;User ID=sa;Initial Catalog=YkLis;Data Source=202.96.1.105'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 606
    Top = 116
  end
end
