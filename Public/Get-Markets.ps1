<#
.Synopsis
Get the markets currently active on Bittrex.  Optionally return inactive markets.
.DESCRIPTION
/public/getmarkets
Used to get the open and available trading markets at Bittrex along with other meta data.

Parameters
None

.EXAMPLE
$markets = Get-Markets
$markets | Where-Object { $_.MarketName.StartsWith("BTC") } | Select-Object -Property MarketName
MarketName
----------
BTC-LTC   
BTC-DOGE  
BTC-VTC   
BTC-PPC   
BTC-FTC   
BTC-RDD   
BTC-NXT   
BTC-DASH  
BTC-POT   
BTC-BLK   
BTC-EMC2  
BTC-XMY   
BTC-AUR   
BTC-EFL   
...

.EXAMPLE
$markets = Get-Markets | Where-Object { $_.MarketName.Contains("EMC") }

$markets


MarketCurrency     : EMC2
BaseCurrency       : BTC
MarketCurrencyLong : Einsteinium
BaseCurrencyLong   : Bitcoin
MinTradeSize       : 16.44736842
MarketName         : BTC-EMC2
IsActive           : True
Created            : 2014-12-24T00:00:00
Notice             : 
IsSponsored        : 
LogoUrl            : https://bittrexblobstorage.blob.core.windows.net/public/aa92fc78-8100-4adb-bbb9-05fb1b7bd166.png

MarketCurrency     : EMC
BaseCurrency       : BTC
MarketCurrencyLong : EmerCoin
BaseCurrencyLong   : Bitcoin
MinTradeSize       : 2.65392781
MarketName         : BTC-EMC
IsActive           : True
Created            : 2016-01-06T05:28:04.553
Notice             : 
IsSponsored        : 
LogoUrl            : https://bittrexblobstorage.blob.core.windows.net/public/449483b1-9832-4273-9d4d-dd8beb5e3f36.png

#>
function Get-Markets
{
    [CmdletBinding()]
    Param
    (
        # Inclucde Inactive Markets
        [Parameter(Mandatory=$false,
                   Position=0)]        
        [string]       
        $IncludeInactive
    )
    
    Begin
    {
        $continueProcessing = $true
        if ( $IncludeInactive -eq $true )
        {
            $markets = Invoke-BittrexRequest -APIURI "/public/getmarkets" -apiAuth (Get-BittrexAPIKeys)
        } else {
            $markets = Invoke-BittrexRequest -APIURI "/public/getmarkets" -apiAuth (Get-BittrexAPIKeys) | Where-Object { $_.IsActive -eq $true }
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
