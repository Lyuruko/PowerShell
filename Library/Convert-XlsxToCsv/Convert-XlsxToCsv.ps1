Function Convert-XlsxToCsv(){

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string][ValidatePattern(".*\.(xlsx|XLSX)")]$FullPath
    )

    if(Test-Path $FullPath){

        $item = Get-Item $FullPath

            $csv = Join-Path $item.DirectoryName -ChildPath ($item.BaseName + ".csv")
            if(Test-Path $csv){ Remove-Item $csv -Force }

            try{

                $excel = New-Object -ComObject Excel.Application
                $wb = $excel.Workbooks.Open($FullPath) 
                $wb.SaveAs($csv,6)
                $wb.Close($false)
                $excel.quit()

                Write-Output $csv

            }catch{
                Write-Output $null # excel fail 
            } 

    }else{
        Write-Output $null # file doesn't exist 
    } 
}