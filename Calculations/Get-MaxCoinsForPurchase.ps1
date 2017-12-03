<#
.Synopsis
Use to calculate your max coins you can purchase with your available funds.
.DESCRIPTION
This calculation doesn't depend on the purchase currency.  
.EXAMPLE
Get-MaxCoinsForPurchase -SourceCurrency BTC -Rate 0.00000025 -ShowBuyCommand
9.2967
#Buy-Limit -Rate 0.00000025 -Quantity 9.2967 -Market

Buy-Limit -Rate 0.00000025 -Quantity 9.2967 -Market BTC-EMC2
Invoke-BittrexRequest : Bittrex API returned an error: MIN_TRADE_REQUIREMENT_NOT_MET
At C:\Users\Chris\Documents\WindowsPowerShell\Modules\BittrexAPI\BittrexAPI.psm1:1592 char:26
+ ... orderbook = Invoke-BittrexRequest -APIURI "/market/buylimit$($marketP ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Invoke-BittrexRequest
 


#>
function Get-MaxCoinsForPurchase
{
    [CmdletBinding()]
    Param
    (
     # Quantity To Purchase
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ValidateSet('BTC','ETH','USDT')]
        [string]       
        $SourceCurrency
        ,
        # Rate at Which To Purchase
        [Parameter(Mandatory=$true,
                   Position=1)]        
        [double]
        $Rate
        ,
        # Show a commented Buy-Limit command
        [Parameter(Mandatory=$false,
                   Position=2)]        
        [switch]
        $ShowBuyCommand
        
    )
    
    Begin
    {
        $continueProcessing = $true
        $sourceBalance = (Get-Balances | Where-Object { $_.Currency -eq "$($SourceCurrency)" }).Available 
        $sourceAvailable = $sourceBalance - ($sourceBalance * .0025)
        $maxBuy = [Math]::Round(($sourceAvailable / $Rate),7)
        Write-Output $maxBuy
        if ( $ShowBuyCommand -eq $true ) 
        {
            $buyLine = "#Add-BuyLimit -Rate {0:n8} -Quantity $($maxBuy) -Market" -f $Rate
            Write-Output $buyLine
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
