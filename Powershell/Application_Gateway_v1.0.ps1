<# 
 .Synopsis
 Given a SubscriptionName returns the Subscription Object (so it can be used later , ie using the SubscriptionId) and acts to validate  

 .Description
 Breaks / Quits if Subscription not found 
 Also Dumps out List of Subscriptions if . 
  
  Prequisites
  -----------
  AzureRM 

  Returns 
  -------
  AzureRM Cmdlets

  Limitations and Known Issues
  ----------------------------
  
  Backlog 
  --------
    
  Change Log
  ----------
  v1.00 Ben Hitchcock 11/01/2017 Base Version
  

  .Parameter SubscriptionName
  
  $RGname - this is common through all scripts
  $Environmenttype -  common to all Either PROD,DEVT



 .Example
 #$Sub = Get-SKANAzureSubscription -SubscriptionName "PROD"
 #$Sub.Id 

 
#>


Function New-SkanAzuApplicationGateway
{

Param(


#ResourceGroup Name

[Parameter(Mandatory=$true)] 
    [string] 
    $RGName,


#Azure Vnet

[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
	[ValidateSet("UK-UKS-PROD-HUB-001-VN","UK-UKW-PROD-HUB-001-VN","UK-WE-PROD-HUB-001-VN")]
    [String]
    $resourcegrouplocation,
 
# Service Environment

[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
	[ValidateSet("PROD","DEVT")]
    [String]
    $EnvironmentType,

# Service Name is the name of the RG eg. GIS or MSSQL etc.
   
[Parameter(Mandatory=$true)] 
    [string]
#[ValidateLength(5,5)]
    $ServiceName,


# Service owner for tags.

[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
	[ValidateSet("Storage & Backup","DEVOPS","Applications","ToBeDefined","Infrastructure Services","Development")]
    [String]
    $serviceOwner,

# End date of service to be added to tags.

[Parameter(Mandatory=$true)] 
    [string] 
    $Serviceenddate,

# Service Cost Code.
   
[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
	[ValidateSet("e8950","e950","4444","5555","6666","7777","TobeDetermind")]
    [String]
    $CostCode,

# Sets the Service Level requirement of the service.

[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
	[ValidateSet("1","2","3","4")]
    [String]
    $ServiceLevel

	
)

#Variables

#RG Naming syntax needs some work for multiple versions of resource group. Used in RG creation depending on region.

$RGSouth = "UK-UKS-PROD-"+$ServiceName.ToUpper()+"-001-RG"
$RGWest  = "UK-UKW-PROD-"+$ServiceName.ToUpper()+"-001-RG"
$RGDevSouth = "UK-UKW-DEVT-"+$ServiceName.ToUpper()+"-001-RG"

#Service Tags

$Tags = @{ CostCode="$costcode"; ServiceOwner="$ServiceOwner"; ServiceEndDate="$serviceenddate" ; ServiceLevel="$ServiceLevel" ; SkanskaRegion="UK"; Environment="$EnvironmentType"}


#$PROD = "7f7062fb-044b-4e23-8b16-e6b2e9f51593"
#$DEVT = "10c08562-f812-4ad6-8873-d823f44e2af3"



#Creating Group Here....

IF ($ResourceGroupLocation -eq "uksouth" -and $EnvironmentType -eq 'PROD') {New-AzureRmResourceGroup -name $RGSouth -Tag $Tags -Location $ResourceGroupLocation -Verbose -Force}

Elseif  ($ResourceGroupLocation -eq "ukwest" -and $EnvironmentType -eq 'PROD') {New-AzureRmResourceGroup -name $RGWest -Tag $Tags -Location $ResourceGroupLocation -Verbose -Force}

Elseif ($ResourceGroupLocation -eq "uksouth" -and $EnvironmentType -eq 'DEVT') {New-AzureRmResourceGroup -Name $RGDevSouth -Tag $Tags -Location $ResourceGroupLocation -Verbose -Force}

Elseif ($ResourceGroupLocation -eq "westeurope" -and $EnvironmentType -eq 'DEVT') {New-AzureRmResourceGroup -Name $RGDevSouth -Tag $Tags -Location $ResourceGroupLocation -Verbose -Force}

Elseif ($ResourceGroupLocation -eq "ukwest" -and $EnvironmentType -eq 'DEVT') { write-host "YOU CANNOT CREATE DEVELOPMENT RESOURCE GROUPS IN UK WEST REGION..... PROCESS NOW ENDING" -ForegroundColor Black -BackgroundColor yellow

Break
 }

write-host "PRODUCTION RESOURCE GROUPS ARE NOW BEING LOCKED TO PREVENT ACCIDENTAL DELETION OF RESOURCES" -ForegroundColor Green -BackgroundColor Black


IF ($ResourceGroupLocation -eq "uksouth" -and $EnvironmentType -eq 'PROD') {New-AzureRmResourceLock -LockName LockRG -LockLevel CanNotDelete -ResourceGroupName $RGSouth -Force}

Elseif  ($ResourceGroupLocation -eq "ukwest" -and $EnvironmentType -eq 'PROD') {New-AzureRmResourceLock  -LockName LockRG -LockLevel CanNotDelete -ResourceGroupName $RGWest -Force}

 { 

 }


Write-Host -Object 'RESOURCE GROUP CREATION COMPLETED NOW DEPLOY RESORCES TO THIS RESOURCE GROUP' -ForegroundColor Black -BackgroundColor yellow
}




# create public ip address
 New-AzureRmPublicIpAddress `
  -ResourceGroupName $RGname `
  -Location eastus `  (use RG Location)
  -Name myAGPublicIPAddress ` (name from RG)
  -AllocationMethod Dynamic


  # Create application gateway

$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName myResourceGroupAG -Name myVNet
$pip = Get-AzureRmPublicIPAddress -ResourceGroupName myResourceGroupAG -Name myAGPublicIPAddress 
$subnet=$vnet.Subnets[0]


$gipconfig = New-AzureRmApplicationGatewayIPConfiguration `
  -Name myAGIPConfig `
  -Subnet $subnet


$fipconfig = New-AzureRmApplicationGatewayFrontendIPConfig `
  -Name myAGFrontendIPConfig `
  -PublicIPAddress $pip


$frontendport = New-AzureRmApplicationGatewayFrontendPort `
  -Name myFrontendPort `
  -Port 80

