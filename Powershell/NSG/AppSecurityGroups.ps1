



$webAsg = New-AzureRmApplicationSecurityGroup -ResourceGroupName UK-UKW-PROD-NWK-001-RG -Name webAsg -Location westeurope
$sqlAsg = New-AzureRmApplicationSecurityGroup -ResourceGroupName UK-UKW-PROD-NWK-001-RG -Name sqlAsg -Location westeurope



$webRule = New-AzureRmNetworkSecurityRuleConfig `
    -Name "AllowHttps" `
    -Access Allow `
    -Protocol Tcp `
    -Direction outbound `
    -Priority 1500 `
    -SourceApplicationSecurityGroupId $webAsg.id `
    -SourcePortRange * `
    -DestinationAddressPrefix VirtualNetwork `
    -DestinationPortRange 443

$sqlRule = New-AzureRmNetworkSecurityRuleConfig `
    -Name "AllowSql" `
    -Access Allow `
    -Protocol Tcp `
    -Direction outbound `
    -Priority 1000 `
    -SourceApplicationSecurityGroupId $sqlAsg.id `
    -SourcePortRange * `
    -DestinationAddressPrefix VirtualNetwork `
-DestinationPortRange 1433


