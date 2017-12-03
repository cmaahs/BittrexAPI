<#
.Synopsis
Save the private protected KEY/SECRET values in the registry in an encrypted format.  This keeps the KEY/SECRET from being stored in plain text in the script.
.EXAMPLE
Save-BittrexAPIKeys -Key '' -Secret ''

.EXAMPLE
Save-BittrexAPIKeys -Key '' -Secret '' -PIN 12354
#>
function Save-BittrexAPIKeys
{
    [CmdletBinding()]
    Param
    (
        # Provide the API KEY value
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]       
        $Key
        ,
        # Provide the API SECRET value
        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]
        $Secret
        ,
        # Provide and use a PIN for extra Encryption/Decryption security.  Will prompt once per Powershell Window for use.
        [Parameter(Mandatory=$false,
                   Position=2)]
        [string]
        $PIN = ""
    )

    Begin
    {
        $continueProcessing = $true
        if ( Write-EncryptedValueToRegistry -RegistryKey "APIKEY" -RegistryValue $Key -PIN $PIN)
        {
            Write-Output "Saved APIKEY Successfully"
            if ( $PIN.Length -gt 0 ) 
            {
                Set-Variable -Name KeyPin -Value $PIN -Scope Global
            }
        } else {
            Write-Error "Problem Storing APIKEY"
        }
        if ( Write-EncryptedValueToRegistry -RegistryKey "APISECRET" -RegistryValue $Secret -PIN $PIN)
        {
            Write-Output "Saved APISECRET Successfully"
            if ( $PIN.Length -gt 0 )
            {
                Set-Variable -Name KeyPin -Value $PIN -Scope Global
            }
        } else {
            Write-Error "Problem Storing APISECRET"
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
        
        }
    }
}
