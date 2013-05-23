#include <Array.au3>
#include <File.au3>

;"C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" /ShowGui /in "%l"
Local $compiler_cmd = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AutoIt3Script\Shell\Compile with Options\Command", "")
Local $src_files = _FileListToArray("." , "*.au3", 1)
Local $output_dir = "..\bin"
Local $cmd = ""

DirRemove ( $output_dir,1)
DirCreate ( $output_dir)


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
