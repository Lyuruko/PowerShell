# Require Posh-SSH module

Function Send-SshCommand(){

    param(
        [Parameter(Mandatory=$true)][string]$IpAddress,
        [Parameter(Mandatory=$true)][string]$Username,
        [Parameter(Mandatory=$true)][string]$Password,
        [Parameter(Mandatory=$true)][string[]]$Commands
    )

    try{
        Import-Module Posh-SSH
        $pswd = ConvertTo-SecureString $Password -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($Username, $pswd)
        $sshSession = New-SSHSession -ComputerName $IpAddress -Credential $cred -AcceptKey
        $shell = $sshSession.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 100)
        $user = Invoke-SSHCommand $sshSession -Command "whoami"
        $user = $user.Output | Out-String
        $user = $user.Trim()

        Write-Host -ForegroundColor DarkCyan "sudo su ..."
        Invoke-SSHStreamExpectSecureAction -ShellStream $shell -Command "sudo su" -ExpectString "[sudo] password for $($user):" -SecureAction $pswd | Out-Null
        Start-Sleep 10

        $Commands | ForEach-Object{

            Write-Host -ForegroundColor Cyan $_
            $shell.WriteLine($_)
            Start-Sleep 10

        }

        Write-Host -ForegroundColor DarkCyan "exit ..."
        $shell.WriteLine("exit")
        Start-Sleep 2

        Write-Host -ForegroundColor DarkCyan "exit ..."
        $shell.WriteLine("exit")
        Start-Sleep 2

        $shell.read() 
        $shell.Close()
        Remove-SSHSession -SSHSession $sshSession | Out-Null
        

    }catch{
        return $_.Exception.Message 
    }
}