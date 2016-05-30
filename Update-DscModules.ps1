#Dynamically Create Zip files for DSC Modules & Create checksum of the zips on the DSC Pull Server

#Set Modules Location
$ModulesPath = "C:\Program Files\WindowsPowerShell\Modules"

#Set DSC Module Store Location
$DscModuleStore = "C:\Program Files\WindowsPowerShell\DscService\Modules"

#Get list of modules in Modules Location
$Modules = Get-Childitem $ModulesPath

ForEach ($Module in $Modules)
	{
	#Get Module version number
	$ModuleVersionNumber = Get-Childitem $ModulesPath\$Module
	$ModuleVersionNumber.Name #Is the version number
	
	#Create Module Zip name based upon format Module_VersionNumber.zip
	$ModuleZip = $module + "_" + $ModuleVersionNumber + ".zip" 
	
	#Set the source folder to a variable
	$ModuleFolder = $ModulesPath + "\" + $Module
	
	#Check for old zip, if it exists, remove it
	$ModuleCheck = $ModulesPath + "\" + $ModuleZip
	If(Test-path $ModuleCheck) 
		{
		Remove-item $ModuleZip
		}
	Else
		{
		#No zip to delete
		}
	
	#Create the zip for the Module
	Add-Type -assembly "system.io.compression.filesystem"
	$PathToZip = $ModulesPath + "\" + $ModuleZip
	[io.compression.zipfile]::CreateFromDirectory($ModuleFolder, $PathToZip)
	}

#Delete the contents of the DSC Module Store (This will be zips & mofs)
rm $DscModuleStore\*.* -InformationAction SilentlyContinue
	
#Move the zip files to the DSC Module Store
mv $ModulesPath\*.zip $DscModuleStore

#Create Checksums for all of the zip files in the DSC Module Store
new-dscchecksum $DscModuleStore

