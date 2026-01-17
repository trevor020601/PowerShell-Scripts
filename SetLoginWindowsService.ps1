#Requires -RunAsAdministrator

using namespace System.Management.Automation

param(
	[Parameter(Mandatory=$true)]
	[string]$ServiceName,
	[Parameter(Mandatory=$true)]
	[string] $UserName,
	[Parameter(Mandatory=$true)]
	[string] $Password
)

$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

$Credential = New-Object PSCredential ($UserName, $SecurePassword)

Set-Service -Name $ServiceName -Status Stopped
Set-Service -Name $ServiceName -Credential $Credential
Set-Service -Name $ServiceName -Status Running