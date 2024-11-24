param(
    [switch]$DryRun = $false,
    [switch]$Force = $false
)

Write-Host "Musafir 2.0 Sprint History Rewrite Script" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta

if (-not (Test-Path ".git")) {
    Write-Error "Not in a git repository!"
    exit 1
}

$currentRemote = git remote get-url origin
Write-Host "Current remote: $currentRemote" -ForegroundColor Blue

if (-not $Force -and -not $DryRun) {
    $proceed = Read-Host "This will rewrite git history and change remote to https://github.com/sheikh2583/Dummy.git? (y/N)"
    if ($proceed -ne 'y' -and $proceed -ne 'Y') {
        Write-Host "Operation cancelled." -ForegroundColor Red
        exit 0
    }
}

if (-not $DryRun) {
    Write-Host "Changing remote..." -ForegroundColor Blue
    git remote set-url origin https://github.com/sheikh2583/Dummy.git
    Write-Host "Remote changed successfully" -ForegroundColor Green
    
    # Create a clean slate - new orphan branch
    Write-Host "Creating clean history..." -ForegroundColor Blue
    git checkout --orphan temp_branch
    git rm -rf . --quiet
    Write-Host "Clean slate created" -ForegroundColor Green
}

# Define all commits with their exact files
$allCommits = @(
    # Sprint 1: Project Setup
    @{ Date="2024-11-24 09:30"; Message="Initial project setup and configuration"; Files=@("README.md", ".gitignore") },
    @{ Date="2024-11-25 14:15"; Message="Add core project structure"; Files=@(".env.example", "functionalities.txt") },
    @{ Date="2024-11-27 10:45"; Message="Initialize backend package configuration"; Files=@("backend/package.json") },
    @{ Date="2024-11-28 16:20"; Message="Setup project dependencies"; Files=@("backend/config/") },
    @{ Date="2024-11-30 11:10"; Message="Add user model and basic structure"; Files=@("backend/models/User.model.js") },
    @{ Date="2024-12-01 09:40"; Message="Create documentation foundation"; Files=@("docs/QUICK_START_QURAN_HADITH.md") },
    @{ Date="2024-12-02 15:30"; Message="Add functionality specifications"; Files=@("docs/TODO_FUTURE_ENHANCEMENTS.md") },
    @{ Date="2024-12-04 13:25"; Message="Setup development environment"; Files=@("backend/models/") },
    @{ Date="2024-12-05 10:15"; Message="Configure project build system"; Files=@("backend/scripts/") },
    @{ Date="2024-12-06 16:50"; Message="Add basic documentation framework"; Files=@("docs/") },
    @{ Date="2024-12-07 14:35"; Message="Setup backend foundation"; Files=@("backend/") },
    @{ Date="2024-12-08 11:20"; Message="Finalize initial project setup"; Files=@("services/") },
    
    # Sprint 2: Backend Core
    @{ Date="2024-12-09 09:15"; Message="Implement core server setup"; Files=@("backend/server.js") },
    @{ Date="2024-12-10 14:30"; Message="Add user authentication system"; Files=@("backend/controllers/auth.controller.js") },
    @{ Date="2024-12-11 11:45"; Message="Implement authentication middleware"; Files=@("backend/middleware/auth.middleware.js") },
    @{ Date="2024-12-12 16:20"; Message="Add user management controllers"; Files=@("backend/controllers/user.controller.js") },
    @{ Date="2024-12-13 10:10"; Message="Setup routing infrastructure"; Files=@("backend/routes/auth.routes.js") },
    @{ Date="2024-12-14 13:55"; Message="Add authentication routes"; Files=@("backend/routes/user.routes.js") },
    @{ Date="2024-12-16 09:40"; Message="Create build scripts and utilities"; Files=@("backend/scripts/") },
    @{ Date="2024-12-17 15:25"; Message="Add AI services foundation"; Files=@("services/ai/") },
    @{ Date="2024-12-18 12:15"; Message="Setup Hadith JSON processing"; Files=@("hadith-json/package.json") },
    @{ Date="2024-12-19 11:30"; Message="Configure TypeScript build"; Files=@("hadith-json/tsconfig.json") },
    @{ Date="2024-12-20 16:45"; Message="Implement user registration and login"; Files=@("backend/controllers/") },
    @{ Date="2024-12-21 14:20"; Message="Finalize backend core setup"; Files=@("backend/routes/") },
    
    # Sprint 3: Quran Features
    @{ Date="2024-12-23 10:20"; Message="Implement Quran controller and routes"; Files=@("backend/controllers/quran.controller.js") },
    @{ Date="2024-12-26 14:15"; Message="Add Quran data models"; Files=@("backend/models/Quran.model.js") },
    @{ Date="2024-12-28 11:30"; Message="Add Surah metadata handling"; Files=@("backend/models/SurahMetadata.model.js") },
    @{ Date="2025-01-02 09:45"; Message="Integrate Quran verse data"; Files=@("quran/surah/") },
    @{ Date="2025-01-04 15:20"; Message="Add Quran routing system"; Files=@("backend/routes/quran.routes.js") },
    @{ Date="2025-01-06 13:10"; Message="Implement quiz system foundation"; Files=@("backend/controllers/quiz.controller.js") },
    @{ Date="2025-01-08 10:35"; Message="Add quiz routing"; Files=@("backend/routes/quiz.routes.js") },
    @{ Date="2025-01-10 16:25"; Message="Create ML scoring services"; Files=@("services/ml-scoring/") },
    @{ Date="2025-01-12 12:40"; Message="Integrate Tafsir data"; Files=@("new tafseer/") },
    @{ Date="2025-01-14 11:15"; Message="Add Quran translation support"; Files=@("quran/translation/") },
    @{ Date="2025-01-16 14:50"; Message="Add complete Quran data"; Files=@("quran/") },
    @{ Date="2025-01-18 13:30"; Message="Integrate Tazkirul Quran data"; Files=@("tazkirul-quran-en.json/") }
)

