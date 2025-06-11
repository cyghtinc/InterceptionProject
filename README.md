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
