
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "\\wsl.localhost\Ubuntu\home\ywatanabe\"
$watcher.Filter = "*.ln"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    $path = $Event.SourceEventArgs.FullPath
    $target = Get-Content $path
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($path.Replace(".ln", ".lnk"))
    $shortcut.TargetPath = $target -replace "^/", "\\wsl.localhost\Ubuntu\"
    $shortcut.Save()
}

Register-ObjectEvent $watcher "Created" -Action $action

# To allow script to be stopped
while ($true) { Start-Sleep -Seconds 1 }
