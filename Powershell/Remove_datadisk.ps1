

$VirtualMachine = Get-AzureRmVM -ResourceGroupName "UK-UKS-PROD-INF-001-RG" -Name "UK-SUH-DC001"
Remove-AzureRmVMDataDisk -VM $VirtualMachine -Name "UK-SUH-DC011-DataDisk"
Update-AzureRmVM -ResourceGroupName "UK-UKS-PROD-INF-001-RG" -VM $VirtualMachine


