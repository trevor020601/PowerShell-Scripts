function Delete-FilesCreatedBeforeDate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateNullOrEmpty()]
		[string]
		$Path,
		[Parameter(Mandatory)]
		[ValidateRange(15,60)]
		[int]
		$Age,
		[Parameter(Mandatory)]
		[ValidateSet("log","tiff","*")]
		[string]
		$FileExtension
	)
	process {
		$Date = $(Get-Date).AddDays(-$Age)

		if (-not (Test-Path $Path -IsValid)) {
			Write-Error "Path $Path was invalid"
			return
		}

		Write-Host "Path $Path is OK and Cleanup is now RUNNING"

		$Count = 0

		try {
			if ($FileExtension -eq "log") {
				Get-ChildItem -Path $Path -Recurse *.log -Exclude *.exe -Force | Where-Object {
					$_.LastWriteTime -lt $Date
				} | ForEach-Object {
					$Count++
					Write-Host "Deleted $($_.Name)"
				} | Remove-Item -Recurse -Force -Verbose -WhatIf
			}
			elseif ($FileExtension -eq "tiff") {
				Get-ChildItem -Path $Path -Recurse *.tiff -Exclude *.exe -Force | Where-Object {
					$_.LastWriteTime -lt $Date
				} | ForEach-Object {
					$Count++
					Write-Host "Deleted $($_.Name)"
				} | Remove-Item -Recurse -Force -Verbose -WhatIf
			}
			elseif ($FileExtension -eq "*") {
				Get-ChildItem -Path $Path -Recurse -Exclude *.exe -Force | Where-Object {
					$_.LastWriteTime -lt $Date
				} | ForEach-Object {
					$Count++
					Write-Host "Deleted $($_.Name)"
				} | Remove-Item -Recurse -Force -Verbose -WhatIf
			}
			Write-Host "$($Count) files have been deleted"
		}
		catch {
			Write-Error "Delete-Item failed with message $($_.Exception.Message)"
		}
	}
}

class CleanupDir {
	[ValidateNullOrEmpty()][string]$Host
	[ValidateNullOrEmpty()][string]$Path
	[ValidateNullOrEmpty()][int]$Age
	[ValidateNullOrEmpty()][string]$FileExtension

	CleanupDir ([string]$h, [string]$p, [int]$a, [string]$f) {
		$this.Host = $h
		$this.Path = $p
		$this.Age = $a
		$this.FileExtension = $f
	}
}

[CleanupDir]$TestDir = [CleanupDir]::new(
	"TestDir",
	"C:\Coding Projects\PowerShell\AutomatedDirCleanupPS\TestDir\",
	15,
	"*"
)
