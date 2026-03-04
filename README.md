# FIRMWARE-LEVEL ROOTKIT INCIDENT

**Date:** 2026-03-04  
**Victim:** chillbra (Dell Laptop)  
**Classification:** CRITICAL - UEFI/SPI Flash Rootkit  

---

## ⚠️ EXECUTIVE SUMMARY

System compromised by **firmware-level malware** that:
- Survives OS reinstallation
- Collects system intelligence while offline
- Exfiltrates via HTTP to external C2
- Blocks security tools and recovery mechanisms

---

## 🔴 INDICATORS OF COMPROMISE (IOCs)

### C2 Infrastructure
| Type | Value | Port | Protocol |
|------|-------|------|----------|
| IPv4 | `216.74.105.201` | 80 | HTTP |

### Malicious Processes
| Process Name | PID | Path | Status |
|--------------|-----|------|--------|
| `Dell.TechHub.Instrumentation.SubAgent` | 7720 | **NULL** - Hollowed | Injected |
| `svchost.exe` | 14376 | **NULL** - Hollowed | C2 Beacon |

### File Indicators (Data Collection)
All created in `C:\Users\Charles Kendrick\Documents\`:

```
6766.txt               (443 KB)  - WMI repository dump
cameradevicemft.csv    (16 KB)   - Camera device data
firerlz.xml            (2.1 MB)  - Firewall rules
firerulez.evtx         (1.1 MB)  - Firewall events
firerulz.txt           (505 KB)  - Firewall analysis
frameserver.csv        (65 KB)   - Frame server data
ker-shimop.csv         (55 KB)   - Kerberos shim operations
kerstreamop.csv        (1.2 KB)  - Kerberos stream data
ntfs.xml               (3.3 MB)  - NTFS metadata
part.xml               (228 KB)  - Partition info
partition.csv          (3.3 KB)  - Disk partitions
stporrt.xml            (766 KB)  - Storage ports
telm.xml               (211 KB)  - Telemetry data
time.xml               (82 KB)   - Time sync data
trerremotecon.xml      (16 KB)   - Remote connections
usbvid.xml             (1.1 MB)  - USB device history
volsnap.xml            (427 KB)  - Volume shadow copies
webauth.xml            (116 KB)  - Web authentication
werpayload.xml         (28 KB)   - Error reporting data
wmi.txt                (443 KB)  - WMI dump
```

### System Information
```
Hostname:     CHILLBRA
OS:           Windows 11 (Build 26100)
BIOS:         Dell Inc. 1.27.1 (2025-12-12)
Motherboard:  Dell Inc. 0FPD87 A00
Serial:       1WMW944
Primary User: chillbra\charles kendrick
```

---

## 📊 ATTACK TIMELINE

| Time | Event |
|------|-------|
| 2026-03-03 23:52 | Dell.TechHub processes spawned (infection time) |
| 2026-03-04 02:22 | Data collection begins (19 recon files) |
| 2026-03-04 15:45 | Active C2 connection established to 216.74.105.201 |
| 2026-03-04 15:55 | HTTP exfiltration over port 80 detected |

---

## 🎯 EXFILTRATED DATA ANALYSIS

The malware collected comprehensive system intelligence:

1. **Network Security:** Firewall rules, exceptions, allowed ports
2. **Authentication:** Kerberos tickets, stream operations
3. **Storage:** NTFS structure, partitions, volume shadow copies
4. **Peripherals:** USB device history, camera devices
5. **System Management:** WMI repository (full dump)
6. **Remote Access:** Connection history, terminal services
7. **Credentials:** Web authentication tokens
8. **Telemetry:** Windows diagnostics data

---

## 🛡️ DEFENSIVE RECOMMENDATIONS

### Immediate (Within 1 Hour)
1. **DISCONNECT** from internet
2. **BLOCK** IP `216.74.105.201` at firewall
3. **KILL** PIDs 7720 and 14376
4. **PRESERVE** evidence files before cleanup

### Short Term (Within 24 Hours)
1. **FLASH BIOS** with clean firmware from Dell
2. **REINSTALL** Windows from trusted media
3. **CHANGE ALL PASSWORDS** (credentials compromised)

### Long Term
1. Monitor network for beaconing to 216.74.0.0/16
2. Enable Secure Boot with custom keys
3. Implement TPM attestation
4. Network segmentation for critical systems

---

## 🧰 TOOLS IN THIS REPO

| Tool | Purpose |
|------|---------|
| `FIRMWARE_MONITOR.ps1` | Continuous monitoring for hollowed processes |
| `MALWARE_CHECK.ps1` | Persistence mechanism scanner |
| `REPAIR_SYSTEM.ps1` | System component repair |
| `INCIDENT_REPORT.json` | Full machine-readable incident data |

---

## 📞 CONTACT

If you have information about this attack:
- This appears to be an APT-level campaign
- Targeting appears intentional (firmware-level sophistication)
- C2 infrastructure may be part of larger botnet

---

## ⚖️ LEGAL NOTICE

This repository contains evidence of a cyber attack.
All data was collected from the victim's own system.
Shared for defensive and educational purposes.
