# Backup Current Git Configuration
# Run this before using deploy_sprints.ps1 to save your current setup

Write-Host "💾 Backing up current git configuration..." -ForegroundColor Blue

# Create backup directory if it doesn't exist
$backupDir = "git_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# Backup current remote configuration  
$currentRemote = git remote get-url origin
$currentRemote | Out-File -FilePath "$backupDir\original_remote.txt"
Write-Host "✅ Current remote saved: $currentRemote" -ForegroundColor Green

# Backup current branches
git branch -a > "$backupDir\branches.txt"
Write-Host "✅ Branches backed up" -ForegroundColor Green

# Backup recent commit history
git log --oneline -20 > "$backupDir\recent_commits.txt" 
Write-Host "✅ Recent commits backed up" -ForegroundColor Green

# Create restoration script
$restoreScript = @"
# Git Restoration Script
# Generated on $(Get-Date)

Write-Host "🔄 Restoring original git configuration..." -ForegroundColor Blue

# Restore original remote
git remote set-url origin $currentRemote
if ($$LASTEXITCODE -eq 0) {
    Write-Host "✅ Remote restored to: $currentRemote" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to restore remote" -ForegroundColor Red
}

Write-Host "✅ Restoration completed!" -ForegroundColor Green
"@

$restoreScript | Out-File -FilePath "$backupDir\restore_original.ps1"

Write-Host "`n📁 Backup created in: $backupDir" -ForegroundColor Magenta
Write-Host "🔄 To restore original setup later, run: .\$backupDir\restore_original.ps1" -ForegroundColor Yellow
Write-Host "`n✅ Backup completed! You can now safely run deploy_sprints.ps1" -ForegroundColor Green