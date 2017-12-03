<#
.Synopsis
Use to place a sell order for a Bittrex market.
.DESCRIPTION
/market/selllimit
Used to place an sell order in a specific market. Use selllimit to place limit orders. Make sure you have the proper permissions set on your API keys for this call to work

Parameters
parameter	required	description
market	required	a string literal for the market (ex: BTC-LTC)
quantity	required	the amount to purchase
rate	required	the rate at which to place the order

.EXAMPLE
$sellLimit = Add-SellLimit -Market BTC-EMC2 -Quantity 200 -Rate 0.00004610

$sellLimit

uuid                                
----                                
47b8d028-19ef-4c8a-ac82-246422cec214


$openOrders = Get-OpenOrders

$openOrders


Uuid              : 
OrderUuid         : 47b8d028-19ef-4c8a-ac82-246422cec214
Exchange          : BTC-EMC2
OrderType         : LIMIT_SELL
Quantity          : 200.00000000
QuantityRemaining : 200.00000000
Limit             : 0.00004610
CommissionPaid    : 0.00000000
Price             : 0.00000000
PricePerUnit      : 
Opened            : 2017-11-30T15:41:33.94
Closed            : 
CancelInitiated   : False
ImmediateOrCancel : False
IsConditional     : False
Condition         : NONE
ConditionTarget   : 

#>
function Add-SellLimit
{
    [CmdletBinding()]
    Param
    (
        # Quantity To Sell
        [Parameter(Mandatory=$true,
                   Position=1)]        
        [string]       
        $Quantity
        ,
        # Rate at Which To Sell
        [Parameter(Mandatory=$true,
                   Position=2)]        
        [string]       
        $Rate
        ,
        # Use to just output the URL and Query string, without interacting with the exchange.
        [Parameter(Mandatory=$false,
                   Position=3)]        
        [switch]       
        $Test
    )
    DynamicParam
    {
        $ParameterName = "Market"
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterPosition = 0

        $AttributeCollection.Add($ParameterAttribute)

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
        $Market = $PSBoundParameters[$ParameterName]
        $marketParam = "?market=$($Market)"
        $quantityParam = "&quantity=$($Quantity)"
        $rateParam = "&rate=$($Rate)"

        if ( $Test -eq $true )
        {
            $orderbook = Invoke-BittrexRequest -APIURI "/market/selllimit$($marketParam)$($quantityParam)$($rateParam)" -apiAuth (Get-BittrexAPIKeys) -Test
        } else {
            $orderbook = Invoke-BittrexRequest -APIURI "/market/selllimit$($marketParam)$($quantityParam)$($rateParam)" -apiAuth (Get-BittrexAPIKeys) 
        }
        Write-Output $orderbook
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
