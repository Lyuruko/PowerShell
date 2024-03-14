Function New-FtpDir {
    param (
        [string]$FtpDirPath,
        [string]$Username,
        [string]$Password
    )

    try {
        $ftpRequest = [Net.WebRequest]::Create($FtpDirPath)
        $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
        $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory

        $ftpResponse = $ftpRequest.GetResponse()
        $ftpResponse.Close()

        $FtpDirPath
    }
    catch {
        Throw $_.Exception
    }
}