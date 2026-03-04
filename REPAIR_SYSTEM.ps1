# Emergency System Repair Script
# Run as Administrator

Write-Host "=== SYSTEM REPAIR SCRIPT ===" -ForegroundColor Cyan

# 1. Check and repair system files
Write-Host "`n[1/5] Checking system integrity..." -ForegroundColor Yellow
sfc /scannow

# 2. Repair Windows Component Store
Write-Host "`n[2/5] Repairing component store..." -ForegroundColor Yellow
DISM /Online /Cleanup-Image /RestoreHealth

# 3. Reset Windows Store
Write-Host "`n[3/5] Resetting Windows Store..." -ForegroundColor Yellow
Get-AppxPackage *WindowsStore* | Reset-AppxPackage
wsreset.exe -i 2>$null
Start-Sleep 5

# 4. Re-register all built-in apps
Write-Host "`n[4/5] Re-registering built-in apps..." -ForegroundColor Yellow
Get-AppxPackage -AllUsers | Foreach-Object {
    Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue
}

# 5. Reset critical services
Write-Host "`n[5/5] Resetting services..." -ForegroundColor Yellow
Set-Service wuauserv -StartupType Automatic
Restart-Service wuauserv -Force
Set-Service BITS -StartupType Automatic
Restart-Service BITS -Force

Write-Host "`n=== REPAIR COMPLETE ===" -ForegroundColor Green
Write-Host "Reboot recommended." -ForegroundColor Red
