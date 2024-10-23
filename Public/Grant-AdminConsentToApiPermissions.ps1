# function Grant-AdminConsentToApiPermissions {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$clientId,

#         [Parameter(Mandatory = $true)]
#         [string]$SPPermissionsPath
#     )

#     try {
#         Write-EnhancedLog -Message "Starting the process to grant admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Load permissions from JSON file
#         $permissionsFile = Join-Path -Path $SPPermissionsPath -ChildPath "SPPermissions.json"
#         if (-not (Test-Path -Path $permissionsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
#             throw "Permissions file not found"
#         }

#         $permissionsJson = Get-Content -Path $permissionsFile -Raw | ConvertFrom-Json
#         $permissions = $permissionsJson.permissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name

#         Write-EnhancedLog -Message "Permissions to be granted: $($permissions -join ', ')" -Level "INFO"

#         # Create and verify the service principal
#         Create-AndVerifyServicePrincipal -ClientId $clientId

#         Write-EnhancedLog -Message "Granting admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Retrieve the service principal for the application
#         $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$clientId'"

#         if ($null -eq $servicePrincipal) {
#             Write-EnhancedLog -Message "Service principal not found for the specified application ID." -Level "ERROR"
#             throw "Service principal not found"
#         }

#         Write-EnhancedLog -Message "Service principal for app ID: $clientId retrieved successfully." -Level "INFO"

#         # Retrieve the service principal ID
#         $servicePrincipalId = $servicePrincipal.Id

#         # Retrieve the Microsoft Graph service principal
#         $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles

#         if ($null -eq $graphServicePrincipal) {
#             Write-EnhancedLog -Message "Microsoft Graph service principal not found." -Level "ERROR"
#             throw "Microsoft Graph service principal not found"
#         }

#         $resourceId = $graphServicePrincipal.Id
#         $appRoles = $graphServicePrincipal.AppRoles

#         # Find the IDs of the required permissions
#         $requiredRoles = $appRoles | Where-Object { $permissions -contains $_.Value } | Select-Object Id, Value

#         if ($requiredRoles.Count -eq 0) {
#             Write-EnhancedLog -Message "No matching app roles found for the specified permissions." -Level "ERROR"
#             throw "No matching app roles found"
#         }

#         Write-EnhancedLog -Message "App roles to be granted: $($requiredRoles.Value -join ', ')" -Level "INFO"

#         # Grant the app roles (application permissions)
#         foreach ($role in $requiredRoles) {
#             $body = @{
#                 principalId = $servicePrincipalId
#                 resourceId  = $resourceId
#                 appRoleId   = $role.Id
#             }

#             $response = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$resourceId/appRoleAssignedTo" -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"

#             Write-EnhancedLog -Message "Granted app role: $($role.Value) with ID: $($role.Id)" -Level "INFO"
#         }
#         # $DBG

#         Write-EnhancedLog -Message "Admin consent granted successfully." -Level "INFO"
#         return $response

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while granting admin consent." -Level "ERROR"
#         Handle-Error -ErrorRecord $_ 
#         throw $_
#     }
# }

# # # Example usage
# # $scopes = @("Application.ReadWrite.All", "Directory.ReadWrite.All", "AppRoleAssignment.ReadWrite.All")
# # Connect-MgGraph -Scopes $scopes

# # Grant-AdminConsentToApiPermissions -ClientId "your-application-id"





# function Grant-AdminConsentToApiPermissions {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$clientId,

#         [Parameter(Mandatory = $true)]
#         [string]$SPPermissionsPath
#     )

#     try {
#         Write-EnhancedLog -Message "Starting the process to grant admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Load permissions from the PSD1 file
#         $permissionsFile = Join-Path -Path $SPPermissionsPath -ChildPath "SPPermissions.psd1"
#         if (-not (Test-Path -Path $permissionsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
#             throw "Permissions file not found"
#         }

