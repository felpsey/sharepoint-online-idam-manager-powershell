# Import-Module -Name "PnP.Powershell"

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

Export-ModuleMember -Function Get-SPOIDTenantSites