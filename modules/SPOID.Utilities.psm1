function Connect-SPOID {
    <#
    .SYNOPSIS
    Creates a new connection to the SharePoint Online Management Shell

    .DESCRIPTION
    Wrapper for Connect-PnPOnline

    .PARAMETER Url
    The fully qualified SharePoint Online url

    .PARAMETER Name
    The unique name of the tenant

    .PARAMETER ClientId
    The Client Id of the registered application in the target tenant 

    .EXAMPLE
    Connect-SPOID -Url https://mytenant-admin.sharepoint.com -ClientId 12345678-1234-1234-1234-1234567890ab

    .EXAMPLE
    Connect-SPOID -Name mytenant -ClientId 12345678-1234-1234-1234-1234567890ab
    #>

    param (
        [Parameter(Mandatory, ParameterSetName = "ByUrl")]
        [string]$Url,

        [Parameter(Mandatory, ParameterSetName = "ByName")]
        [string]$Name,

        [Parameter(Mandatory=$true)]
        [string]$ClientId
    )

    [string]$ConnectionUrl = ""

    switch ($PSCmdlet.ParameterSetName) {
        "ByURL" {
            $ConnectionUrl = $Url
        }

        "ByName" {
            $ConnectionUrl = "https://{0}-admin.sharepoint.com" -f $Name
        }
    }

    Write-Warning "Connecting to $($ConnectionUrl) $($PSCmdlet.ParameterSetName)"

    try {
        Invoke-WebRequest -Uri $ConnectionUrl -TimeoutSec 10 | Out-Null
    }
    catch {
        Write-Error "SharePoint Online URL is invalid or inaccessible from this host: $($_.Exception.Message)"

        return
    }

    try {
        Connect-PnPOnline -Url $ConnectionUrl -Interactive -ClientId $ClientId
    }
    catch {
        Write-Error "Unable to connect to SharePoint Online: $($_.Exception.Message)"
    }

    Write-Host "SUCCESS: Connected to $($Url)" -ForegroundColor Green
}

function Disconnect-SPOID {
    try {
        Disconnect-PnPOnline
    }
    catch {
        Write-Error "Unable to disconnect from SharePoint Online using SPOID: $($_.Exception.Message)"
    }
}

function Test-SPOIDConnection {
    <#
    .SYNOPSIS
    Checks if there is an active connect to SharePoint Online

    #>

    try {
        Get-PnPContext | Out-Null
    }
    catch {
        # SharePoint Online Management Shell is not connected or experienced an error retrieving connection context

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

Export-ModuleMember -Function Connect-SPOID, Test-SPOIDConnection, Register-SPOIDEntraIDApplication