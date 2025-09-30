# Third-Party Risk Radar

This project provides a web-based dashboard for monitoring third-party vendor risk.

## Local Development Setup (Without Docker)

This guide explains how to run the application on your local Windows machine using PowerShell scripts.

### Prerequisites

Before you begin, ensure you have the following installed and accessible in your system's PATH:

1.  **Python** (Version 3.8 or newer)
    -   Download from: [python.org](https://www.python.org/downloads/)
    -   **Important**: During installation, make sure to check the box that says "Add Python to PATH".

2.  **Node.js** (LTS version recommended)
    -   Download from: [nodejs.org](https://nodejs.org/)
    -   This includes `npm` (Node Package Manager).

3.  **Microsoft ODBC Driver 17 for SQL Server**
    -   This is required for the backend to communicate with your local SQL Server instance.
    -   Download from: [Microsoft's official site](https://www.microsoft.com/en-us/download/details.aspx?id=56567)

4.  **SQL Server Express Edition**
    -   You need a local database instance. SQL Server Express is a free version suitable for development.
    -   Download from: [Microsoft's official site](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
    -   During installation, you can choose the default settings. After installation, ensure the database service is running.

### Step 1: Set Up the Environment

This step installs all the necessary Python and Node.js packages for the project. You only need to run this once.

1.  Open a new PowerShell terminal.
2.  Navigate to the root directory of this project.
3.  Run the setup script:

    ```powershell
    .\setup-env.ps1
    ```

This script will:
- Verify that all prerequisites are installed.
- Create a Python virtual environment in a `.venv` folder.
- Install backend dependencies into the virtual environment.
- Install frontend dependencies via `npm`.

### Step 2: Run the Application

After the setup is complete, you can run the application with a single command.

1.  In the same PowerShell terminal, run the startup script:

    ```powershell
    .\run-app.ps1
    ```

This script will:
- Start the backend API server in the background.
- Start the frontend web server in the background.

The application is now running!

-   **Frontend UI**: [http://localhost:3000](http://localhost:3000)
-   **Backend API Docs**: [http://localhost:8000/docs](http://localhost:8000/docs)

### Step 3: Stop the Application

To stop both the backend and frontend servers, you can either:
-   Close the PowerShell window where `run-app.ps1` is running.
-   Run the following command in the same PowerShell window:
    ```powershell
    Get-Job | Stop-Job
    ```