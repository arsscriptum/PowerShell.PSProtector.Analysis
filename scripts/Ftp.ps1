<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>


function Upload-ToPsProtectorCloud {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, position = 0)]
        [string]$Remote,
        [Parameter(Mandatory=$true, position = 1)]
        [string]$Local
    )
   
    try{    
        
        $request = [System.Net.FtpWebRequest]::Create($remote)
        $request.Credentials = [System.Net.NetworkCredential]::new("demo", "rWf1+ccFx!p2a0e");
        $request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $request.UsePassive = $true
        $fileStream = [System.IO.File]::OpenRead($local)
        $ftpStream = $request.GetRequestStream()
        $fileStream.CopyTo($ftpStream)
        $ftpStream.Dispose()
        $fileStream.Dispose()

    }catch{
        Write-Warning "$_"
    }
}


function Download-FromPsProtectorCloud {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, position = 0)]
        [string]$Remote,
        [Parameter(Mandatory=$true, position = 1)]
        [string]$Local,
        [Parameter(Mandatory=$false)]
        [switch]$Delete
    )
   
    try{    
        
        # Create a FTPWebRequest
        $FTPRequest = [System.Net.FtpWebRequest]::Create($Remote)
        $FTPRequest.Credentials =  [System.Net.NetworkCredential]::new("demo", "rWf1+ccFx!p2a0e");
        $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
        $FTPRequest.UseBinary = $true
        $FTPRequest.KeepAlive = $false
        # Send the ftp request
        $FTPResponse = $FTPRequest.GetResponse()
        Write-Host "Downloaded `"$Remote`"" -f Yellow
        # Get a download stream from the server response
        $ResponseStream = $FTPResponse.GetResponseStream()
        # Create the target file on the local system and the download buffer
        $LocalFileFile = [IO.FileStream]::new($Local,[IO.FileMode]::Create)
        [byte[]]$ReadBuffer = New-Object byte[] 1024
        # Loop through the download
        do {
            $ReadLength = $ResponseStream.Read($ReadBuffer,0,1024)
            $LocalFileFile.Write($ReadBuffer,0,$ReadLength)
        }
        while ($ReadLength -ne 0)
        $LocalFileFile.Close()
        $LocalFileFile.Dispose()
        Write-Host "Wrote `"$Local`"" -f Magenta
        $LocalFileFile
        if($Delete){
            $FTPDeleteRequest = [System.Net.FtpWebRequest]::Create($Remote)
            $FTPDeleteRequest.Credentials =  [System.Net.NetworkCredential]::new("demo", "rWf1+ccFx!p2a0e");
            $FTPDeleteRequest.Method = [System.Net.WebRequestMethods+Ftp]::DeleteFile
            $FTPResponse = $FTPDeleteRequest.GetResponse()
            $Result = $FTPResponse.StatusCode
            if('FileActionOK' -eq $Result){
                Write-Host "Deleted `"$Remote`"" -f Magenta
            }else{
                Write-Host "Error Deleting `"$Remote`"" -f Red
            }
        }

    }catch{
        Write-Warning "$_"
    }
}



function Test-FtpModuleReady {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, position = 0)]
        [string]$Remote
    )
    try{      
        $request = [Net.WebRequest]::Create($Remote)
        $request.Credentials = [System.Net.NetworkCredential]::new("demo", "rWf1+ccFx!p2a0e");
        $request.Method = [Net.WebRequestMethods+Ftp]::GetFileSize
        try{
            $request.GetResponse() | Out-Null
            return $True
        }catch{
            $response = $_.Exception.InnerException.Response;
            if ($response.StatusCode -eq [Net.FtpStatusCode]::ActionNotTakenFileUnavailable){
                Return $False
            }else{
                Write-Host ("Error: " + $_.Exception.Message)
            }
        }
    }catch{
        Write-Warning "$_"
    }
}
