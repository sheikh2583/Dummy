# How to Use the Sprint Deployment Script

## Prerequisites
- Ensure you're in the Musafir-2.0 directory
- Have git configured with your credentials
- PowerShell execution policy allows script execution

## Usage Options

### 1. Test Run (Recommended First)
```powershell
.\deploy_sprints.ps1 -DryRun
```
This shows what would happen without making any changes.

### 2. Interactive Deployment
```powershell
.\deploy_sprints.ps1
```
This will ask for confirmation before changing the remote.

### 3. Automated Deployment
```powershell
.\deploy_sprints.ps1 -Force
```
This runs without prompts (use carefully).

## What the Script Does

1. **Changes Remote**: Updates git remote to https://github.com/sheikh2583/Dummy.git
2. **Creates 50-60 Commits**: 10-12 commits per sprint with randomized dates
3. **Backdates Commits**: Uses proper Git timestamps for the specified periods
4. **Organizes Logically**: Groups related files together in meaningful commits  
5. **Pushes Everything**: Force pushes all commits to the new repository

## Sprint Timeline
- **Sprint 1**: Project setup (24.11.2024 - 08.12.2024)
- **Sprint 2**: Backend core (08.12.2024 - 22.12.2024) 
- **Sprint 3**: Quran features (22.12.2024 - 19.01.2025)
- **Sprint 4**: Hadith & mobile (19.01.2025 - 02.03.2025)
- **Sprint 5**: Final features (19.01.2025 - 02.03.2025)

## Safety Features
- Dry run mode to preview changes
- File existence checking
- Confirmation prompts (unless -Force used)
- Detailed logging of all actions
- Graceful handling of missing files

## After Running
The script will push everything to https://github.com/sheikh2583/Dummy.git with a complete commit history spanning the specified sprint periods.