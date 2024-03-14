Function Remove-FtpDir {
    param(
        [Parameter(Mandatory=$true)][string]$FtpDirPath,
        [Parameter(Mandatory=$true)][string]$Username,
        [Parameter(Mandatory=$true)][string]$Password
    )

    try{
        $ftpWebRequest = [System.Net.FtpWebRequest]::Create($FtpDirPath)
        $ftpWebRequest.Method = [System.Net.WebRequestMethods+Ftp]::RemoveDirectory
        $ftpWebRequest.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
        $response = $ftpWebRequest.GetResponse()
        $response.Close()
    }catch{
        Throw $_.Exception
    }
}