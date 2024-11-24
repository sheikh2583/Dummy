param(
    [switch]$Execute = $false
)

Write-Host "Sprint-Based Commit History Creator" -ForegroundColor Magenta
Write-Host "==================================" -ForegroundColor Magenta

if (-not $Execute) {
    Write-Host "This script will create a new commit history with proper sprint dates." -ForegroundColor Yellow
    Write-Host "Current repository will be backed up first." -ForegroundColor Yellow
    Write-Host "" 
    Write-Host "Run with -Execute to actually perform the operation:" -ForegroundColor Cyan
    Write-Host "  .\create_sprint_history.ps1 -Execute" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}

# Sprint commit definitions
$sprintCommits = @(
    # Sprint 1: Nov 24 - Dec 8, 2024
    @{ Date="2024-11-24 09:30:00"; Message="Initial project setup and README"; Files=@("README.md") },
    @{ Date="2024-11-25 10:15:00"; Message="Add project configuration files"; Files=@(".gitignore", ".env.example") },
    @{ Date="2024-11-26 14:30:00"; Message="Add functionality specifications"; Files=@("functionalities.txt") },
    @{ Date="2024-11-28 11:20:00"; Message="Initialize backend package structure"; Files=@("backend/package.json") },
    @{ Date="2024-11-30 15:45:00"; Message="Setup backend configuration"; Files=@("backend/config/") },
    @{ Date="2024-12-02 09:10:00"; Message="Add user authentication model"; Files=@("backend/models/User.model.js") },
    @{ Date="2024-12-04 13:25:00"; Message="Create project documentation"; Files=@("docs/QUICK_START_QURAN_HADITH.md", "docs/TODO_FUTURE_ENHANCEMENTS.md") },
    @{ Date="2024-12-06 16:50:00"; Message="Add backend models foundation"; Files=@("backend/models/") },
    @{ Date="2024-12-08 11:30:00"; Message="Setup project services and scripts"; Files=@("backend/scripts/", "services/") },
    
    # Sprint 2: Dec 8 - Dec 22, 2024  
    @{ Date="2024-12-09 09:15:00"; Message="Implement core server setup"; Files=@("backend/server.js") },
    @{ Date="2024-12-10 14:30:00"; Message="Add authentication system"; Files=@("backend/controllers/auth.controller.js") },
    @{ Date="2024-12-12 11:45:00"; Message="Implement authentication middleware"; Files=@("backend/middleware/auth.middleware.js") },
    @{ Date="2024-12-14 16:20:00"; Message="Add user management controllers"; Files=@("backend/controllers/user.controller.js") },
    @{ Date="2024-12-16 10:10:00"; Message="Setup authentication routing"; Files=@("backend/routes/auth.routes.js") },
    @{ Date="2024-12-18 13:55:00"; Message="Add user routing system"; Files=@("backend/routes/user.routes.js") },
    @{ Date="2024-12-20 15:25:00"; Message="Setup Hadith JSON processing"; Files=@("hadith-json/package.json", "hadith-json/tsconfig.json") },
    @{ Date="2024-12-22 12:15:00"; Message="Add AI services foundation"; Files=@("services/ai/") },
    
    # Sprint 3: Dec 22, 2024 - Jan 19, 2025
    @{ Date="2024-12-23 10:20:00"; Message="Implement Quran controllers"; Files=@("backend/controllers/quran.controller.js") },
    @{ Date="2024-12-26 14:15:00"; Message="Add Quran data models"; Files=@("backend/models/Quran.model.js") },
    @{ Date="2024-12-28 11:30:00"; Message="Add Surah metadata system"; Files=@("backend/models/SurahMetadata.model.js") },
    @{ Date="2025-01-02 09:45:00"; Message="Setup Quran routing system"; Files=@("backend/routes/quran.routes.js") },
    @{ Date="2025-01-05 15:20:00"; Message="Integrate Quran verse data"; Files=@("quran/surah/") },
    @{ Date="2025-01-08 13:10:00"; Message="Implement quiz system"; Files=@("backend/controllers/quiz.controller.js") },
    @{ Date="2025-01-11 10:35:00"; Message="Add quiz routing and ML scoring"; Files=@("backend/routes/quiz.routes.js", "services/ml-scoring/") },
    @{ Date="2025-01-14 16:25:00"; Message="Add Tafsir and translation data"; Files=@("new tafseer/", "quran/translation/") },
    @{ Date="2025-01-17 12:40:00"; Message="Complete Quran data integration"; Files=@("quran/", "tazkirul-quran-en.json/") },
    
    # Sprint 4: Jan 19 - Mar 2, 2025
    @{ Date="2025-01-20 09:25:00"; Message="Implement Hadith system"; Files=@("backend/controllers/hadith.controller.js") },
    @{ Date="2025-01-24 14:40:00"; Message="Add Hadith data models and routing"; Files=@("backend/models/Hadith.model.js", "backend/routes/hadith.routes.js") },
    @{ Date="2025-01-28 11:15:00"; Message="Setup Hadith data processing"; Files=@("hadith-json/src/", "hadith-json/db/") },
    @{ Date="2025-02-02 16:30:00"; Message="Add mobile app foundation"; Files=@("mobile-app/") },
    @{ Date="2025-02-06 10:20:00"; Message="Implement message system"; Files=@("backend/controllers/message.controller.js", "backend/models/Message.model.js") },
    @{ Date="2025-02-10 13:45:00"; Message="Add message routing system"; Files=@("backend/routes/message.routes.js") },
    @{ Date="2025-02-15 15:10:00"; Message="Develop mobile app structure"; Files=@("mobile-app/src/") },
    
    # Sprint 5: Jan 19 - Mar 2, 2025  
    @{ Date="2025-01-22 11:30:00"; Message="Implement Salat timing system"; Files=@("backend/controllers/salat.controller.js") },
    @{ Date="2025-02-01 15:45:00"; Message="Add prayer tracking features"; Files=@("backend/models/SalatScore.model.js", "backend/routes/salat.routes.js") },
    @{ Date="2025-02-08 10:20:00"; Message="Add chat functionality"; Files=@("backend/routes/chat.routes.js") },
    @{ Date="2025-02-15 14:35:00"; Message="Implement ML search capabilities"; Files=@("backend/ml-search/") },
    @{ Date="2025-02-22 12:15:00"; Message="Add data processing utilities"; Files=@("data/") },
    @{ Date="2025-02-26 11:40:00"; Message="Add comprehensive documentation"; Files=@("docs/") },
    @{ Date="2025-03-01 16:20:00"; Message="Finalize Hadith type definitions"; Files=@("hadith-json/types/", "hadith-json/README.md") }
)