#         $permissionsData = Import-PowerShellDataFile -Path $permissionsFile
        
#         # Extract the permissions that are granted and consolidate both application and delegated permissions
#         $grantedPermissions = @(
#             $permissionsData.applicationPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name
#             $permissionsData.delegatedPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name
#         )

#         Wait-Debugger

#         Write-EnhancedLog -Message "Permissions to be granted: $($grantedPermissions -join ', ')" -Level "INFO"

#         # Create and verify the service principal
#         Create-AndVerifyServicePrincipal -ClientId $clientId

#         Write-EnhancedLog -Message "Granting admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Retrieve the service principal for the application
#         $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$clientId'"

#         if ($null -eq $servicePrincipal) {
#             Write-EnhancedLog -Message "Service principal not found for the specified application ID." -Level "ERROR"
#             throw "Service principal not found"
#         }

#         Write-EnhancedLog -Message "Service principal for app ID: $clientId retrieved successfully." -Level "INFO"

#         # Retrieve the service principal ID
#         $servicePrincipalId = $servicePrincipal.Id

#         # Retrieve the Microsoft Graph service principal
#         $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles

#         if ($null -eq $graphServicePrincipal) {
#             Write-EnhancedLog -Message "Microsoft Graph service principal not found." -Level "ERROR"
#             throw "Microsoft Graph service principal not found"
#         }

#         $resourceId = $graphServicePrincipal.Id
#         $appRoles = $graphServicePrincipal.AppRoles

#         # Find the IDs of the required permissions
#         $requiredRoles = $appRoles | Where-Object { $grantedPermissions -contains $_.Value } | Select-Object Id, Value

#         if ($requiredRoles.Count -eq 0) {
#             Write-EnhancedLog -Message "No matching app roles found for the specified permissions." -Level "ERROR"
#             throw "No matching app roles found"
#         }

#         Write-EnhancedLog -Message "App roles to be granted: $($requiredRoles.Value -join ', ')" -Level "INFO"

#         # Grant the app roles (application permissions)
#         foreach ($role in $requiredRoles) {
#             $body = @{
#                 principalId = $servicePrincipalId
#                 resourceId  = $resourceId
#                 appRoleId   = $role.Id
#             }

#             $response = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$resourceId/appRoleAssignedTo" -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"

#             Write-EnhancedLog -Message "Granted app role: $($role.Value) with ID: $($role.Id)" -Level "INFO"
#         }

#         Write-EnhancedLog -Message "Admin consent granted successfully." -Level "INFO"
#         return $response

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while granting admin consent." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }

# Example usage:
# Grant-AdminConsentToApiPermissions -ClientId "your-application-id" -SPPermissionsPath "C:\path\to\permissions"








# function Grant-AdminConsentToApiPermissions {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$clientId,

#         [Parameter(Mandatory = $true)]
#         [string]$SPPermissionsPath
#     )

#     try {
#         Write-EnhancedLog -Message "Starting the process to grant admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Load permissions from the PSD1 file
#         $permissionsFile = Join-Path -Path $SPPermissionsPath -ChildPath "SPPermissions.psd1"
#         if (-not (Test-Path -Path $permissionsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
#             throw "Permissions file not found"
#         }

#         $permissionsData = Import-PowerShellDataFile -Path $permissionsFile
        
#         # Extract the permissions that are granted and consolidate both application and delegated permissions
#         $grantedPermissions = @(
#             $permissionsData.applicationPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty permissionName
#             $permissionsData.delegatedPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty permissionName
#         )

#         if ($grantedPermissions.Count -eq 0) {
#             Write-EnhancedLog -Message "No permissions to be granted were found." -Level "WARNING"
#         } else {
#             Write-EnhancedLog -Message "Permissions to be granted: $($grantedPermissions -join ', ')" -Level "INFO"
#         }

#         # Create and verify the service principal
#         Create-AndVerifyServicePrincipal -ClientId $clientId

