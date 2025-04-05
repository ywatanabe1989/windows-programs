# Define the folder path and user
$folderPath = "C:\Program Files (x86)\ywatanabe"
$user = "wyusu"  # Replace this with the actual username

# Define the permissions to grant
$permissions = "F"  # F for Full control (Read, Write, Execute)

# Run icacls to grant the specified permissions
try {
    # Correctly pass the user and permissions as part of the command
    icacls $folderPath /grant "${user}:${permissions}" /T

    Write-Host "Permissions successfully changed for $folderPath"
} catch {
    Write-Host "Failed to change permissions: $_"
}
