[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formAllEmailAddresses = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelAllEmailAddresses = $null
[System.Windows.Forms.ComboBox]$comboboxSelectAllEmailAddresses = $null
[System.Windows.Forms.Button]$buttonCancelformAllEmailAddresses = $null
[System.Windows.Forms.Label]$labelSelectAllEmailAddresses = $null
[System.Windows.Forms.Button]$buttonformAllEmailAddresses = $null
function InitializeComponent {

$labelAllEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectAllEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformAllEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectAllEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformAllEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.Button')
$formAllEmailAddresses.SuspendLayout()

$labelAllEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelAllEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 70) 
$labelAllEmailAddresses.Name = 'labelAllEmailAddresses' 
$labelAllEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(74, 29) 
$labelAllEmailAddresses.TabIndex = 20 
$labelAllEmailAddresses.Text = 'Email Addresses:' 
$comboboxSelectAllEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectAllEmailAddresses.FormattingEnabled = $True 
$comboboxSelectAllEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(92, 67) 
$comboboxSelectAllEmailAddresses.Name = 'comboboxSelectAllEmailAddresses' 
$comboboxSelectAllEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(534, 29) 
$comboboxSelectAllEmailAddresses.Sorted = $True 
$comboboxSelectAllEmailAddresses.TabIndex = 18 
$buttonCancelformAllEmailAddresses.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformAllEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformAllEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(151, 114) 
$buttonCancelformAllEmailAddresses.Name = 'buttonCancelformAllEmailAddresses' 
$buttonCancelformAllEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformAllEmailAddresses.TabIndex = 21 
$buttonCancelformAllEmailAddresses.Text = '&Cancel' 
$buttonCancelformAllEmailAddresses.UseVisualStyleBackColor = $True 
$labelSelectAllEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectAllEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectAllEmailAddresses.Name = 'labelSelectAllEmailAddresses' 
$labelSelectAllEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 47) 
$labelSelectAllEmailAddresses.TabIndex = 19 
$labelSelectAllEmailAddresses.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformAllEmailAddresses.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformAllEmailAddresses.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformAllEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformAllEmailAddresses.ForeColor = [System.Drawing.Color]::Black 
$buttonformAllEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(388, 114) 
$buttonformAllEmailAddresses.Name = 'buttonformAllEmailAddresses' 
$buttonformAllEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformAllEmailAddresses.TabIndex = 17 
$buttonformAllEmailAddresses.Text = '&OK' 
$buttonformAllEmailAddresses.UseVisualStyleBackColor = $True 
$formAllEmailAddresses.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formAllEmailAddresses.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formAllEmailAddresses.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formAllEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formAllEmailAddresses.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formAllEmailAddresses.Name = 'formAllEmailAddresses' 
$formAllEmailAddresses.Text = 'Email Addresses' 
$formAllEmailAddresses.add_Load($formAllEmailAddresses_Load)
$formAllEmailAddresses.Controls.Add($labelAllEmailAddresses)
$formAllEmailAddresses.Controls.Add($comboboxSelectAllEmailAddresses)
$formAllEmailAddresses.Controls.Add($buttonCancelformAllEmailAddresses)
$formAllEmailAddresses.Controls.Add($labelSelectAllEmailAddresses)
$formAllEmailAddresses.Controls.Add($buttonformAllEmailAddresses)
$formAllEmailAddresses.ResumeLayout($false) 
}
. InitializeComponent
