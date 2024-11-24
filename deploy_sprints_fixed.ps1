# Sprint-based Git Deployment Script for Musafir 2.0
# This script deploys the repository in 5 sprints with backdated commits

param(
    [switch]$DryRun = $false,
    [switch]$Force = $false
)

# Sprint Configuration
$sprints = @{
    1 = @{
        StartDate = "2024-11-24"
        EndDate = "2024-12-08" 
        Description = "Project Setup & Core Structure"
        Files = @(
            "README.md",
            ".gitignore", 
            ".env.example",
            "functionalities.txt",
            "backend/package.json",
            "backend/config/",
            "backend/models/User.model.js",
            "docs/QUICK_START_QURAN_HADITH.md",
            "docs/TODO_FUTURE_ENHANCEMENTS.md"
        )
    }
    2 = @{
        StartDate = "2024-12-08"
        EndDate = "2024-12-22"
        Description = "Backend Core Development"
        Files = @(
            "backend/server.js",
            "backend/models/",
            "backend/controllers/auth.controller.js",
            "backend/controllers/user.controller.js", 
            "backend/middleware/auth.middleware.js",
            "backend/routes/auth.routes.js",
            "backend/routes/user.routes.js",
            "backend/scripts/",
            "services/ai/",
            "hadith-json/package.json",
            "hadith-json/tsconfig.json"
        )
    }
    3 = @{
        StartDate = "2024-12-22" 
        EndDate = "2025-01-19"
        Description = "Quran Features & Data Integration"
        Files = @(
            "backend/controllers/quran.controller.js",
            "backend/routes/quran.routes.js", 
            "backend/models/Quran.model.js",
            "backend/models/SurahMetadata.model.js",
            "quran/",
            "backend/controllers/quiz.controller.js",
            "backend/routes/quiz.routes.js",
            "services/ml-scoring/",
            "new tafseer/",
            "tazkirul-quran-en.json/"
        )
    }
    4 = @{
        StartDate = "2025-01-19"
        EndDate = "2025-03-02" 
        Description = "Hadith System & Mobile App Foundation" 
        Files = @(
            "backend/controllers/hadith.controller.js",
            "backend/routes/hadith.routes.js",
            "backend/models/Hadith.model.js", 
            "hadith-json/src/",
            "hadith-json/db/",
            "mobile-app/",
            "backend/controllers/message.controller.js",
            "backend/routes/message.routes.js",
            "backend/models/Message.model.js"
        )
    }
    5 = @{
        StartDate = "2025-01-19"
        EndDate = "2025-03-02"
        Description = "Final Features & Documentation"
        Files = @(
            "backend/controllers/salat.controller.js", 
            "backend/routes/salat.routes.js",
            "backend/models/SalatScore.model.js",
            "backend/routes/chat.routes.js",
            "backend/ml-search/",
            "data/",
            "docs/",
            "hadith-json/types/",
            "hadith-json/README.md"
        )
    }
}

function Get-RandomTimestamp {
    param(
        [DateTime]$StartDate,
        [DateTime]$EndDate
    )
    
    $timeSpan = $EndDate - $StartDate
    $randomDays = Get-Random -Minimum 0 -Maximum $timeSpan.TotalDays
    $randomHours = Get-Random -Minimum 8 -Maximum 20
    $randomMinutes = Get-Random -Minimum 0 -Maximum 59
    
    return $StartDate.AddDays($randomDays).AddHours($randomHours).AddMinutes($randomMinutes)
}

function Test-FilesExist {
    param([string[]]$Files)
    
    $missing = @()
    foreach ($file in $Files) {
        if (-not (Test-Path $file)) {
            $missing += $file
        }
    }
    return $missing
}

function New-BackdatedCommit {
    param(
        [string]$Message,
        [DateTime]$CommitDate,
        [string[]]$Files,
        [bool]$DryRun
    )
    
    $env:GIT_COMMITTER_DATE = $CommitDate.ToString("yyyy-MM-dd HH:mm:ss")
    $env:GIT_AUTHOR_DATE = $CommitDate.ToString("yyyy-MM-dd HH:mm:ss")
    
    Write-Host "📅 Creating commit: '$Message' at $CommitDate" -ForegroundColor Green
    
    if ($DryRun) {
        Write-Host "   [DRY RUN] Would add files: $($Files -join ', ')" -ForegroundColor Yellow
        return
    }
    
    foreach ($file in $Files) {
        if (Test-Path $file) {
            git add $file
            Write-Host "   ✅ Added: $file" -ForegroundColor Cyan
        } else {
            Write-Host "   ⚠️  File not found: $file" -ForegroundColor Yellow
        }
    }
    
    git commit -m $Message
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Commit created successfully" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Failed to create commit" -ForegroundColor Red
    }
}

# Main execution
Write-Host "🚀 Musafir 2.0 Sprint Deployment Script" -ForegroundColor Magenta
Write-Host "=======================================" -ForegroundColor Magenta

if (-not (Test-Path ".git")) {
    Write-Error "❌ This directory is not a git repository!"
    exit 1
}

$currentRemote = git remote get-url origin
Write-Host "📍 Current remote: $currentRemote" -ForegroundColor Blue

if (-not $Force -and -not $DryRun) {
    $proceed = Read-Host "🔄 Change remote to https://github.com/sheikh2583/Dummy.git? (y/N)"
    if ($proceed -ne 'y' -and $proceed -ne 'Y') {
        Write-Host "❌ Deployment cancelled." -ForegroundColor Red
        exit 0
    }
}

