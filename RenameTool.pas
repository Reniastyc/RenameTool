﻿unit RenameTool;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Winapi.ShellAPI, Winapi.Windows,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts, FMX.ExtCtrls, FMX.Memo.Types, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.ListBox, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Data.Bind.Components;

type
  TSubtileRenameTool = class(TForm)
    DropTarget_Files: TDropTarget;
    Layout_Left: TLayout;
    Layout_Client: TLayout;
    Memo_Files: TMemo;
    StyleBook: TStyleBook;
    Layout_Bottom: TLayout;
    DropTarget_Targets: TDropTarget;
    Memo_Targets: TMemo;
    Label_Hint: TLabel;
    Layout_Tools: TLayout;
    Layout_Hint: TLayout;
    ComboBox_Lang: TComboBox;
    Lang: TLang;
    SpeedButton_Rename: TSpeedButton;
    Label_Files: TLabel;
    Label_Targets: TLabel;
    Layout_LeftTool: TLayout;
    ListBox_Files: TListBox;
    BindingsList1: TBindingsList;
    Button_LeftSort: TButton;
    Panel_Left: TPanel;
    Button_LeftClear: TButton;
    Layout_ClientTool: TLayout;
    Panel_Client: TPanel;
    Button_ClientSort: TButton;
    Button_ClientClear: TButton;
    Label_Count: TLabel;
    procedure FormResize(Sender: TObject);
    procedure DropTarget_FilesDropped(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure DropTarget_TargetsDropped(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure DropTarget_FilesDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF;
      var Operation: TDragOperation);
    procedure DropTarget_TargetsDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF;
      var Operation: TDragOperation);
    procedure SpeedButton_RenameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox_LangChange(Sender: TObject);
    procedure Button_LeftSortClick(Sender: TObject);
    procedure Button_LeftClearClick(Sender: TObject);
    procedure Button_ClientSortClick(Sender: TObject);
    procedure Button_ClientClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SubtileRenameTool: TSubtileRenameTool;
  OnCreateEvent: Boolean;

implementation

{$R *.fmx}

procedure TSubtileRenameTool.DropTarget_TargetsDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF;
  var Operation: TDragOperation);
begin
  Operation := TDragOperation.Copy;
end;

procedure TSubtileRenameTool.DropTarget_TargetsDropped(Sender: TObject; const Data: TDragObject; const Point: TPointF);
var
  i, l: Integer;
begin
  l := Length(Data.Files);
  for i := 0 to l - 1 do
  begin
    Memo_Targets.Lines.Add(Data.Files[i]);
  end;
end;

procedure TSubtileRenameTool.Button_ClientClearClick(Sender: TObject);
begin
  Memo_Targets.Lines.Clear;
end;

procedure TSubtileRenameTool.Button_ClientSortClick(Sender: TObject);
begin
  ListBox_Files.Sorted := False;
  ListBox_Files.Items.Text := Memo_Targets.Lines.Text;
  ListBox_Files.Sorted := True;
  Memo_Targets.Lines.Text := ListBox_Files.Items.Text;
end;

procedure TSubtileRenameTool.Button_LeftClearClick(Sender: TObject);
begin
  Memo_Files.Lines.Clear;
end;

procedure TSubtileRenameTool.Button_LeftSortClick(Sender: TObject);
begin
  ListBox_Files.Sorted := False;
  ListBox_Files.Items.Text := Memo_Files.Lines.Text;
  ListBox_Files.Sorted := True;
  Memo_Files.Lines.Text := ListBox_Files.Items.Text;
end;

procedure TSubtileRenameTool.ComboBox_LangChange(Sender: TObject);
begin
  if OnCreateEvent then
  begin
    Exit;
  end;
  case ComboBox_Lang.ItemIndex of
    0: LoadLangFromStrings(Lang.LangStr['en']);
    1: LoadLangFromStrings(Lang.LangStr['tc']);
    2: LoadLangFromStrings(Lang.LangStr['sc']);
  end;
  DropTarget_Files.Text := Label_Files.Text;
  DropTarget_Targets.Text := Label_Targets.Text;
end;

procedure TSubtileRenameTool.DropTarget_FilesDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF;
  var Operation: TDragOperation);
begin
  Operation := TDragOperation.Copy;
end;

procedure TSubtileRenameTool.DropTarget_FilesDropped(Sender: TObject; const Data: TDragObject; const Point: TPointF);
var
  i, l: Integer;
begin
  l := Length(Data.Files);
  for i := 0 to l - 1 do
  begin
    Memo_Files.Lines.Add(Data.Files[i]);
  end;
end;

procedure TSubtileRenameTool.FormCreate(Sender: TObject);
var
  ID: Word;
begin
  ID := GetSystemDefaultLangID;
  OnCreateEvent := True;
  try
    case ID of
      $1404, $0404, $0C04:
      begin
        LoadLangFromStrings(Lang.LangStr['tc']);
        ComboBox_Lang.ItemIndex := 1;
      end;
      $1004, $0804:
      begin
        LoadLangFromStrings(Lang.LangStr['sc']);
        ComboBox_Lang.ItemIndex := 2;
      end
    else
      LoadLangFromStrings(Lang.LangStr['en']);
      ComboBox_Lang.ItemIndex := 0;
    end;
  finally
    OnCreateEvent := False;
  end;
  DropTarget_Files.Text := Label_Files.Text;
  DropTarget_Targets.Text := Label_Targets.Text;
end;

procedure TSubtileRenameTool.FormResize(Sender: TObject);
begin
  Layout_Left.Width := Width / 2;
end;

procedure TSubtileRenameTool.SpeedButton_RenameClick(Sender: TObject);
var
  FileName, DestName, TS: string;
  i, l: Integer;
begin
  if Memo_Files.Lines.Count <> Memo_Targets.Lines.Count then
  begin
    ShowMessage(Label_Count.Text);
    Exit;
  end;
  l := Memo_Files.Lines.Count;
  for i := 0 to l - 1 do
  begin
    FileName := Memo_Files.Lines[i];
    TS := ExtractFileExt(FileName);
    DestName := ChangeFileExt(Memo_Targets.Lines[i], TS);
    if FileExists(FileName) then
    begin
      if ExtractFilePath(DestName) = '' then
      begin
        DestName := ExtractFilePath(FileName) + DestName;
      end;
      RenameFile(FileName, DestName);
    end;
  end;
end;

end.
