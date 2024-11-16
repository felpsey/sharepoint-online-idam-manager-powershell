if (Test-SPOIDConnection) {
    try {
        Disconnect-PnPOnline
    } catch {
        Write-Error "Unable to disconnect from SharePoint Online $($_.Exception.Message)"
    }

    Write-Host "Successfully disconnected from SharePoint Online" -ForegroundColor Green
} else {
    Write-Error "SharePoint Online is not connected."
}