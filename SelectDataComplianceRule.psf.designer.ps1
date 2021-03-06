[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formComplianceRules = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelRules = $null
[System.Windows.Forms.ComboBox]$comboboxDLC = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelRules = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxDLC = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formComplianceRules.SuspendLayout()

$labelRules.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelRules.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 63) 
$labelRules.Name = 'labelRules' 
$labelRules.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(95, 29) 
$labelRules.TabIndex = 13 
$labelRules.Text = 'Rules:' 
$comboboxDLC.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxDLC.FormattingEnabled = $True 
$comboboxDLC.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(113, 63) 
$comboboxDLC.Name = 'comboboxDLC' 
$comboboxDLC.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(513, 29) 
$comboboxDLC.Sorted = $True 
$comboboxDLC.TabIndex = 12 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(131, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 15 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelInstructions.TabIndex = 14 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(342, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 11 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formComplianceRules.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formComplianceRules.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formComplianceRules.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formComplianceRules.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formComplianceRules.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formComplianceRules.Name = 'formComplianceRules' 
$formComplianceRules.Text = 'Compliance Rules' 
$formComplianceRules.add_Load($formComplianceRules_Load)
$formComplianceRules.Controls.Add($labelRules)
$formComplianceRules.Controls.Add($comboboxDLC)
$formComplianceRules.Controls.Add($buttonCancel)
$formComplianceRules.Controls.Add($LabelInstructions)
$formComplianceRules.Controls.Add($buttonOK)
$formComplianceRules.ResumeLayout($false) 
}
. InitializeComponent
