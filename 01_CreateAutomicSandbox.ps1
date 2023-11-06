# NAT-Network für Automic Sandbox Installation
$nat_networkname = 'aenet_10.0.11'
$nat_networkrange = '10.0.11.0/24'
./create_nat-network.ps1

# Windows 2022 Server
$vm_guestname = 'ad'
$vm_basefolder = 'V:\VMs'
$windows_adminname = 'administrator'
$windows_password = 'swordfish'
$windows_isofile = 'V:\_Downloads\iso\Windows2022Evaluation.iso'
$windows_user = 'ab'
$windows_username = 'AnBu'
$domain_name = 'ab.local'
./create_windows2022_inc_guestaddition.ps1

# Installation Active Directory Domain Controller and Automic-Tools fuer Laborumgebung
$windows_fixed_ip = '10.0.11.4'
$windows_fixed_mask = '24'
$windows_fixed_gw = '10.0.11.1'
$windows_fixed_dns = '127.0.0.1'
$domain_password = 'Swordfish!'
./install_active_directory.ps1
