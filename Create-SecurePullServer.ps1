#HTTPS
configuration CreateSecurePullServer
{
  param
  (
	[string[]]$ComputerName = 'localhost',
	
	[ValidateNotNullOrEmpty()] 
    [string] $certificateThumbPrint,
  
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[String] $RegistrationKey
  )
  
  Import-DSCResource -ModuleName xPSDesiredStateConfiguration

  Node $ComputerName
  {
    WindowsFeature DSCServiceFeature
    {
		Ensure	= "Present"
		Name	= "DSC-Service"
    }

    xDscWebService PSDSCPullServer
    {
		Ensure 			= "Present"
		EndpointName		= "PSDSCPullServer"
		Port			= 8080
		PhysicalPath		= "$env:SystemDrive\inetpub\PSDSCPullServer"
		CertificateThumbPrint	= $certificateThumbPrint
		ModulePath		= "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
		ConfigurationPath	= "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
		State			= "Started"
		DependsOn		= "[WindowsFeature]DSCServiceFeature"
    }
	
	File RegistrationKeyFile
	{
		Ensure			= 'Present'
		Type			= 'File'
		DestinationPath		= "$env:PROGRAMFILES\WindowsPowerShell\DscService\RegistrationKeys.txt"
		Contents		= $RegistrationKey
	}

  }

}

$certificates = Get-ChildItem -path cert:\LocalMachine\My
$RegKey = [guid]::newGuid()
CreateSecurePullServer -certificateThumbprint '0C53BAA5D940E19A88FD5D35BACEC4DC94D5AB00' -RegistrationKey $RegKey -OutputPath "C:\Configs\PullServer"
Start-DscConfiguration -Path "C:\Configs\PullServer"
#Set firewall rule to allow 8080 inbound
new-netfirewallrule -displayname "Allow PowerShell Desired State Configuration" -direction inbound -action allow -protocol tcp -LocalPort 8080
