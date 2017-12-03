<#
.Synopsis
Get all currencies for which you have balances or deposit addresses defined.
.DESCRIPTION
/account/getbalances
Used to retrieve all balances from your account

Parameters
None

.EXAMPLE
Get-Balances

Currency      : BTC
Balance       : 0.00000233
Available     : 0.00000233
Pending       : 0.00000000
CryptoAddress : 

#>
function Get-Balances
{
    [CmdletBinding()]
    Param
    (
       
    )
    
    Begin
    {
        $continueProcessing = $true
        $currencyBalance = Invoke-BittrexRequest -APIURI "/account/getbalances" -apiAuth (Get-BittrexAPIKeys)
        Write-Output $currencyBalance
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
