
$formCachedCreds_Load={
	#TODO: Initialize Form Controls here
	
}

$buttonYes_Click = {
	$TempDir = $env:temp
	$O365AdminTempFolderCreds = ("$TempDir" + "\O365AdminCenter_Creds")
	#Create temporary directory
	[system.io.directory]::CreateDirectory("$O365AdminTempFolderCreds")
	$global:o365credentials | Export-Clixml -path $O365AdminTempFolderCreds\Creds.xml -Force
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name CredMem -Value 1 -Force | Out-Null
	
}

$buttonNo_Click={
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name CredMem -Value 0 -Force | Out-Null
	
}

$buttonDontAsk_Click={
	Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name CredMem -Value 2 -Force | Out-Null
	
}

. (Join-Path $PSScriptRoot 'CachedCreds.psf.designer.ps1')
$formCachedCreds.ShowDialog()
