
$ArchType_Load={
	
}

$buttonDontAsk_Click = {
	
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableArchPrompt -Value 1 -Force | Out-Null
	$ArchType.Close()
}

. (Join-Path $PSScriptRoot 'PreReq_ArchType.psf.designer.ps1')
$ArchType.ShowDialog()