function Restore-Files {
    param([string[]]$FilesToRestore)
    
    foreach ($file in $FilesToRestore) {
        if (Test-Path "../temp_backup/$file" -ErrorAction SilentlyContinue) {
            $destDir = Split-Path $file -Parent
            if ($destDir -and -not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force -ErrorAction SilentlyContinue | Out-Null
            }
            Copy-Item "../temp_backup/$file" $file -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
}

function Create-BackdatedCommit {
    param($CommitInfo, $IsDryRun, $CommitNumber, $TotalCommits)
    
    Write-Host "[$CommitNumber/$TotalCommits] $($CommitInfo.Date) - $($CommitInfo.Message)" -ForegroundColor Green
    
    if ($IsDryRun) {
        Write-Host "  [DRY RUN] Files: $($CommitInfo.Files -join ', ')" -ForegroundColor Yellow
        return
    }
    
    # Restore files for this commit
    Restore-Files -FilesToRestore $CommitInfo.Files
    
    # Add files
    $filesAdded = 0
    foreach ($file in $CommitInfo.Files) {
        if (Test-Path $file) {
            git add $file
            $filesAdded++
            Write-Host "  Added: $file" -ForegroundColor Cyan
        } else {
            Write-Host "  Warning: $file (not found)" -ForegroundColor Yellow
        }
    }
    
    # Create commit with backdated timestamp
    if ($filesAdded -gt 0) {
        $env:GIT_COMMITTER_DATE = $CommitInfo.Date + ":00"
        $env:GIT_AUTHOR_DATE = $CommitInfo.Date + ":00"
        
        git commit -m $CommitInfo.Message --quiet
        Write-Host "  Committed: $filesAdded files" -ForegroundColor Green
    } else {
        Write-Host "  Skipped: No files to commit" -ForegroundColor Yellow
    }
}

if (-not $DryRun) {
    # Create backup of current files
    Write-Host "Creating backup..." -ForegroundColor Blue
    if (Test-Path "../temp_backup") {
        Remove-Item "../temp_backup" -Recurse -Force
    }
    git checkout main
    Copy-Item "." "../temp_backup" -Recurse -Force
    Write-Host "Backup created" -ForegroundColor Green
    
    # Switch to the clean branch
    git checkout temp_branch
}

# Create all commits
Write-Host "`nCreating $($allCommits.Count) commits across 5 sprints..." -ForegroundColor Magenta

for ($i = 0; $i -lt $allCommits.Count; $i++) {
    Create-BackdatedCommit -CommitInfo $allCommits[$i] -IsDryRun $DryRun -CommitNumber ($i + 1) -TotalCommits $allCommits.Count
    Start-Sleep -Milliseconds 200
}

if (-not $DryRun) {
    # Clean up environment variables
    Remove-Item Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
    Remove-Item Env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
    
    # Replace main branch with our new history
    Write-Host "`nReplacing main branch..." -ForegroundColor Blue
    git branch -D main -f
    git branch -m main
    
    # Push to remote
    Write-Host "Pushing to repository..." -ForegroundColor Magenta
    git push origin main --force
    Write-Host "Successfully pushed to https://github.com/sheikh2583/Dummy.git" -ForegroundColor Green
    
    # Clean up backup
    Remove-Item "../temp_backup" -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "`nHistory rewrite completed!" -ForegroundColor Magenta
Write-Host "Total: $($allCommits.Count) commits with proper sprint dates" -ForegroundColor Blue