function Get-SPOIDTenantSites {
    <#
    .SYNOPSIS
    Returns a complete list of SharePoint sites in connected tenant

    .DESCRIPTION
    N/A

    .EXAMPLE
    Register-SPOIDEntraIDApplication -TenantId 12345678-1234-1234-1234-1234567890ab
    #>

    $sites = @()
    $filteredSites = @()

    try {
        $sites = Get-PnPTenantSite

        foreach ($site in $sites) {
            $filteredSites += [PSCustomObject]@{
                Url = $site.Url
                Title = $site.Title
                Owner = $site.Owner
                ArchiveStatus = $site.Archive
                IsTeamsConnected = $site.IsTeamsConnected
            }
        }
    }
    catch {
        throw "Unable to retrieve a list of tenant sites: $($_.Exception.Message)"
    }

    return $filteredSites
}

function Export-SPOIDTenantSites {
    param (
        [ValidateSet("HTML", "CSV", "JSON")]
        [string]$OutputFormat,
        [string]$OutputFile = "$((Get-Date).ToString("yyyy_MM_dd_HH_mm_ss"))_tenant_sites"
    )

    if (-not (Test-SPOIDConnection)) {
        Write-Error "A connection to SharePoint Online does not exist in this session"
    
        Exit 1
    }
    
    switch ($OutputFormat) {
        "HTML" {
            Write-Verbose "Exporting tenant sites as HTML..."
        }
    
        "CSV" {
            Write-Verbose "Exporting tenant sites as CSV..."

            try {
                Get-SPOIDTenantSites | Export-Csv -Path "$($OutputFile).csv"
            }
            catch {
                <#Do this if a terminating exception happens#>
            }
        }
    
        "JSON" {
            Write-Verbose "Exporting tenant sites as JSON..."
        }
    }

}

Export-ModuleMember -Function Get-SPOIDTenantSites, Export-SPOIDTenantSites