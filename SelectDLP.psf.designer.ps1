[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formDataLossPreventionPo = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelPolicies = $null
[System.Windows.Forms.ComboBox]$comboboxDLP = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelPolicies = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxDLP = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formDataLossPreventionPo.SuspendLayout()

$labelPolicies.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelPolicies.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 66) 
$labelPolicies.Name = 'labelPolicies' 
$labelPolicies.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(77, 29) 
$labelPolicies.TabIndex = 8 
$labelPolicies.Text = 'Policies:' 
$comboboxDLP.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxDLP.FormattingEnabled = $True 
$comboboxDLP.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(95, 66) 
$comboboxDLP.Name = 'comboboxDLP' 
$comboboxDLP.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(531, 29) 
$comboboxDLP.Sorted = $True 
$comboboxDLP.TabIndex = 7 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(151, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 10 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelInstructions.TabIndex = 9 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(367, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 6 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formDataLossPreventionPo.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formDataLossPreventionPo.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formDataLossPreventionPo.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formDataLossPreventionPo.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formDataLossPreventionPo.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formDataLossPreventionPo.Name = 'formDataLossPreventionPo' 
$formDataLossPreventionPo.Text = 'Data Loss Prevention Policies' 
$formDataLossPreventionPo.add_Load($formDataLossPreventionPo_Load)
$formDataLossPreventionPo.Controls.Add($labelPolicies)
$formDataLossPreventionPo.Controls.Add($comboboxDLP)
$formDataLossPreventionPo.Controls.Add($buttonCancel)
$formDataLossPreventionPo.Controls.Add($LabelInstructions)
$formDataLossPreventionPo.Controls.Add($buttonOK)
$formDataLossPreventionPo.ResumeLayout($false) 
}
. InitializeComponent
