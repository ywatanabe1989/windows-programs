# Get-Process -Name "Spw" | Stop-Process -Force

# kill-sigmaplot.ps1
Get-Process -Name "Spw" -ErrorAction SilentlyContinue | Stop-Process -Force

