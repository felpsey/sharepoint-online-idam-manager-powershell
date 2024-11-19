Import-Module -Name "PnP.Powershell"

function Connect-SPOID {
    <#
    .SYNOPSIS
    Creates a new conneciton to the SharePoint Online Management Shell

    .DESCRIPTION
    Wrapper for Connect-PnPOnline

    .PARAMETER Url
    The fully qualified SharePoint Online url

    .PARAMETER Name
    The unique name of the tenant

    .PARAMETER ClientId
    The Client Id of the registered application in the target tenant 

    .EXAMPLE
    Connect-SPO -Url https://mytenant-admin.sharepoint.com -ClientId 12345678-1234-1234-1234-1234567890ab

    .EXAMPLE
    Connect-SPO -Name mytenant -ClientId 12345678-1234-1234-1234-1234567890ab
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

    Write-Verbose "Connecting to $($ConnectionUrl) $($PSCmdlet.ParameterSetName)"

    try {
        $response = Invoke-WebRequest -Uri $ConnectionUrl -TimeoutSec 10
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

    Write-Host "Successfully connected to SharePoint Online using SPOID module" -ForegroundColor Green
}

Export-ModuleMember -Function Connect-SPOID, Test-SPOIDConnection, Export-SPOIDTenantSites