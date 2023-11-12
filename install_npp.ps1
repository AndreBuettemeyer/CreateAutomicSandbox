#Install Active-Directory
#Variable $vm_guestname with the virtuellen maschine name must be defined.
#Variable $windows_adminname must be defined.
#Variable $windows_password with the administrator password must be defined.
#Variable $windows_user must be defined.
#Variable $npp_file with the Path do the installationfile

write-host 'Install notepad++'
$vmliste = VBOXManage list vms --long
$vmvorhanden = $vmliste.contains('Name:                        ' + $vm_guestname)
if ( $vmvorhanden -eq 'True')
	{
		Start-Sleep -Seconds 1
		VBoxManage guestcontrol $vm_guestname copyto --username $windows_adminname --password $windows_password --target-directory C:\Users\$windows_user'\Downloads\npp.exe' --recursive --verbose  $npp_file
		Start-Sleep -Seconds 1
		VBoxManage guestcontrol  $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe C:\Users\$windows_user'\Downloads\npp.exe -argumentlist /S -verb runas -wait'
		./create_link.ps1 -source "'C:\Programme\Notepad++\notepad++.exe'" -link "'C:\Users\$windows_user\Desktop\notepad++.lnk'"
	}
else
	{
		write-host $vm_guestname' does not exists. First start installation.'
	}