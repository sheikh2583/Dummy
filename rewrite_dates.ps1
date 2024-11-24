param(
    [switch]$DryRun = $false
)

Write-Host "Git History Date Rewrite Script" -ForegroundColor Magenta
Write-Host "===============================" -ForegroundColor Magenta

if (-not (Test-Path ".git")) {
    Write-Error "Not in a git repository!"
    exit 1
}

# Define the sprint dates we want to assign to existing commits
$targetDates = @(
    "2024-11-24 09:30:00",
    "2024-11-25 14:15:00", 
    "2024-11-27 10:45:00",
    "2024-11-28 16:20:00",
    "2024-11-30 11:10:00",
    "2024-12-01 09:40:00",
    "2024-12-02 15:30:00",
    "2024-12-04 13:25:00",
    "2024-12-05 10:15:00",
    "2024-12-06 16:50:00",
    "2024-12-07 14:35:00"
)

# Get the list of commits in reverse order (oldest first)
Write-Host "Getting commit list..." -ForegroundColor Blue
$commits = git log --reverse --pretty=format:"%H" | Where-Object { $_ -ne "" }

Write-Host "Found $($commits.Count) commits to rewrite" -ForegroundColor Green

if ($DryRun) {
    Write-Host "[DRY RUN] Would rewrite these commits:" -ForegroundColor Yellow
    for ($i = 0; $i -lt [Math]::Min($commits.Count, $targetDates.Count); $i++) {
        $shortHash = $commits[$i].Substring(0, 7)
        Write-Host "  $shortHash -> $($targetDates[$i])" -ForegroundColor Cyan
    }
    exit 0
}

Write-Host "Creating date rewrite script..." -ForegroundColor Blue

# Create a temporary environment script for git filter-branch
$filterScript = @"
# Extract commit hash from GIT_COMMIT
case `$GIT_COMMIT in
"@

for ($i = 0; $i -lt [Math]::Min($commits.Count, $targetDates.Count); $i++) {
    $filterScript += "`n    $($commits[$i]))"
    $filterScript += "`n        export GIT_AUTHOR_DATE=`"$($targetDates[$i])`""
    $filterScript += "`n        export GIT_COMMITTER_DATE=`"$($targetDates[$i])`""
    $filterScript += "`n        ;;"
}

$filterScript += "`nesac"

# Save the filter script
$filterScript | Out-File -FilePath "temp_filter.sh" -Encoding UTF8

Write-Host "Running git filter-branch..." -ForegroundColor Magenta
Write-Host "This may take a while..." -ForegroundColor Yellow

# Run git filter-branch
git filter-branch --env-filter "$(Get-Content 'temp_filter.sh' -Raw)" --force

# Clean up
Remove-Item "temp_filter.sh" -ErrorAction SilentlyContinue

Write-Host "Pushing rewritten history..." -ForegroundColor Blue
git push origin main --force

Write-Host "History rewrite completed!" -ForegroundColor Green
Write-Host "Check the repository: https://github.com/sheikh2583/Dummy.git" -ForegroundColor Blue