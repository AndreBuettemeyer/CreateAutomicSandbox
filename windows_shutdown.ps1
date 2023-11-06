#Shutdown Windows VM
#Requirements:
#Virtualbox Guest Additions must be installed.
#Variable $vm_guestname with the virtuellen maschine name must be defined.
#Variable $windows_adminname with the administrator name must be defined.
#Varialbe $windows_password with the administrator password must be defined.

#Shutdown
VBoxManage guestcontrol $vm_guestname  run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'Stop-Computer -ComputerName localhost -Force'
$shutdowndone = 'False'
while ( $shutdowndone -ne 'True')
	{
		$vminfo = vboxmanage showvminfo $vm_guestname --machinereadable
		$shutdowndone = $vminfo.contains('VMState="poweroff"')
		write-host 'Shutdown not yet done. Wait 10 seconds ...'
		Start-Sleep -Seconds 10
	}