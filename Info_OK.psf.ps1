
$formInformation_Load={
	$labelInformation.Text = $InformationText 
	
}

. (Join-Path $PSScriptRoot 'Info_OK.psf.designer.ps1')
$formInformation.ShowDialog()
