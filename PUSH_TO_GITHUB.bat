@echo off
echo ==========================================
echo PUSH EVIDENCE TO GITHUB
echo ==========================================
echo.

set REPO_PATH=C:\Users\Charles Kendrick\Documents\EVIDENCE_REPO
cd /d "%REPO_PATH%"

echo [1/4] Checking git status...
git status
echo.

echo [2/4] Adding all files...
git add -A
echo.

echo [3/4] Committing changes...
git commit -m "Update evidence - %date% %time%"
echo.

echo [4/4] Pushing to GitHub...
echo.
echo IF THIS IS YOUR FIRST PUSH:
echo 1. Create repo on GitHub first (do NOT initialize with README)
echo 2. Run: git remote add origin https://github.com/YOURNAME/REPO.git
echo 3. Run: git branch -M main
echo.
echo Then push with:
echo    git push -u origin main
echo.
echo Or run this script again after setting remote.
echo.

:: Try to push (will fail if no remote configured)
git push -u origin main 2>nul
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Push failed. You need to configure remote first.
    echo.
    echo To configure, run these commands:
    echo    git remote add origin https://github.com/YOURNAME/firmware-rootkit-evidence.git
    echo    git branch -M main
    echo    git push -u origin main
)

echo.
pause
