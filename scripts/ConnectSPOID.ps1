if (Test-SPOIDConnection) {
    Write-Error "SharePoint Online is already connected. Disconnect to connect to another tenant"

    return
}

$TenantName = Read-Host "Tenant Name"
$ClientId = Read-Host "SPOID Application Client Id"

try {
    Connect-SPOID -Name $TenantName -ClientId $ClientId        
}
catch {
    throw $_.Exception.Message
}