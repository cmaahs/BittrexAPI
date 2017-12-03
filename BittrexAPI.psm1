    $Account  = @( Get-ChildItem -Path $PSScriptRoot\Account\*.ps1 -ErrorAction SilentlyContinue )
    $Calculations = @( Get-ChildItem -Path $PSScriptRoot\Calculations\*.ps1 -ErrorAction SilentlyContinue )
    $Encryption = @( Get-ChildItem -Path $PSScriptRoot\Encryption\*.ps1 -ErrorAction SilentlyContinue )
    $Interface = @( Get-ChildItem -Path $PSScriptRoot\Interface\*.ps1 -ErrorAction SilentlyContinue )
    $Market = @( Get-ChildItem -Path $PSScriptRoot\Market\*.ps1 -ErrorAction SilentlyContinue )
    $Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )

    Foreach($import in @($Account + $Calculations + $Encryption + $Interface + $Market + $Public))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }
