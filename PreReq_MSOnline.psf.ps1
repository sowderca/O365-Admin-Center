
$form_prereqMSonline_Load = {
	
}



$buttonYes_Click = {
	
	Start-Process https://www.microsoft.com/en-us/download/details.aspx?id=41950
}

$buttonDontAsk_Click = {
	
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 1 -Force | Out-Null
	$form_prereqMSonline.close()
	
}

. (Join-Path $PSScriptRoot 'PreReq_MSOnline.psf.designer.ps1')
$form_prereqMSonline.ShowDialog()
