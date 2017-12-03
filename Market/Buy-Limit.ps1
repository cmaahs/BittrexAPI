<#
.Synopsis
Use to place a buy order in a Bittrex market.  
.DESCRIPTION
/market/buylimit
Used to place a buy order in a specific market. Use buylimit to place limit orders. Make sure you have the proper permissions set on your API keys for this call to work

Parameters
parameter	required	description
market	    required	a string literal for the market (ex: BTC-LTC)
quantity	required	the amount to purchase
rate	    required	the rate at which to place the order.

.EXAMPLE
Add-BuyLimit -Rate 0.00004000 -Quantity 223.9345106 -Market BTC-EMC2

uuid                                
----                                
a0d0579e-529b-4a59-a278-0f8d8c88f795


.EXAMPLE
Add-BuyLimit -Rate 0.00000025 -Quantity 9.2967 -Market BTC-EMC2
Invoke-BittrexRequest : Bittrex API returned an error: MIN_TRADE_REQUIREMENT_NOT_MET
 
#>
function Add-BuyLimit
{
    [CmdletBinding()]
    Param
    (
        # Quantity To Purchase
        [Parameter(Mandatory=$true,
                   Position=1)]        
        [string]       
        $Quantity
        ,
        # Rate at Which To Purchase
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
            $orderbook = Invoke-BittrexRequest -APIURI "/market/buylimit$($marketParam)$($quantityParam)$($rateParam)" -apiAuth (Get-BittrexAPIKeys) -Test
        } else {
            $orderbook = Invoke-BittrexRequest -APIURI "/market/buylimit$($marketParam)$($quantityParam)$($rateParam)" -apiAuth (Get-BittrexAPIKeys)
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
