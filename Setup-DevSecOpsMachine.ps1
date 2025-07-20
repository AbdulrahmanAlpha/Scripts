<#
.SYNOPSIS
    Setup script for a DevSecOps-ready Windows 10 machine.
.DESCRIPTION
    Removes unnecessary Microsoft apps, installs DevOps/DevSecOps tools,
    enables developer features, and configures the system for power users.
.NOTES
    Author: Abdulrahman A. Muhamad (aka Mr. Alpha)
    
    GitHub: https://github.com/AbdulrahmanAlpha
#>

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrator')) {
    Write-Error "Please run this script as Administrator."
    exit 1
}

# Enable script execution
Set-ExecutionPolicy Bypass -Scope Process -Force

# Enable Windows Features
Write-Host "`n[+] Enabling developer mode, virtualization and WSL..." -ForegroundColor Cyan
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -All
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-For-Linux -NoRestart -All
Enable-WindowsOptionalFeature -Online -FeatureName Containers -NoRestart -All

# Enable Developer Mode
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

# Install Chocolatey
Write-Host "`n[+] Installing Chocolatey package manager..." -ForegroundColor Cyan
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Refresh environment
$env:Path += ";$($env:ProgramData)\chocolatey\bin"

# Install DevSecOps, productivity, and system tools
$packages = @(
    "git", "python", "nodejs-lts", "vscode", "docker-desktop", "kubectl",
    "terraform", "ansible", "powershell-core", "7zip", "vlc", "brave", "oh-my-posh",
    "windows-terminal", "notepadplusplus", "openssl.light", "nmap", "wireshark",
    "postman", "awscli", "azure-cli", "googlechrome", "gcloudsdk", "jdk11"
)

Write-Host "`n[+] Installing DevSecOps & productivity tools via Chocolatey..." -ForegroundColor Cyan
foreach ($pkg in $packages) {
    choco install $pkg -y --ignore-checksums
}

# Remove Unnecessary Microsoft Apps
Write-Host "`n[+] Removing unnecessary Microsoft apps..." -ForegroundColor Cyan
$appList = @(
    "Microsoft.BingWeather", "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.People",
    "Microsoft.SkypeApp", "Microsoft.Xbox.TCUI", "Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider", "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo",
    "Microsoft.MicrosoftEdge", "Microsoft.WindowsFeedbackHub", "Microsoft.WindowsMaps",
    "Microsoft.OneConnect", "Microsoft.MSPaint"
)

foreach ($app in $appList) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | where DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# Install WSL Distro - Kali Linux
Write-Host "`n[+] Installing Kali Linux WSL Distro..." -ForegroundColor Cyan
Invoke-WebRequest -Uri https://aka.ms/wsl-kali-linux-new -OutFile "$env:USERPROFILE\Downloads\kali.appx"
Add-AppxPackage -Path "$env:USERPROFILE\Downloads\kali.appx"

# Optional: Set Kali as default WSL
wsl --set-default-version 2
wsl --set-default kali-linux

# Power user tweaks
Write-Host "`n[+] Applying power user tweaks..." -ForegroundColor Cyan
# Show file extensions, hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0
# Enable Windows Terminal as default
Set-ItemProperty -Path "HKCU:\Console" -Name ForceV2 -Value 1

# Create God Mode folder
Write-Host "`n[+] Creating God Mode folder on Desktop..." -ForegroundColor Cyan
New-Item -Path "$env:USERPROFILE\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" -ItemType Directory -Force

# Cleanup
Write-Host "`n[+] Cleaning up temporary files..." -ForegroundColor Cyan
Remove-Item "$env:USERPROFILE\Downloads\kali.appx" -Force -ErrorAction SilentlyContinue

# Done
Write-Host "`n[✔] DevSecOps Machine setup complete. Please restart your machine." -ForegroundColor Green