#         Write-EnhancedLog -Message "Granting admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Retrieve the service principal for the application
#         $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$clientId'"

#         if ($null -eq $servicePrincipal) {
#             Write-EnhancedLog -Message "Service principal not found for the specified application ID." -Level "ERROR"
#             throw "Service principal not found"
#         }

#         Write-EnhancedLog -Message "Service principal for app ID: $clientId retrieved successfully." -Level "INFO"

#         # Retrieve the service principal ID
#         $servicePrincipalId = $servicePrincipal.Id

#         # Retrieve the Microsoft Graph service principal
#         $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles

#         if ($null -eq $graphServicePrincipal) {
#             Write-EnhancedLog -Message "Microsoft Graph service principal not found." -Level "ERROR"
#             throw "Microsoft Graph service principal not found"
#         }

#         $resourceId = $graphServicePrincipal.Id
#         $appRoles = $graphServicePrincipal.AppRoles

#         # Find the IDs of the required permissions
#         $requiredRoles = $appRoles | Where-Object { $grantedPermissions -contains $_.Value } | Select-Object Id, Value

#         if ($requiredRoles.Count -eq 0) {
#             Write-EnhancedLog -Message "No matching app roles found for the specified permissions." -Level "ERROR"
#             throw "No matching app roles found"
#         }

#         Write-EnhancedLog -Message "App roles to be granted: $($requiredRoles.Value -join ', ')" -Level "INFO"

#         # Grant the app roles (application permissions)
#         foreach ($role in $requiredRoles) {
#             $body = @{
#                 principalId = $servicePrincipalId
#                 resourceId  = $resourceId
#                 appRoleId   = $role.Id
#             }

#             $response = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$resourceId/appRoleAssignedTo" -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"

#             Write-EnhancedLog -Message "Granted app role: $($role.Value) with ID: $($role.Id)" -Level "INFO"
#         }

#         Write-EnhancedLog -Message "Admin consent granted successfully." -Level "INFO"
#         return $response

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while granting admin consent." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }







# function Grant-AdminConsentToApiPermissions {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$clientId,

#         [Parameter(Mandatory = $true)]
#         [string]$SPPermissionsPath
#     )

#     try {
#         Write-EnhancedLog -Message "Starting the process to grant admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Load permissions from the PSD1 file
#         $permissionsFile = Join-Path -Path $SPPermissionsPath -ChildPath "SPPermissions.psd1"
#         if (-not (Test-Path -Path $permissionsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
#             throw "Permissions file not found"
#         }

#         $permissionsData = Import-PowerShellDataFile -Path $permissionsFile

#         # Extract the permissions that are granted and consolidate both application and delegated permissions
#         $grantedPermissions = @(
#             $permissionsData.applicationPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name
#             $permissionsData.delegatedPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name
#         )

#         if ($grantedPermissions.Count -eq 0) {
#             Write-EnhancedLog -Message "No permissions to be granted were found." -Level "WARNING"
#         } else {
#             Write-EnhancedLog -Message "Permissions to be granted: $($grantedPermissions -join ', ')" -Level "INFO"
#         }

#         # Create and verify the service principal
#         Create-AndVerifyServicePrincipal -ClientId $clientId

#         Write-EnhancedLog -Message "Granting admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Retrieve the service principal for the application
#         $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$clientId'"

#         if ($null -eq $servicePrincipal) {
#             Write-EnhancedLog -Message "Service principal not found for the specified application ID." -Level "ERROR"
#             throw "Service principal not found"
#         }

#         Write-EnhancedLog -Message "Service principal for app ID: $clientId retrieved successfully." -Level "INFO"

#         # Retrieve the service principal ID
#         $servicePrincipalId = $servicePrincipal.Id

#         # Retrieve the Microsoft Graph service principal
#         $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles

#         if ($null -eq $graphServicePrincipal) {
#             Write-EnhancedLog -Message "Microsoft Graph service principal not found." -Level "ERROR"
#             throw "Microsoft Graph service principal not found"
#         }

