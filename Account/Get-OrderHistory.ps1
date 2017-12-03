<#
.Synopsis
Get your order history, optionally for a specific market.
.DESCRIPTION
/account/getorderhistory
Used to retrieve your order history.

Parameters
parameter	required	description
market	    optional	a string literal for the market (ie. BTC-LTC). If ommited, will return for all markets

.EXAMPLE
$orderHistory = Get-OrderHistory

$orderHistory.Count
45

.EXAMPLE
$markets = Get-Markets | Where-Object { $_.MarketName -eq "BTC-LTC" -or $_.MarketName -eq "BTC-EMC2" }

$markets


MarketCurrency     : LTC
BaseCurrency       : BTC
MarketCurrencyLong : Litecoin
BaseCurrencyLong   : Bitcoin
MinTradeSize       : 0.02784181
MarketName         : BTC-LTC
IsActive           : True
Created            : 2014-02-13T00:00:00
Notice             : 
IsSponsored        : 
LogoUrl            : https://bittrexblobstorage.blob.core.windows.net/public/6defbc41-582d-47a6-bb2e-d0fa88663524.png

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

$orderHistory = $markets | Get-OrderHistory

$orderHistory.Count
12

.EXAMPLE
Get-OrderHistory | Select-Object -First 1


OrderUuid         : f49c2e39-e3a7-4381-a17c-9a6de9d83321
Exchange          : BTC-EMC2
TimeStamp         : 2017-11-30T16:49:16.56
OrderType         : LIMIT_SELL
Limit             : 0.00004500
Quantity          : 200.00000000
QuantityRemaining : 0.00000000
Commission        : 0.00002250
Price             : 0.00900000
PricePerUnit      : 0.00004500000000000000
IsConditional     : False
Condition         : NONE
ConditionTarget   : 
ImmediateOrCancel : False
Closed            : 2017-11-30T16:49:33.887


#>
function Get-OrderHistory
{
    [CmdletBinding()]
    Param
    (
       
    )
    DynamicParam
    {
        $ParameterName = "Market"
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $false
        $ParameterAttribute.ValueFromPipeline = $true
        $ParameterAttribute.ValueFromPipelineByPropertyName = $true
        $AttributeCollection.Add($ParameterAttribute)

        $ParameterPosition = 0

        $ParameterAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList "MarketName"
        $AttributeCollection.Add($ParameterAlias)

        $arrSet = foreach ( $market in Get-MarketsForParameter ) { Write-Output $market.MarketName.ToString() }
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

        $AttributeCollection.Add($ValidateSetAttribute)

        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary

    }
    Begin
    {
        $continueProcessing = $true
        $orderHistoryCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $Market = $PSBoundParameters[$ParameterName]  
            if ( $Market.Length -gt 0 )
            {      
                $marketParam = "?market=$($Market)"
            } else {
                $marketParam = ""
            }
            $orderHistory = Invoke-BittrexRequest -APIURI "/account/getorderhistory$($marketParam)" -apiAuth (Get-BittrexAPIKeys)
            $orderHistoryCollection += $orderHistory
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $orderHistoryCollection
        }
    }
}
