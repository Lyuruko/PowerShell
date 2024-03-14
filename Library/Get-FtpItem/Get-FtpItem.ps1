Function Get-FtpItem() {
    param(
        [Parameter(Mandatory=$true)][string]$FtpItemPath,
        [Parameter(Mandatory=$true)][string]$Username,
        [Parameter(Mandatory=$true)][string]$Password,
        [Parameter(Mandatory=$true)][string]$LocalItemPath
    )
    $web_client = New-Object System.Net.WebClient 
    $web_client.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)  

    try{
        $web_client.DownloadFile($FtpItemPath, $LocalItemPath)
        $LocalItemPath
    }catch{
        Throw $_.Exception
    }
}