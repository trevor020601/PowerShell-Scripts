# Hyper-V Needs to be Enabled
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

Get-NetAdapter

# External Switch
New-VMSwitch -Name "TestSwitch" -NetAdapterName "TestNetAdapter"

# Internal or Private Switch
#New-VMSwitch -Name "TestSwitch" -SwitchType "Internal"

# Share Virtual Switch with Management OS
Set-VMSwitch -Name "TestSwitch" -AllowManagementOS $true

New-VM -Name "TestVM" -MemoryStartupBytes 4GB -BootDevice VHD -NewVHDPath "C:\VMs\Test.vhdx" -Path "C:\Downloads\windows.iso" -NewVHDSizeBytes 20GB -Generation 2 -Switch "TestSwitch"

Start-VM -Name "TestVM"

VMConnect.exe localhost "TestVM"