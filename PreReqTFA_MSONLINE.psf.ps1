
$FormPreReqTFA_MSOLINE_Load={
	#TODO: Initialize Form Controls here
	
}

$buttonYes_Click={
	Start-Process -FilePath http://connect.microsoft.com/site1164/Downloads/DownloadDetails.aspx?DownloadID=59185
	
}

$buttonDontAsk_Click={
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlineTFA -Value 1 -Force | Out-Null
	$FormPreReqTFA_MSOLINE.close()
	
}

. (Join-Path $PSScriptRoot 'PreReqTFA_MSONLINE.psf.designer.ps1')
$FormPreReqTFA_MSOLINE.ShowDialog()
