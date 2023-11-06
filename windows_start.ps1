#Start Windows VM
#Requirements:
#Virtualbox Guest Additions must be installed.
#Variable $vm_guestname with the virtuellen maschine name must be defined.

#Start
vboxmanage startvm $vm_guestname
$startupdone = 'False'
while ( $startupdone -ne 'True')
	{
		$vminfo = vboxmanage showvminfo $vm_guestname
		$startupdone = $vminfo.contains('Additions run level:         3')
		write-host 'Start not yet done. Wait 1 minute ...'
		Start-Sleep -Seconds 60
	}