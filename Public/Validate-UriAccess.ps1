function Validate-UriAccess {
    param (
        [string]$uri,
        [hashtable]$headers
    )

    Write-EnhancedLog -Message "Validating access to URI: $uri" -Level "INFO"
    try {
        $response = Invoke-WebRequest -Uri $uri -Headers $headers -Method Get
        if ($response.StatusCode -eq 200) {
            Write-EnhancedLog -Message "Access to $uri PASS" -Level "INFO"
            return $true
        } else {
            Write-EnhancedLog -Message "Access to $uri FAIL" -Level "ERROR"
            return $false
        }
    } catch {
        Write-EnhancedLog -Message "Access to $uri FAIL - $_" -Level "ERROR"
        return $false
    }
}





# function Validate-UriAccess {
#     param (
#         [string]$uri,
#         [hashtable]$headers
#     )

#     Write-EnhancedLog -Message "Validating access to URI: $uri" -Level "INFO"

#     # Initialize the HttpClient with a short timeout
#     $httpClient = [System.Net.Http.HttpClient]::new()
#     $httpClient.Timeout = [System.TimeSpan]::FromSeconds(10)

#     # Add headers to HttpClient
#     foreach ($key in $headers.Keys) {
#         $httpClient.DefaultRequestHeaders.Add($key, $headers[$key])
#     }

#     try {
#         $response = $httpClient.GetAsync($uri).Result
#         if ($response.StatusCode -eq [System.Net.HttpStatusCode]::OK) {
#             Write-EnhancedLog -Message "Access to $uri PASS" -Level "INFO"
#             return $true
#         } else {
#             Write-EnhancedLog -Message "Access to $uri FAIL (StatusCode: $($response.StatusCode))" -Level "ERROR"
#             return $false
#         }
#     } catch {
#         Write-EnhancedLog -Message "Access to $uri FAIL - $_" -Level "ERROR"
#         return $false
#     } finally {
#         # Dispose the HttpClient to free resources
#         $httpClient.Dispose()
#     }
# }




# function Validate-UriAccess {
#     param (
#         [string]$uri,
#         [hashtable]$headers
#     )

#     Write-EnhancedLog -Message "Validating access to URI: $uri" -Level "INFO"

#     # Initialize the HttpClient with a short timeout
#     $httpClient = [System.Net.Http.HttpClient]::new()
#     $httpClient.Timeout = [System.TimeSpan]::FromSeconds(10)

#     try {
#         # Add headers to HttpClient
#         foreach ($key in $headers.Keys) {
#             if ($key -notin @('Content-Type', 'Content-Length', 'Content-Disposition')) {
#                 $httpClient.DefaultRequestHeaders.Add($key, $headers[$key])
#             }
#         }

#         $response = $httpClient.GetAsync($uri).Result
#         if ($response.StatusCode -eq [System.Net.HttpStatusCode]::OK) {
#             Write-EnhancedLog -Message "Access to $uri PASS" -Level "INFO"
#             return $true
#         } else {
#             Write-EnhancedLog -Message "Access to $uri FAIL (StatusCode: $($response.StatusCode))" -Level "ERROR"
#             return $false
#         }
#     } catch {
#         Write-EnhancedLog -Message "Access to $uri FAIL - $_" -Level "ERROR"
#         return $false
#     } finally {
#         # Dispose the HttpClient to free resources
#         $httpClient.Dispose()
#     }
# }
