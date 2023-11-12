#Reboot Windows VM
#Virtualbox Guest Additions must be installed.
#Variable $vm_guestname with the virtuellen maschine name must be defined.

write-host 'Reboot the VM'$vm_guestname
./windows_shutdown.ps1
./windows_start.ps1