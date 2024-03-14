Function Invoke-GsOptimizePdf(){

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string]$SourcePdf,
        [Parameter(Mandatory = $true)][string]$OutputPdf,
        [Parameter(Mandatory = $false)][ValidateSet("PressReader","MediaCarrier")][String]$Type = 'PressReader'

    )

    $ghostscript_exe = 'C:\Program Files (x86)\gs\gs9.16\bin\gswin32c.exe'
    if(Test-Path $ghostscript_exe){}else{ return ($ghostscript_exe+" file not found.") }

    switch ($Type) {
        PressReader { 
            $ghostscript_arg = '-sDEVICE=pdfwrite -r300 -dNOPAUSE -dQUIET -dBATCH -sOutputFile='+$OutputPdf+' '+$SourcePdf
            break 
        }    
        MediaCarrier { 
            $ghostscript_arg = '-sDEVICE=pdfwrite -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile='+$OutputPdf+' '+$SourcePdf
            break 
        }    
    }

    if(Test-Path (Split-Path $OutputPdf)){}else{ New-Item -ItemType Directory -Path (Split-Path $OutputPdf) | Out-Null }
    if(Test-Path $OutputPdf){Remove-Item $OutputPdf -Force -Verbose}
    Start-Process $ghostscript_exe -ArgumentList $ghostscript_arg -Wait
    if(Test-Path $OutputPdf){ Write-Output $OutputPdf }else{ Write-Output $null }
} 