#Create automic install folder
#Variable $vm_guestname with the virtuellen maschine name must be defined.
#Variable $windows_adminname must be defined.
#Variable $windows_password with the administrator password must be defined.
#Variable $automic_install_folder with the Path do the installationfile

write-host 'Create automic installation folder'
$vmliste = VBOXManage list vms --long
$vmvorhanden = $vmliste.contains('Name:                        ' + $vm_guestname)
if ( $vmvorhanden -eq 'True')
	{
		Start-Sleep -Seconds 1
		VBoxManage guestcontrol  $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'New-Item -Name \"automic\" -ItemType Directory -Path \"c:\\"'
		Start-Sleep -Seconds 1
		VBoxManage guestcontrol $vm_guestname copyto --username $windows_adminname --password $windows_password --target-directory 'C:\automic\install' --recursive --verbose  $automic_install_folder	
	}
else
	{
		write-host $vm_guestname' does not exists. First start installation.'
	}