#         $resourceId = $graphServicePrincipal.Id
#         $appRoles = $graphServicePrincipal.AppRoles

#         # Find the IDs of the required permissions
#         $requiredRoles = $appRoles | Where-Object { $grantedPermissions -contains $_.Value } | Select-Object Id, Value

#         if ($requiredRoles.Count -eq 0) {
#             Write-EnhancedLog -Message "No matching app roles found for the specified permissions." -Level "ERROR"
#             throw "No matching app roles found"
#         }

#         Write-EnhancedLog -Message "App roles to be granted: $($requiredRoles.Value -join ', ')" -Level "INFO"

#         # Grant the app roles (application permissions)
#         foreach ($role in $requiredRoles) {
#             $body = @{
#                 principalId = $servicePrincipalId
#                 resourceId  = $resourceId
#                 appRoleId   = $role.Id
#             }

#             $response = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$resourceId/appRoleAssignedTo" -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"

#             Write-EnhancedLog -Message "Granted app role: $($role.Value) with ID: $($role.Id)" -Level "INFO"
#         }

#         Write-EnhancedLog -Message "Admin consent granted successfully." -Level "INFO"
#         return $response

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while granting admin consent." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }




# function Grant-AdminConsentToApiPermissions {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$clientId,

#         [Parameter(Mandatory = $true)]
#         [string]$SPPermissionsPath
#     )

#     try {
#         Write-EnhancedLog -Message "Starting the process to grant admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Load permissions from the PSD1 file
#         $permissionsFile = Join-Path -Path $SPPermissionsPath -ChildPath "SPPermissions.psd1"
#         if (-not (Test-Path -Path $permissionsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
#             throw "Permissions file not found"
#         }

#         # Import the PSD1 data
#         $permissionsData = Import-PowerShellDataFile -Path $permissionsFile

#         # Ensure application and delegated permissions are present
#         $applicationPermissions = $permissionsData.applicationPermissions
#         $delegatedPermissions = $permissionsData.delegatedPermissions

#         # Combine both granted application and delegated permissions
#         $grantedPermissions = @(
#             $applicationPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name
#             $delegatedPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name
#         )

#         if ($grantedPermissions.Count -eq 0) {
#             Write-EnhancedLog -Message "No permissions to be granted were found." -Level "WARNING"
#         } else {
#             Write-EnhancedLog -Message "Permissions to be granted: $($grantedPermissions -join ', ')" -Level "INFO"
#         }

#         # Create and verify the service principal
#         Create-AndVerifyServicePrincipal -ClientId $clientId

#         Write-EnhancedLog -Message "Granting admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Retrieve the service principal for the application
#         $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$clientId'"

#         if ($null -eq $servicePrincipal) {
#             Write-EnhancedLog -Message "Service principal not found for the specified application ID." -Level "ERROR"
#             throw "Service principal not found"
#         }

#         Write-EnhancedLog -Message "Service principal for app ID: $clientId retrieved successfully." -Level "INFO"

#         # Retrieve the service principal ID
#         $servicePrincipalId = $servicePrincipal.Id

#         # Retrieve the Microsoft Graph service principal
#         $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles

#         if ($null -eq $graphServicePrincipal) {
#             Write-EnhancedLog -Message "Microsoft Graph service principal not found." -Level "ERROR"
#             throw "Microsoft Graph service principal not found"
#         }

#         $resourceId = $graphServicePrincipal.Id
#         $appRoles = $graphServicePrincipal.AppRoles

#         # Find the IDs of the required permissions
#         $requiredRoles = $appRoles | Where-Object { $grantedPermissions -contains $_.Value } | Select-Object Id, Value

#         if ($requiredRoles.Count -eq 0) {
#             Write-EnhancedLog -Message "No matching app roles found for the specified permissions." -Level "ERROR"
#             throw "No matching app roles found"
#         }

