<#
.Synopsis
When the script needs to use the API KEY/SECRET this function reads them into variables.
$apiAuth = Get-BittrexAPIKeys
use $apiAuth.Key for the key, and $apiAuth.Secret for the secret.
#>
function Get-BittrexAPIKeys
{
    [CmdletBinding()]
    Param
    (
        # Provide and use a PIN for extra Encryption/Decryption security.  Will prompt once per Powershell Window for use.
        [Parameter(Mandatory=$false,
                   Position=0)]
        [string]
        $PIN = ""
    )

    Begin
    {
        $continueProcessing = $true 
        if ( ( ($Global:KeyPin).Length -gt 0 ) -and ( $PIN -eq "" ) )
        {
            $PIN = $Global:KeyPin
        }
        $apiKey = Get-EncryptedValueFromRegistry -RegistryKey "APIKEY" -PIN $PIN
        $apiSecret = Get-EncryptedValueFromRegistry -RegistryKey "APISECRET" -PIN $PIN
        $apiAuth = "" | Select-Object Key,Secret
        $apiAuth.Key = $apiKey
        $apiAuth.Secret = $apiSecret
        #Write-Output $apiKey
        #Write-Output $apiSecret    
        Write-Output $apiAuth   
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
