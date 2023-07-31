<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>


$RootPath=(Resolve-Path "$PSScriptRoot").Path
$ScriptPath=(Resolve-Path "$RootPath\scripts").Path
$PublicPath=(Resolve-Path "$RootPath\public").Path
$ModulePath=(Resolve-Path "$RootPath\module").Path

$MySuperModulePath=(Resolve-Path "$ModulePath\MySuperModule.psm1").Path
$ScriptFtpPath=(Resolve-Path "$ScriptPath\Ftp.ps1").Path
$ScriptXmlDefinitionFilePath=(Resolve-Path "$ScriptPath\XmlDefinitionFile.ps1").Path
$ScriptUploadAndConvertPath=(Resolve-Path "$ScriptPath\UploadAndConvert.ps1").Path


. "$ScriptFtpPath"
. "$ScriptXmlDefinitionFilePath"
. "$ScriptUploadAndConvertPath"




Write-Host "ModuleScriptPath: `"$MySuperModulePath`"" -f Yellow

Invoke-UploadAndConvert $MySuperModulePath