#         Write-EnhancedLog -Message "App roles to be granted: $($requiredRoles.Value -join ', ')" -Level "INFO"

#         # Grant the app roles (application permissions)
#         foreach ($role in $requiredRoles) {
#             $body = @{
#                 principalId = $servicePrincipalId
#                 resourceId  = $resourceId
#                 appRoleId   = $role.Id
#             }

#             $response = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$resourceId/appRoleAssignedTo" -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"

#             Write-EnhancedLog -Message "Granted app role: $($role.Value) with ID: $($role.Id)" -Level "INFO"
#         }

#         Write-EnhancedLog -Message "Admin consent granted successfully." -Level "INFO"
#         return $response

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while granting admin consent." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }






# function Grant-AdminConsentToApiPermissions {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$clientId,

#         [Parameter(Mandatory = $true)]
#         [string]$SPPermissionsPath
#     )

#     try {
#         Write-EnhancedLog -Message "Starting the process to grant admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Load permissions from the PSD1 file
#         $permissionsFile = Join-Path -Path $SPPermissionsPath -ChildPath "SPPermissions.psd1"
#         if (-not (Test-Path -Path $permissionsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
#             throw "Permissions file not found"
#         }

#         $permissionsData = Import-PowerShellDataFile -Path $permissionsFile
#         $applicationPermissions = $permissionsData.applicationPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name
#         $delegatedPermissions = $permissionsData.delegatedPermissions | Where-Object { $_.granted -eq $true } | Select-Object -ExpandProperty name

#         Write-EnhancedLog -Message "Application permissions to be granted: $($applicationPermissions -join ', ')" -Level "INFO"
#         Write-EnhancedLog -Message "Delegated permissions to be granted: $($delegatedPermissions -join ', ')" -Level "INFO"

#         # Create and verify the service principal
#         Create-AndVerifyServicePrincipal -ClientId $clientId

#         Write-EnhancedLog -Message "Granting admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Retrieve the service principal for the application
#         $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$clientId'"

#         if ($null -eq $servicePrincipal) {
#             Write-EnhancedLog -Message "Service principal not found for the specified application ID." -Level "ERROR"
#             throw "Service principal not found"
#         }

#         Write-EnhancedLog -Message "Service principal for app ID: $clientId retrieved successfully." -Level "INFO"

#         # Retrieve the service principal ID
#         $servicePrincipalId = $servicePrincipal.Id

#         # Retrieve the Microsoft Graph service principal
#         $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles

#         if ($null -eq $graphServicePrincipal) {
#             Write-EnhancedLog -Message "Microsoft Graph service principal not found." -Level "ERROR"
#             throw "Microsoft Graph service principal not found"
#         }

#         $resourceId = $graphServicePrincipal.Id
#         $appRoles = $graphServicePrincipal.AppRoles

#         # Combine the permissions (application + delegated)
#         $allPermissions = $applicationPermissions + $delegatedPermissions

#         # Find the IDs of the required permissions
#         $requiredRoles = $appRoles | Where-Object { $allPermissions -contains $_.Value } | Select-Object Id, Value

#         if ($requiredRoles.Count -eq 0) {
#             Write-EnhancedLog -Message "No matching app roles found for the specified permissions." -Level "ERROR"
#             throw "No matching app roles found"
#         }

#         Write-EnhancedLog -Message "App roles to be granted: $($requiredRoles.Value -join ', ')" -Level "INFO"

#         # Grant the app roles (application permissions)
#         foreach ($role in $requiredRoles) {
#             $body = @{
#                 principalId = $servicePrincipalId
#                 resourceId  = $resourceId
#                 appRoleId   = $role.Id
#             }

#             $response = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$resourceId/appRoleAssignedTo" -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"

#             Write-EnhancedLog -Message "Granted app role: $($role.Value) with ID: $($role.Id)" -Level "INFO"
#         }

