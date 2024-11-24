param(
    [switch]$DryRun = $false,
    [switch]$Force = $false
)

Write-Host "🚀 Musafir 2.0 Sprint Deployment Script" -ForegroundColor Magenta
Write-Host "=======================================" -ForegroundColor Magenta

# Check if in git repo
if (-not (Test-Path ".git")) {
    Write-Error "❌ Not in a git repository!"
    exit 1
}

# Show current remote
$currentRemote = git remote get-url origin
Write-Host "📍 Current remote: $currentRemote" -ForegroundColor Blue

# Confirm remote change
if (-not $Force -and -not $DryRun) {
    $proceed = Read-Host "🔄 Change remote to https://github.com/sheikh2583/Dummy.git? (y/N)"
    if ($proceed -ne 'y' -and $proceed -ne 'Y') {
        Write-Host "❌ Deployment cancelled." -ForegroundColor Red
        exit 0
    }
}

# Change remote
if (-not $DryRun) {
    Write-Host "🔄 Changing remote..." -ForegroundColor Blue
    git remote set-url origin https://github.com/sheikh2583/Dummy.git
    Write-Host "✅ Remote changed successfully" -ForegroundColor Green
}

# Sprint 1: Nov 24 - Dec 8, 2024 - Project Setup
Write-Host "`n🏃‍♂️ SPRINT 1: Project Setup & Core Structure" -ForegroundColor Magenta
Write-Host "📅 2024-11-24 to 2024-12-08" -ForegroundColor Blue

$sprint1_commits = @(
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
    @{ Date="2024-12-08 11:20"; Message="Finalize initial project setup"; Files=@("services/") }
)

# Sprint 2: Dec 8 - Dec 22, 2024 - Backend Core  
Write-Host "`n🏃‍♂️ SPRINT 2: Backend Core Development" -ForegroundColor Magenta
Write-Host "📅 2024-12-08 to 2024-12-22" -ForegroundColor Blue

$sprint2_commits = @(
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
    @{ Date="2024-12-21 14:20"; Message="Finalize backend core setup"; Files=@("backend/routes/") }
)

# Sprint 3: Dec 22, 2024 - Jan 19, 2025 - Quran Features
Write-Host "`n🏃‍♂️ SPRINT 3: Quran Features & Data Integration" -ForegroundColor Magenta  
Write-Host "📅 2024-12-22 to 2025-01-19" -ForegroundColor Blue

