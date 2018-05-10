<# 
Author: Ben Hitchcock
Date: 10.5.18
Current Version:

 .Synopsis
 What is this script or function trying to achieve.

 .Description
 this is what the script or function is trying to do.

  
  Prequisites
  -----------
  AzureRM 

  what modules and other components are required for this script to function.


  Limitations and Known Issues
  ----------------------------


  
  Backlog 
  --------
    
  anything left to complete

  Change Log
  ----------
how many versions etc

  v1.00 Ben Hitchcock 11/01/2017 Base Version
  

  .Parameter RGName

$RGname - this is common through all scripts
$Environmenttype -  common to all Either PROD,DEVT


 .Example
 #$RGName = Get-AzureRMRG -name
 #$rgname.name

 
#>


Function New-BenAzuResourceGroup
{

Param(

#RG Azure Region

[Parameter(ParameterSetName=’ResourceLocal’, Mandatory = $true)]
	[ValidateSet("uksouth","ukwest","westeurope")]
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

$Tags = @{ CostCode="$costcode"; ServiceOwner="$ServiceOwner"; ServiceEndDate="$serviceenddate" ; ServiceLevel="$ServiceLevel" ; BenskaRegion="UK"; Environment="$EnvironmentType"}


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