#         Write-EnhancedLog -Message "Admin consent granted successfully." -Level "INFO"
#         return $response

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while granting admin consent." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }





# function Grant-AdminConsentToApiPermissions {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$clientId,

#         [Parameter(Mandatory = $true)]
#         [string]$SPPermissionsPath
#     )

#     try {
#         Write-EnhancedLog -Message "Starting the process to grant admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Load permissions from the PSD1 file
#         $permissionsFile = Join-Path -Path $SPPermissionsPath -ChildPath "SPPermissions.psd1"
#         if (-not (Test-Path -Path $permissionsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
#             throw "Permissions file not found"
#         }

#         $permissionsData = Import-PowerShellDataFile -Path $permissionsFile

#         # Combine application and delegated permissions
#         $allPermissions = @($permissionsData.applicationPermissions + $permissionsData.delegatedPermissions)

#         # Filter granted permissions and ensure property existence
#         $grantedPermissions = foreach ($perm in $allPermissions) {
#             if ($perm.PSObject.Properties['name'] -and $perm.granted -eq $true) {
#                 $perm.name
#             } else {
#                 # Log if property is missing or invalid
#                 Write-EnhancedLog -Message "Permission object missing 'name' property or is not granted: $($perm | Out-String)" -Level "WARNING"
#             }
#         }

#         if ($grantedPermissions.Count -eq 0) {
#             Write-EnhancedLog -Message "No granted permissions found." -Level "ERROR"
#             throw "No granted permissions found."
#         }

#         Write-EnhancedLog -Message "Permissions to be granted: $($grantedPermissions -join ', ')" -Level "INFO"

#         # Create and verify the service principal
#         Create-AndVerifyServicePrincipal -ClientId $clientId

#         Write-EnhancedLog -Message "Granting admin consent to API permissions for App ID: $clientId" -Level "INFO"

#         # Retrieve the service principal for the application
#         $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$clientId'"

#         if ($null -eq $servicePrincipal) {
#             Write-EnhancedLog -Message "Service principal not found for the specified application ID." -Level "ERROR"
#             throw "Service principal not found"
#         }

#         Write-EnhancedLog -Message "Service principal for app ID: $clientId retrieved successfully." -Level "INFO"

#         # Retrieve the service principal ID
#         $servicePrincipalId = $servicePrincipal.Id

#         # Retrieve the Microsoft Graph service principal
#         $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles

#         if ($null -eq $graphServicePrincipal) {
#             Write-EnhancedLog -Message "Microsoft Graph service principal not found." -Level "ERROR"
#             throw "Microsoft Graph service principal not found"
#         }

#         $resourceId = $graphServicePrincipal.Id
#         $appRoles = $graphServicePrincipal.AppRoles

#         # Find the IDs of the required permissions
#         $requiredRoles = $appRoles | Where-Object { $grantedPermissions -contains $_.Value } | Select-Object Id, Value

#         if ($requiredRoles.Count -eq 0) {
#             Write-EnhancedLog -Message "No matching app roles found for the specified permissions." -Level "ERROR"
#             throw "No matching app roles found"
#         }

#         Write-EnhancedLog -Message "App roles to be granted: $($requiredRoles.Value -join ', ')" -Level "INFO"

#         # Grant the app roles (application permissions)
#         foreach ($role in $requiredRoles) {
#             $body = @{
#                 principalId = $servicePrincipalId
#                 resourceId  = $resourceId
#                 appRoleId   = $role.Id
#             }

#             $response = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$resourceId/appRoleAssignedTo" -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"

#             Write-EnhancedLog -Message "Granted app role: $($role.Value) with ID: $($role.Id)" -Level "INFO"
#         }

#         Write-EnhancedLog -Message "Admin consent granted successfully." -Level "INFO"
#         return $response

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while granting admin consent." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }





