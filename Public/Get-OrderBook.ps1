<#
.Synopsis
Get the orderbook for a specified market.
.DESCRIPTION
/public/getorderbook
Used to get retrieve the orderbook for a given market

Parameters
parameter	required	description
market	    required	a string literal for the market (ex: BTC-LTC)
type	    required	buy, sell or both to identify the type of orderbook to return.

.EXAMPLE
$orderBook = Get-OrderBook -Market BTC-EMC2 -OrderType BOTH

($orderBook | Where-Object { $_.OrderType -eq "BUY" }).Count
587

($orderBook | Where-Object { $_.OrderType -eq "SELL" }).Count
1913

.EXAMPLE
$markets = Get-Markets | Where-Object { $_.MarketName.Contains("EMC") }

$orderBook = $markets | Get-OrderBook -OrderType BOTH

$orderBook | Select-Object -Property Market,OrderType | Sort-Object -Property Market,OrderType -Unique

Market   OrderType
------   ---------
BTC-EMC  BUY      
BTC-EMC  SELL     
BTC-EMC2 BUY      
BTC-EMC2 SELL     

.EXAMPLE
$orderBook = $markets | Get-OrderBook -OrderType BUY

$orderBook | Select-Object -Property Market,OrderType | Sort-Object -Property Market,OrderType -Unique

Market   OrderType
------   ---------
BTC-EMC  BUY      
BTC-EMC2 BUY      
#>
function Get-OrderBook
{
    [CmdletBinding()]
    Param
    (
        # Limit the Order Type by specifying the type
        [Parameter(Mandatory=$true,
                   Position=1)]        
        [ValidateSet('BUY','SELL','BOTH')]
        [string]       
        $OrderType = "BOTH"
    )
    DynamicParam
    {
        $ParameterName = "Market"
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
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
        $orderBookCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $Market = $PSBoundParameters[$ParameterName]
            $marketParam = "?market=$($Market)"
            $typeParam = "&type=$($OrderType.ToLower())"
            $orderbook = Invoke-BittrexRequest -APIURI "/public/getorderbook$($marketParam)$($typeParam)" -apiAuth (Get-BittrexAPIKeys)
            if ( $OrderType -eq "BOTH" )
            {
                $orderCollection = @()
                foreach ( $s in $orderbook.sell ) 
                {
                    $s_item = "" | Select-Object Market,OrderType,Quantity,Rate
                    $s_item.Market = $Market
                    $s_item.OrderType = "SELL"
                    $s_item.Quantity = $s.Quantity
                    $s_item.Rate = $s.Rate
                    $orderCollection += $s_item
                }                
                foreach ( $b in $orderbook.buy ) 
                {
                    $b_item = "" | Select-Object Market,OrderType,Quantity,Rate
                    $b_item.Market = $Market
                    $b_item.OrderType = "BUY"
                    $b_item.Quantity = $b.Quantity
                    $b_item.Rate = $b.Rate
                    $orderCollection += $b_item
                }
                $orderBookCollection += $orderCollection
            } else {
                $orderCollection = @()
                foreach ( $o in $orderbook ) 
                {
                    $o_item = "" | Select-Object Market,OrderType,Quantity,Rate
                    $o_item.Market = $Market
                    $o_item.OrderType = $OrderType
                    $o_item.Quantity = $o.Quantity
                    $o_item.Rate = $o.Rate
                    $orderCollection += $o_item
                }
                $orderBookCollection += $orderCollection
            }
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $orderBookCollection
        }
    }
}
