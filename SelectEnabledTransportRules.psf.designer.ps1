[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formTransportRules = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelTransportRules = $null
[System.Windows.Forms.ComboBox]$comboboxTPs = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$labelSelectTransportRules = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelTransportRules = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxTPs = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectTransportRules = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formTransportRules.SuspendLayout()

$labelTransportRules.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelTransportRules.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 66) 
$labelTransportRules.Name = 'labelTransportRules' 
$labelTransportRules.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(144, 28) 
$labelTransportRules.TabIndex = 33 
$labelTransportRules.Text = 'Transport Rules:' 
$comboboxTPs.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxTPs.FormattingEnabled = $True 
$comboboxTPs.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(162, 66) 
$comboboxTPs.Name = 'comboboxTPs' 
$comboboxTPs.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(464, 29) 
$comboboxTPs.Sorted = $True 
$comboboxTPs.TabIndex = 32 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(146, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 31 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$labelSelectTransportRules.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectTransportRules.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 8) 
$labelSelectTransportRules.Name = 'labelSelectTransportRules' 
$labelSelectTransportRules.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectTransportRules.TabIndex = 34 
$labelSelectTransportRules.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(381, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 30 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formTransportRules.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formTransportRules.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formTransportRules.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formTransportRules.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formTransportRules.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formTransportRules.Name = 'formTransportRules' 
$formTransportRules.Text = 'Transport Rules' 
$formTransportRules.add_Load($formTransportRules_Load)
$formTransportRules.Controls.Add($labelTransportRules)
$formTransportRules.Controls.Add($comboboxTPs)
$formTransportRules.Controls.Add($buttonCancel)
$formTransportRules.Controls.Add($labelSelectTransportRules)
$formTransportRules.Controls.Add($buttonOK)
$formTransportRules.ResumeLayout($false) 
}
. InitializeComponent
