
$webNic = Get-AzureRmNetworkInterface -ResourceGroupName Internal-machine-RG
$webasg = Get-AzureRmApplicationSecurityGroup -ResourceGroupName UK-UKW-PROD-NWK-001-RG -Name webAsg
$webNic.IpConfigurations[0].ApplicationSecurityGroups = $webAsg
Set-AzureRmNetworkInterface -NetworkInterface $webNic

#$sqlNic = Get-AzureRmNetworkInterface -Name sql1333 -ResourceGroupName asgtest
#$sqlNic.IpConfigurations[0].ApplicationSecurityGroups = $sqlAsg
#Set-AzureRmNetworkInterface -NetworkInterface $sqlNic


Remove 

$nic=Get-AzureRmNetworkInterface `
  -Name UK-SUH-IN001-01-nic `
  -ResourceGroupName UK-UKS-PROD-INF-001-RG

$nic.IpConfigurations[0].ApplicationSecurityGroups = $null
$nic | Set-AzureRmNetworkInterface









