$datasrce = "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=XXXX.com)(PORT=XXXX)))(CONNECT_DATA=(SERVICE_NAME=XXXX)))"
$username = "XXXX"
$password = "XXXX"

$query = @"
SELECT * FROM XXXX
"@

Get-QueryResult -DataSource $datasrce -UserName $username -Password $password -Query $query