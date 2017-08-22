param(
    [string]
    $Folder,

    [string]
    $ResultsType = "nunit3"
)

$Url = "https://ci.appveyor.com/api/testresults/$ResultsType/$($env:APPVEYOR_JOB_ID)"

if(-Not (Test-Path $Folder))
{
    Write-Host "Directory '$Folder' not found"
    exit(1)
}

# upload results to AppVeyor
foreach($ResultsFile in (Get-ChildItem '.' -File -Recurse).FullName)
{
	try
	{
		$wc = New-Object 'System.Net.WebClient'
		$wc.UploadFile($Url, $ResultsFile)
		Write-Host "Tests result file $ResultsFile uploaded correctly"
	}
	catch
	{
		Write-Host "Error uploading file $ResultsFile to $Url"
		$Exception = $_.Exception
		
		while($null -ne $Exception)
		{
			Write-Host "Error: $($Exception.Message)"
			$Exception = $Exception.InnerException
		}
		
		exit(2)
	}
}
