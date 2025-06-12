param(
    [switch]$RenameExisting,
    [switch]$MonitorNew,
    [int]$Interval,
    [string]$SysvolPath,
    [switch]$Recursive
)

# Set defaults if no switches are provided
if (-not ($PSBoundParameters.Count)) {
    $RenameExisting = $true
    $MonitorNew = $true
    $Interval = 3
    $Recursive = $true
}

# Set interval default if not provided
if (-not $Interval) { $Interval = 3 }

# Set target SYSVOL path
if (-not $SysvolPath) {
    try {
        $domain = ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()).Name
        $SysvolPath = "\\$domain\SYSVOL"
        if (-not $PSBoundParameters.ContainsKey("Recursive")) {
            $Recursive = $true
        }
    } catch {
        Write-Error "Unable to determine domain FQDN. Are you connected to a domain?"
        exit
    }
}

# Set up logging
$logFile = "$PSScriptRoot\sysvol_monitor.log"
function Log {
    param ($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

Log "=== Script started ==="
Log "Monitoring path: $SysvolPath"
Log "RenameExisting: $RenameExisting | MonitorNew: $MonitorNew | Interval: $Interval | Recursive: $Recursive"

$knownFiles = @{}

# Choose file discovery mode
function Get-Files {
    param ($path)
    if ($Recursive) {
        return Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue
    } else {
        return Get-ChildItem -Path $path -File -ErrorAction SilentlyContinue
    }
}

# Rename a file with 'aa' if not already done
function Rename-FileSafely {
    param ($file)
    $fullPath = $file.FullName
    $newName = "$($file.BaseName)aa$($file.Extension)"
    if ($file.Name -ne $newName) {
        try {
            Rename-Item -Path $fullPath -NewName $newName -ErrorAction Stop
            Log "Renamed file: '$($file.Name)' → '$newName'"
        } catch {
            Log "Error renaming file '$($file.Name)': $_"
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
        Log "Error during existing file scan: $_"
    }
}

# Monitor loop for new files
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
