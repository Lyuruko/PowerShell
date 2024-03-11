$datasrce = "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=XXXX)(PORT=XXXX)))(CONNECT_DATA=(SERVICE_NAME=XXXX)))"
$username = "XXXX"
$password = "XXXX"

$query = @"
SELECT * FROM XXXX
"@

Get-OracleQueryResult -DataSource $datasrce -UserName $username -Password $password -Query $query