function Grant-AdminConsentToApiPermissions {
    param (
        [Parameter(Mandatory = $true)]
        [string]$clientId,

        [Parameter(Mandatory = $true)]
        [string]$SPPermissionsPath
    )

    try {
        Write-EnhancedLog -Message "Starting the process to grant admin consent to API permissions for App ID: $clientId" -Level "INFO"

        # Load permissions from the PSD1 file
        $permissionsFile = Join-Path -Path $SPPermissionsPath -ChildPath "SPPermissions.psd1"
        if (-not (Test-Path -Path $permissionsFile)) {
            Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
            throw "Permissions file not found"
        }

        $permissionsData = Import-PowerShellDataFile -Path $permissionsFile

        # Combine application and delegated permissions
        $allPermissions = @($permissionsData.applicationPermissions + $permissionsData.delegatedPermissions)

        # Filter granted permissions and ensure property existence
        $grantedPermissions = @()
        $allPermissions | ForEach-Object {
            if ($_ -is [hashtable] -or $_ -is [pscustomobject]) {
                # If it's a hashtable, make sure the 'name' and 'granted' properties exist
                if ($_['name'] -and $_['granted'] -eq $true) {
                    $grantedPermissions += $_['name']
                } else {
                    # Log if 'name' or 'granted' is missing or false
                    Write-EnhancedLog -Message "Permission object missing 'name' or 'granted' is false: $($_ | Out-String)" -Level "WARNING"
                }
            } else {
                # Log if it's not a supported object type
                Write-EnhancedLog -Message "Unsupported object type: $($_.GetType().FullName)" -Level "WARNING"
            }
        }

        if ($grantedPermissions.Count -eq 0) {
            Write-EnhancedLog -Message "No granted permissions found." -Level "ERROR"
            throw "No granted permissions found."
        }

        Write-EnhancedLog -Message "Permissions to be granted: $($grantedPermissions -join ', ')" -Level "INFO"

        # Create and verify the service principal
        Create-AndVerifyServicePrincipal -ClientId $clientId

        Write-EnhancedLog -Message "Granting admin consent to API permissions for App ID: $clientId" -Level "INFO"

        # Retrieve the service principal for the application
        $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$clientId'"

        if ($null -eq $servicePrincipal) {
            Write-EnhancedLog -Message "Service principal not found for the specified application ID." -Level "ERROR"
            throw "Service principal not found"
        }

        Write-EnhancedLog -Message "Service principal for app ID: $clientId retrieved successfully." -Level "INFO"

        # Retrieve the service principal ID
        $servicePrincipalId = $servicePrincipal.Id

        # Retrieve the Microsoft Graph service principal
        $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles

        if ($null -eq $graphServicePrincipal) {
            Write-EnhancedLog -Message "Microsoft Graph service principal not found." -Level "ERROR"
            throw "Microsoft Graph service principal not found"
        }

        $resourceId = $graphServicePrincipal.Id
        $appRoles = $graphServicePrincipal.AppRoles

        # Find the IDs of the required permissions
        $requiredRoles = $appRoles | Where-Object { $grantedPermissions -contains $_.Value } | Select-Object Id, Value

        if ($requiredRoles.Count -eq 0) {
            Write-EnhancedLog -Message "No matching app roles found for the specified permissions." -Level "ERROR"
            throw "No matching app roles found"
        }

        Write-EnhancedLog -Message "App roles to be granted: $($requiredRoles.Value -join ', ')" -Level "INFO"

        # Grant the app roles (application permissions)
        foreach ($role in $requiredRoles) {
            $body = @{
                principalId = $servicePrincipalId
                resourceId  = $resourceId
                appRoleId   = $role.Id
            }

            $response = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$resourceId/appRoleAssignedTo" -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"

            Write-EnhancedLog -Message "Granted app role: $($role.Value) with ID: $($role.Id)" -Level "INFO"
        }

        Write-EnhancedLog -Message "Admin consent granted successfully." -Level "INFO"
        return $response

    } catch {
        Write-EnhancedLog -Message "An error occurred while granting admin consent." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}


