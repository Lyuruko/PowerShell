Function Add-FtpItem(){
    param(
        [Parameter(Mandatory=$true)][string]$FtpItemPath,
        [Parameter(Mandatory=$true)][string]$Username,
        [Parameter(Mandatory=$true)][string]$Password,
        [Parameter(Mandatory=$true)][string]$LocalItemPath
    )
    $web_client = New-Object System.Net.WebClient 
    $web_client.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)  

    try{

        $uri = New-Object System.Uri($FtpItemPath) 
        $web_client.UploadFile($uri, $LocalItemPath)
        $FtpItemPath

    }catch{
        Throw $_.Exception
    }
}