param(
	[Parameter(Mandatory=$true)]
	[string]$DriveLetter,
	[Parameter(Mandatory=$true)]
	[ValidateSet("NTFS","FAT32","exFAT","ReFS")]
	[string]$FileSystem,
	[Parameter(Mandatory=$true)]
	[string]$NewDriveName
)

Format-Volume -DriveLetter $DriveLetter -FileSystem $FileSystem -NewFileSystemLabel $NewDriveName
