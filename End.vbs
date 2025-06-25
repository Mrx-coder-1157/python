' ================================
' EndMiner.vbs - Full XMRig Cleanup
' ================================
On Error Resume Next

Set shell = CreateObject("WScript.Shell")
Set fso   = CreateObject("Scripting.FileSystemObject")
Set wmi   = GetObject("winmgmts:\\.\root\cimv2")

' === 1. Kill miner process
Set minerProcs = wmi.ExecQuery("SELECT * FROM Win32_Process WHERE Name='systemcache.exe'")
For Each proc In minerProcs
    proc.Terminate()
Next

' === 2. Kill watchdog VBS or PS1 processes
Set scriptProcs = wmi.ExecQuery("SELECT * FROM Win32_Process WHERE Name='wscript.exe' OR Name='cscript.exe' OR Name='powershell.exe'")
For Each p In scriptProcs
    cmdline = LCase(p.CommandLine)
    If InStr(cmdline, "windowsupdate") > 0 Or InStr(cmdline, "startmining.ps1") > 0 Or InStr(cmdline, "svchost.vbs") > 0 Then
        p.Terminate()
    End If
Next

' === 3. Remove registry autorun key
shell.RegDelete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\WindowsUpdate"

' === 4. Delete scheduled task
shell.Run "cmd /c schtasks /delete /tn ""WindowsUpdateSvc"" /f", 0, True

' === 5. Delete all folders and files
paths = Array( _
  shell.ExpandEnvironmentStrings("%APPDATA%") & "\XMRigMiner", _
  shell.ExpandEnvironmentStrings("%APPDATA%") & "\WindowsUpdate", _
  "C:\Users\Public\Libraries\svchost.vbs" _
)

For Each path In paths
    If fso.FileExists(path) Then
        fso.DeleteFile path, True
    ElseIf fso.FolderExists(path) Then
        fso.DeleteFolder path, True
    End If
Next

' === 6. Extra forced removal using cmd (handles locked folders)
For Each path In paths
    shell.Run "cmd /c rmdir /s /q """ & path & """", 0, True
Next

' === 7. Done
MsgBox "Miner fully removed.", vbInformation, "Cleanup Complete"
