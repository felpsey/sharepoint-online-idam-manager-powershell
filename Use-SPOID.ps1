Import-Module "./SPOID.psd1" -Force

# Connect-SPOID -Name "felpsey" -ClientId "b4da5f45-1243-45fc-a02a-9a5901e33c7a" -Verbose

Get-SPOIDTenantSites | ft *

# Disconnect-PnPOnline