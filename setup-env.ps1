# =================================================================
# Environment Setup Script for Third-Party Risk Radar
#
# This script prepares your local environment to run the application
# without Docker. It performs the following actions:
# 1. Checks for essential prerequisites (Python, Node.js, ODBC Driver).
# 2. Creates a Python virtual environment (`.venv`).
# 3. Installs backend dependencies from `backend/requirements.txt`.
# 4. Installs frontend dependencies from `frontend/package.json`.
# =================================================================

# --- Helper Functions ---
function Check-CommandExists {
    param ($command)
    return (Get-Command $command -ErrorAction SilentlyContinue)
}

function Write-Step {
    param ($message)
    Write-Host "✅ STEP: $message" -ForegroundColor Green
}

function Write-Action {
    param ($message)
    Write-Host "   -> $message"
}

function Write-Warning {
    param ($message)
    Write-Host "⚠️ WARNING: $message" -ForegroundColor Yellow
}

function Write-Error {
    param ($message)
    Write-Host "❌ ERROR: $message" -ForegroundColor Red
    exit 1
}

# --- Main Script ---
Write-Host "--- Starting Environment Setup for Third-Party Risk Radar ---"

# 1. Prerequisite Checks
Write-Step "Checking for prerequisites..."

if (-not (Check-CommandExists "python")) {
    Write-Warning "Python is not found in your PATH."
    Write-Host "Please install Python 3.8+ from https://www.python.org/downloads/ and ensure it's added to your PATH."
    exit 1
}
Write-Action "Python found."

if (-not (Check-CommandExists "node")) {
    Write-Action "Node.js not found in PATH. Checking default installation directory..."
    $nodeDefaultPath = "C:\Program Files\nodejs"
    if (Test-Path -Path $nodeDefaultPath) {
        Write-Action "Node.js found at $nodeDefaultPath. Adding to PATH for this session."
        $env:Path = "$nodeDefaultPath;" + $env:Path
    } else {
        Write-Warning "Node.js is not found in your PATH or the default directory."
        Write-Host "Please install Node.js (LTS) from https://nodejs.org/ and ensure it's added to your PATH."
        exit 1
    }

}
Write-Action "Node.js found."

# Check for ODBC Driver (a bit trickier, we'll check for the DLL)
$odbcDriverPath = "$env:SystemRoot\System32\msodbcsql17.dll"
if (-not (Test-Path $odbcDriverPath)) {
    Write-Warning "Microsoft ODBC Driver 17 for SQL Server not found."
    Write-Host "Please download and install it from: https://www.microsoft.com/en-us/download/details.aspx?id=56567"
    exit 1
}
Write-Action "Microsoft ODBC Driver 17 for SQL Server found."

# 2. Create Python Virtual Environment
Write-Step "Setting up backend..."
if (Test-Path -Path ".venv") {
    Write-Action "Virtual environment '.venv' already exists. Skipping creation."
} else {
    Write-Action "Creating Python virtual environment in '.venv'..."
    python -m venv .venv
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to create Python virtual environment."
    }
}

# 3. Install Backend Dependencies
Write-Action "Installing backend dependencies from backend/requirements.txt..."
./.venv/Scripts/python.exe -m pip install -r backend/requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install backend dependencies. Please check the output above."
}
Write-Action "Backend dependencies installed successfully."

# 4. Install Frontend Dependencies
Write-Step "Setting up frontend..."
Write-Action "Installing frontend dependencies from frontend/package.json..."
Push-Location -Path "frontend"
npm install
if ($LASTEXITCODE -ne 0) {
    Pop-Location
    Write-Error "Failed to install frontend dependencies. Please check the output above."
}
Pop-Location
Write-Action "Frontend dependencies installed successfully."

Write-Host ""
Write-Host "🎉 Environment setup complete! 🎉" -ForegroundColor Green
Write-Host "You can now run the application using the 'run-app.ps1' script."