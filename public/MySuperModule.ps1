
###
# This is a TEST Module to show the binary conversion

function Invoke-MySuperFunction{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [parameter(mandatory=$false, position=0, ValueFromRemainingArguments=$true)][string]$Color = 'Cyan'
    )
    Clear-Host 
    Write-Host "`t`t`t`t`t`t`tDEMO FUNCTION" -f $Color 
    Write-Host "`t`t`t`t=====================================================" -f DarkYellow
    Write-Host "`n`t`t`t`t" -n
    0..20 | % {
        Write-Host "$_ " -f $Color -n
        Start-Sleep -Milliseconds 300
    }
    Write-Host "`n" 
    Write-Host "`t`t`t`t=====================================================" -f DarkYellow
}

function Invoke-MySuperFunctionCaller{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [parameter(mandatory=$false, position=0, ValueFromRemainingArguments=$true)]$Options
    )

    Invoke-MySuperFunction -Color 'Cyan'
}

