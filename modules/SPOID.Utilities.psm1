function Test-SPOIDConnection {
    <#
    .SYNOPSIS
    Checks if there is an active connect to SharePoint Online

    #>

    try {
        Get-PnPContext
    }
    catch {
        # SharePoint Online Management Shell is not connected

        return $false
    }

    # SharePoint Online Management Shell is connected

    return $true
}

function Register-SPOIDEntraIDApplication {
    <#
    .SYNOPSIS
    Registers a new application in Entra Id with required API permissions

    .DESCRIPTION
    As of September 9th 2024 the multi-tenant PnP Management Shell Entra ID app has been deleted.
    It has always been recommended practice to register your own Entra Id Application with minimal permissions required. This has become mandatory.

    .PARAMETER TenantId
    Tenant Id of target tenant

    .EXAMPLE
    Register-SPOIDEntraIDApplication -TenantId 12345678-1234-1234-1234-1234567890ab
    #>

    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantId
    )

    try {
        Register-PnPEntraIDAppForInteractiveLogin -ApplicationName "SharePoint Online IDaM Manager" -TenantId $TenantId -Interactive        
    }
    catch {
        throw "Unable to register Entra ID Application: $($_.Exception.Message)"
    }
}

Export-ModuleMember -Function Test-SPOIDConnection, Register-SPOIDEntraIDApplication