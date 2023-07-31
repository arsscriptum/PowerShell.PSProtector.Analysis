<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>


function Invoke-UploadAndConvert {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, position = 0)]
        [string]$ModuleScriptPath
    )
   
    try{
        
        
        $ModuleIdentifier = (gi "$ModuleScriptPath").Basename
        $TmpString = "{0}.{1}" -f "$ENV:COMPUTERNAME","$ModuleIdentifier"
        
        $CurrentPath = (Get-Location).Path
        $EXPORT_ModuleScriptPath = "{0}\{1}_{2}.psm1" -f "$CurrentPath", "$ModuleIdentifier", "$TmpString"
        Copy-Item "$ModuleScriptPath" "$EXPORT_ModuleScriptPath" -Force
        Write-Host "File 1: `"$EXPORT_ModuleScriptPath`"" -f Magenta

        $EXPORT_XmlFile =  "{0}\{1}_{2}.xml" -f "$CurrentPath",  "$ModuleIdentifier", "$TmpString"
        $in = "c:\{0}.psm1" -f $ModuleName 
        $out = "c:\{0}.dll" -f $ModuleName 
        $LoadMsg = "LOADING TEST MODULE {0}" -f $ModuleName
        #$LoadMsg = $LoadMsg.Replace("`n","``n")
        [System.Version]$Version = "4.1.3.22"
        Get-ModuleXmlDefinitionFile -InputFile "$in" -OutputFile "$out" -Version $Version -Copyright '(c) test' -LoadMessage $LoadMsg | Set-Content "$EXPORT_XmlFile"
        Write-Host "File 2: `"$EXPORT_XmlFile`"" -f Yellow
    
       
        $BaseFtpPath = "ftp://cloud.psprotector.com/Input"

        $SendPath = "{0}/{1}" -f $BaseFtpPath, ((Get-Item "$EXPORT_XmlFile").Name)
        Write-Host "Sending $SendPath" -f DarkCyan
        Upload-ToPsProtectorCloud "$SendPath" "$EXPORT_XmlFile"

        $SendPath = "{0}/{1}" -f $BaseFtpPath, ((Get-Item "$EXPORT_ModuleScriptPath").Name)
        Write-Host "Sending $SendPath" -f DarkCyan
        Upload-ToPsProtectorCloud "$SendPath" "$EXPORT_ModuleScriptPath"
     
        Write-Host "Both Files Uploaded!" -f Red 

        Start-Sleep 1

        $BaseFtpPath = "ftp://cloud.psprotector.com/Output"
        $RemoteDllPath = "{0}/{1}_{2}.dll" -f $BaseFtpPath, "$ModuleIdentifier", "$TmpString"

        $Ready = $False
        While($Ready -eq $False){
            Write-Host "Checking is Dll is Ready $RemoteDllPath..." -n -f DarkCyan
            $Ready = Test-FtpModuleReady "$RemoteDllPath"
            Start-Sleep 3
            if($Ready)
            {
                $Local = "{0}\{1}.dll" -f "$CurrentPath", "$ModuleIdentifier" 
                Write-Host "YES" -f Green
                Download-FromPsProtectorCloud $RemoteDllPath $Local -Delete
                $SystemModulePath = $ENV:PSModulePath.Split(';')[0]
                $Dest = "{0}\{1}" -f $SystemModulePath, $ModuleIdentifier
                mkdir "$Dest" -ea Ignore
                Move-Item "$Local" "$Dest" -Force
                
            }
            else
            {
                Write-Host "No" -f Yellow
            }
        }
        Remove-Item $EXPORT_ModuleScriptPath -EA Ignore
        Remove-Item $EXPORT_XmlFile -EA Ignore


         

    }catch{
        Write-Warning "$_"
    }
}

