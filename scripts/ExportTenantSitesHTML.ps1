# Define paths
$csvPath = "output/Sites.csv"  # Path to your CSV file
$htmlPath = "output/Sites.html"  # Path to save the HTML file

# Read the CSV file
if (-not (Test-Path -Path $csvPath)) {
    Write-Error "CSV file not found at $csvPath"
    return
}

$csvData = Import-Csv -Path $csvPath

# Generate HTML table
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List of SharePoint Sites in site $((Get-PnPContext).Url)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>List of SharePoint Sites in site $((Get-PnPContext).Url)</h1>
    <table>
        <thead>
            <tr>
"@

# Add table headers
$headers = $csvData[0].PSObject.Properties.Name
foreach ($header in $headers) {
    $htmlContent += "                <th>$header</th>`n"
}

$htmlContent += @"
            </tr>
        </thead>
        <tbody>
"@

# Add table rows
foreach ($row in $csvData) {
    $htmlContent += "            <tr>`n"
    foreach ($header in $headers) {
        $htmlContent += "                <td>$($row.$header)</td>`n"
    }
    $htmlContent += "            </tr>`n"
}

$htmlContent += @"
        </tbody>
    </table>
</body>
</html>
"@

# Save the HTML file
$htmlContent | Out-File -FilePath $htmlPath -Encoding UTF8

Write-Host "HTML file generated at $htmlPath" -ForegroundColor Green