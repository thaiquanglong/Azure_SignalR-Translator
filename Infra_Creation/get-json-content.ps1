az account show | Tee-Object -Variable jsonContent | Out-Null

# Specify the temporary file path
$tempFilePath = "$env:TEMP\tempfile.json"


try {
    # Write JSON content to the temporary file
    $jsonContent | Out-File -FilePath $tempFilePath -Encoding UTF8 -Force

    # Read and verify the content of the temporary file
    Write-Output "Content of temporary file:"
    $json = (Get-Content $tempFilePath -Raw) | ConvertFrom-Json


    az account list --query "[?user.name=='$($json.user.name)'].{ID:id}" | Tee-Object -Variable sub_output | Out-Null
    $sub = ConvertFrom-Json -InputObject "$sub_output"
    $sub.ID

    # Perform operations with the file as needed

} finally {
    # Delete the temporary file
    Remove-Item -Path $tempFilePath -Force -ErrorAction SilentlyContinue
    Write-Output "Temporary file deleted."
}