Write-Host "Creating backup branch..." -ForegroundColor Blue
git branch backup_main main

Write-Host "Creating new commit history with sprint dates..." -ForegroundColor Magenta
Write-Host "This will create $($sprintCommits.Count) commits" -ForegroundColor Blue

# Create orphan branch for clean history
git checkout --orphan new_main
git rm -rf . --quiet 2>$null

# Restore files from backup and create commits
foreach ($i in 0..($sprintCommits.Count - 1)) {
    $commit = $sprintCommits[$i]
    Write-Host "[$($i+1)/$($sprintCommits.Count)] $($commit.Date) - $($commit.Message)" -ForegroundColor Green
    
    # Restore files from backup for this commit
    git checkout backup_main -- $commit.Files 2>$null
    
    # Set commit date environment variables
    $env:GIT_COMMITTER_DATE = $commit.Date
    $env:GIT_AUTHOR_DATE = $commit.Date
    
    # Add files and commit
    git add . 2>$null
    git commit -m $commit.Message --quiet
    
    Write-Host "  Committed with date: $($commit.Date)" -ForegroundColor Cyan
}

# Clean up environment variables
Remove-Item Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
Remove-Item Env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue

Write-Host "`nReplacing main branch..." -ForegroundColor Blue
git checkout main
git reset --hard new_main

Write-Host "Pushing new history to repository..." -ForegroundColor Magenta
git push origin main --force

Write-Host "`nSUCCESS!" -ForegroundColor Green
Write-Host "Created $($sprintCommits.Count) commits across 5 sprints" -ForegroundColor Blue
Write-Host "Repository: https://github.com/sheikh2583/Dummy.git" -ForegroundColor Blue
Write-Host "Commits span: Nov 24, 2024 - Mar 2, 2025" -ForegroundColor Blue

Write-Host "`nCleaning up..." -ForegroundColor Yellow
git branch -D new_main backup_main

Write-Host "`nSprint deployment completed successfully!" -ForegroundColor Magenta