Function Invoke-EpPurgeApi(){

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)][ValidateSet("Page","Edition","Url")][String]$Type = 'Url',
        [Parameter(Mandatory = $false)][string]$Pub = "xxxxx",
        [Parameter(Mandatory = $false)][string][ValidatePattern("\d{4}-\d{2}-\d{2}")]$Date = ((Get-Date).ToString('yyyy-MM-dd')),
        [Parameter(Mandatory = $false)][string]$Page = 'xxxxx',
        [Parameter(Mandatory = $false)][string]$Url = 'https://xxxxx.com',
        [Parameter(Mandatory = $false)][int]$MaxRetry = 3,
        [Parameter(Mandatory = $false)][int]$WaitSeconds = 1
    )

    $Url = $Url.Replace('&','%26')

    switch ($Type) {
        Page { 
            $purge_url = ('https://xxxxx.com/xxxxx.php?type=purge_page&pub='+($Pub.ToLower())+'&date='+$Date+'&page='+$Page)
            break 
        }
        Edition {
            $purge_url = ('https://xxxxx.com/xxxxx.php?type=purge_edition&pub='+($Pub.ToLower())+'&date='+$Date)
            break
        }
        Url{
            $purge_url = ('https://xxxxx.com/xxxxx.php?type=purge_url&url='+$Url)
            break
        }
    }

    $purge_count   = 0
    $purge_success = $false
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    while( ($purge_count -lt $MaxRetry) -and ($purge_success -eq $false) ){

        $purge_count++

        $iwr = Invoke-WebRequest $purge_url
        $cfj = ConvertFrom-Json $iwr.Content
        $purge_success = [System.Convert]::ToBoolean($cfj.success)

        #Write-Host ("Purge   : "+$purge_url)
        #Write-Host ("Attempt : "+$purge_count)
        #Write-Host ("Success : "+$purge_success)

        if(($purge_count -lt $MaxRetry) -and ($purge_success -eq $false)){

            #Write-Host -ForegroundColor Cyan ('Sleeping for '+$WaitSeconds+' seconds... ')
            Start-Sleep -Seconds $WaitSeconds

        }else{
        
            $out_obj = New-Object -TypeName psobject 
            $out_obj | Add-Member -MemberType NoteProperty -Name Result  -Value $iwr.Content
            $out_obj | Add-Member -MemberType NoteProperty -Name Success -Value $purge_success
            Write-Output $out_obj
        
        }

    }

}