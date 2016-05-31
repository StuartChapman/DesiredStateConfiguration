#Dynamically Create Zip files for DSC Modules & Create checksum of the zips

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
	
	#Create Module Zip name based upon format Module_VersionNumber.zip
	$ModuleZip = $module.Name + "_" + $ModuleVersionNumber.Name + ".zip" 
	
	#Set the source folder to a variable
	$ModuleFolder = $ModulesPath + "\" + $Module + "\" + $ModuleVersionNumber.Name
	
	#Check for old zip, if it exists, remove it
	$ModuleCheck = $ModulesPath + "\" + $ModuleZip
	If(Test-path $ModuleCheck) 
		{
		Remove-item $ModuleZip -ErrorAction SilentlyContinue
		}
	Else
		{
		#No zip to delete
		}
	
	#Create the zip for the Module, stored in C:\Program Files\WindowsPowerShell\Modules
	Compress-Archive -Path $ModuleFolder\* -DestinationPath $ModulesPath\$ModuleZip
	}

#Delete the contents of the DSC Module Store (This will be zips & mofs)
rm $DscModuleStore\*.* -InformationAction SilentlyContinue
	
#Move the zip files to the DSC Module Store
mv $ModulesPath\*.zip $DscModuleStore

#Create Checksums for all of the zip files in the DSC Module Store
new-dscchecksum $DscModuleStore
