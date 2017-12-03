<#
.Synopsis
Get the last 24 hour summary of a specific market.
.DESCRIPTION
/public/getmarketsummary
Used to get the last 24 hour summary of all active exchanges

Parameters
parameter	required	description
market	    required	a string literal for the market (ex: BTC-LTC)

.EXAMPLE
$marketSummary = Get-MarketSummary -Market BTC-EMC2

$marketSummary


MarketName     : BTC-EMC2
High           : 0.00004762
Low            : 0.00003610
Volume         : 34229816.58875449
Last           : 0.00003983
BaseVolume     : 1411.25755872
TimeStamp      : 2017-11-30T00:55:08.29
Bid            : 0.00003930
Ask            : 0.00003931
OpenBuyOrders  : 1000
OpenSellOrders : 4277
PrevDay        : 0.00004679
Created        : 2014-12-24T00:00:00

.EXAMPLE
$markets = Get-Markets | Where-Object { $_.MarketName.Contains("EMC") }

$markets | Get-MarketSummary


MarketName     : BTC-EMC2
High           : 0.00004762
Low            : 0.00003610
Volume         : 33922990.10398286
Last           : 0.00003980
BaseVolume     : 1396.48543839
TimeStamp      : 2017-11-30T00:58:33.943
Bid            : 0.00003980
Ask            : 0.00004000
OpenBuyOrders  : 1021
OpenSellOrders : 4274
PrevDay        : 0.00004500
Created        : 2014-12-24T00:00:00

MarketName     : BTC-EMC
High           : 0.00009750
Low            : 0.00009337
Volume         : 185270.63854877
Last           : 0.00009345
BaseVolume     : 17.38097205
TimeStamp      : 2017-11-30T00:54:05.377
Bid            : 0.00009345
Ask            : 0.00009380
OpenBuyOrders  : 147
OpenSellOrders : 1445
PrevDay        : 0.00009695
Created        : 2016-01-06T05:28:04.553

#>
function Get-MarketSummary
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
        $marketSummaryCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $Market = $PSBoundParameters[$ParameterName]        
            $marketParam = "?market=$($Market)"
            $marketsummary = Invoke-BittrexRequest -APIURI "/public/getmarketsummary$($marketParam)" -apiAuth (Get-BittrexAPIKeys)
            $marketSummaryCollection += $marketsummary
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $marketSummaryCollection
        }
    }
}
