$userModulePath = "$($env:USERPROFILE)\Documents\WindowsPowershell\Modules\"

if ( Test-Path $userModulePath )
{
    $modulePath = "$($userModulePath)BittrexAPI"
    if ( -not ( Test-Path $userModulePath ) )
    {
        New-Item -Path $modulePath -ItemType Directory
    }
    Get-ChildItem -Filter * | Unblock-File
    Copy-Item -Path .\Account -Filter * -Destination $modulePath\Account
    Copy-Item -Path .\Calculations -Filter * -Destination $modulePath\Calculations
    Copy-Item -Path .\Encryption -Filter * -Destination $modulePath\Encryption
    Copy-Item -Path .\en-US -Filter * -Destination $modulePath\en-US
    Copy-Item -Path .\Interface -Filter * -Destination $modulePath\Interface
    Copy-Item -Path .\Market -Filter * -Destination $modulePath\Market
    Copy-Item -Path .\Public -Filter * -Destination $modulePath\Public
    Copy-Item -Path .\BittrexAPI.psd1 -Destination $modulePath\BittrexAPI.psd1
    Copy-Item -Path .\BittrexAPI.psm1 -Destination $modulePath\BittrexAPI.psm1
} else {
	Write-Warning "Couldn't locate the User's Module Path at $($userModulePath)"
}