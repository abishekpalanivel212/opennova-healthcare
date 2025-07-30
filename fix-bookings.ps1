# PowerShell script to fix booking data issues
# This script will connect to PostgreSQL and run the fix

Write-Host "Starting booking data fix..." -ForegroundColor Green

# Database connection details
$DB_HOST = "localhost"
$DB_PORT = "5432"
$DB_NAME = "opennova"
$DB_USER = "postgres"
$DB_PASS = "abi@1234"  # Updated with correct password

# SQL file path
$SQL_FILE = "fix-database.sql"

# Check if psql is available
try {
    $psqlVersion = psql --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "PostgreSQL client found: $psqlVersion" -ForegroundColor Green
    } else {
        throw "psql not found"
    }
} catch {
    Write-Host "Error: PostgreSQL client (psql) not found in PATH" -ForegroundColor Red
    Write-Host "Please install PostgreSQL client or add it to your PATH" -ForegroundColor Yellow
    exit 1
}

# Check if SQL file exists
if (-not (Test-Path $SQL_FILE)) {
    Write-Host "Error: SQL file '$SQL_FILE' not found" -ForegroundColor Red
    exit 1
}

# Run the SQL fix
Write-Host "Running database fix..." -ForegroundColor Yellow

$env:PGPASSWORD = $DB_PASS
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $SQL_FILE

if ($LASTEXITCODE -eq 0) {
    Write-Host "Database fix completed successfully!" -ForegroundColor Green
    Write-Host "Please refresh your browser to see the updated booking data." -ForegroundColor Cyan
} else {
    Write-Host "Error: Database fix failed" -ForegroundColor Red
    exit 1
}

# Clean up
$env:PGPASSWORD = "" 