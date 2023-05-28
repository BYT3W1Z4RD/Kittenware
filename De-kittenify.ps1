$expectedPassword = "DONTFUCKWITHCATS"
$enteredPassword = Read-Host "Enter the password: "
$sourcePath = "Decrypted Images/images.zip"
$destinationPath = "Decrypted Images"
if ($enteredPassword -ne $expectedPassword) {
    Write-Host "Incorrect Password!"
    exit
}
Rename-Item -Path "Encrypted Images.{2559a1f2-21d7-11d4-bdaf-00c04f60b9f0}" -NewName "Decrypted Images"
if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Force -Path $destinationPath | Out-Null
}
Add-Type -A 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipFile]::ExtractToDirectory($sourcePath, $destinationPath)
Remove-Item -Path $sourcePath
