param(
	[Parameter(Mandatory=$true)]
	[string]$SourcePath,
	[Parameter(Mandatory=$true)]
	[string] $DestinationPath
)

$LogFile = "C:\Logs\BackupLog.txt"
$LogFilePath = (Get-ChildItem -Path $LogFile).Path
if (-not (Test-Path -Path $LogFilePath)) {
	New-Item -ItemType Directory -Path $LogFilePath -Force
}

# Robocopy command
# /E: Copies subdirectories, including empty ones
# /Z: Copies files in restartable mode
# /MT[:n]: Creates multi-threaded copies
# /LOG[:file]: Writes status output to the log file (overwrites existing log)
robocopy $SourcePath $DestinationPath /E /Z /MT:8 /LOG:$LogFile

if ($LASTEXITCODE -gt 7) {
    Write-Error "Robocopy completed with errors. Check log file at $LogFile"
} else {
    Write-Host "Robocopy completed successfully. Check log file at $LogFile"
}

