$PublicFolder = GEt-ChildItem "\\tp-fs-01\Public" -Directory
foreach ($folder in $PublicFolder){
    icacls.exe "\\tp-fs-01\PUBLIC" /restore "C:\ACLS\$folder" /c
}