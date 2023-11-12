#Create link
#Variable $vm_guestname with the virtuellen maschine name must be defined.
#Variable $windows_adminname must be defined.
#Variable $windows_password with the administrator password must be defined.
#Call Create_link with -source "'Filepath'" -link "'Linkpath'"'
param 
	(
		$source,
		$link
	)
$link_available = VBoxManage guestcontrol $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "Test-Path $link"
while ( $link_available -ne 'True')
	{	
		write-host $link' not yet done. Wait 10 seconds ...'
		VBoxManage guestcontrol $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "New-Item -Value ""$source"" -path ""$link"" -ItemType SymbolicLink"
		Start-Sleep -Seconds 10
		$link_available = VBoxManage guestcontrol $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "Test-Path $link"
	}