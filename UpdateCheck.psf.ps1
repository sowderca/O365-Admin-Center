
$UpdateCheck_Load = {
	$PublicVersion = Invoke-WebRequest -Uri https://www.o365admin.center/update.txt | Select-Object -ExpandProperty content
	$labelUpdateCheck.Text = "Update Available! Version $PublicVersion is now available, would you like to download it?"
	
}

$buttonYes_Click = {
	#Trial
	#Start-Process -FilePath "https://www.o365admin.center"
	
	#Standard
	#Start-Process -FilePath https://www.o365admin.center/Paid/O365AdminCenter.zip
	#Start-Process -FilePath "https://www.o365admin.center/Paid/O365_Admin_Center_Standard.msi"
	#Start-Process -FilePath "https://www.o365admin.center/Paid/O365_Admin_Center_Standard.exe"
	
	#PREMIUM
	Start-Process -FilePath https://www.o365admin.center/Paid/Support/O365AdminCenterPremium.zip
	#Start-Process -FilePath "https://www.o365admin.center/Paid/Support/O365_Admin_Center_Premium.msi"
	#Start-Process -FilePath "https://www.o365admin.center/Paid/Support/O365_Admin_Center_Premium.exe" 
	
}

$buttonNo_Click={
	
	
}

$buttonDontAsk_Click={
	Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name UpdateCheck -Value 1 -Force | Out-Null
	
}

. (Join-Path $PSScriptRoot 'UpdateCheck.psf.designer.ps1')
$UpdateCheck.ShowDialog()
