# --- Script ---

Write-Host "Starting the Third-Party Risk Radar application setup..." -ForegroundColor Green

# Step 1: Check if Docker is running
Write-Host "Verifying Docker is running..."
docker --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker command failed. Please ensure Docker Desktop is installed and running." -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}
Write-Host "Docker found." -ForegroundColor Green

# Step 2: Build and run the application using Docker Compose
Write-Host "Building and starting the application containers (frontend, backend, db)..." -ForegroundColor Yellow
Write-Host "This might take several minutes the first time."

# Use 'docker compose' to build and run all services in detached mode (-d)
docker compose up --build -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "There was an error building or starting the containers." -ForegroundColor Red
    Write-Host "For a detailed log, run this command in your terminal: docker compose up --build"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

Write-Host "`n--- Application is Starting Up! ---" -ForegroundColor Cyan
Write-Host "Frontend Dashboard will be available at: http://localhost:3000"
Write-Host "Backend API will be available at:       http://localhost:8000"
Write-Host "API Docs (Swagger UI) are at:         http://localhost:8000/docs"

# Step 3: Provide instructions on how to stop the application
Write-Host "`n--- How to Stop the Application ---" -ForegroundColor Yellow
Write-Host "To stop all running services, open a PowerShell terminal in this directory and run:"
Write-Host "docker compose down"

Write-Host "`nSetup complete!" -ForegroundColor Green
Read-Host -Prompt "Press Enter to continue..."