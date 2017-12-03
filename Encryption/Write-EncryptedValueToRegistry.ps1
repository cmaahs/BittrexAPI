<#
.Synopsis
Save a provided string value to a specified registry key
.DESCRIPTION
Creates a key in the HKCU:\Software\BittrexPSModule and saves the provided value encrypted using the currently logged in user's security keys
#>
function Write-EncryptedValueToRegistry
{
    [CmdletBinding()]
    Param
    (
        # Registry Key Name
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]       
        $RegistryKey
        ,
        # Registry Key Value
        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]
        $RegistryValue
        ,
        # Optional PIN for Salt
        [Parameter(Mandatory=$false,
                   Position=2)]
        [string]
        $PIN
    )

    Begin
    {
        $continueProcessing = $true
        $encryptedData = Encrypt-Value -ValueToEncrypt $RegistryValue -PIN $PIN
        if ( -not ( Test-Path "HKCU:\Software\BittrexPSModule" ) ) 
        {
            New-Item "HKCU:\Software\BittrexPSModule"
        }
        if ( $PIN -ne "" )
        {
            $readPinValue = (Get-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name "RequirePIN" -ErrorAction SilentlyContinue).RequirePIN
            if ( $readPinValue -ne $null )
            {
                Remove-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name "RequirePIN"
                New-ItemProperty -PropertyType DWord -Path "HKCU:\Software\BittrexPSModule" -Name "RequirePIN" -Value $true
            } else {
                New-ItemProperty -PropertyType DWord -Path "HKCU:\Software\BittrexPSModule" -Name "RequirePIN" -Value $true
            }
        } else {
            $readPinValue = (Get-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name "RequirePIN" -ErrorAction SilentlyContinue).RequirePIN
            if ( $readPinValue -ne $null )
            {     
                Remove-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name "RequirePIN"
            }
        }

        $readValue = (Get-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name $RegistryKey -ErrorAction SilentlyContinue).($RegistryKey)
        if ( $readValue -ne $null )
        {
            Remove-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name $RegistryKey
            New-ItemProperty -PropertyType Binary -Path "HKCU:\Software\BittrexPSModule" -Name $RegistryKey -Value $encryptedData
        } else {
            New-ItemProperty -PropertyType Binary -Path "HKCU:\Software\BittrexPSModule" -Name $RegistryKey -Value $encryptedData
        }
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {

        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            $readValue = Get-EncryptedValueFromRegistry -RegistryKey $RegistryKey -PIN $PIN
            if ( $readValue -eq $RegistryValue ) 
            {
                Write-Output $true
            } else {
                Write-Output $false
            }
        }
    }
}
