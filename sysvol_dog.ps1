param(
    [switch]$RenameExisting,
    [switch]$MonitorNew,
    [int]$Interval,
    [string]$SysvolPath,
    [switch]$Recursive
)

# Set defaults if no switches provided
if (-not $PSBoundParameters.Count) {
    $RenameExisting = $true
    $MonitorNew = $true
    $Interval = 3
    $Recursive = $false
}

# Set interval default if not provided
if (-not $Interval) { $Interval = 3 }

# Set default SYSVOL path if not provided
if (-not $SysvolPath) {
    try {
        $domain = ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()).Name
        $SysvolPath = "\\$domain\SYSVOL"
    } catch {
        Write-Error "Unable to determine domain FQDN. Are you connected to a domain?"
        exit
    }
}

# Set default for recursive if not explicitly provided
if (-not $PSBoundParameters.ContainsKey("Recursive")) {
    $Recursive = $false
}

# Setup logging
$logFile = "$PSScriptRoot\sysvol_monitor.log"
function Log {
    param ($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

Log "=== Script started ==="
Log "Target path: $SysvolPath"
Log "RenameExisting: $RenameExisting | MonitorNew: $MonitorNew | Interval: $Interval sec | Recursive: $Recursive"

$knownFiles = @{}

# File discovery function
function Get-Files {
    param ($path)
    if ($Recursive) {
        return Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue
    } else {
        return Get-ChildItem -Path $path -File -ErrorAction SilentlyContinue
    }
}

# Safe renaming
function Rename-FileSafely {
    param ($file)
    $fullPath = $file.FullName
    $newName = "$($file.BaseName)aa$($file.Extension)"
    if ($file.Name -ne $newName) {
        try {
            Rename-Item -Path $fullPath -NewName $newName -ErrorAction Stop
            Log "Renamed: '$($file.Name)' → '$newName'"
        } catch {
            Log "Rename error on '$($file.Name)': $_"
        }
    }
}

# Rename existing files
if ($RenameExisting) {
    try {
        Get-Files -path $SysvolPath | ForEach-Object {
            $knownFiles[$_.FullName] = $true
            Rename-FileSafely -file $_
        }
    } catch {
        Log "Error processing existing files: $_"
    }
}

# Monitor loop
if ($MonitorNew) {
    while ($true) {
        try {
            Get-Files -path $SysvolPath | ForEach-Object {
                $fullPath = $_.FullName
                if (-not $knownFiles.ContainsKey($fullPath)) {
                    $knownFiles[$fullPath] = $true
                    Rename-FileSafely -file $_
                }
            }
        } catch {
            Log "Monitoring error: $_"
        }
        Start-Sleep -Seconds $Interval
    }
} else {
    Log "Monitoring disabled. Exiting."
}
