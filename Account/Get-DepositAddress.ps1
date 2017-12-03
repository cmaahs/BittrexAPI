<#
.Synopsis
Get and/or Create a deposit address for a specific currency.
.DESCRIPTION
/account/getdepositaddress
Used to retrieve or generate an address for a specific currency. If one does not exist, the call will fail and return ADDRESS_GENERATING until one is available.

Parameters
parameter	required	description
currency	required	a string literal for the currency (ie. BTC)

.EXAMPLE
Get-DepositAddress -Currency LTC

Currency Address                           
-------- -------                           
LTC      

.EXAMPLE
$currencies = Get-Currencies | Where-Object { $_.Currency -eq "LTC" -or $_.Currency -eq "BTC"  }

$currencies


urrency        : BTC
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

$currencies | Get-DepositAddress

Currency Address                           
-------- -------                           
BTC      bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
LTC      lllllllllllllllllllllllllllllllllllll

#>
function Get-DepositAddress
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
        $ParameterAttribute.Mandatory = $true
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
        $currencyAddressCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $Currency = $PSBoundParameters[$ParameterName]        
            $currencyParam = "?currency=$($Currency)"
            $depositAddress = Invoke-BittrexRequest -APIURI "/account/getdepositaddress$($currencyParam)" -apiAuth (Get-BittrexAPIKeys)
            $currencyAddressCollection += $depositAddress
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $currencyAddressCollection
        }
    }
}
