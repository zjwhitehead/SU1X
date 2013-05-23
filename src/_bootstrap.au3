#include <Array.au3>
#include <File.au3>

;"C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" /ShowGui /in "%l"
Local $compiler_cmd = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AutoIt3Script\Shell\Compile with Options\Command", "")
;"C:\Program Files (x86)\NSIS\makensisw.exe" "%1"
Local $installer_cmd = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\NSIS.Script\shell\compile\command", "")
Local $src_files = _FileListToArray("." , "*.au3", 1)
Local $output_dir = "..\bin"
Local $cmd = ""

DirRemove ( $output_dir,1)
DirCreate ( $output_dir)

If $compiler_cmd = "" Then
	Msgbox(0,"Error","Compiler not found")
	Exit
EndIf


For $element In $src_files
    $cmd = $compiler_cmd
	$cmd = StringReplace ( $cmd, "%l", $element)
	If FileExists($element) AND $element <>  @ScriptName Then
		RunWait ( $cmd )
	EndIf
Next

DirCopy ( "images", $output_dir & "\images", 1)
DirCopy ( "profiles", $output_dir & "\profiles", 1)
DirCopy ( "support", $output_dir & "\support", 1)
DirCopy ( "tools", $output_dir & "\tools", 1)

FileCopy ( "..\*.txt", $output_dir, 1)
FileCopy ( "..\LICENSE", $output_dir, 1)

FileCopy ( "*.xml", $output_dir, 1)
FileCopy ( "*.exe", $output_dir, 1)

FileCopy ( "config.default.ini","config.ini", 0)
FileCopy ( "config.ini", $output_dir, 1)

If $installer_cmd = "" Then
	Msgbox(0,"Error","NSIS not found, skipping install.")
	Exit
EndIf

$installer = MsgBox(4,'Create installer','Create an installer?')
If $installer = 6 Then
	FileCopy ( "su1x_installer.default.nsi","su1x_installer.nsi", 0)
	$installer_cmd = StringReplace ( $installer_cmd, "%1", "su1x_installer.nsi")
	RunWait($installer_cmd)
EndIf

