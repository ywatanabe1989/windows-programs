
# Run this script as Administrator

# Stop any running SigmaPlot processes
Get-Process *sigmaplot* -ErrorAction SilentlyContinue | Stop-Process -Force

# Remove SigmaPlot installation directory
$installDir = "C:\Program Files (x86)\SigmaPlot*"
Remove-Item -Path $installDir -Recurse -Force -ErrorAction SilentlyContinue

# Remove SigmaPlot data in AppData
$appDataLocal = "$env:LOCALAPPDATA\Systat Software"
$appDataRoaming = "$env:APPDATA\Systat Software"
Remove-Item -Path $appDataLocal -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $appDataRoaming -Recurse -Force -ErrorAction SilentlyContinue

# Remove SigmaPlot registry entries
$registryPaths = @(
    "HKLM:\SOFTWARE\Systat Software",
    "HKLM:\SOFTWARE\WOW6432Node\Systat Software Inc.",
    "HKCU:\Software\Systat Software"
)


foreach ($path in $registryPaths) {
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
}


# Remove Start Menu shortcuts
$startMenuPaths = @(
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\SigmaPlot*",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\SigmaPlot*"
)

foreach ($path in $startMenuPaths) {
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
}



# Remove Desktop shortcuts
$desktopPath = [Environment]::GetFolderPath("Desktop")
Remove-Item -Path "$desktopPath\SigmaPlot*.lnk" -Force -ErrorAction SilentlyContinue

# Clean up temp files
Remove-Item -Path "$env:TEMP\SigmaPlot*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "SigmaPlot remnants have been removed. Please restart your computer for changes to take full effect."

# Function to recursively search and remove registry keys containing "sigmaplot"
function Remove-SigmaPlotRegistry {
    param (
        [Parameter(Mandatory=$true)]
        [Microsoft.Win32.RegistryKey]$Root,
        [string]$Path = ""
    )

    $subKeys = $Root.OpenSubKey($Path).GetSubKeyNames()

    foreach ($key in $subKeys) {
        $fullPath = if ($Path) { "key" } else { $key }

        if ($key -match "sigmaplot" -or $fullPath -match "sigmaplot") {
            Write-Host "Removing: $($Root.Name)\$fullPath"
            Remove-Item -Path "$($Root.Name)\$fullPath" -Recurse -Force -ErrorAction SilentlyContinue
        } else {
            Remove-SigmaPlotRegistry -Root $Root -Path $fullPath
        }
    }

    # Check and remove values in the current key
    $values = $Root.OpenSubKey($Path).GetValueNames()
    foreach ($value in $values) {
        if ($value -match "sigmaplot") {
            Write-Host "Removing value: $($Root.Name)\value"
            Remove-ItemProperty -Path "$($Root.Name)\$Path" -Name $value -Force -ErrorAction SilentlyContinue
        }
    }
}
