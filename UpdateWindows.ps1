# Needs to be ran with Administrator privileges

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force

Install-Module -Name PSWindowsUpdate -Force -SkipPublisherCheck

Import-Module PSWindowsUpdate -Force

Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -AutoReboot -Verbose