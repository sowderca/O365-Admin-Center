
$formDatePicker_Load={
	$labelStartDate.text = $StartDateText
	$formDatePicker.Text = $StartDateFormText
}


$buttonformStartDate_Click={

}


. (Join-Path $PSScriptRoot 'SelectDatePicker.psf.designer.ps1')
$formDatePicker.ShowDialog()
