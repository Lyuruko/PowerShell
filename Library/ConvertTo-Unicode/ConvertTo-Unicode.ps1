Function ConvertTo-Unicode(){
    Param([Parameter(Mandatory = $true)][AllowEmptyString()][string]$Text)
    $out = $Text.ToCharArray() | ForEach-Object{ '\u{0:X4}' -f [int][char]$_ }
    Write-Output ([system.String]::Join("", $out))
}