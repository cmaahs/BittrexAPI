<#
.Synopsis
Get a list of all your historical deposits, optionally by currency.
.DESCRIPTION
/account/getdeposithistory
Used to retrieve your deposit history.

Parameters
parameter	required	description
currency	optional	a string literal for the currecy (ie. BTC). If omitted, will return for all currencies

.EXAMPLE
$depositHistory = Get-DepositHistory

$depositHistory.count
5

$depositHistory | Where-Object { $_.Currency -eq "BTC" }


Id            : 41545939
Amount        : 0.00264030
Currency      : BTC
Confirmations : 2
LastUpdated   : 2017-11-20T13:52:31.36
TxId          : yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
CryptoAddress : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

.EXAMPLE
$currencies = Get-Currencies | Where-Object { $_.Currency -eq "LTC" -or $_.Currency -eq "BTC"  }

$currencies


Currency        : BTC
CurrencyLong    : Bitcoin
MinConfirmation : 2
TxFee           : 0.00100000
IsActive        : True
CoinType        : BITCOIN
BaseAddress     : 1N52wHoVR79PMDishab2XmRHsbekCdGquK
Notice          : 

Currency        : LTC
CurrencyLong    : Litecoin
MinConfirmation : 6
TxFee           : 0.01000000
IsActive        : True
CoinType        : BITCOIN
BaseAddress     : LhyLNfBkoKshT7R8Pce6vkB9T2cP2o84hx
Notice          : 

$depositHistory = $currencies | Get-DepositHistory

$depositHistory.Count
5

#>
function Get-DepositHistory
{
    [CmdletBinding()]
    Param
    (
       
    )
    DynamicParam
    {
        $ParameterName = "Currency"
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $false
        $ParameterAttribute.ValueFromPipeline = $true
        $ParameterAttribute.ValueFromPipelineByPropertyName = $true
        $AttributeCollection.Add($ParameterAttribute)

        $ParameterPosition = 0

        $arrSet = foreach ( $currency in Get-CurrenciesForParameter ) { Write-Output $currency.Currency.ToString() }
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
        $depositHistoryCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $Currency = $PSBoundParameters[$ParameterName] 
            if ( $currency.Length -gt 0 )
            {       
                $currencyParam = "?currency=$($Currency)"
            } else {
                $currencyParam = ""
            }
            $depositHistory = Invoke-BittrexRequest -APIURI "/account/getdeposithistory$($currencyParam)" -apiAuth (Get-BittrexAPIKeys)
            $depositHistoryCollection += $depositHistory
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $depositHistoryCollection
        }
    }
}
