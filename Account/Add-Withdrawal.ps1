<#
.Synopsis
Used to execute a withdrawal from one of your account balances.
.DESCRIPTION
/account/withdraw
Used to withdraw funds from your account. note: please account for txfee.

Parameters
parameter	required	description
currency	required	a string literal for the currency (ie. BTC)
quantity	required	the quantity of coins to withdraw
address	    required	the address where to send the funds.
paymentid	optional	used for CryptoNotes/BitShareX/Nxt optional field (memo/paymentid)

.EXAMPLE
$withdrawl = Add-Withdrawal -Currency EMC2 -Quantity 10 -Address xxxxxxxxxxxxxxxxxxxxxxxxxxxx
$withdrawl

uuid                                
----                                
c5045600-7b26-4cd0-965c-1f7d164bfb5e

#>
function Add-Withdrawal
{
    [CmdletBinding()]
    Param
    (
        # Quantity To Transfer
        [Parameter(Mandatory=$true,
                   Position=1)]        
        [string]       
        $Quantity
        ,
        # Transfer Address
        [Parameter(Mandatory=$true,
                   Position=2)]        
        [string]       
        $Address
        ,
        # Payment Note/Memo
        [Parameter(Mandatory=$false,
                   Position=3)]        
        [string]       
        $PaymentID = ""
        
    )
    DynamicParam
    {
        $ParameterName = "Currency"
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterPosition = 0

        $AttributeCollection.Add($ParameterAttribute)

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
        $Currency = $PSBoundParameters[$ParameterName]        
        $currencyParam = "?currency=$($Currency)"
        $quantityParam = "&quantity=$($Quantity)"
        $addressParam = "&address=$($Address)"
        if ( $PaymentID.Length -gt 0 )
        {
            $paymentidParam = "&paymentID=$($PaymentID)"
        } else {
            $paymentidParam = ""
        }
        $depositAddress = Invoke-BittrexRequest -APIURI "/account/withdraw$($currencyParam)$($quantityParam)$($addressParam)$($paymentidParam)" -apiAuth (Get-BittrexAPIKeys)
        Write-Output $depositAddress
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
