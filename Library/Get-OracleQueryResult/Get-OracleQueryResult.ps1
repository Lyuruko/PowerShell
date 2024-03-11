$oracle_dll_path = (Join-Path (Split-Path $MyInvocation.MyCommand.Path) -ChildPath "Oracle.ManagedDataAccess.dll")

Function Get-OracleQueryResult(){

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string]$DataSource,
        [Parameter(Mandatory = $true)][string]$UserName,
        [Parameter(Mandatory = $true)][string]$Password,
        [Parameter(Mandatory = $true)][string]$Query
    )

    try{ Add-Type -Path $oracle_dll_path }catch{ return $_.exception }

    $output_arypso = New-Object System.Collections.Generic.List[System.Object]

    $connectionString    = 'User Id=' + $UserName + ';Password=' + $Password + ';Data Source=' + $DataSource
    $connection          = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectionString)
    $command             = $connection.CreateCommand()
    $command.CommandText = ($Query -replace '(^\s+|\s+$)','' -replace '\s+',' ')

    $connection.open()

    if($connection.State -eq "Open"){

        $reader = $command.ExecuteReader()

        if($reader.HasRows){

            while ($reader.Read()) {

                $output_pso = New-Object -TypeName PSObject

                for($i = 0; $i -lt $reader.FieldCount ;$i++){

                    $fieldName = $reader.GetName($i)
                    try { $fieldValue = $reader.GetValue($i) }catch{$fieldValue = ''}
                    $output_pso | Add-Member -MemberType NoteProperty -Name $fieldName -Value $fieldValue

                }

                $output_arypso.Add($output_pso)

            }

        }else{
            
            "READER HAS NO ROWS"

        }

        $connection.Close()

    }else{

        "CONNECTION NOT OPEN"

    }

    Return $output_arypso

}