<#
.Synopsis
Used internally to populate the Dynamic Parameter named Market
.DESCRIPTION
.EXAMPLE
#>
function Get-MarketsForParameter
{
    [CmdletBinding()]
    Param
    (
       
    )
    
    Begin
    {
        $continueProcessing = $true
        if ( ( $Global:LastRetrievedCache -eq $null ) -or ((Get-Date) - $Global:LastRetrievedCache).TotalMinutes -gt 10 )
        {
            $markets = Invoke-BittrexRequest -APIURI "/public/getmarkets" -apiAuth (Get-BittrexAPIKeys) -IsPublic | Select-Object -Property MarketName | Sort-Object -Property MarketName
            $lastRetrieved = Get-Date
            Set-Variable -Name MarketCache -Value $markets -Scope Global
            Set-Variable -Name LastRetrievedCache -Value $lastRetrieved -Scope Global
        } else {
            $markets = $Global:MarketCache
        }
        Write-Output $markets
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
