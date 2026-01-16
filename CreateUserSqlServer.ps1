param(
    [Parameter(Mandatory=$true)]
	[string]$UserName,
    [Parameter(Mandatory=$true)]
	[string]$Password,
    [Parameter(Mandatory=$true)]
	[string]$DatabaseName
)

if (-not (Get-Module -Name SqlServer -ListAvailable)) {
    Write-Host "Module SqlServer not found. Attempting to install..."

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # -Scope CurrentUser avoids needing administrator privileges if only for the current user
    # -Force accepts the PSGallery as an untrusted repository automatically and bypasses warnings
    Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber

    Write-Host "Module SqlServer installed successfully."
} else {
    Write-Host "Module SqlServer is already installed."
}

Import-Module -Name SqlServer

# TODO: Add roles here or make separate script
$sqlQuery = @"
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '$(userName)')
BEGIN
    CREATE LOGIN [$(userName)] WITH PASSWORD = '$(password)';
END
USE [$(databaseName)];
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = '$(userName)')
BEGIN
    CREATE USER [$(userName)] FOR LOGIN [$(userName)];
END
"@

$sqlParams = @(
    "userName='$UserName'",
    "password='$Password'",
    "databaseName='$DatabaseName'"
)

Invoke-Sqlcmd -ServerInstance $serverName -Database $databaseName -Query $sqlQuery -Variable $sqlParams