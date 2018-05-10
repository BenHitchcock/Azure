####Create Server.

$rg = "UK-UKS-DEVT-ARCGIS-001-RG"
$pwd = ConvertTo-SecureString 'F33dm3n0wpl5!' -AsPlainText -Force;
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList 'Arcgisadmin', $pwd

$srv = New-AzureRmSqlServer -ServerName "uk-uks-devt-arcgis-001-dbs" -location "uk south" -ServerVersion "12.0" -ResourceGroupName $rg -SqlAdministratorCredentials $cred -Verbose
$srvname = $srv.ServerName
Get-AzureRmSqlServer -ServerName $srvname -ResourceGroupName $rg 


####Create Database.

$db = New-AzureRmSqlDatabase -DatabaseName "ukuksdevtarcgis001db" -ServerName $srvname -ResourceGroupName $rg -Edition basic
$dbname = $db.DatabaseName
Get-AzureRmSqlDatabase -ServerName $srvname -ResourceGroupName $rg 
 











