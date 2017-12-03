<#
.Synopsis
Retrieve the latest trades that have occured for the specified market.
.DESCRIPTION
/public/getmarkethistory
Used to retrieve the latest trades that have occured for a specific market.

Parameters
parameter	required	description
market	    required	a string literal for the market (ex: BTC-LTC)

.EXAMPLE
$marketHistory = Get-MarketHistory -Market BTC-EMC2

$marketHistory.count
200

.EXAMPLE
$marketHistory = $markets | Get-MarketHistory

$markets | Select-Object -Property MarketName

MarketName
----------
BTC-EMC2  
BTC-EMC   


$marketHistory | Select-Object -Property Market | Sort-Object -Property Market -Unique

Market
----------
BTC-EMC   
BTC-EMC2  
#>
function Get-MarketHistory
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
        if ( $arrSet.Count -gt 0 )
        {
            $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

            $AttributeCollection.Add($ValidateSetAttribute)
        }
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
    
    }
    Begin
    {
        $continueProcessing = $true
        $marketHistoryCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $Market = $PSBoundParameters[$ParameterName]        
            $marketParam = "?market=$($Market)"
            $markethistory = Invoke-BittrexRequest -APIURI "/public/getmarkethistory$($marketParam)" -apiAuth (Get-BittrexAPIKeys)
            foreach ( $mh in $markethistory ) 
            {
                $mh_item = "" | Select-Object  Market,Id,TimeStamp,Quantity,Price,Total,FillType,OrderType
                $mh_item.Market = $Market
                $mh_item.Id = $mh.Id
                $mh_item.TimeStamp = $mh.TimeStamp
                $mh_item.Quantity = $mh.Quantity
                $mh_item.Price = $mh.Price
                $mh_item.Total = $mh.Total
                $mh_item.FillType = $mh.FillType
                $mh_item.OrderType = $mh.OrderType
                $marketHistoryCollection += $mh_item
            }
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $marketHistoryCollection
        }
    }
}
