<#
.Synopsis
Take a string and return an encrypted byte array
.DESCRIPTION
Using the System.Security.Cryptography.ProtectedData::Protect, return an encrypted byte array.
#>
function Encrypt-Value
{
    [CmdletBinding()]
    Param
    (
        # String to Encrypt
        [Parameter(Mandatory=$false,
                   Position=0)]
        [string]       
        $ValueToEncrypt
        ,
        # PIN for Salt
        [Parameter(Mandatory=$false,
                   Position=1)]
        [string]       
        $PIN
        
    )

    Begin
    {
        $continueProcessing = $true
        Add-Type -AssemblyName System.Security
        $pinBytes = $null
        $bytes = $ValueToEncrypt.ToCharArray() | % {[byte] $_}
        if ( $PIN.Length -gt 0 )
        {
            $pinBytes = $PIN.ToCharArray() | % {[byte] $_}
        } else {
            $pinBytes = $null
        }
        $encryptedBytes = [System.Security.Cryptography.ProtectedData]::Protect($bytes,$pinBytes,[System.Security.Cryptography.DataProtectionScope]::CurrentUser)
        Write-Output $encryptedBytes
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
