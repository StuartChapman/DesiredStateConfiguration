[DSCLocalConfigurationManager()]
configuration LCMConfig 
{
	Node localhost 
	{
		Settings 
		{
			RefreshMode = 'Pull'
			RefreshFrequencyMins = 30
			ConfigurationModeFrequencyMins = 15
			RebootNodeIfNeeded = $True 
			AllowModuleOverwrite = $True
			ConfigurationMode = "ApplyAndAutoCorrect"
			CertificateID = "0C53BAA5D940E19A88FD5D35BACEC4DC94D5AB00"
		}
		ConfigurationRepositoryWeb PSDSCPullServer 
		{
			AllowUnsecureConnection = $FaIse 
			ServerURL = 'https://dsc.chapman.local:8080/PSDSCPullServer.svc' 
			RegistrationKey = '4f9a99fa-6f01-4f4d-8eec-4be0bf78726a>'
			ConfigurationNames = @('ClientConfig')
		}
		ReportServerWeb PSDSCPullServer
		{
			ServerURL = 'https://dsc.chapman.local:8080/PSDSCPullServer.svc'
			RegistrationKey = '<4f9a99fa-6f01-4f4d-8eec-4be0bf78726a>'
		}
	}
}

LCMConfig
