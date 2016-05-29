$mypwd = ConvertTo-SecureString -String "Sp4mBurg3r" -Force -AsPlainText
Import-PfxCertificate -FilePath "$env:temp\DscPrivateKey.pfx" -CertStoreLocation Cert:\LocalMachine\Root -Password $mypwd > $null

# Confirm thumbprint of the imported certificate is correct
$Cert = Get-ChildItem -Path cert:\LocalMachine\Root `
| Where-Object {($_.FriendlyName -eq 'DSC Credential Encryption certificate') `
 -and ($_.Subject -eq "CN=DSC")} | Select-Object -First 1

#Check eventlog source exists, if not, create.
$check = [System.Diagnostics.EventLog]::SourceExists("DSC Scripts")
If ($check -eq $False)
  {
  New-EventLog –LogName Application –Source “DSC Scripts”
  }

#Check for imported certificate with subject "CN=DSC" and Thumbprint "0C53BAA5D940E19A88FD5D35BACEC4DC94D5AB00", write eventlog according to whether cert was imported or not
If (($cert.thumbprint -eq "0C53BAA5D940E19A88FD5D35BACEC4DC94D5AB00") -and ($cert.subject -eq "CN=DSC"))
  {
  Write-EventLog –LogName Application –Source “DSC Scripts” -EntryType Information –EventID 1 `
  –Message “DSC Credential Encryption certificate imported to cert:\LocalMachine\Root successfully.”
  }
Else 
  {
  Write-EventLog –LogName Application –Source “DSC Scripts” -EntryType Error –EventID 2 `
  –Message “DSC Credential Encryption certificate was not imported.”
  }
