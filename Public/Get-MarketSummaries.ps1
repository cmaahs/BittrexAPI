<#
.Synopsis
Return the last 24 hour summary of all active exchanges on Bittrex.
.DESCRIPTION
/public/getmarketsummaries
Used to get the last 24 hour summary of all active exchanges

Parameters
None
.EXAMPLE
$marketSummaries = Get-MarketSummaries

$marketSummaries | Where-Object { $_.MarketName -eq "BTC-EMC2" }


MarketName     : BTC-EMC2
High           : 0.00005099
Low            : 0.00003610
Volume         : 35976415.10730453
Last           : 0.00003949
BaseVolume     : 1499.04926758
TimeStamp      : 2017-11-30T00:42:32.177
Bid            : 0.00003951
Ask            : 0.00003989
OpenBuyOrders  : 965
OpenSellOrders : 4282
PrevDay        : 0.00004904
Created        : 2014-12-24T00:00:00
#>
function Get-MarketSummaries
{
    [CmdletBinding()]
    Param
    (
       
    )
    
    Begin
    {
        $continueProcessing = $true
        $marketsummary = Invoke-BittrexRequest -APIURI "/public/getmarketsummaries" -apiAuth (Get-BittrexAPIKeys)
        Write-Output $marketsummary
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
