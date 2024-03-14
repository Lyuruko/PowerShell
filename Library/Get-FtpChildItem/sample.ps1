Get-FtpChildItem -FtpPath 'ftp://xxxxx.com/temp01/' `
                 -Username 'xxxxx' `
                 -Password 'xxxxx' `
                 -Recurse $true | Select-Object FullName