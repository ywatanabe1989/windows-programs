# Load the required assembly
Add-Type -AssemblyName System.Windows.Forms

# Define the target application name (part of its window title)
$appTitle = "Your Application Name"  # Replace with your target application's window title

# Wait for the application to be running
while (-not (Get-Process | Where-Object { $_.MainWindowTitle -like "*$appTitle*" })) {
    Start-Sleep -Seconds 1
}

# Bring the application to the foreground
$wshell = New-Object -ComObject wscript.shell
$wshell.AppActivate($appTitle)

# Wait a moment to ensure the application is ready
Start-Sleep -Seconds 2

# Send the password using SendKeys
$password = "1234"
[System.Windows.Forms.SendKeys]::SendWait($password)
