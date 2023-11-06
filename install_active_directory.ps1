#Install Active-Directory
#Variable $vm_guestname with the virtuellen maschine name must be defined.
#Variable $windows_adminname must be defined.
#Variable $windows_password with the administrator password must be defined.
#Variable $windows_fixed_ip with the VM IP-Adress must be defined.
#Variable $windows_fixed_mask with the VM Networkmask must be defined.
#Variable $windows_fixed_gw must with the VM Gateway be defined.
#Variable $windows_fixed_dns with the VM DNS-Setting must be defined.
#Variable $domain_password with the AD Password must be defined.
#Variable $domain_name with the Domain Name must be defined.


write-host 'Install Active-Directory'
$vmliste = VBOXManage list vms --long
$vmvorhanden = $vmliste.contains('Name:                        ' + $vm_guestname)
if ( $vmvorhanden -eq 'True')
	{
		$shutdown = 'False'
		$vminfo = vboxmanage showvminfo $vm_guestname --machinereadable
		$shutdowndone = $vminfo.contains('VMState="poweroff"')
		if ($shutdown = 'true')
		{
			./windows_start.ps1
		}
		VBoxManage guestcontrol $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'Set-NetIPInterface -InterfaceIndex (get-netadapter -name \"Ethernet\").IfIndex -Dhcp Disabled'
		VBoxManage guestcontrol $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'New-NetIPAddress -InterfaceIndex (get-netadapter -name \"Ethernet\").IfIndex -IPAddress '$windows_fixed_ip' -AddressFamily IPv4 -PrefixLength '$windows_fixed_mask' -DefaultGateway '$windows_fixed_gw''
		VBoxManage guestcontrol $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'Set-DnsClientServerAddress -InterfaceIndex (get-netadapter -name \"Ethernet\").IfIndex -ServerAddresses (\"'$windows_fixed_dns'\")'
		VBoxManage guestcontrol $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'Add-WindowsFeature AD-Domain-Services '
		VBoxManage guestcontrol $vm_guestname run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe '$password = \"'$domain_password'\" | ConvertTo-SecureString -AsPlainText -Force ; Install-ADDSForest -DomainName $domain_name -InstallDNS -NoDnsOnNetwork -SafeModeAdministratorPassword $password -Force'
		Start-Sleep -Seconds 60
		./windows_start.ps1
	}
else
	{
		write-host $vm_guestname' does not exists. First start installation.'
	}

			