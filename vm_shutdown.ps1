#Hard shutdown VM
#Requirements:
#Variable $vm_guestname with the virtuellen maschine name must be defined.

#Shutdown
vboxmanage controlvm $vm_guestname poweroff
$shutdowndone = 'False'
while ( $shutdowndone -ne 'True')
	{
		$vminfo = vboxmanage showvminfo $vm_guestname --machinereadable
		$shutdowndone = $vminfo.contains('VMState="poweroff"')
		write-host 'Shutdown not yet done. Wait 10 seconds ...'
		Start-Sleep -Seconds 10
	}
