function Get-SPOIDTenantSites {
    <#
    .SYNOPSIS
    Returns a complete list of SharePoint sites from the connected tenant

    .DESCRIPTION
    N/A

    .EXAMPLE
    Get-SPOIDTenantSites
    #>

    if (-not (Test-SPOIDConnection)) {
        Write-Error "A connection to SharePoint Online does not exist in this session. Use Connect-SPOID to establish a connection."
    
        Exit 1
    }

    try {
        $sites = Get-PnPTenantSite
    }
    catch {
        throw "Unable to retrieve a list of tenant sites: $($_.Exception.Message)"
    }

    return $sites
}

function Export-SPOIDTenantSites {
    param (
        [ValidateSet("HTML", "CSV", "JSON")]
        [string]$OutputFormat,
        [string]$OutputFile = "$((Get-Date).ToString("yyyy_MM_dd_HH_mm_ss"))_tenant_sites"
    )

    if (-not (Test-SPOIDConnection)) {
        Write-Error "A connection to SharePoint Online does not exist in this session. Use Connect-SPOID to establish a connection."
    
        Exit 1
    }
    
    switch ($OutputFormat) {
        "HTML" {
            Write-Verbose "Exporting tenant sites as HTML..."

            $SelectedProperties = @(
                "GroupId",
                "HubSiteId",
                "IsHubSite",
                "IsTeamsChannelConnected",
                "IsTeamsConnected",
                "LastContentModifiedDate",
                "Owner",
                "SharingCapability",
                "Status",
                "Title",
                "Url",
                "ArchiveStatus",
                "Temaplate"
            )

            $Sites = Get-SPOIDTenantSites

            $HtmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List of SharePoint Sites in site $((Get-PnPContext).Url)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>List of SharePoint Sites in site $((Get-PnPContext).Url)</h1>
    <table>
        <thead>
            <tr>
"@

            foreach ($Site in $Sites) {
                $HtmlContent += "<h2>Site: $($Site.Title)</h2>"
                $HtmlContent += "<table>"
                $HtmlContent += "<thead><tr><th>Property</th><th>Value</th></tr></thead>"
                $HtmlContent += "<tbody>"

                foreach ($Property in $SelectedProperties) {
                    $Value = $Site.$Property
            
                    # Convert complex types to strings if necessary
                    if ($Value -is [array]) {
                        $Value = $Value -join ", "
                    } elseif ($Value -is [datetime]) {
                        $Value = $Value.ToString("yyyy-MM-dd HH:mm:ss")
                    } elseif ($null -eq $Value) {
                        $Value = "N/A"
                    }
            
                    $HtmlContent += "<tr><td>$Property</td><td>$Value</td></tr>"
                }

                $HtmlContent += "</tbody></table>"
            }

            # Close the HTML tags
            $HtmlContent += @"
</body>
</html>
"@
            
            try {
                $HtmlContent | Set-Content -Path "$($OutputFile).html" -Encoding utf8
            }
            catch {
                throw "Unable to export tenant sites as HTML: $($_.Exception.Message)"
            }

            Write-Host "Successfully exported tenant sites to $((Resolve-Path "$OutputFile.html").Path)" -ForegroundColor Green
        }
    
        "CSV" {
            Write-Verbose "Exporting tenant sites as CSV..."

            try {
                Get-SPOIDTenantSites | Export-Csv -Path "$($OutputFile).csv"
            }
            catch {
                throw "Unable to export tenant sites as CSV: $($_.Exception.Message)"
            }
        }
    
        "JSON" {
            Write-Verbose "Exporting tenant sites as JSON..."
        }
    }

}

Export-ModuleMember -Function Get-SPOIDTenantSites, Export-SPOIDTenantSites