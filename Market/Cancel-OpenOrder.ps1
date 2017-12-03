<#
.Synopsis
Use to cancel an open order using the Order UUID.  Currently this API call returns NOTHING on a success.  Even though the API call suggests a return should happen.
.DESCRIPTION
/market/cancel
Used to cancel a buy or sell order.

Parameters
parameter	required	description
uuid	    required	uuid of buy or sell order

.EXAMPLE
$openOrders = Get-OpenOrder

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

Remove-OpenOrder -OrderUuid 47b8d028-19ef-4c8a-ac82-246422cec214
Cancellation of /market/cancel?uuid=47b8d028-19ef-4c8a-ac82-246422cec214 is successful.

.EXAMPLE
$openOrders = Get-OpenOrder

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

#be AWARE that if there are multiple orders in the $openOrders collection you will cancel them all...
$openOrders | Remove-OpenOrder
Cancellation of /market/cancel?uuid=47b8d028-19ef-4c8a-ac82-246422cec214 is successful.

Get-OpenOrders
{nothing returned}  # expected since we did cancel the order

#>
function Remove-OpenOrder
{
    [CmdletBinding()]
    Param
    (
        # Specify the OrderUUID to cancel.
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]        
        [string]       
        $OrderUuid
       
    )
    
    Begin
    {
        $continueProcessing = $true
        $cancelledOrdersCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $marketcancel = Invoke-BittrexRequest -APIURI "/market/cancel?uuid=$($OrderUuid)" -apiAuth (Get-BittrexAPIKeys)
            $cancelledOrdersCollection += $marketcancel
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $cancelledOrdersCollection
        }
    }
}
