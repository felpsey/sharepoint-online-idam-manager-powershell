function Test-SPOIDConnection {
    try {
        $context = Get-PnPContext
    }
    catch {
        # SharePoint Online Management Shell is not connected

        return $false
    }

    # SharePoint Online Management Shell is connected

    return $true
}

Export-ModuleMember -Function Test-SPOIDConnection