if (-not $DryRun) {
    Write-Host "🔄 Changing remote to Dummy repository..." -ForegroundColor Blue
    git remote set-url origin https://github.com/sheikh2583/Dummy.git
    Write-Host "✅ Remote changed successfully" -ForegroundColor Green
}

foreach ($sprintNum in 1..5) {
    $sprint = $sprints[$sprintNum]
    Write-Host "`n🏃‍♂️ SPRINT $sprintNum : $($sprint.Description)" -ForegroundColor Magenta
    Write-Host "📅 $($sprint.StartDate) to $($sprint.EndDate)" -ForegroundColor Blue
    
    Write-Host "🔍 Checking files for Sprint $sprintNum..." -ForegroundColor Yellow
    $missingFiles = Test-FilesExist $sprint.Files
    if ($missingFiles.Count -gt 0) {
        Write-Host "⚠️  Some files not found: $($missingFiles -join ', ')" -ForegroundColor Yellow
    }
    
    $availableFiles = $sprint.Files | Where-Object { Test-Path $_ }
    Write-Host "✅ Found $($availableFiles.Count) files/folders for Sprint $sprintNum" -ForegroundColor Green
    
    $commitCount = Get-Random -Minimum 10 -Maximum 13
    Write-Host "📊 Creating $commitCount commits for Sprint $sprintNum" -ForegroundColor Cyan
    
    $fileGroups = @()
    $filesPerCommit = [Math]::Max(1, [Math]::Ceiling($availableFiles.Count / $commitCount))
    
    for ($i = 0; $i -lt $commitCount; $i++) {
        $start = $i * $filesPerCommit
        $end = [Math]::Min($start + $filesPerCommit - 1, $availableFiles.Count - 1)
        
        if ($start -lt $availableFiles.Count) {
            $groupFiles = $availableFiles[$start..$end]
            $fileGroups += ,@($groupFiles)
        }
    }
    
    $commitMessages = switch ($sprintNum) {
        1 {
            @(
                "Initial project setup and configuration",
                "Add core project structure and README", 
                "Setup environment configuration", 
                "Add basic documentation framework",
                "Initialize backend package configuration",
                "Setup project dependencies and structure",
                "Add user model and basic auth structure",
                "Create project documentation foundation",
                "Setup development environment",
                "Add functionality specifications",
                "Configure project build system",
                "Finalize initial project setup"
            )
        }
        2 {
            @(
                "Implement core server setup",
                "Add user authentication system",
                "Create database models foundation", 
                "Implement authentication middleware",
                "Add user management controllers",
                "Setup routing infrastructure", 
                "Add authentication routes",
                "Implement user registration and login",
                "Create build scripts and utilities",
                "Add AI services foundation",
                "Setup Hadith JSON processing",
                "Configure TypeScript build system"
            )
        }
        3 {
            @(
                "Implement Quran controller and routes",
                "Add Quran data models",
                "Integrate Quran verse data",
                "Add Surah metadata handling", 
                "Implement quiz system foundation",
                "Add Quran search functionality",
                "Create ML scoring services",
                "Integrate Tafsir data",
                "Add Quran translation support",
                "Implement verse lookup system", 
                "Add Quran audio features",
                "Finalize Quran data integration"
            )
        }
        4 {
            @(
                "Implement Hadith controller system",
                "Add Hadith data models",
                "Create Hadith database structure",
                "Add mobile app foundation", 
                "Implement message system",
                "Add React Native setup",
                "Create mobile navigation structure",
                "Add Hadith search functionality",
                "Implement mobile UI components",
                "Add mobile state management",
                "Create mobile services layer", 
                "Integrate mobile data services"
            )
        }
        5 {
            @(
                "Implement Salat timing system",
                "Add prayer score tracking",
                "Create chat functionality",
                "Add ML search capabilities",
                "Implement vector search",
                "Add comprehensive documentation",
                "Create API documentation", 
                "Add deployment guides",
                "Implement advanced search features",
                "Add data processing utilities",
                "Create developer documentation",
                "Finalize project documentation"
            )
        }
    }
    
    $startDate = [DateTime]::Parse($sprint.StartDate)
    $endDate = [DateTime]::Parse($sprint.EndDate)
    
    $timestamps = @()
    for ($i = 0; $i -lt $fileGroups.Count; $i++) {
        $timestamps += Get-RandomTimestamp -StartDate $startDate -EndDate $endDate
    }
    $timestamps = $timestamps | Sort-Object
    
    for ($i = 0; $i -lt $fileGroups.Count; $i++) {
        if ($fileGroups[$i] -and $fileGroups[$i].Count -gt 0) {
            $message = if ($i -lt $commitMessages.Count) { $commitMessages[$i] } else { "Sprint $sprintNum development update" }
            New-BackdatedCommit -Message $message -CommitDate $timestamps[$i] -Files $fileGroups[$i] -DryRun $DryRun
            Start-Sleep -Milliseconds 500
        }
    }
}

Remove-Item Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
Remove-Item Env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue

Write-Host "`n🚀 Pushing to remote repository..." -ForegroundColor Magenta

if ($DryRun) {
    Write-Host "   [DRY RUN] Would push to: https://github.com/sheikh2583/Dummy.git" -ForegroundColor Yellow
} else {
    git push -u origin main --force
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Successfully pushed all commits to https://github.com/sheikh2583/Dummy.git" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to push to remote repository" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Sprint deployment completed!" -ForegroundColor Magenta
Write-Host "📊 Total commits created across 5 sprints" -ForegroundColor Blue
Write-Host "🔗 Repository: https://github.com/sheikh2583/Dummy.git" -ForegroundColor Blue

if (-not $DryRun) {
    Write-Host "`n📋 Final Repository Status:" -ForegroundColor Blue
    git log --oneline -10
}