
$PreReq_Azure_Load={
	
}

$labelAzure_Click={
	
}

$buttonYes_Click = {
	
	Start-Process -FilePath http://go.microsoft.com/fwlink/p/?linkid=236297
	
}

$buttonDontAsk_Click = {
	
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 1 -Force | Out-Null
	$PreReq_Azure.close()
}

. (Join-Path $PSScriptRoot 'PreReq_Azure.psf.designer.ps1')
$PreReq_Azure.ShowDialog()
