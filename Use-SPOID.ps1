Import-Module "./SPOID.psd1" -Force

# Connect-SPOID -Name "felpsey" -ClientId "b4da5f45-1243-45fc-a02a-9a5901e33c7a" -Verbose

function Connect-SharePointUsingSPOID {
    $TenantName = Read-Host "Tenant Name: "
    $ClientId = Read-Host "Entra ID Client Id: "

    try {
        Connect-SPOID -Name $TenantName -ClientId $ClientId        
    }
    catch {
        throw $_.Exception.Message
    }

    Write-Host "Successfully connected to SharePoint Online Management Shell using SPOID module" -ForegroundColor Green
}

function Show-Menu {
    foreach ($key in $menuOptions.Keys) {
        Write-Host "[$key] $($menuOptions[$key])"
    }
}

function Main {
    $menuOptions = @{
        1 = "Connect to SharePoint Online Management Shell"
        2 = "Disconnect from SharePoint Online Management Shell"
    }    

    while ($true) {
        Show-Menu

        $menuSelection = Read-Host "> "

        switch ($menuSelection) {
            1 { Connect-SharePointUsingSPOID }
            2 { Disconnect-PnPOnline }
            default { Write-Error "Invalid selection. Please select a valid option" }
        }
    }
}

Main