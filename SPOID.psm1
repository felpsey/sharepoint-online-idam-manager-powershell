function Connect-SPO {
    <#
    .SYNOPSIS
    Creates a new conneciton to the SharePoint Online Management Shell

    .DESCRIPTION
    Wrapper for Connect-SPOService

    .PARAMETER Url
    The fully qualified SharePoint Online url

    .PARAMETER Name
    The unique name of the tenant

    .EXAMPLE
    Connect-SPO -Url https://mytenant-admin.sharepoint.com

    .EXAMPLE
    Connect-SPO -Name mytenant
    #>

    param (
        [Parameter(Mandatory, ParameterSetName = "ByUrl")]
        [string]$Url,

        [Parameter(Mandatory, ParameterSetName = "ByName")]
        [string]$Name
    )

    switch ($PSCmdlet.ParameterSetName) {
        "ByURL" {
            Write-Output "URL"
        }

        "ByName" {
            Write-Output "Name"
        }
    }
}

Export-ModuleMember -Function Connect-SPO