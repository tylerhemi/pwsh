$PublicFolder = GEt-ChildItem "\\tp-fs-01\Public" -Directory
foreach ($folder in $PublicFolder){
    icacls.exe $folder.FullName /save C:\$folder /t
}