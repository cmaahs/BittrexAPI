<#
.Synopsis
.DESCRIPTION
.EXAMPLE
#>
function Invoke-BittrexRequest
{
    [CmdletBinding()]
    Param
    (
        # URI for the API Call
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]       
        $APIURI
        ,
        # API Authorization Information Key/Secret
        [Parameter(Mandatory=$true,
                   Position=1)]
        $apiAuth
        ,
        # API Authorization Information Key/Secret
        [Parameter(Mandatory=$false,
                   Position=2)]
        [switch]
        $Test
        ,
        # Skip the PIN Check if it is a public call
        [Parameter(Mandatory=$false,
                   Position=3)]
        [switch]
        $IsPublic
    )

    Begin
    {
        $continueProcessing = $true
        $epoch = Get-Date("1970-01-01")
        [int]$nonce = (( Get-Date ) - $epoch).TotalSeconds

        if ( -Not ($IsPublic) ) 
        {
            $readPinValue = (Get-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name "RequirePIN" -ErrorAction SilentlyContinue).RequirePIN
            if ( ( $readPinValue -eq $true ) -and ( $global:KeyPin -eq $null ) )
            {
                Write-Error "You have specified a PIN to protect your API KEYS for the BittrexAPI module functions."
                Write-Warning "Use the 'Set-BittrexKeyPin -PIN nnnn' to set the correct PIN"
                $continueProcessing = $false                
            }
        }
        if ( $continueProcessing -eq $true ) 
        {
            $baseURL = "https://bittrex.com/api/v1.1"
        
            if ( $APIURI.Contains("?") )
            {
                $secureURL = "$($baseURL)$($APIURI)&apikey=$($apiAuth.Key)&nonce=$($nonce)"
            } else {
                $secureURL = "$($baseURL)$($APIURI)?apikey=$($apiAuth.Key)&nonce=$($nonce)"
            }
            $utf = New-Object System.Text.UTF8Encoding
            $byteSecureURL = $utf.GetBytes($secureURL)

            $sha = New-Object System.Security.Cryptography.HMACSHA512
            $sha.Key = [Text.Encoding]::ASCII.GetBytes($apiAuth.Secret)
            $computeSha = $sha.ComputeHash($byteSecureURL)
        
            $signature = [System.BitConverter]::ToString($computeSha) -replace "-"

            $headers = @{"apisign"=$signature}

            Write-Verbose $secureURL
            if ( -not $Test )
            {
                $response = Invoke-WebRequest -Uri $secureURL -Headers $headers
                $returnObject = $response | ConvertFrom-Json
                Write-Verbose "RAW Response: $($response)"
                Write-Verbose "Return Object: $($returnObject)"        
                #if ( -not ( ($returnObject | Get-Member | Where-Object { $_.Name -eq "success" }).Count -eq 0 ) )
                #{
                #
                #}                    
                if ( -not ( $returnObject.PSObject.Properties['success'] ) )
                {
                    Write-Error "Bittrex API did not return JSON data, as expected."
                    $continueProcessing = $false
                }
                if ( -not ( $returnObject.success -eq $true ) )
                {
                    Write-Error "Bittrex API returned an error: $($response.message)"
                    $continueProcessing = $false
                }
                if ( $continueProcessing -eq $true )
                {
                    if ( ($secureURL.Contains("/market/cancel")) -and ( $returnObject.success -eq $true ) )
                    {
                        Write-Output "Cancellation of $($APIURI) is successful."
                    }
                    Write-Output $returnObject.Result
                } else {
                    Write-Output $null
                }
            } else {
                Write-Output $secureURL
            }
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
$readPinValue = (Get-ItemProperty -Path "HKCU:\Software\BittrexPSModule" -Name "RequirePIN" -ErrorAction SilentlyContinue).RequirePIN
if ( $readPinValue -eq $true ) 
{
    $PIN = Read-Host -Prompt "PIN Required"
    Set-Variable -Name KeyPin -Value $PIN -Scope Global  
    try 
    {
        $authInfo = Get-BittrexAPIKeys -PIN $PIN
        Write-Verbose "The PIN was accepted" -Verbose
    } catch {
        Write-Error "Please provide the correct PIN before calling other BittrexAPI module functions."
        Write-Warning "Use the 'Set-BittrexKeyPin -PIN nnnn' to set the correct PIN"
    }          
}