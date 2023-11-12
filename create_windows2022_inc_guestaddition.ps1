#Create Windows VM inclusive VirtualBox Guest Additions
#Requirements:
#Variable $vm_guestname with the virtuellen maschine name must be defined.
#Variable $vm_basefolder wth the path to the VirtualBox VM location must be defined
#Variable $windows_password with the administrator password must be defined.
#Variable $windows_isofile with the path and filename to the installation iso file. Download the .iso file to the Destination
#Variable $nat_networkname must be defined.
#Variable $windows_user must be defined.
#Variable $windows_username must be defined.
#Variable $windows_adminname must be defined.
#Variable $domain_name with the Domain Name must be defined.

write-host 'Create Windows 2022 inclusive VirtualBox Guest Additions'
$vmliste = VBOXManage list vms --long
$vmvorhanden = $vmliste.contains('Name:                        ' + $vm_guestname)
if ( $vmvorhanden -eq 'True')
	{
		write-host $vm_guestname' already exists'
	}
else
	{
		write-host $vm_guestname' does not exists. Start guest preparation.'
		VBoxManage createvm --name $vm_guestname --ostype Windows2022_64 --register --basefolder $vm_basefolder
		VBoxManage modifyvm $vm_guestname --clipboard-mode bidirectional 
		VBoxManage modifyvm $vm_guestname --memory 6144 --boot1 dvd --boot2 disk --boot3 none --boot4 none
		VBoxManage modifyvm $vm_guestname --cpus 2
		VBoxManage modifyvm $vm_guestname --vram 128 --graphicscontroller vboxsvga
		VBoxManage storagectl $vm_guestname --name SATA --add sata --controller IntelAHCI --portcount 2
		VBoxManage createhd --filename $vm_basefolder'\'$vm_guestname'\'$vm_guestname'.vdi' --size 51200 --variant standard
		VBoxManage storageattach $vm_guestname --storagectl SATA --port 0 --device 0 --type hdd --medium $vm_basefolder'\'$vm_guestname'\'$vm_guestname'.vdi'
		VBoxManage modifyvm $vm_guestname --audio-enabled=off
		VBoxManage modifyvm $vm_guestname --nic1 natnetwork --nat-network1 $nat_networkname
		VBOXManage modifyvm $vm_guestname --usb on --usbxhci on
		Copy-Item "C:\Program Files\Oracle\VirtualBox\UnattendedTemplates\win_nt6_unattended.xml" -Destination $vm_basefolder'\'$vm_guestname'\windows2022-trial.xml'
		(Get-Content -path $vm_basefolder'\'$vm_guestname'\windows2022-trial.xml' -Raw).replace('<ProductKey>','<!-- <ProductKey>') | Set-Content -Path $vm_basefolder'\'$vm_guestname'\windows2022-trial.xml'
		(Get-Content -path $vm_basefolder'\'$vm_guestname'\windows2022-trial.xml' -Raw).replace('</ProductKey>','</ProductKey> -->') | Set-Content -Path $vm_basefolder'\'$vm_guestname'\windows2022-trial.xml'
		write-host $vm_guestname' Start guest installation.'
		VBoxManage unattended install $vm_guestname --iso $windows_isofile --user=$windows_user --password=$windows_password --full-user-name=$windows_username --install-additions --language=de-DE --locale=de_DE --country=DE --time-zone=CET --hostname $vm_guestname'.'$domain_name --image-index 2 --script-template $vm_basefolder'\'$vm_guestname'\windows2022-trial.xml'
		vboxmanage startvm $vm_guestname
		$installdone = 'False'
		while ( $installdone -ne 'True')
			{
				$vminfo = vboxmanage showvminfo $vm_guestname
				$installdone = $vminfo.contains('Additions run level:         3')
				write-host 'Installation not yet done. Wait 1 minute ...'
				Start-Sleep -Seconds 60
			}
		VBoxManage setextradata $vm_guestname GUI/Input/MouseIntegration true
		./vm_shutdown.ps1
		./windows_start.ps1
		write-host $vm_guestname' Start postinstallation settings.'
		VBoxManage guestcontrol ad run --username $windows_user --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'Set-WinUserLanguageList de-DE -Force'
		VBoxManage guestcontrol ad run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose'
		VBoxManage guestcontrol ad run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'New-Item -Path \"registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\" -Name Reliability -Force'
		VBoxManage guestcontrol ad run --username $windows_adminname --password $windows_password --wait-stdout --wait-stderr --exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 'Set-ItemProperty -Path \"registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Reliability\" -Name ShutdownReasonOn -Value 0 -Force'
		./windows_reboot.ps1
	}


