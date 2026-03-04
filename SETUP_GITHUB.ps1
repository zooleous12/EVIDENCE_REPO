# GitHub Setup Script
# Run this in your elevated PowerShell to push to GitHub

$RepoPath = "C:\Users\Charles Kendrick\Documents\EVIDENCE_REPO"
Set-Location $RepoPath

Write-Host "=== GITHUB SETUP ===" -ForegroundColor Cyan
Write-Host ""

# Get GitHub username
$GitHubUser = Read-Host "Enter your GitHub username"
$RepoName = Read-Host "Enter repository name (or press Enter for 'firmware-rootkit-evidence')"
if ([string]::IsNullOrWhiteSpace($RepoName)) {
    $RepoName = "firmware-rootkit-evidence"
}

$RemoteUrl = "https://github.com/$GitHubUser/$RepoName.git"

Write-Host ""
Write-Host "Setting up remote: $RemoteUrl" -ForegroundColor Yellow

# Check if remote already exists
$existingRemote = git remote -v 2>$null
if ($existingRemote -match "origin") {
    Write-Host "Remote 'origin' already exists. Removing..." -ForegroundColor Red
    git remote remove origin
}

# Add remote
git remote add origin $RemoteUrl
git branch -M main

Write-Host ""
Write-Host "=== READY TO PUSH ===" -ForegroundColor Green
Write-Host "Repository: $RemoteUrl"
Write-Host ""
Write-Host "Files to push:"
git ls-files | ForEach-Object { Write-Host "  - $_" }
Write-Host ""

$confirm = Read-Host "Push to GitHub now? (y/n)"
if ($confirm -eq 'y' -or $confirm -eq 'Y') {
    Write-Host "Pushing..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ SUCCESS! Evidence pushed to:" -ForegroundColor Green
        Write-Host "   $RemoteUrl" -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "❌ PUSH FAILED" -ForegroundColor Red
        Write-Host "Possible reasons:"
        Write-Host "  - Repository doesn't exist on GitHub yet"
        Write-Host "  - Authentication required (use Personal Access Token)"
        Write-Host "  - Network connectivity issues"
        Write-Host ""
        Write-Host "To create repo, visit:"
        Write-Host "   https://github.com/new" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
