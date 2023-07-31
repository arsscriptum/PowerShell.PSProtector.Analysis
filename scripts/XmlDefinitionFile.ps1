<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>



function Get-ModuleXmlDefinitionFile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$false)]
        [string]$InputFile = "n/a",
        [Parameter(Mandatory=$false)]
        [string]$OutputFile = "n/a",
        [Parameter(Mandatory=$false)]
        [string]$Title = "n/a",
        [Parameter(Mandatory=$false)]
        [string]$Description = "n/a",
        [Parameter(Mandatory=$false)]
        [string]$Company = "n/a",
        [Parameter(Mandatory=$false)]
        [string]$Product = "n/a",
        [Parameter(Mandatory=$false)]
        [string]$Copyright = "n/a",
        [Parameter(Mandatory=$false)]
        [string]$LoadMessage = "",
        [Parameter(Mandatory=$false)]
        [System.Version]$Version = "1.0.0.0"
    )
   
    try{    
        $loadmsg_enabled = 'false'
        if([string]::IsNullOrEmpty($LoadMessage) -eq $False){
            $loadmsg_enabled = 'true'
        }
        $xmldata = @"
<?xml version=`"1.0`" encoding=`"UTF-8`"?>
<ProjectPreferences xmlns:xsd=`"http://www.w3.org/2001/XMLSchema`" xmlns:xsi=`"http://www.w3.org/2001/XMLSchema-instance`">
   <InputFileName>{0}</InputFileName>
   <DestinationPath>{1}</DestinationPath>
   <AssemblyTitle>{2}</AssemblyTitle>
   <AssemblyDescription>{3}</AssemblyDescription>
   <AssemblyCompany>{4}</AssemblyCompany>
   <AssemblyProduct>{5}</AssemblyProduct>
   <AssemblyCopyright>{6}</AssemblyCopyright>
   <AssemblyVersionMajor>{7}</AssemblyVersionMajor>
   <AssemblyVersionMinor>{8}</AssemblyVersionMinor>
   <AssemblyVersionBuild>{9}</AssemblyVersionBuild>
   <AssemblyVersionRevision>{10}</AssemblyVersionRevision>
   <LicenseEnabled>false</LicenseEnabled>
   <LicenseRegistredTo />
   <LicenseExpiredDateEnabled>false</LicenseExpiredDateEnabled>
   <LicenseExpiredDate>{11}</LicenseExpiredDate>
   <OtherShowLoadingMessageEnabled>$loadmsg_enabled</OtherShowLoadingMessageEnabled>
   <OtherScriptBlockLoggingSettings>0</OtherScriptBlockLoggingSettings>
   <OtherShowLoadingMessage>{12}</OtherShowLoadingMessage>
   <OtherTargetFrameworkSettings>0</OtherTargetFrameworkSettings>
</ProjectPreferences>
"@
        $DateStr = Get-Date -UFormat "%m.%d.%Y"
        $xmldata = $xmldata -f $InputFile, $OutputFile, $Title, $Description, $Company, $Product,$Copyright , $Version.Major, $Version.Minor, $Version.Build, $Version.Revision, $DateStr, $LoadMessage
        $xmldata
    }catch{
        Write-Error "$_"
    }
}