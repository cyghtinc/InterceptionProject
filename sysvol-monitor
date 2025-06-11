param(
    [switch]$RenameExisting,
    [switch]$MonitorNew,
    [int]$Interval
)

# Set defaults if no switches provided
if (-not ($PSBoundParameters.ContainsKey('RenameExisting') -or $PSBoundParameters.ContainsKey('MonitorNew') -or $PSBoundParameters.ContainsKey('Interval'))) {
    $RenameExisting = $true
    $MonitorNew = $true
    $Interval = 3
} else {
    if (-not $PSBoundParameters.ContainsKey('Interval')) {
        $Interval = 3
    }
}

# Get domain FQDN and SYSVOL path
try {
    $domain = ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()).Name
    $sysvolPath = "\\$domain\SYSVOL"
} catch {
    Write-Error "Unable to determine domain FQDN. Are you connected to a domain?"
    exit
}

# Setup logging
$logFile = "$PSScriptRoot\sysvol_monitor.log"
function Log {
    param ($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

Log "=== Script started ==="
Log "Domain: $domain"
Log "RenameExisting: $RenameExisting | MonitorNew: $MonitorNew | Interval: $Interval seconds"

$knownFiles = @{}

# Rename existing files
if ($RenameExisting) {
    try {
        Get-ChildItem -Path $sysvolPath -Recurse -File | ForEach-Object {
            $fullPath = $_.FullName
            $knownFiles[$fullPath] = $true

            $newName = "$($_.BaseName)aa$($_.Extension)"
            if ($_.Name -ne $newName) {
                try {
                    Rename-Item -Path $fullPath -NewName $newName -ErrorAction Stop
                    Log "Renamed existing file: '$($_.Name)' → '$newName'"
                } catch {
                    Log "Failed to rename existing file '$($_.Name)': $_"
                }
            }
        }
    } catch {
        Log "Error listing existing files: $_"
    }
}

# Monitor and rename new files
if ($MonitorNew) {
    while ($true) {
        try {
            Get-ChildItem -Path $sysvolPath -Recurse -File -ErrorAction Stop | ForEach-Object {
                $fullPath = $_.FullName
                if (-not $knownFiles.ContainsKey($fullPath)) {
                    $knownFiles[$fullPath] = $true

                    $newName = "$($_.BaseName)aa$($_.Extension)"
                    if ($_.Name -ne $newName) {
                        try {
                            Rename-Item -Path $fullPath -NewName $newName -ErrorAction Stop
                            Log "Renamed new file: '$($_.Name)' → '$newName'"
                        } catch {
                            Log "Failed to rename new file '$($_.Name)': $_"
                        }
                    }
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
