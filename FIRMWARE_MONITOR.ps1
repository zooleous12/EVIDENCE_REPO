# Firmware-Level Rootkit Monitor
# Run as Administrator - This will loop every 2 minutes

$LogFile = "C:\Users\Charles Kendrick\Documents\THREAT_LOG_$(Get-Date -Format 'yyyyMMdd_HHmm').txt"

function Write-ThreatLog($Message, $Color = "White") {
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] $Message"
    Write-Host $LogEntry -ForegroundColor $Color
    Add-Content -Path $LogFile -Value $LogEntry
}

Write-ThreatLog "=== FIRMWARE ROOTKIT MONITOR STARTED ===" "Cyan"
Write-ThreatLog "Logging to: $LogFile" "Gray"

# Known good baseline (update these with your clean values)
$KnownGoodProcesses = @{
    "svchost.exe" = @("C:\Windows\System32\svchost.exe", "C:\Windows\SysWOW64\svchost.exe")
    "lsass.exe" = "C:\Windows\System32\lsass.exe"
    "services.exe" = "C:\Windows\System32\services.exe"
    "csrss.exe" = "C:\Windows\System32\csrss.exe"
}

$SuspiciousRemoteIPs = @("216.74.105.201")

while ($true) {
    Write-ThreatLog "`n--- Scan Cycle $(Get-Date -Format 'HH:mm:ss') ---" "Yellow"
    
    # 1. Check for hollowed processes (no path)
    Write-ThreatLog "[SCAN] Checking for hollowed processes..." "Gray"
    $Hollowed = Get-Process | Where-Object { 
        $_.ProcessName -in @("svchost","lsass","services","csrss","wininit","winlogon") -and 
        [string]::IsNullOrEmpty($_.Path) 
    }
    if ($Hollowed) {
        foreach ($proc in $Hollowed) {
            Write-ThreatLog "[ALERT] HOLLOWED PROCESS: $($proc.ProcessName) (PID: $($proc.Id)) - NO PATH!" "Red"
            Write-ThreatLog "[ACTION] Attempting to kill PID $($proc.Id)..." "Magenta"
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    }
    
    # 2. Check for suspicious network connections
    Write-ThreatLog "[SCAN] Checking network connections..." "Gray"
    $SuspiciousConnections = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue | Where-Object { 
        $_.RemoteAddress -in $SuspiciousRemoteIPs -or
        ($_.RemotePort -eq 80 -and $_.OwningProcess -eq 14376)
    }
    if ($SuspiciousConnections) {
        foreach ($conn in $SuspiciousConnections) {
            $proc = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
            Write-ThreatLog "[ALERT] SUSPICIOUS CONNECTION: $($proc.ProcessName) (PID: $($conn.OwningProcess)) -> $($conn.RemoteAddress):$($conn.RemotePort)" "Red"
        }
    }
    
    # 3. Check for new Dell processes without paths
    Write-ThreatLog "[SCAN] Checking Dell processes..." "Gray"
    $SuspiciousDell = Get-Process | Where-Object { 
        $_.ProcessName -like "*Dell*" -and 
        [string]::IsNullOrEmpty($_.Path)
    }
    if ($SuspiciousDell) {
        foreach ($proc in $SuspiciousDell) {
            Write-ThreatLog "[ALERT] SUSPICIOUS DELL PROCESS: $($proc.ProcessName) (PID: $($proc.Id)) - NO PATH!" "Red"
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    }
    
    # 4. Check for new files in Documents
    Write-ThreatLog "[SCAN] Checking for new recon files..." "Gray"
    $RecentFiles = Get-ChildItem "C:\Users\Charles Kendrick\Documents" -File | Where-Object { 
        $_.Extension -in @('.xml','.csv','.txt','.evtx','.log') -and
        $_.LastWriteTime -gt (Get-Date).AddMinutes(-5)
    }
    if ($RecentFiles) {
        foreach ($file in $RecentFiles) {
            Write-ThreatLog "[ALERT] NEW FILE: $($file.Name) (Size: $([math]::Round($file.Length/1KB,2)) KB)" "Red"
        }
    }
    
    # 5. Check WMI persistence
    Write-ThreatLog "[SCAN] Checking WMI subscriptions..." "Gray"
    $WMIFilters = Get-WmiObject __EventFilter -Namespace root\subscription -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'SCM Event Log Filter' }
    $WMIConsumers = Get-WmiObject __EventConsumer -Namespace root\subscription -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'SCM Event Log Consumer' }
    if ($WMIFilters -or $WMIConsumers) {
        Write-ThreatLog "[ALERT] SUSPICIOUS WMI PERSISTENCE DETECTED!" "Red"
        $WMIFilters | ForEach-Object { Write-ThreatLog "  Filter: $($_.Name)" "Red" }
        $WMIConsumers | ForEach-Object { Write-ThreatLog "  Consumer: $($_.Name) ($($_.__CLASS))" "Red" }
    }
    
    Write-ThreatLog "[STATUS] Scan complete. Sleeping 2 minutes..." "Green"
    Start-Sleep -Seconds 120
}
