# InterceptionProject
Stopping Ransomware in real-time
# SYSVOL Watchdog 🛡️  
> **Real-time File Monitor for SYSVOL – Rename suspicious or unauthorized files before ransomware spreads.**

---

## 🔥 Why This Tool?

Ransomware actors often abuse the `\\<domain>\SYSVOL` share to drop and spread malicious scripts via GPO or login mechanisms. Once a file lands in SYSVOL, it may automatically execute on multiple endpoints.  
**SYSVOL Watchdog** prevents that by **renaming new and existing files in real time**, disrupting the attack and halting its spread.

---

## 🧠 How It Works

- Automatically determines the current domain and targets the default SYSVOL share (`\\<domain>\SYSVOL`), unless a custom path is provided.
- **Renames any new files** by adding `"aa"` to the base name (e.g., `start.ps1` → `startaa.ps1`).
- Optionally renames **existing files** at startup.
- **Can target specific subfolders** within SYSVOL using `-SysvolPath`.
- **Recursive scanning** can be enabled or disabled with the `-Recursive` switch.
- Logs every action and error to a local `.log` file.

---

## ⚙️ Usage

```powershell
# Default behavior – renames both new and existing files recursively in default SYSVOL
.\sysvol-monitor.ps1

# Rename only existing files at startup
.\sysvol-monitor.ps1 -RenameExisting

# Monitor only new files (every 5 seconds)
.\sysvol-monitor.ps1 -MonitorNew -Interval 5

# Target specific SYSVOL subfolder (non-recursive)
.\sysvol-monitor.ps1 -SysvolPath "\\corp.local\SYSVOL\corp.local\Policies" -Recursive

# Rename existing and monitor new files in a custom SYSVOL folder (recursively)
.\sysvol-monitor.ps1 -SysvolPath "\\corp.local\SYSVOL\corp.local\Scripts" -RenameExisting -MonitorNew -Recursive


## 🛠️ Parameters

| Parameter        | Type     | Default                     | Description |
|------------------|----------|-----------------------------|-------------|
| `-RenameExisting` | Switch   | False                       | Renames all existing files in the target folder at startup. |
| `-MonitorNew`     | Switch   | True (if no params passed)  | Monitors for new files and renames them. |
| `-Interval`       | Integer  | 3                           | How often to scan for new files (in seconds). |
| `-SysvolPath`     | String   | `\\<domain>\SYSVOL`         | Custom path to scan, such as a subfolder inside SYSVOL. |
| `-Recursive`      | Switch   | **False**                   | Whether to scan subfolders inside the target path. |




## 🛡️ Security Use Case: Ransomware Defense
This tool acts as an automated containment control:

Stops ransomware from leveraging SYSVOL as a launch point.

Prevents execution of new scripts or GPO-injected files.

Buys critical response time for the SOC/IR team to investigate.

Can be run temporarily or 24/7 on critical servers or a jump host.

## 📦 Deployment Options
Scheduled Task: Automatically launch the script at system boot.

Windows Service: Convert using tools like nssm or winser.

GPO Startup Script: Deploy to multiple machines for layered protection.

## 📋 Requirements
PowerShell 5.1+

Domain-joined machine

Read/write permissions to \\<domain>\SYSVOL

🚨 Important Notes
The script does not delete files — it only renames them for safety and traceability.

Only files are renamed. Directories are not affected.

Use caution when running this tool in production. It may interfere with legitimate scripts if not coordinated with IT/DevOps.

🤝 Contributing
Pull requests and feature suggestions are welcome. If you found this useful in stopping an actual threat, we’d love to hear your story!

📜 License
MIT License
