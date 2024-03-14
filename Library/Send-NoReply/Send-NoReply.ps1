Function Send-NoReply(){

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string]$To,
        [Parameter(Mandatory = $true)][string]$Subject,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Body,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$ScriptPath,
        [Parameter(Mandatory = $false)][array]$Attachment
    )

    $noreply_email    = 'noreply@xxxxx.com'
    $noreply_password = 'xxxxx'

    $mail = New-Object System.Net.Mail.MailMessage
    $mail.From = $noreply_email
    $mail.To.Add($To)
    $mail.Bcc.Add('xxx@xxxxx.com')
    $mail.Subject = $Subject + " " + (Get-Date).ToString("yyyy-MM-dd")
    $mail.Body = $Body + "`n`n`n" +
    "--`n" +
    "Email Time: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")+ " (EST)" + "`n" + 
    "Script Path: " + $ScriptPath + "`n" + 
    "Computer Name: " + $env:computername

    If ($Attachment.Count -gt 0) {
        $Attachment | ForEach-Object {
            $mail.Attachments.Add((New-Object Net.Mail.Attachment($_)))        
        }
    }

    $smtp_server = "smtp.gmail.com"
    $smtp_port   = "587"
    $smtp_client = New-Object System.Net.Mail.SmtpClient($smtp_server, $smtp_port)
    $smtp_client.EnableSsl = $true
    $smtp_client.Credentials = New-Object System.Net.NetworkCredential($noreply_email, $noreply_password);
    $smtp_client.Send($mail)
}