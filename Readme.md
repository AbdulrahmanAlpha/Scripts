# 🚀 Setup-DevSecOpsMachine.ps1

An all-in-one PowerShell script to transform your Windows 10 machine into a **DevSecOps-Ready Beast**.

**Author:** [Abdulrahman A. Muhamad (aka Mr. Alpha)](https://github.com/AbdulrahmanAlpha)

> Streamline your workflow, remove the bloat, and install exactly what you need to conquer DevOps, DevSecOps, and beyond.

---

## ⚙️ What Does This Script Do?

Imagine unboxing a brand-new laptop and running **one script** that:

- Removes all bloatware and Microsoft noise (Edge, Bing, Media Player, and more)
- Enables WSL, Virtualization, Containers, and Developer Mode
- Installs all essential DevOps & DevSecOps tools
- Adds productivity tools like Brave, VLC, 7zip, Notepad++
- Deploys Kali Linux inside WSL automatically
- Applies power tweaks for terminal warriors
- Creates the iconic GodMode folder for full control

---

## 🧠 Why Use It?

Because you’re a **DevSecOps engineer**, not someone wasting hours doing:

- Manual installs
- Feature toggling in Settings
- Googling which apps to uninstall
- Configuring developer environment by hand

This script does all of that in minutes.  
_It’s your fast lane to a clean, powerful, professional DevSecOps machine._

---

## 🔧 Features & Breakdown

### ✅ 1. Run as Administrator
Ensures full access to system-level operations.

### 🧰 2. Enable Essential Windows Features
- WSL & VirtualMachinePlatform
- Containers for Docker
- Developer Mode via Registry

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -All
reg add "HKLM\...\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f
````

---

### 🍫 3. Install Chocolatey (Package Manager)

Chocolatey makes installing apps in Windows as easy as Linux apt/yum.

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

---

### 📦 4. Install DevSecOps & Developer Tools

Automatically installs the latest versions of:

* Git, Node.js, Python, VS Code, Docker, Kubernetes (kubectl), Ansible, Terraform
* Security tools: Wireshark, Nmap, OpenSSL, Postman
* Cloud CLIs: AWS CLI, Azure CLI, GCloud SDK
* Java SDK, Oh-My-Posh, Brave, VLC, Notepad++

```powershell
$packages = @("git", "python", "nodejs-lts", ..., "gcloudsdk")
foreach ($pkg in $packages) {
    choco install $pkg -y --ignore-checksums
}
```

---

### 🗑️ 5. Remove Microsoft Bloatware

No more Xbox, Bing, Weather, Edge, or 3D Viewer clutter.

```powershell
$appList = @("Microsoft.BingWeather", ..., "Microsoft.MSPaint")
foreach ($app in $appList) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
}
```

---

### 🐉 6. Install Kali Linux on WSL

SecOps starts with a proper distro. This script installs Kali from official Microsoft URL.

```powershell
Invoke-WebRequest -Uri https://aka.ms/wsl-kali-linux-new -OutFile "$env:USERPROFILE\Downloads\kali.appx"
Add-AppxPackage -Path "$env:USERPROFILE\Downloads\kali.appx"
```

Then sets Kali as default distro for WSL2.

---

### ⚡ 7. Power Tweaks for Pros

* Show hidden files and file extensions
* Enable Windows Terminal v2
* Create “God Mode” folder for full system control

```powershell
Set-ItemProperty -Path "HKCU:\...\Explorer\Advanced" -Name Hidden -Value 1
New-Item -Path "$env:USERPROFILE\Desktop\GodMode.{ED7BA470...}" -ItemType Directory -Force
```

---

## 🖥️ How to Run

1. Open PowerShell **as Administrator**
2. Run the script:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\Setup-DevSecOpsMachine.ps1
```

---

## 🧼 Final Cleanup

The script automatically removes temporary `.appx` files after installation.

---

## ✅ Final Note

After the script completes:

* Restart your PC
* Open Terminal (Windows Terminal or PowerShell Core)
* Start working in your ready-to-roll DevSecOps environment

---

### 💡 Tip:

Want to convert the script into a `.exe`?

```powershell
Install-Module -Name ps2exe
Invoke-ps2exe -inputFile "Setup-DevSecOpsMachine.ps1" -outputFile "SetupDevSecOps.exe"
```

---

## 📬 Feedback & Contributions

Feel free to open issues or PRs on [GitHub](https://github.com/AbdulrahmanAlpha)

> You build systems to scale. Now build your system the same way.
