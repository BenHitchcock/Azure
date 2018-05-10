$getDPIP = Get-AzureRmPublicIpAddress -Name UK-UKS-DEVT-REMOTE-001-01-DPIP   -ResourceGroupName UK-UKS-DEVT-ARCGIS-001-RG




$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig `
  -Name "PublicIPFrontEnd" `
  -PublicIpAddress $getDPIP


$backendPool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "BackEndPool1"



#$RDPprobeOFF = New-AzureRmLoadBalancerProbeConfig -Name "RDPOn" -Protocol Tcp -Port 33899 -IntervalInSeconds 16 -ProbeCount 2


#$RDPprobeON = New-AzureRmLoadBalancerProbeConfig -Name "RDPOff" -Protocol Tcp -Port 3389 -IntervalInSeconds 16 -ProbeCount 2



#$lbrule = New-AzureRmLoadBalancerRuleConfig `
 # -Name "myLoadBalancerRule" `
 # -FrontendIpConfiguration $frontendIP `
 # -BackendAddressPool $backendPool `
 # -Protocol Tcp `
 # -FrontendPort 33899 `
 # -BackendPort 3389 `
  #-Probe $RDPprobeON

$natrule1 = New-AzureRmLoadBalancerInboundNatRuleConfig `
-Name 'RDP1' `
-FrontendIpConfiguration $frontendIP `
-Protocol tcp `
-FrontendPort 5333 `
-BackendPort 3389


$lb = New-AzureRmLoadBalancer `
-ResourceGroupName $getDPIP.ResourceGroupName `
-Name 'UK-UKS-DEVT-ARCGIS-001-ELB' `
-Location 'UK South' `
-FrontendIpConfiguration $frontendIP `
-BackendAddressPool $backendPool  `
-InboundNatRule $natrule1
