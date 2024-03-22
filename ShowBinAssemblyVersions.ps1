<#
	Use in command line with .\ShowBinAssemblyVersions -Path 'ENTER-VALID-PATH-HERE\bin'
#>

param (
	[Parameter(Mandatory)]
	[ValidateNullOrEmpty()]
	[ValidateScript({Test-Path -LiteralPath $_})]
	[string]
	$Path
)

function Show-BinAssemblyVersions([string] $Path) {
	process {
		Get-ChildItem -Path $Path -Filter *.dll |
			ForEach-Object {
				try {
					$_ | Add-Member NoteProperty FileVersion ($_.VersionInfo.FileVersion)
					$_ | Add-Member NoteProperty AssemblyVersion (
						[Reflection.AssemblyName]::GetAssemblyName($_.FullName).Version
					)
				}
				catch {}
				$_
			} |
			Select-Object Name,FileVersion,AssemblyVersion
	}
}

Show-BinAssemblyVersions -Path $Path