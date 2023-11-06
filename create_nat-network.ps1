#Create nat-network
#Requirements:
#Variable $nat_networkname must be defined.
#Variable $nat_networkrange must be defined.

write-host 'Create NAT-Network'
$natnetworkliste = VBOXManage natnetwork list
$natnetworkvorhanden = $natnetworkliste.contains('Name:         ' + $nat_networkname)
if ( $natnetworkvorhanden -eq 'True' )
	{
		write-host $nat_networkname' already exists'
	}
else
	{
		write-host $nat_networkname' does not exists. Start installation.'
		VBOXManage natnetwork add --netname $nat_networkname --network $nat_networkrange --enable --dhcp on --ipv6 off
	}