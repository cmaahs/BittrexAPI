<#
.Synopsis
Get the balance for a specific currency in your account.
.DESCRIPTION
/account/getbalance
Used to retrieve the balance from your account for a specific currency.

Parameters
parameter	required	description
currency	required	a string literal for the currency (ex: LTC)

.EXAMPLE 
Get-Balance -Currency 'EMC2'

Currency      : EMC2
Balance       : 14.79996962
Available     : 14.79996962
Pending       : 0.00000000
CryptoAddress : 

.EXAMPLE
$currencies = Get-Currencies | Where-Object { $_.Currency -eq "EMC2" -or $_.Currency -eq "BTC"  }

$currencies


Currency        : BTC
CurrencyLong    : Bitcoin
MinConfirmation : 2
TxFee           : 0.00100000
IsActive        : True
CoinType        : BITCOIN
BaseAddress     : 1N52wHoVR79PMDishab2XmRHsbekCdGquK
Notice          : 

Currency        : EMC2
CurrencyLong    : Einsteinium
MinConfirmation : 128
TxFee           : 0.20000000
IsActive        : True
CoinType        : BITCOIN
BaseAddress     : 
Notice          : 

$currencies | Get-Balance


Currency      : BTC
Balance       : 0.00000233
Available     : 0.00000233
Pending       : 0.00000000
CryptoAddress : 

Currency      : EMC2
Balance       : 14.79996962
Available     : 14.79996962
Pending       : 0.00000000
CryptoAddress : 


#>
function Get-Balance
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
        $currencyBalanceCollection = @()
    }
    Process
    {
        if ( $continueProcessing -eq $true )
        {
            $Currency = $PSBoundParameters[$ParameterName]        
            $currencyParam = "?currency=$($Currency)"
            $currencyBalance = Invoke-BittrexRequest -APIURI "/account/getbalance$($currencyParam)" -apiAuth (Get-BittrexAPIKeys)
            $currencyBalanceCollection += $currencyBalance
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $currencyBalanceCollection
        }
    }
}
