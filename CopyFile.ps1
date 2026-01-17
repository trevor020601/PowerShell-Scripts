param(
	[Parameter(Mandatory=$true)]
	[string]$SourceFile,
	[Parameter(Mandatory=$true)]
	[string] $DestinationDirectory
)

if (-not (Test-Path -Path $DestinationDirectory)) {
	New-Item -ItemType Directory -Path $DestinationDirectory -Force
}

Copy-Item -Path $SourceFile -Destination $DestinationDirectory -Force
