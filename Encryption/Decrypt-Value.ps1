<#
.Synopsis
Decrypt a byte array
.DESCRIPTION
System.Security.Cryptography.ProtectedData::Unprotect expects data in a byte array.
#>
function Decrypt-Value
{
    [CmdletBinding()]
    Param
    (
        # EncryptedValueToDecrypt
        [Parameter(Mandatory=$true,
                   Position=0)]
        [byte[]]       
        $ValueToDecrypt
        ,
        # PIN for Salt
        [Parameter(Mandatory=$false,
                   Position=1)]
        [string]       
        $PIN
        
    )

    Begin
    {
        Add-Type -AssemblyName System.Security
        $continueProcessing = $true
        $pinBytes = $null
        if ( $PIN.Length -gt 0 )
        {
            $pinBytes = $PIN.ToCharArray() | % {[byte] $_}
        } else {
            $pinBytes = $null
        }
        try 
        {
            $clearText = ""
            $bytes = [System.Security.Cryptography.ProtectedData]::Unprotect($ValueToDecrypt, $pinBytes, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
            $bytes | % { $clearText += [char]$_ }
            Write-Output $clearText
        } catch {
            Write-Output ""
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
