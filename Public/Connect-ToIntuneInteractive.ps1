# The following does not work any more due to  
# If you are using the Microsoft Intune PowerShell app registration in #Entra with applicationId d1ddf0e4-d672-4dae-b554-9d5bdfd93547, you will need to update your code before April 1, 2024
# https://oofhours.com/2024/03/29/using-a-well-known-intune-app-id-for-access-to-graph-not-for-much-longer/

function Connect-ToIntuneInteractive {
    param (
        [Parameter(Mandatory = $true)]
        [string]$tenantId,
        [Parameter(Mandatory = $true)]
        [string]$clientId # Use your newly registered app's client ID
    )

    try {
        # Log the start of the interactive login
        Write-EnhancedLog -Message "Starting interactive login for Intune with custom app registration..." -Level 'INFO'
        # Write-EnhancedLog -Message "Starting interactive login to Intune..." -Level 'INFO'

        # Define the scopes needed for Intune
        $scopes = "DeviceManagementApps.ReadWrite.All", "DeviceManagementManagedDevices.ReadWrite.All"

        # Connect interactively to Microsoft Graph (Intune) using the custom app registration
        Connect-MgGraph -ClientId $clientId -TenantId $tenantId -Scopes $scopes -NoWelcome


        # Conditional check for Intune connection
        # if ($ConnectToIntune) {
        # try {
        # Log the connection attempt
        # Write-EnhancedLog -Message "Calling Connect-MSIntuneGraph interactively" -Level "WARNING"

        # Call the Connect-MSIntuneGraph function interactively (no parameters needed for interactive login)
        # $Session = Connect-MSIntuneGraph -tenantId $tenantId

        # Log the successful connection
        Write-EnhancedLog -Message "Connecting to Graph using Connect-MSIntuneGraph interactively - done" -Level "INFO"
        # } catch {
        #     Handle-Error -ErrorRecord $_
        # }
        # }


        # Log a successful connection
        Write-EnhancedLog -Message "Successfully connected to Microsoft Intune interactively using custom app registration." -Level 'INFO'

    }
    catch {
        # Handle any errors during the interactive connection
        $errorMessage = "Failed to connect to Intune interactively. Reason: $($_.Exception.Message)"
        Write-EnhancedLog -Message $errorMessage -Level 'ERROR'
        throw $errorMessage
    }
}
