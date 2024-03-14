Function Remove-FtpItem {
    param(
        [Parameter(Mandatory=$true)][string]$FtpItemPath,
        [Parameter(Mandatory=$true)][string]$Username,
        [Parameter(Mandatory=$true)][string]$Password
    )

    try{
        $ftpWebRequest = [System.Net.FtpWebRequest]::Create($FtpItemPath)
        $ftpWebRequest.Method = [System.Net.WebRequestMethods+Ftp]::DeleteFile
        $ftpWebRequest.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
        $response = $ftpWebRequest.GetResponse()
        $response.Close()
    }catch{
        Throw $_.Exception
    }
}