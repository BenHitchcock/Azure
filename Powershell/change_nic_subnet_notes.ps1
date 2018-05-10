$VMName = "UK-SUH-AP002"

$rgname = "UK-UKS-DEVT-ARCGIS-001-RG"


$Nicname = "UK-SUH-AP002-01-Nic"

$VirtualMachine = Get-AzureRmVM -ResourceGroupName $RGname -Name $VMName

$resourceGroupName = Get-AzureRmResourceGroup -Name UK-UKS-DEVT-ARCGIS-001-RG

$destinationsubnetname = "EXT-APP-001-SN"

#get nic




$NIC = Get-AzureRmNetworkInterface -Name $Nicname -ResourceGroupName UK-UKS-DEVT-ARCGIS-001-RG

$nic.IpConfigurations[0].PrivateIpAddress


$vnet = Get-AzureRmVirtualNetwork -Name UK-PROD-UKS-EXT-001-VN  -ResourceGroupName UK-UKS-DEVT-NWK-001-RG



$Subnet2 = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name $destinationsubnetname


$NIC.IpConfigurations[0].Subnet.Id = $Subnet2.Id



Set-AzureRmNetworkInterface -NetworkInterface $NIC

