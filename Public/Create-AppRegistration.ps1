# function Create-AppRegistration {
#     param (
#         [string]$AppName,
#         # [string]$PermsFile = "$PSScriptRoot\permissions.json"
#         [string]$PermsFile
#     )

#     try {
#         if (-Not (Test-Path $PermsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $PermsFile" -Level "ERROR"
#             throw "Permissions file missing"
#         }
    
#         $permissions = Get-Content -Path $PermsFile -Raw | ConvertFrom-Json

#         # Convert the JSON data to the required types
#         $requiredResourceAccess = @()
#         foreach ($perm in $permissions.permissions) {
#             $resourceAccess = @()
#             foreach ($access in $perm.ResourceAccess) {
#                 $resourceAccess += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceAccess]@{
#                     Id   = [Guid]$access.Id
#                     Type = $access.Type
#                 }
#             }
#             $requiredResourceAccess += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequiredResourceAccess]@{
#                 ResourceAppId  = [Guid]$perm.ResourceAppId
#                 ResourceAccess = $resourceAccess
#             }
#         }

#         # Connect to Graph interactively
#         # Connect-MgGraph -Scopes "Application.ReadWrite.All"
    
#         # Get tenant details
#         $tenantDetails = Get-MgOrganization | Select-Object -First 1
    
#         # Create the application
#         $app = New-MgApplication -DisplayName $AppName -SignInAudience "AzureADMyOrg" -RequiredResourceAccess $requiredResourceAccess
    
#         if ($null -eq $app) {
#             Write-EnhancedLog -Message "App registration failed" -Level "ERROR"
#             throw "App registration failed"
#         }
    
#         Write-EnhancedLog -Message "App registered successfully" -Level "INFO"
#         return @{ App = $app; TenantDetails = $tenantDetails }
        
#     }
#     catch {
#         Handle-Error -ErrorRecord $_
#     }
# }



# function Create-AppRegistration {
#     param (
#         [string]$AppName,
#         # Provide the path to the PSD1 file instead of JSON
#         [string]$PermsFile
#     )

#     try {
#         if (-Not (Test-Path $PermsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $PermsFile" -Level "ERROR"
#             throw "Permissions file missing"
#         }

#         # Load the PSD1 permissions file
#         $permissions = Import-PowerShellDataFile -Path $PermsFile

#         # Convert the PSD1 data to the required types
#         $requiredResourceAccess = @()
#         foreach ($perm in $permissions.permissions) {
#             $resourceAccess = @()

#             # Loop through both applicationPermissions and delegatedPermissions
#             foreach ($accessType in @('applicationPermissions', 'delegatedPermissions')) {
#                 if ($perm.ContainsKey($accessType)) {
#                     foreach ($access in $perm[$accessType]) {
#                         $resourceAccess += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceAccess]@{
#                             Id   = [Guid]$access.id
#                             Type = $access.type
#                         }
#                     }
#                 }
#             }

#             $requiredResourceAccess += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequiredResourceAccess]@{
#                 ResourceAppId  = [Guid]$perm.resourceAppId
#                 ResourceAccess = $resourceAccess
#             }
#         }

#         # Connect to Graph interactively
#         # Connect-MgGraph -Scopes "Application.ReadWrite.All"

#         # Get tenant details
#         $tenantDetails = Get-MgOrganization | Select-Object -First 1

#         # Create the application
#         $app = New-MgApplication -DisplayName $AppName -SignInAudience "AzureADMyOrg" -RequiredResourceAccess $requiredResourceAccess

#         if ($null -eq $app) {
#             Write-EnhancedLog -Message "App registration failed" -Level "ERROR"
#             throw "App registration failed"
#         }

#         Write-EnhancedLog -Message "App registered successfully" -Level "INFO"
#         return @{ App = $app; TenantDetails = $tenantDetails }
        
#     }
#     catch {
#         Handle-Error -ErrorRecord $_
#     }
# }




#       # Function to get the permission ID based on the name and type (either Role or Scope)
#       function Get-PermissionId {
#         param (
#             [string]$permissionName,
#             [string]$permissionType
#         )
        
#         if ($permissionType -eq 'Role') {
#             # Fetch App Role by value
#             $appRole = $graphServicePrincipal.appRoles | Where-Object { $_.value -eq $permissionName }
#             return $appRole.id
#         } elseif ($permissionType -eq 'Scope') {
#             # Fetch OAuth2 Scope by value
#             $oauthScope = $graphServicePrincipal.oauth2PermissionScopes | Where-Object { $_.value -eq $permissionName }
#             return $oauthScope.id
#         } else {
#             throw "Unknown permission type: $permissionType"
#         }
#     }



# function Create-AppRegistration {
#     param (
#         [string]$AppName,
#         # Provide the path to the PSD1 file instead of JSON
#         [string]$PermsFile
#     )

#     try {
#         if (-Not (Test-Path $PermsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $PermsFile" -Level "ERROR"
#             throw "Permissions file missing"
#         }

#         # Load the PSD1 permissions file
#         $permissions = Import-PowerShellDataFile -Path $PermsFile

#         # Fetch the Microsoft Graph Service Principal
#         $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles,oauth2PermissionScopes

  

#         # Convert the PSD1 data to the required types
#         $requiredResourceAccess = @()
#         foreach ($perm in $permissions.permissions) {
#             $resourceAccess = @()

#             # Loop through both applicationPermissions and delegatedPermissions
#             foreach ($accessType in @('applicationPermissions', 'delegatedPermissions')) {
#                 if ($perm.ContainsKey($accessType)) {
#                     foreach ($access in $perm[$accessType]) {
#                         $permissionId = Get-PermissionId -permissionName $access.name -permissionType $access.type
#                         if (-not $permissionId) {
#                             Write-EnhancedLog -Message "Permission ID not found for $($access.name)" -Level "ERROR"
#                             throw "Permission ID missing for $($access.name)"
#                         }

