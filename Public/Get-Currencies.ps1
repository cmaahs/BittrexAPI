<#
.Synopsis
Get active currencies supported on Bittrex, optionally include inactive currencies.
.DESCRIPTION
/public/getcurrencies
Used to get all supported currencies at Bittrex along with other meta data.

Parameters
None
.EXAMPLE
$currencies = Get-Currencies

$currencies | Where-Object { $_.Currency -like "*EMC*" }


Currency        : EMC2
CurrencyLong    : Einsteinium
MinConfirmation : 128
TxFee           : 0.20000000
IsActive        : True
CoinType        : BITCOIN
BaseAddress     : 
Notice          : 

Currency        : EMC
CurrencyLong    : EmerCoin
MinConfirmation : 6
TxFee           : 0.02000000
IsActive        : True
CoinType        : BITCOIN
BaseAddress     : 
Notice          : 


#>
function Get-Currencies
{
    [CmdletBinding()]
    Param
    (
        # Inclucde Inactive Currencies
        [Parameter(Mandatory=$false,
                   Position=0)]        
        [string]       
        $IncludeInactive   
    )
    
    Begin
    {
        $continueProcessing = $true
        if ( $IncludeInactive -eq $true )
        {
            $currency = Invoke-BittrexRequest -APIURI "/public/getcurrencies" -apiAuth (Get-BittrexAPIKeys)
        } else {
            $currency = Invoke-BittrexRequest -APIURI "/public/getcurrencies" -apiAuth (Get-BittrexAPIKeys) | Where-Object { $_.IsActive -eq $true }
        }        
        Write-Output $currency
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
