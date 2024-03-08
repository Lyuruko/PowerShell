Function Count-IndexOf(){

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string]$InputString,
        [Parameter(Mandatory = $true)][string]$SearchString
    )

    $count = 0
    $array = New-Object System.Collections.Generic.List[System.Object]

    while( $InputString.IndexOf($SearchString) -ne -1 ){
        $a = $InputString.IndexOf($SearchString) + $SearchString.Length
        $b = $InputString.Length - ($InputString.IndexOf($SearchString) + $SearchString.Length)
        $array_sum = 0
        $array | Foreach { $array_sum += $_ }

        Write-Output ($InputString.IndexOf($SearchString)  +  $count * $SearchString.Length + $array_sum)

        $array.Add( $InputString.IndexOf($SearchString) )
        $InputString = ($InputString.Substring($a,$b))
        $count++
    }
}