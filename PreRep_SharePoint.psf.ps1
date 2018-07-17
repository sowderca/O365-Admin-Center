
$formERRORSharePoint_Load={
	
}

$buttonDontAsk_Click = {
	
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 1 -Force | Out-Null
	
}

$buttonYes_Click={
	
	Start-Process -FilePath https://www.microsoft.com/en-us/download/confirmation.aspx?id=35588
	$formERRORSharePoint.Close()
	
}

. (Join-Path $PSScriptRoot 'PreRep_SharePoint.psf.designer.ps1')
$formERRORSharePoint.ShowDialog()
