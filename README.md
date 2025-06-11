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

🛠️ Parameters
Parameter	Type	Default	Description
-RenameExisting	Switch	False	Renames all existing files in SYSVOL at startup.
-MonitorNew	Switch	True	Monitors for new files and renames them automatically.
-Interval	Integer	3	Number of seconds between each scan cycle.

📄 Example Log Output
pgsql
Copy
Edit
2025-06-11 13:00:01 - Renamed existing file: 'startup.bat' → 'startupaa.bat'
2025-06-11 13:00:04 - Renamed new file: 'malicious.vbs' → 'maliciousaa.vbs'
2025-06-11 13:00:07 - Failed to rename new file 'policy.ps1': Access to the path is denied.
Logs are saved in sysvol_monitor.log in the same directory as the script.

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
