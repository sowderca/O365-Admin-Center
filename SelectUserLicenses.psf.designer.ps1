[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formCurrentLicenses = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelCurrentLicense = $null
[System.Windows.Forms.ComboBox]$comboboxSelectCurrentLicense = $null
[System.Windows.Forms.Button]$buttonCancelformCurrentLicense = $null
[System.Windows.Forms.Label]$labelSelectCurrentLicenses = $null
[System.Windows.Forms.Button]$buttonformCurrentLicense = $null
function InitializeComponent {

$labelCurrentLicense = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectCurrentLicense = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformCurrentLicense = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectCurrentLicenses = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformCurrentLicense = (New-Object -TypeName 'System.Windows.Forms.Button')
$formCurrentLicenses.SuspendLayout()

$labelCurrentLicense.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelCurrentLicense.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 69) 
$labelCurrentLicense.Name = 'labelCurrentLicense' 
$labelCurrentLicense.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(105, 29) 
$labelCurrentLicense.TabIndex = 20 
$labelCurrentLicense.Text = 'Licenses:' 
$comboboxSelectCurrentLicense.FormattingEnabled = $True 
$comboboxSelectCurrentLicense.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(123, 69) 
$comboboxSelectCurrentLicense.Name = 'comboboxSelectCurrentLicense' 
$comboboxSelectCurrentLicense.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(503, 29) 
$comboboxSelectCurrentLicense.Sorted = $True 
$comboboxSelectCurrentLicense.TabIndex = 18 
$buttonCancelformCurrentLicense.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformCurrentLicense.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformCurrentLicense.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(145, 114) 
$buttonCancelformCurrentLicense.Name = 'buttonCancelformCurrentLicense' 
$buttonCancelformCurrentLicense.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformCurrentLicense.TabIndex = 21 
$buttonCancelformCurrentLicense.Text = '&Cancel' 
$buttonCancelformCurrentLicense.UseVisualStyleBackColor = $True 
$labelSelectCurrentLicenses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectCurrentLicenses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(15, 9) 
$labelSelectCurrentLicenses.Name = 'labelSelectCurrentLicenses' 
$labelSelectCurrentLicenses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(611, 45) 
$labelSelectCurrentLicenses.TabIndex = 19 
$buttonformCurrentLicense.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformCurrentLicense.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformCurrentLicense.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformCurrentLicense.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(365, 114) 
$buttonformCurrentLicense.Name = 'buttonformCurrentLicense' 
$buttonformCurrentLicense.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformCurrentLicense.TabIndex = 17 
$buttonformCurrentLicense.Text = '&OK' 
$buttonformCurrentLicense.UseVisualStyleBackColor = $True 
$formCurrentLicenses.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formCurrentLicenses.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formCurrentLicenses.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formCurrentLicenses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$formCurrentLicenses.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formCurrentLicenses.Name = 'formCurrentLicenses' 
$formCurrentLicenses.Text = 'Licenses' 
$formCurrentLicenses.add_Load($formCurrentLicenses_Load)
$formCurrentLicenses.Controls.Add($labelCurrentLicense)
$formCurrentLicenses.Controls.Add($comboboxSelectCurrentLicense)
$formCurrentLicenses.Controls.Add($buttonCancelformCurrentLicense)
$formCurrentLicenses.Controls.Add($labelSelectCurrentLicenses)
$formCurrentLicenses.Controls.Add($buttonformCurrentLicense)
$formCurrentLicenses.ResumeLayout($false) 
}
. InitializeComponent
