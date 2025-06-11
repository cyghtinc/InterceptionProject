# InterceptionProject
Stopping Ransomware in real-time
# SYSVOL Watchdog 🛡️  
> **Real-time File Monitor for SYSVOL – Rename suspicious or unauthorized files before ransomware spreads.**

---

## 🔥 Why This Tool?

Ransomware attacks often begin by dropping malicious scripts or policies in the `\\<domain>\SYSVOL` share. These files can automatically execute via GPO or login scripts, affecting the entire network. This tool **monitors the SYSVOL share in real time**, and **renames any new files** before they can execute — effectively **disrupting the attack chain**.

## 🧠 How It Works

- Automatically identifies the domain’s FQDN and accesses `\\<domain>\SYSVOL`.
- **Renames any new files** every 3 seconds by appending `"aa"` to the filename (e.g., `logon.vbs` → `logonaa.vbs`).
- Optionally, renames existing files at startup.
- Runs continuously in the background to **halt ransomware propagation**.
- Logs every action and error for traceability.

---

## ⚙️ Usage

```powershell
# Run with all features (default behavior)
.\sysvol-monitor.ps1

# Run and only rename existing files in SYSVOL
.\sysvol-monitor.ps1 -RenameExisting

# Run and only monitor new files
.\sysvol-monitor.ps1 -MonitorNew

# Run and set custom scan interval (in seconds)
.\sysvol-monitor.ps1 -RenameExisting -MonitorNew -Interval 10



🛡️ Security Use Case: Ransomware Defense
This tool acts as an automated containment control:

Stops ransomware from leveraging SYSVOL as a launch point.

Prevents execution of new scripts or GPO-injected files.

Buys critical response time for the SOC/IR team to investigate.

Can be run temporarily or 24/7 on critical servers or a jump host.

📦 Deployment Options
Scheduled Task: Automatically launch the script at system boot.

Windows Service: Convert using tools like nssm or winser.

GPO Startup Script: Deploy to multiple machines for layered protection.

📋 Requirements
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
