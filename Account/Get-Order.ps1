<#
.Synopsis
Use to get an order by order UUID.
.DESCRIPTION
/account/getorder
Used to retrieve a single order by uuid.

Parameters
parameter	required	description
uuid	    required	the uuid of the buy or sell order

.EXAMPLE
Get-Order -OrderUuid 110d2b99-3fe2-4713-998d-e2670ec26422

.EXAMPLE
$orderHistory = Get-OrderHistory -Market BTC-LTC

$orderHistory | Select-Object -Property OrderUuid,Exchange,OrderType

OrderUuid                            Exchange OrderType 
---------                            -------- --------- 
110d2b99-3fe2-4713-998d-e2670ec26422 BTC-LTC  LIMIT_SELL
4147080c-479a-4ea3-a173-427783d5c8e9 BTC-LTC  LIMIT_SELL
5c9e2e72-6127-4aa8-be14-c9b792e639fe BTC-LTC  LIMIT_SELL
c61bf764-956e-48f8-8ede-ad121d3ea393 BTC-LTC  LIMIT_SELL

$orders = $orderHistory | Get-Order

$orders | Select-Object -Property OrderUuid,CommissionPaid

OrderUuid                            CommissionPaid
---------                            --------------
110d2b99-3fe2-4713-998d-e2670ec26422     0.00002295
4147080c-479a-4ea3-a173-427783d5c8e9     0.00000815
5c9e2e72-6127-4aa8-be14-c9b792e639fe     0.00000706
c61bf764-956e-48f8-8ede-ad121d3ea393     0.00001072

#>
function Get-Order
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
        $orderCollection = @()               
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            Write-Verbose "Looking Up: $($OrderUuid)"
            $order = Invoke-BittrexRequest -APIURI "/account/getorder?uuid=$($orderUuid)" -apiAuth (Get-BittrexAPIKeys)
            $orderCollection += $order
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $orderCollection
        }
    }
}
