
$formExecutionPolicy_Load={
	
	
}

$buttonDontAsk_Click={
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name ExecutionPolicy -Value 1 -Force | Out-Null
	
}

$buttonOK_Click={
	
}

. (Join-Path $PSScriptRoot 'SelecPreReqExecutionPolicy.psf.designer.ps1')
$formExecutionPolicy.ShowDialog()