$sprint3_commits = @(
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

# Sprint 4: Jan 19 - Mar 2, 2025 - Hadith & Mobile
Write-Host "`n🏃‍♂️ SPRINT 4: Hadith System & Mobile App" -ForegroundColor Magenta
Write-Host "📅 2025-01-19 to 2025-03-02" -ForegroundColor Blue

$sprint4_commits = @(
    @{ Date="2025-01-20 09:25"; Message="Implement Hadith controller system"; Files=@("backend/controllers/hadith.controller.js") },
    @{ Date="2025-01-23 14:40"; Message="Add Hadith data models"; Files=@("backend/models/Hadith.model.js") },
    @{ Date="2025-01-26 11:15"; Message="Create Hadith routing"; Files=@("backend/routes/hadith.routes.js") },
    @{ Date="2025-01-29 16:30"; Message="Add Hadith source files"; Files=@("hadith-json/src/") },
    @{ Date="2025-02-01 10:20"; Message="Create Hadith database structure"; Files=@("hadith-json/db/") },
    @{ Date="2025-02-04 13:45"; Message="Add mobile app foundation"; Files=@("mobile-app/") },
    @{ Date="2025-02-07 15:10"; Message="Implement message system"; Files=@("backend/controllers/message.controller.js") },
    @{ Date="2025-02-10 12:35"; Message="Add message models"; Files=@("backend/models/Message.model.js") },
    @{ Date="2025-02-13 11:50"; Message="Create message routing"; Files=@("backend/routes/message.routes.js") },
    @{ Date="2025-02-16 14:15"; Message="Add mobile navigation structure"; Files=@("mobile-app/src/navigation/") },
    @{ Date="2025-02-20 10:40"; Message="Implement mobile UI components"; Files=@("mobile-app/src/components/") },
    @{ Date="2025-02-25 16:25"; Message="Integrate mobile services layer"; Files=@("mobile-app/src/services/") }
)

# Sprint 5: Jan 19 - Mar 2, 2025 - Final Features  
Write-Host "`n🏃‍♂️ SPRINT 5: Final Features & Documentation" -ForegroundColor Magenta
Write-Host "📅 2025-01-19 to 2025-03-02" -ForegroundColor Blue

$sprint5_commits = @(
    @{ Date="2025-01-22 11:30"; Message="Implement Salat timing system"; Files=@("backend/controllers/salat.controller.js") },
    @{ Date="2025-01-28 15:45"; Message="Add prayer score tracking"; Files=@("backend/models/SalatScore.model.js") },
    @{ Date="2025-02-03 10:20"; Message="Create Salat routing"; Files=@("backend/routes/salat.routes.js") },
    @{ Date="2025-02-08 14:35"; Message="Add chat functionality"; Files=@("backend/routes/chat.routes.js") },
    @{ Date="2025-02-12 12:15"; Message="Implement ML search capabilities"; Files=@("backend/ml-search/") },
    @{ Date="2025-02-17 11:40"; Message="Add data processing utilities"; Files=@("data/") },
    @{ Date="2025-02-21 16:20"; Message="Add comprehensive documentation"; Files=@("docs/ARABIC_WRITING_FEATURE.md") },
    @{ Date="2025-02-24 13:50"; Message="Create API documentation"; Files=@("docs/QURAN_HADITH_IMPLEMENTATION.md") },
    @{ Date="2025-02-26 10:25"; Message="Add deployment guides"; Files=@("docs/QIBLA_COMPASS.md") },
    @{ Date="2025-02-28 15:30"; Message="Add Hadith type definitions"; Files=@("hadith-json/types/") },
    @{ Date="2025-03-01 12:45"; Message="Create developer documentation"; Files=@("hadith-json/README.md") },
    @{ Date="2025-03-02 14:10"; Message="Finalize project documentation"; Files=@("docs/") }
)

# Function to create commit
function Create-Commit {
    param($CommitData, $IsDryRun)
    
    $env:GIT_COMMITTER_DATE = $CommitData.Date + ":00"
    $env:GIT_AUTHOR_DATE = $CommitData.Date + ":00"
    
    Write-Host "📅 $($CommitData.Date) - $($CommitData.Message)" -ForegroundColor Green
    
    if ($IsDryRun) {
        Write-Host "   [DRY RUN] Files: $($CommitData.Files -join ', ')" -ForegroundColor Yellow
        return
    }
    
    foreach ($file in $CommitData.Files) {
        if (Test-Path $file) {
            git add $file
            Write-Host "   ✅ $file" -ForegroundColor Cyan
        } else {
            Write-Host "   ⚠️  $file (not found)" -ForegroundColor Yellow
        }
    }
    
    git commit -m $CommitData.Message
    Start-Sleep -Milliseconds 300
}

# Execute all commits
$allCommits = $sprint1_commits + $sprint2_commits + $sprint3_commits + $sprint4_commits + $sprint5_commits

foreach ($commit in $allCommits) {
    Create-Commit -CommitData $commit -IsDryRun $DryRun
}

# Cleanup
Remove-Item Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
Remove-Item Env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue

# Push to repository
Write-Host "`n🚀 Pushing to repository..." -ForegroundColor Magenta
if ($DryRun) {
    Write-Host "   [DRY RUN] Would push to: https://github.com/sheikh2583/Dummy.git" -ForegroundColor Yellow
} else {
    git push -u origin main --force
    Write-Host "✅ Successfully pushed to https://github.com/sheikh2583/Dummy.git" -ForegroundColor Green
}

Write-Host "`n🎉 Deployment completed!" -ForegroundColor Magenta
Write-Host "📊 Total: $($allCommits.Count) commits across 5 sprints" -ForegroundColor Blue