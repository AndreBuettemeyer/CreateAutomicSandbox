# NAT-Network für Automic Sandbox Installation
$nat_networkname = 'aenet_10.0.11'
$nat_networkrange = '10.0.11.0/24'
./create_nat-network.ps1

# AD Windows 2022 Server
$vm_guestname = 'ad'
$vm_basefolder = 'V:\VMs'
$windows_adminname = 'administrator'
$windows_password = 'swordfish'
$windows_isofile = 'V:\_Downloads\iso\Windows2022Evaluation.iso'
$windows_user = 'ab'
$windows_username = 'AnBu'
$domain_name = 'example.local'
./create_windows2022_inc_guestaddition.ps1

# AD Installation Active Directory Domain Controller and Automic-Tools
$windows_fixed_ip = '10.0.11.4'
$windows_fixed_mask = '24'
$windows_fixed_gw = '10.0.11.1'
$windows_fixed_dns = '127.0.0.1'
$domain_password = 'Swordfish!'
./install_active_directory.ps1

# AD Appinstallationen 
$automic_install_folder = 'V:\_Downloads\Automic\21.0.5'
$npp_file = 'V:\_Downloads\tools\npp.8.4.3.Installer.x64.exe'
$kse_file = 'V:\_Downloads\tools\kse-551-setup.exe'
$7zip_file = 'V:\_Downloads\tools\7z2201-x64.exe'
$putty_file = 'V:\_Downloads\tools\putty-64bit-0.79-installer.msi'
$winscp_file = 'V:\_Downloads\tools\WinSCP-6.1.2.msi'
$java_file = 'V:\_Downloads\tools\jre-8u391-windows-x64.exe'
./create_automic_install_folder.ps1
./install_npp.ps1
./install_kse.ps1
./install_7zip.ps1
./install_putty.ps1
./install_winscp.ps1
./install_java.ps1