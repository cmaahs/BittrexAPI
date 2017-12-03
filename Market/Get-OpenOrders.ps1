<#
.Synopsis
Use to get your open orders, optionally for a specific market.
.DESCRIPTION
/market/getopenorders
Get all orders that you currently have opened. A specific market can be requested

Parameters
parameter	required	description
market	    optional	a string literal for the market (ie. BTC-LTC)

.EXAMPLE
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
function Get-OpenOrders
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
        $openOrdersCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $marketParam = ""
            $Market = $PSBoundParameters[$ParameterName]   
            if ( $Market.Length -gt 0 )
            {     
                $marketParam = "?market=$($Market)"
            }
            $openorders = Invoke-BittrexRequest -APIURI "/market/getopenorders$($marketParam)" -apiAuth (Get-BittrexAPIKeys)
            $openOrdersCollection += $openorders
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $openOrdersCollection
        }
    }
}
