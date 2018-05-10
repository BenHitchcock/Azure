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


Function New-SkanAzuNetworkInterface
{

Param(

#VM Name

[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
	[ValidateSet("uksouth","ukwest","westeurope")]
    [String]
    $VirtualMachineName,
 
# ResourceGroupName

[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
    [String]
    $RGName,

# VNET
   
[Parameter(Mandatory=$true)] 
    [string]
#[ValidateLength(5,5)]
    $VirtualNetwork,


# Subnet

[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
	[ValidateSet("Storage & Backup","DEVOPS","Applications","ToBeDefined","Infrastructure Services","Development")]
    [String]
    $Subnet
	
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



