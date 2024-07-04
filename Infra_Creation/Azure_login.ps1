terraform -version
az login | Out-Null
az account show | Tee-Object -Variable jsonContent | Out-Null

# Specify the temporary file path
$tempFilePath = "$env:TEMP\tempfile.json"


try {
    # Write JSON content to the temporary file
    $jsonContent | Out-File -FilePath $tempFilePath -Encoding UTF8 -Force

    # Read and verify the content of the temporary file

    $json = (Get-Content $tempFilePath -Raw) | ConvertFrom-Json
    write-host "`n"
    Write-Output "Current Azure Account Name:"
    Write-Output "$($json.user.name)"
    write-host "`n"
    Write-Output "Current Azure Subscription:"
    write-host "`n"
    az account list --query "[?user.name=='$($json.user.name)'].{Name:name, ID:id, Default:isDefault}" --output Table

    write-host "`n"
    write-host "`n"

} finally {
    # Delete the temporary file
    Remove-Item -Path $tempFilePath -Force -ErrorAction SilentlyContinue
    Write-Output "Session Ended"
}

