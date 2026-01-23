# \\\\ServerName\\ShareName\\FolderPath
param(
    [Parameter(Mandatory=$true)]
    [string] $ServersFilePath
)

# Create an array to store the results
$Results = @()

# Read the list of servers and loop through them
foreach ($ServerFilePath in (Get-Content $ServersFilePath)) {
    $Server = $ServerFilePath -split '\\' | Where-Object { $_ } | Select-Object -First 1
    Write-Host "Checking directory size on $Server..." -ForegroundColor Cyan
    
    try {
        # Use Invoke-Command to run a script block on the remote server
        $SizeInBytes = Invoke-Command -ComputerName $Server -ScriptBlock {
            param($Path)
            # Get all files recursively and measure the total length (size)
            $items = Get-ChildItem -Path $Path -File -Recurse -Force -ErrorAction SilentlyContinue
            ($items | Measure-Object -Property Length -Sum).Sum
        } -ArgumentList $ServerFilePath -ErrorAction Stop

        # Convert the size from Bytes to Gigabytes and format it
        if ($SizeInBytes -eq $null) {
            $SizeFormatted = "N/A or Access Denied"
        } else {
            $SizeGB = [math]::Round($SizeInBytes / 1GB, 3)
            $SizeFormatted = "$SizeGB GB"
        }

        # Create a custom object for the result
        $ResultObject = [PSCustomObject]@{
            #ServerName  = $Server
            Directory   = $ServerFilePath
            Size        = $SizeFormatted
            #SizeInBytes = $SizeInBytes # Optional: keep original bytes for sorting/processing
        }
        
        # Add the result to the collection
        $Results += $ResultObject

    }
    catch {
        Write-Host "Error connecting to $Server or accessing path: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Display the results in a grid view and export to a CSV file
$Results | Out-GridView -Title "Remote Directory Sizes"
$Results | Export-Csv -Path "C:\Temp\DirectorySizesReport.csv" -NoTypeInformation
