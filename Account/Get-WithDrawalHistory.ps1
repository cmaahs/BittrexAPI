<#
.Synopsis
Get a listing of all your historical withdrawals, optionally by currency.
.DESCRIPTION
/account/getwithdrawalhistory
Used to retrieve your withdrawal history.

Parameters
parameter	required	description
currency	optional	a string literal for the currecy (ie. BTC). If omitted, will return for all currencies

.EXAMPLE
$withdrawalHistory = Get-WithdrawalHistory

$withdrawalHistory

PaymentUuid    : c5045600-7b26-4cd0-965c-1f7d164bfb5e
Currency       : EMC2
Amount         : 9.80000000
Address        : xxxxxxxxxxxxxxxxxxxxxxxxxxxx
Opened         : 2017-11-30T14:53:18.99
Authorized     : True
PendingPayment : False
TxCost         : 0.20000000
TxId           : yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
Canceled       : False
InvalidAddress : False

.EXAMPLE
@('LTC','EMC2') | Get-WithdrawalHistory


PaymentUuid    : c5045600-7b26-4cd0-965c-1f7d164bfb5e
Currency       : EMC2
Amount         : 9.80000000
Address        : xxxxxxxxxxxxxxxxxxxxxxxxxxxx
Opened         : 2017-11-30T14:53:18.99
Authorized     : True
PendingPayment : False
TxCost         : 0.20000000
TxId           : yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
Canceled       : False
InvalidAddress : False


#>
function Get-WithdrawalHistory
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
        $withdrawalHistoryCollection = @()
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
            $withdrawalHistory = Invoke-BittrexRequest -APIURI "/account/getwithdrawalhistory$($currencyParam)" -apiAuth (Get-BittrexAPIKeys)
            $withdrawalHistoryCollection += $withdrawalHistory
        } #continue processing
    }
    End
    {
        if ( $continueProcessing -eq $true ) 
        {
            Write-Output $withdrawalHistoryCollection
        }
    }
}
