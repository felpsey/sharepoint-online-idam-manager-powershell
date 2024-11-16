@{
    RootModule = 'SPOID.psm1'
    ModuleVersion = '0.0.1'
    Author = 'Ethan Phelps'
    Description = 'A PowerShell module for managing and auditing SharePoint IdAM configurations'

    PowerShellVersion = '7.4'

    RequiredModules = @(
        @{ ModuleName = 'PnP.PowerShell'; ModuleVersion = '2.12.0' }
    )

    NestedModules = @(
        'modules/SPOID.Sites.psm1',
        'modules/SPOID.Utilities.psm1'
    )

    PrivateData = @{
        PSData = @{
            Tags        = @('SharePoint', 'Audit', 'IdAM', 'PowerShell')
            ProjectUri  = 'https://github.com/felpsey/sharepoint-online-idam-manager-powershell'
            LicenseUri  = 'https://opensource.org/licenses/MIT'
        }
    }
}