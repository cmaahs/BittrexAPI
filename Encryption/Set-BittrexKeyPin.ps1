<#
.Synopsis
Save the private protected KEY/SECRET values in the registry in an encrypted format.  This keeps the KEY/SECRET from being stored in plain text in the script.
#>
function Set-BittrexKeyPin
{
    [CmdletBinding()]
    Param
    (
        # Provide and use a PIN for extra Encryption/Decryption security.  Will prompt once per Powershell Window for use.
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]
        $PIN
    )

    Begin
    {
        $continueProcessing = $true
        if ( $PIN.Length -gt 0 ) 
        {
            Set-Variable -Name KeyPin -Value $PIN -Scope Global
            try {
                $authInfo = Get-BittrexAPIKeys -PIN $PIN
                Write-Output "The PIN was accepted"
            } catch {
                Write-Error "Please provide the correct PIN before calling other BittrexAPI module functions."
            }
        } else {
            Write-Warning "Please provide a PIN"
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
