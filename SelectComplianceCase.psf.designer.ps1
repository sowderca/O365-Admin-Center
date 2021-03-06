[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formComplianceCases = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelCases = $null
[System.Windows.Forms.ComboBox]$comboboxComplianceCases = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelCases = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxComplianceCases = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formComplianceCases.SuspendLayout()

$labelCases.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelCases.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 66) 
$labelCases.Name = 'labelCases' 
$labelCases.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(85, 29) 
$labelCases.TabIndex = 18 
$labelCases.Text = 'Cases:' 
$comboboxComplianceCases.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxComplianceCases.FormattingEnabled = $True 
$comboboxComplianceCases.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(113, 66) 
$comboboxComplianceCases.Name = 'comboboxComplianceCases' 
$comboboxComplianceCases.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(513, 29) 
$comboboxComplianceCases.Sorted = $True 
$comboboxComplianceCases.TabIndex = 17 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(140, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 20 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelInstructions.TabIndex = 19 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(337, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 16 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formComplianceCases.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formComplianceCases.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formComplianceCases.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formComplianceCases.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formComplianceCases.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formComplianceCases.Name = 'formComplianceCases' 
$formComplianceCases.Text = 'Compliance Cases' 
$formComplianceCases.add_Load($formComplianceCases_Load)
$formComplianceCases.Controls.Add($labelCases)
$formComplianceCases.Controls.Add($comboboxComplianceCases)
$formComplianceCases.Controls.Add($buttonCancel)
$formComplianceCases.Controls.Add($LabelInstructions)
$formComplianceCases.Controls.Add($buttonOK)
$formComplianceCases.ResumeLayout($false) 
}
. InitializeComponent
