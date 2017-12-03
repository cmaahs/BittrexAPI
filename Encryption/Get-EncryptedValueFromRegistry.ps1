<#
.Synopsis
Return a decrypted string value from a provided registry key.
The registry key must contain an encrypted value, encrypted by the System.Security.Cryptography.ProtectedData::Protect method.
#>
function Get-EncryptedValueFromRegistry
{
    [CmdletBinding()]
    Param
    (
        # Key name to read from
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]       
        $RegistryKey
        ,                
        # Optional PIN for Salt
        [Parameter(Mandatory=$false,
                   Position=1)]
        [string]
        $PIN = ""

    )

    Begin
    {
        $continueProcessing = $true
        $readValue = (Get-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name $RegistryKey -ErrorAction SilentlyContinue).($RegistryKey)
        $decryptedValue = Decrypt-Value -ValueToDecrypt $readValue -PIN $PIN
        Write-output $decryptedValue
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
        
        }
    }
}
