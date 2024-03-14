Function Get-FtpChildItem(){

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string]$FtpPath,
        [Parameter(Mandatory = $true)][string]$Username,
        [Parameter(Mandatory = $true)][string]$Password,
        [Parameter(Mandatory = $true)][boolean]$Recurse
    )


    # add "/" to the end if missing

    if($FtpPath.Substring($FtpPath.Length-1,1) -ne "/"){ $FtpPath = $FtpPath+"/" }
    Write-Host -ForegroundColor Cyan ("Reading "+$FtpPath)



    # get and read ftp ListDirectoryDetails stream result, convert to array object
    # omit "." and ".." from ftp stream results

    $file_array = New-Object System.Collections.ArrayList
    $web_request = [System.Net.FtpWebRequest]::Create($FtpPath)
    $web_request.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
    $web_request.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
    $web_request.UseBinary = $False
    $web_request.KeepAlive = $False
    
    try{
        $response = $web_request.GetResponse()
        $response_check = $true
    }catch{
        $response_check = $false
    }

    if($response_check){

        $response_stream = $response.GetResponseStream()
        $stream_reader = New-Object System.IO.StreamReader($response_stream,[System.Text.Encoding]::Default)
   
        try{

            While ($file = $stream_reader.ReadLine()){
                if( ($file -ne ".") -and ($file -ne "..") ){ 
                    [void] $file_array.add("$file")
                }
            }

            $stream_reader.close()
            $response_stream.close()
            $response.Close()

        }catch{
        
            Write-Host -ForegroundColor Red ("Stream ReadLine failed for "+$FtpPath)
            Return $_.Exception
        }

    }else{

        Write-Host -ForegroundColor Red ("Ftp GetResponse failed for "+$FtpPath)
        Return $_.Exception
    }



    # split stream ftp results and rebuild into obj
    # if filetype is <DIR> and $Recurse is true, recursive call this function again to go deeper

    $file_array | ForEach-Object{

        $split = ($_ -split '\ +') # split FTP stream results

        $file_name = (3..($split.Length) | ForEach-Object{ $Split[$_] }) -join " "
        $file_name = $file_name.Substring(0, $file_name.Length-1)  

        $obj = New-Object -TypeName PSObject
        $obj | Add-Member -MemberType NoteProperty -Name Date -Value $split[0]
        $obj | Add-Member -MemberType NoteProperty -Name Time -Value $split[1]
        $obj | Add-Member -MemberType NoteProperty -Name Info -Value $split[2]
        $obj | Add-Member -MemberType NoteProperty -Name Name -Value $file_name
        $obj | Add-Member -MemberType NoteProperty -Name FullName -Value ($FtpPath+$file_name)

        if( ($split[2] -eq "<DIR>") -and $Recurse ){
            Get-FtpChildItem -FtpPath ($FtpPath+$file_name+"/") -Username $Username -Password $Password -Recurse $Recurse
        }

        return $obj
    }

}