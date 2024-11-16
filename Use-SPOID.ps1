Import-Module "./SPOID.psd1" -Force

# Connect-SPOID -Name "felpsey" -ClientId "b4da5f45-1243-45fc-a02a-9a5901e33c7a" -Verbose

function Exit-SPOID {
    if (Test-SPOIDConnection) {
        Write-Warning "SharePoint Online Management Shell is still connected. Do you wish to continue? (Y/n)"

        $choice = Read-Host "> "

        switch($choice) {
            "Y" { Exit 0 }
        }
    } else {
        Exit 0
    }
}

function Connect-SharePointUsingSPOID {
    $TenantName = Read-Host "Tenant Name"
    $ClientId = Read-Host "Entra ID Client Id"

    try {
        Connect-SPOID -Name $TenantName -ClientId $ClientId        
    }
    catch {
        throw $_.Exception.Message
    }
}

function Disconnect-SharePointUsingSPOID {
    if (Test-SPOIDConnection) {
        Disconnect-PnPOnline
    } else {
        Write-Error "SharePoint Online Management Shell is not connected."
    }
}

function Show-Menu {
    $options = @{
        1 = "Connect to SharePoint Online Management Shell"
        2 = "Disconnect from SharePoint Online Management Shell"
        3 = "Exit"
    }   

    foreach ($key in ($options.Keys | Sort-Object)) {
        Write-Host "[$key] $($options[$key])"
    }

    $choice = Read-Host ">"

    switch ($choice) {
        1 { Connect-SharePointUsingSPOID }
        2 { Disconnect-SharePointUsingSPOID }
        3 { Exit-SPOID }
        default { Write-Error "Invalid selection. Please select a valid option" }
    }
}

function Main {
    while ($true) {
        Show-Menu
    }
}

Main