#                         $resourceAccess += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceAccess]@{
#                             Id   = [Guid]$permissionId
#                             Type = $access.type
#                         }
#                     }
#                 }
#             }

#             $requiredResourceAccess += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequiredResourceAccess]@{
#                 ResourceAppId  = [Guid]$perm.resourceAppId
#                 ResourceAccess = $resourceAccess
#             }
#         }

#         # Connect to Graph interactively
#         # Connect-MgGraph -Scopes "Application.ReadWrite.All"

#         # Get tenant details
#         $tenantDetails = Get-MgOrganization | Select-Object -First 1

#         # Create the application
#         $app = New-MgApplication -DisplayName $AppName -SignInAudience "AzureADMyOrg" -RequiredResourceAccess $requiredResourceAccess

#         if ($null -eq $app) {
#             Write-EnhancedLog -Message "App registration failed" -Level "ERROR"
#             throw "App registration failed"
#         }

#         Write-EnhancedLog -Message "App registered successfully" -Level "INFO"
#         return @{ App = $app; TenantDetails = $tenantDetails }
        
#     }
#     catch {
#         Handle-Error -ErrorRecord $_
#     }
# }



        # Function to get the permission ID based on the name and type (either Role or Scope)
        function Get-PermissionId {
            param (
                [string]$permissionName,
                [string]$permissionType
            )
            
            try {
                if ($permissionType -eq 'Role') {
                    # Fetch App Role by value
                    $appRole = $graphServicePrincipal.appRoles | Where-Object { $_.value -eq $permissionName }
                    if ($null -eq $appRole) {
                        Write-EnhancedLog -Message "Permission ID not found for $permissionName (Type: $permissionType)" -Level "ERROR"
                        throw "Permission ID missing for $permissionName"
                    }
                    return $appRole.id
                } elseif ($permissionType -eq 'Scope') {
                    # Fetch OAuth2 Scope by value
                    $oauthScope = $graphServicePrincipal.oauth2PermissionScopes | Where-Object { $_.value -eq $permissionName }
                    if ($null -eq $oauthScope) {
                        Write-EnhancedLog -Message "Permission ID not found for $permissionName (Type: $permissionType)" -Level "ERROR"
                        throw "Permission ID missing for $permissionName"
                    }
                    return $oauthScope.id
                } else {
                    Write-EnhancedLog -Message "Unknown permission type: $permissionType for $permissionName" -Level "ERROR"
                    throw "Unknown permission type: $permissionType"
                }
            }
            catch {
                Write-EnhancedLog -Message "Error while retrieving permission ID for $permissionName $_" -Level "ERROR"
                return $null
            }
        }




function Create-AppRegistration {
    param (
        [string]$AppName,
        # Provide the path to the PSD1 file instead of JSON
        [string]$PermsFile
    )

    try {
        if (-Not (Test-Path $PermsFile)) {
            Write-EnhancedLog -Message "Permissions file not found: $PermsFile" -Level "ERROR"
            throw "Permissions file missing"
        }

        # Load the PSD1 permissions file
        $permissions = Import-PowerShellDataFile -Path $PermsFile

        # Fetch the Microsoft Graph Service Principal
        $graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Select id,appRoles,oauth2PermissionScopes



        # Convert the PSD1 data to the required types
        $requiredResourceAccess = @()
        foreach ($perm in $permissions.permissions) {
            $resourceAccess = @()

            # Loop through both applicationPermissions and delegatedPermissions
            foreach ($accessType in @('applicationPermissions', 'delegatedPermissions')) {
                if ($perm.ContainsKey($accessType)) {
                    foreach ($access in $perm[$accessType]) {
                        $permissionId = Get-PermissionId -permissionName $access.name -permissionType $access.type
                        if (-not $permissionId) {
                            # Log and skip the permission if the ID is not found
                            Write-EnhancedLog -Message "Skipping permission $($access.name) due to missing ID" -Level "WARNING"
                            continue
                        }

                        $resourceAccess += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceAccess]@{
                            Id   = [Guid]$permissionId
                            Type = $access.type
                        }
                    }
                }
            }

            if ($resourceAccess.Count -gt 0) {
                $requiredResourceAccess += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequiredResourceAccess]@{
                    ResourceAppId  = [Guid]$perm.resourceAppId
                    ResourceAccess = $resourceAccess
                }
            } else {
                Write-EnhancedLog -Message "No valid resource access found for $($perm.resourceAppId), skipping this entry" -Level "WARNING"
            }
        }

        # Ensure we have valid resource access before proceeding
        if ($requiredResourceAccess.Count -eq 0) {
            Write-EnhancedLog -Message "No valid permissions found in the PSD1 file, aborting app registration" -Level "ERROR"
            throw "No valid permissions found"
        }

        # Connect to Graph interactively if needed
        # Connect-MgGraph -Scopes "Application.ReadWrite.All"

        # Get tenant details
        $tenantDetails = Get-MgOrganization | Select-Object -First 1

        # Create the application
        $app = New-MgApplication -DisplayName $AppName -SignInAudience "AzureADMyOrg" -RequiredResourceAccess $requiredResourceAccess

        if ($null -eq $app) {
            Write-EnhancedLog -Message "App registration failed" -Level "ERROR"
            throw "App registration failed"
        }

        Write-EnhancedLog -Message "App registered successfully" -Level "INFO"
        return @{ App = $app; TenantDetails = $tenantDetails }
        
    }
    catch {
        Write-EnhancedLog -Message "Error occurred during app registration: $_" -Level "ERROR"
        Handle-Error -ErrorRecord $_
    }
}









