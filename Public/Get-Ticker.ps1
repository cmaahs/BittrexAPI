<#
.Synopsis
Get the ticker for a specifc market.
.DESCRIPTION
/public/getticker
Used to get the current tick values for a market.

Parameters
parameter	required	description
market      required	a string literal for the market (ex: BTC-LTC)

.EXAMPLE
Get-Ticker -Market BTC-EMC2

.EXAMPLE
$markets = Get-Markets | Where-Object { $_.MarketName.Contains("EMC") }

$markets | Get-Ticker

Market          Bid        Ask       Last
------          ---        ---       ----
BTC-EMC2 0.00003927 0.00003948 0.00003948
BTC-EMC  0.00009338 0.00009345 0.00009338

#>
function Get-Ticker
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
        $tickerCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $Market = $PSBoundParameters[$ParameterName]
            $marketParam = "?market=$($Market)"
            $ticker = Invoke-BittrexRequest -APIURI "/public/getticker$($marketParam)" -apiAuth (Get-BittrexAPIKeys)
            $t_item = "" | Select-Object Market,Bid,Ask,Last
            $t_item.Market = $Market
            $t_item.Bid = $ticker.Bid
            $t_item.Ask = $ticker.Ask
            $t_item.Last = $ticker.Last
            $tickerCollection += $t_item
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $tickerCollection
        }
    }
}
