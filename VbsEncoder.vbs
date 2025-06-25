Dim fso, inFile, outFile, inPath, outPath, content, encoded, i, ch
Set fso = CreateObject("Scripting.FileSystemObject")

' === Set your paths directly here:
inPath  = "C:\Users\a9805\OneDrive\Desktop\zz\Start.vbs"
outPath = "C:\Users\a9805\OneDrive\Desktop\zz\s_e.vbs"

If Not fso.FileExists(inPath) Then
    MsgBox "Input file not found!", vbCritical
    WScript.Quit
End If

Set inFile = fso.OpenTextFile(inPath, 1)
content = inFile.ReadAll
inFile.Close

encoded = ""
For i = 1 To Len(content)
    ch = Mid(content, i, 1)
    encoded = encoded & "Chr(" & Asc(ch) & ")"
    If i < Len(content) Then encoded = encoded & " & "
Next

Set outFile = fso.CreateTextFile(outPath, True)
outFile.WriteLine "Execute " & encoded
outFile.Close

MsgBox "Obfuscated VBS created at: " & outPath, vbInformation, "Done"
