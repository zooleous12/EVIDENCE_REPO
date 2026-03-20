# Evidence Extraction Notes from theshow.txt

## File Overview
- 4,946 lines total
- Log of a malware investigation/cleanup session on Windows system
- AI assistant used: Kimi/Kiro (via Kimi CLI)
- User: Charles Kendrick (cckendrick@ksu.edu), Maricopa AZ
- Session covers: BitLocker decryption, malware discovery, UEFI bootkit removal, evidence preservation

## Key Evidence Items Found

### 1. BitLocker Decryption (Lines 1-21)
- D: drive was encrypted with XTS-AES 128
- Decrypted using manage-bde command
- Key protectors: Numerical + External

### 2. mmc.exe.config Hijacking (Lines 23-921)
- mmc.exe.config was blocking access to Windows Management Console
- Classic "Living Off The Land" technique
- mmc.exe itself legitimate (SHA256: 35791f1dbd343a5a46a3a18100e2e85c1df83085053e07deae56d46132f982af)
- mmc.exe.config was the hijacker - renamed to .old then deleted

### 3. Evidence Files Found (Lines 392-509)
- Location: C:\Users\freeb\OneDrive\Desktop\copilot.microsoft.com\static\edge\assets\123\manyes - Copy - Copy\
- UNLOCKED_EVIDENCE_DECODED.json
- UNLOCKED_EVIDENCE_ENCODED.base64
- UNLOCKED_EVIDENCE_STEGANOGRAPHY.png
- tmpDFF8.tmp.py (steganography payload with personal data)
- decode.py (steganography decoder)
- Git-repository--ffb222a86dc6c7c423b1d4bd2daeb3e93f5d7968.zip (Copilot injection evidence, Dec 21 2025)
- Evidence_Report.pdf
- Manus_Timeline_Evidence.pdf

### 4. Critical Findings
- **IP Theft**: Lecture Me AI platform source code stolen
- **Commercial Secrets**: .env files with DB configs, payment processing
- **Trap Files**: signature-replacement.man - re-establishes access when opened
- **Surveillance**: Personal profile data embedded (Charles Kendrick, Maricopa AZ)
- **Steganography**: Hidden data in PNG files

### 5. Evidence Accidentally Deleted & Recovered (Lines 621-821)
- AI accidentally deleted 19 evidence files and 4 directories
- Recovered from shadow copy (2/28/2026 12:02:08 PM)
- Secured in CHARLES_KENDRICK_CASE_EVIDENCE_SECURE.zip (3.18 MB)
- Backup: CHARLES_KENDRICK_CASE_EVIDENCE_BACKUP.zip

### 6. Hidden System Folders / Rootkit Evidence (Lines 924+)
- Malware hiding in PNG file on corrupted drive
- Took over C:\$(something) locked above root
- Hidden system folders: $Recycle.Bin, $WINDOWS.~BT, $WinREAgent

## Still need to read: Lines 963-4946 (already read 4238-4946 earlier)
## Key sections still to extract: Lines 963-4237
