
$PreReq_S4B_Load={
	#TODO: Initialize Form Controls here
	
}

$buttonYes_Click={
	Start-Process -FilePath https://www.microsoft.com/en-us/download/confirmation.aspx?id=39366
	
}

$buttonDontAsk_Click = {
	
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSkypeOnlineConnectorPrompt -Value 1 -Force | Out-Null
	
}

. (Join-Path $PSScriptRoot 'PreReq_SkypeForBusiness.psf.designer.ps1')
$PreReq_S4B.ShowDialog()
