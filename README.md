# BittrexAPI
Powershell Module for accessing the Bittrex Marketplace via their API

## Getting Started
    Download and extract the zip, or clone the repository.  
    
### Installation
    Open a Powershell windows and change to the source directory.
    Run the following commands:

    >Unblock-File Install-AsModuleInUserModuleDirectory.ps1
    >.\Install-AsModuleInUserModuleDirectory.ps1

    This will install into your User Documents\WindowsPowershell\Modules
    directory.  You check check for a successful installation with this 
    command:

    >Get-Module -ListAvailable | Where-Object { $_.Path -like "*Documents*" }
        You should see BittrexAPI in the module list.

    >Import-Module BittrexAPI
    >Get-Command -Module BittrexAPI
        This will list the available commands.

### Setup Account
    Create a "READ INFO" key/secret pair on the Bittrex website.
    
    >Save-BittrexAPIKeys -Key 'your key' -Secret 'your secret'
        Read below on the use of -PIN to add a layer of security
    
### Run your first query    
    >Get-Balances
          

## SHORT DESCRIPTION
    Implementation of the Bittrex CryptoCurrency Exchange Website API

## LONG DESCRIPTION
    A set of Powershell CmdLets to allow a user to interact with their Bittrex
    website account from the Powershell command line.

    The API allows query of account and market data, as well as submission of 
    limit buy and sell requests, and withdrawal requests from your Bittrex 
    wallets.

    Protection of your API KEY and API SECRET is ** CRITICAL **.  Hopefully if
    you are this far, this won't be news to you.  I would recommend testing the 
    public/informational CmdLets using an API key/secret that has the READ INFO
    switch set, and none of the others.  Any of the Get- CmdLets should return 
    data using an API key with only the READ INFO switch set.  After you are 
    comfortable, turn on the LIMIT TRADE switch and test the Add-BuyLimit and
    Add-SellLimit CmdLets using values that will NOT trigger a fill.  That way
    you can use the Get-OpenOrders CmdLet and test the Remove-OpenOrder CmdLet
    as well.  

    In the spirit of PROTECTING your keys, this module will store them in the 
    windows user registry as encrypted values using the currently logged in 
    user's cryptography key pair.  This at least separates the Powershell Module
    and the keys to the kingdom.  An attacker would need run an executable or 
    script as the user to be able to decrypt and read the data.  They will know
    the registry keys since they are part of the Powershell Module.  For each 
    call that is made to Bittrex, these registry values are read and decrypted.  

    If you feel as I do, that an extra layer of security would be good, without
    drastically reducing the usefulness of the tool, then one can add a PIN 
    which is used to SALT the encryption.  Upon loading the module using the 
    Import-Module BittrexAPI command, you will be prompted to provide your PIN
    if you specified to use one.  This PIN is stored in a $global Powershell
    variable in memory and is used during the decryption calls.  Once the active
    Powershell window is closed, this value disappears.  This makes it
    exceptionally more difficult for an attacker to be able to read the registry
    values and decrypt them, because now they need to use the PIN to SALT the
    UnProtect method.  With the values of Crypto Currencies increasing
    drastically recently, the incentive for those with a shaky moral compass 
    to steal data related to Crypto Currencies goes way up.  

    Never, ever, store your API key and/or secret in a script file as plain 
    text.  

    Happy Trading.

    Many fractions of EMC2 were sacraficed in the making of this module, 
    mostly because I was impatient in my testing.

    If you find this module useful, any tiny amount donated is greatly
    appreciated.  If you want to share trading tips instead, those are 
    welcome as well.

    BTC  Donations: 1CGSMmQTAJQcaD22yH2tzt25igfZZ1qMs2
    ETH  Donations: 0x557F79E8679c5b3f8B876B1221FCD29cbf5A855E
    LTC  Donations: LXqKpEX2upAgptq4dvpaw58waWXd2aSb2F
    EMC2 Donations: EK2i543yb8AiLXybhR8D2EvaaGReTtifyV

    Trading Tips:   cmaahs@outlook.com

## EXAMPLES
    ** INFORMATIONAL CmdLets **
    Get-Markets | Where-Object { $_.MarketName.Contains("EMC") }
    Get-Currencies
    Get-MarketSummaries
    Get-MarketSummary -Market BTC-EMC2
    Get-Ticker -Market BTC-EMC2
    Get-MarketHistory -Market BTC-EMC2
    Get-OrderBook -Market BTC-EMC2 -OrderType BOTH
    
    ** Market Interaction CmdLets **
    Add-BuyLimit -Rate 0.00004000 -Quantity 223.9345106 -Market BTC-EMC2
        - returns OrderUuid
    Add-SellLimit -Market BTC-EMC2 -Quantity 200 -Rate 0.00004610
        - returns OrderUuid
    Remove-OpenOrder -OrderUuid 47b8d028-19ef-4c8a-ac82-246422cec214
        - used to cancel an open order
    Get-OpenOrders
        - list your open orders
    
    ** Account Interaction CmdLets **
    Get-Balances
    Get-Balance -Currency 'EMC2'
    Get-DepositAddress -Currency LTC
    Get-Order -OrderUuid 110d2b99-3fe2-4713-998d-e2670ec26422
    Get-OrderHistory
    Add-Withdrawl -Currency EMC2 -Quantity 10 -Address {your address here}
    Get-WithdrawalHistory
    Get-DepositHistory

    ** Utility / Calculation CmdLets **
    Save-BittrexAPIKeys -Key 'dfj34jf8dalekd887e' -Secret '234jejladj44jdntid77dk3kdj' -PIN 12354
        - Key and Secret are provided via the Bittrex Account Interface
    Get-MaxCoinsForPurchase -SourceCurrency BTC -Rate 0.00000025 -ShowBuyCommand
        - returns the number of coins you can purchase based on your available balance


