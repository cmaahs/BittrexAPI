<#
.Synopsis
Used internally to populate the Dynamic Parameter named Currency
.DESCRIPTION
.EXAMPLE
#>
function Get-CurrenciesForParameter
{
    [CmdletBinding()]
    Param
    (
       
    )
    
    Begin
    {
        $continueProcessing = $true
        if ( ( $Global:LastRetrievedCacheCurrency -eq $null ) -or ((Get-Date) - $Global:LastRetrievedCacheCurrency).TotalMinutes -gt 10 )
        {
            $currencies = Invoke-BittrexRequest -APIURI "/public/getcurrencies" -apiAuth (Get-BittrexAPIKeys) -IsPublic | Select-Object -Property Currency | Sort-Object -Property Currency
            $lastRetrieved = Get-Date
            Set-Variable -Name CurrencyCache -Value $currencies -Scope Global
            Set-Variable -Name LastRetrievedCacheCurrency -Value $lastRetrieved -Scope Global
        } else {
            $currencies = $Global:CurrencyCache
        }
        Write-Output $currencies
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
