$VM = Get-AzureRmVM -ResourceGroupName UK-UKS-DEVT-ARCGIS-001-RG -Name UK-SUH-AP003

$nicID = (Get-AzureRmNetworkInterface -Name uk-suh-ap003_nic -ResourceGroupName UK-UKS-DEVT-ARCGIS-001-RG).Id


Remove-AzureRmVMNetworkInterface -VM $vm -NetworkInterfaceIDs $nicID | `
    Update-AzureRmVm -ResourceGroupName "UK-UKS-DEVT-ARCGIS-001-RG"


# Add Nic


$vmname = "UK-SUH-AP003"

$vmrg = "UK-UKS-DEVT-ARCGIS-001-RG"

$nwrg = "UK-UKS-DEVT-NWK-001-RG"

$vnet = "UK-PROD-UKS-EXT-001-VN"

$snet = "EXT-APP-001-SN"

$nicname = $vm.ToUpper()+"-01-Nic"


#choose vnet/subnet

$myVnet = Get-AzureRmVirtualNetwork -Name $vnet -ResourceGroupName $nwrg  

#needs to pull info on subnet etc.

$backEnd = $myVnet.Subnets|?{$_.Name -eq $snet}

#Need to pull location forgot how to do this :)

$RGLocation = (Get-AzureRmResourceGroup -Name UK-UKS-DEVT-ARCGIS-001-RG -Location "uk south")

# pull vm info..

$vm = get-azurermvm -ResourceGroupName $vmrg -Name $vmname


# create nic


New-AzureRmNetworkInterface -Name $nicname -ResourceGroupName $vmrg -Location "UK South" -SubnetId $backEnd.Id

# 

$nicId = (Get-AzureRmNetworkInterface -ResourceGroupName $vmrg -Name "$nicname").Id
Add-AzureRmVMNetworkInterface -VM $vm -Id $nicId | Update-AzureRmVm -ResourceGroupName $vmrg 


# set nic to primary....





# List existing NICs on the VM and find which one is primary
$vm.NetworkProfile.NetworkInterfaces

# Set NIC 0 to be primary
$vm.NetworkProfile.NetworkInterfaces[0].Primary = $true
$vm.NetworkProfile.NetworkInterfaces[1].Primary = $false

# Update the VM state in Azure
Update-AzureRmVM -VM $vm -ResourceGroupName "myResourceGroup"


