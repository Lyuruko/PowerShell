Function Add-SftpItem(){

    param(
        [Parameter(Mandatory=$true)][string]$IpAddress,
        [Parameter(Mandatory=$true)][string]$Username,
        [Parameter(Mandatory=$true)][string]$Password,
        [Parameter(Mandatory=$true)][string]$RemoteDirPath,
        [Parameter(Mandatory=$true)][string]$LocalItemPath
    )

    try{
        Import-Module Posh-SSH
        $pswd = ConvertTo-SecureString $Password -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($Username, $pswd)
        $sftpSession = New-SFTPSession -ComputerName $IpAddress -Credential $cred
        Set-SFTPItem -SFTPSession $sftpSession -Destination $RemoteDirPath -Path $LocalItemPath -Force
        $result = Test-SFTPPath -SFTPSession $sftpSession -Path ($RemoteDirPath + (Split-Path $LocalItemPath -Leaf))
        Remove-SFTPSession -SFTPSession $sftpSession | Out-Null
        return $result

    }catch{
        return $_.Exception.Message 
    }
}