try {
    Get-SPOIDTenantSites | Export-Csv -Path ./output/Sites.csv
}
catch {
    Write-Error "Unable to export tenant sites to csv: $($_.Exception.Message)"
}