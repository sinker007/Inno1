# =================================================================
# Application Startup Script for Third-Party Risk Radar
#
# This script runs the backend and frontend servers simultaneously.
#
# Pre-requisites:
# - Run the `setup-env.ps1` script once to install dependencies.
#
# What this script does:
# 1. Activates the Python virtual environment.
# 2. Starts the backend FastAPI server on http://localhost:8000.
# 3. Starts the frontend Next.js dev server on http://localhost:3000.
# =================================================================

# --- Helper Functions ---
function Write-Step {
    param ($message)
    Write-Host "✅ STEP: $message" -ForegroundColor Green
}

function Write-Info {
    param ($message)
    Write-Host "   -> $message"
}

function Write-Error {
    param ($message)
    Write-Host "❌ ERROR: $message" -ForegroundColor Red
    exit 1
}

# --- Main Script ---
Write-Host "--- Starting Third-Party Risk Radar Application ---"

# 1. Prerequisite Checks
Write-Step "Verifying environment..."
if (-not (Test-Path -Path ".venv")) {
    Write-Error "Virtual environment '.venv' not found. Please run 'setup-env.ps1' first."
}
# Check for Node.js and add to PATH if necessary
if (-not (Get-Command "node" -ErrorAction SilentlyContinue)) {
    Write-Info "Node.js not found in PATH. Checking default installation directory..."
    $nodeDefaultPath = "C:\Program Files\nodejs"
    if (Test-Path -Path $nodeDefaultPath) {
        Write-Info "Node.js found at $nodeDefaultPath. Adding to PATH for this session."
        $env:Path = "$nodeDefaultPath;" + $env:Path
    } else {
        Write-Error "Node.js not found. Please run 'setup-env.ps1' or ensure Node.js is in your PATH."
    }
}
Write-Info "Environment verified."

# 2. Start Backend Server
Write-Step "Starting backend server..."
$backendJob = Start-Job -ScriptBlock {
    # Activate venv, navigate, and run uvicorn
    & ./.venv/Scripts/Activate.ps1
    Push-Location -Path "backend"
    uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
    Pop-Location
} -Name "Backend"
Write-Info "Backend (API) is starting in the background."

# 3. Start Frontend Server
Write-Step "Starting frontend server..."
$frontendJob = Start-Job -ScriptBlock {
    # Navigate to frontend and start
    Push-Location -Path "frontend"
    npm run dev
    Pop-Location
} -Name "Frontend"
Write-Info "Frontend (UI) is starting in the background."


Write-Host ""
Write-Host "🎉 Application is running! 🎉" -ForegroundColor Green
Write-Host ""
Write-Host "   - Frontend UI:      http://localhost:3000"
Write-Host "   - Backend API Docs: http://localhost:8000/docs"
Write-Host ""
Write-Host "To stop the application, close this PowerShell window or run:"
Write-Host "   Get-Job | Stop-Job"
Write-Host ""

# Keep the script running to show job status
while ($true) {
    $backendStatus = (Get-Job -Name "Backend").State
    $frontendStatus = (Get-Job -Name "Frontend").State

    if ($backendStatus -ne 'Running' -or $frontendStatus -ne 'Running') {
        Write-Host "One of the services has stopped. See job status below:" -ForegroundColor Yellow
        Get-Job
        break
    }
    Start-Sleep -Seconds 5
}