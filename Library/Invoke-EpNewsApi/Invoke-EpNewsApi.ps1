Function Invoke-EpNewsApi(){

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)][string]$Pub = "XX",
        [Parameter(Mandatory = $false)][string][ValidatePattern("\d{4}\d{2}\d{2}")]$Date = ((Get-Date).ToString('yyyyMMdd'))
    )

    $api_username = 'XXXXX'
    $api_password = 'XXXXX'
    $api_site     = 'https://XXXXX.com/api/'
    $api_pub      = $Pub
    $api_date     = $Date
    $api_uri      = $api_site + $api_pub + "/" + $api_date

    $auth         = $api_username + ':' + $api_password
    $encode       = [System.Text.Encoding]::UTF8.GetBytes($auth)
    $base64string = [System.Convert]::ToBase64String($encode)
    $headers      = @{"Authorization"="Basic $($base64string)"}

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12
    return Invoke-RestMethod -Uri $api_uri -Method GET -Headers $headers

}