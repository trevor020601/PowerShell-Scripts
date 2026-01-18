param(
    [Parameter(Mandatory=$true)]
    [string] $CertificatePath,
	[Parameter(Mandatory=$true)]
	[int] $DaysToExpiration
)

$ExpirationDate = (Get-Date).AddDays($DaysToExpiration)

Get-ChildItem -Path $CertificatePath -Recurse | 
    Where-Object { $_.NotAfter -lt $ExpirationDate } | 
    Select-Object Subject, Issuer, NotAfter, FriendlyName, @{
        Label = "Expires In (Days)"; 
        Expression = { ($_.NotAfter - (Get-Date)).Days }
    } | Format-Table -AutoSize
