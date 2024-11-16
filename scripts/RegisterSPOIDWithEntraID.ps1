$TenantId = Read-Host "Tenant Id"

try {
    Register-SPOIDEntraIDApplication -TenantId $TenantId
}
catch {
    Write-Error "Unable to register application with Entra ID: $($_.Exception.Message)"
}