Function Test-FtpDir {
    param (
        [Parameter(Mandatory=$true)][string]$FtpDirPath,
        [string]$Username,
        [string]$Password
    )

    $ftpWebRequest = [Net.WebRequest]::Create($FtpDirPath)
    $ftpWebRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectory
    $ftpWebRequest.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)

    try {
        $ftpResponse = $ftpWebRequest.GetResponse()
        $ftpResponse.Close()
        return $true
    }
    catch {
        return $false
    }
}