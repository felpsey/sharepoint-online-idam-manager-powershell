Import-Module "./SPOID.psd1" -Force

# Connect-SPOID -Name "felpsey" -ClientId "b4da5f45-1243-45fc-a02a-9a5901e33c7a" -Verbose

function Exit-SPOID {
    if (Test-SPOIDConnection) {
        Write-Warning "SharePoint Online is still connected. Do you wish to continue? (Y/n)"
    
        $choice = Read-Host "> "
    
        switch($choice) {
            "Y" { Exit 0 }
        }
    } else {
        Exit 0
    }
}

function Show-Menu {
    $options = @{
        1 = "Register SPOID with Entra ID"
        2 = "Connect to SharePoint Online"
        3 = "Show SharePoint Connection Context"
        4 = "Disconnect from SharePoint Online"
        5 = "Exit"
        6 = "Export Tenant Sites to CSV"
        7 = "Export Tenant Sites to HTML"
    }   

    foreach ($key in ($options.Keys | Sort-Object)) {
        Write-Host "[$key] $($options[$key])"
    }

    $choice = Read-Host ">"

    switch ($choice) {
        1 { . ./scripts/RegisterSPOIDWithEntraID.ps1 }
        2 { . ./scripts/ConnectSPOID.ps1 }
        3 { . ./scripts/GetSPOIDSharePointContext.ps1 }
        4 { . ./scripts/DisconnectSPOID.ps1 }
        5 { Exit-SPOID }
        6 { . ./scripts/ExportTenantSitesCSV.ps1 }
        7 { . ./scripts/ExportTenantSitesHTML.ps1 }
        default { Write-Error "Invalid selection. Please select a valid option" }
    }
}

function Main {
    if (-not (Test-Path -Path "output")) {
        New-Item -Path "output" -ItemType Directory | Out-Null
    }

    while ($true) {
        Show-Menu
    }
}

Main