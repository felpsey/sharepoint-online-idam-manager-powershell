try {
    Get-PnPContext
}
catch {
    Write-Error "Unable to get context: $($_.Exception.Message)"
}