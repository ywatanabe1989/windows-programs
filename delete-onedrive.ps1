# Run this script as Administrator

# Stop OneDrive process if it's running
Get-Process onedrive -ErrorAction SilentlyContinue | Stop-Process -Force

# Uninstall OneDrive
$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
If (!(Test-Path $onedrive)) {
    $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
}
Start-Process $onedrive "/uninstall" -NoNewWindow -Wait

# Remove OneDrive leftovers
Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "C:\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue

# Remove OneDrive from the Explorer Side Panel
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Force -Recurse -ErrorAction SilentlyContinue

# Reset default user folders
$folders = @("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")

foreach ($folder in $folders) {
    $path = [Environment]::GetFolderPath($folder)
    $defaultPath = "C:\Users\folder"

    if ($path -ne $defaultPath) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $folder -Value $defaultPath
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name $folder -Value $defaultPath
    }

    # Move files from old location to new location
    if (Test-Path $path) {
        Move-Item -Path "$path\*" -Destination $defaultPath -Force -ErrorAction SilentlyContinue
    }
}

# Refresh environment
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "OneDrive has been removed and default folders have been reset. Please restart your computer for changes to take full effect."
