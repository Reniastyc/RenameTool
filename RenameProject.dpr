program RenameProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  RenameTool in 'RenameTool.pas' {SubtileRenameTool};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSubtileRenameTool, SubtileRenameTool);
  Application.Run;
end.
