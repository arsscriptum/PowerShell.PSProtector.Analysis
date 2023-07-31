<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>


$RootPath=(Resolve-Path "$PSScriptRoot").Path
$ScriptPath=(Resolve-Path "$RootPath\scripts").Path
$PublicPath=(Resolve-Path "$RootPath\public").Path
$ModulePath=(Resolve-Path "$RootPath\module").Path

$TemplateModulePath=(Resolve-Path "$ModulePath\Template.psm1").Path
$MySuperModulePath=(Resolve-Path "$ModulePath\MySuperModule.psm1").Path
$ScriptFtpPath=(Resolve-Path "$ScriptPath\Ftp.ps1").Path
$ScriptXmlDefinitionFilePath=(Resolve-Path "$ScriptPath\XmlDefinitionFile.ps1").Path
$ScriptUploadAndConvertPath=(Resolve-Path "$ScriptPath\UploadAndConvert.ps1").Path


. "$ScriptFtpPath"
. "$ScriptXmlDefinitionFilePath"
. "$ScriptUploadAndConvertPath"


function Get-GithubExe{
    $Cmd = Get-Command 'git.exe'
    if($Cmd -ne $Null){
        return $Cmd.Source
    }
    return $Null
}

$GithubExe = Get-GithubExe

if($GithubExe -ne $Null){

    $RemoteUrl = &"$GithubExe" 'config' '--get' 'remote.origin.url'
    $RemoteUrl = $RemoteUrl.Replace('.git','/raw/master/public/MySuperModule.ps1')

    (Get-Content $TemplateModulePath -Raw).Replace("__MODULE_SCRIPT_URL__", "$RemoteUrl") | Set-Content $MySuperModulePath

    Write-Host "ModuleScriptPath: `"$MySuperModulePath`"" -f Yellow
}

Invoke-UploadAndConvert $MySuperModulePath

