#Set WinRM Client settings

#Set the Registry Location
$RegistryPath = "HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client"
$Key1 = "AllowCredSSP"
$Value1 = "1"
$PropertyType1 = "DWORD"  
$Key2 = "TrustedHosts"
$Value2 = "1"
$PropertyType2 = "DWORD"
$Key3 = "TrustedHostsList"
$Value3 = "*"
$PropertyType3 = "String"

$Test = Test-Path $registryPath
If ($Test -eq $true)
	{
	New-ItemProperty $RegistryPath -Name $Key1 -Value $Value1 -PropertyType $PropertyType1 -Force | Out-Null
	New-ItemProperty $RegistryPath -Name $Key2 -Value $Value2 -PropertyType $PropertyType2 -Force | Out-Null
	New-ItemProperty $RegistryPath -Name $Key3 -Value $Value3 -PropertyType $PropertyType3 -Force | Out-Null
	}
