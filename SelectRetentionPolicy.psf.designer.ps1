[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formRetentionPolicies = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelRetentionPolicies = $null
[System.Windows.Forms.ComboBox]$comboboxRetentionPolicies = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelRetentionPolicies = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxRetentionPolicies = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formRetentionPolicies.SuspendLayout()

$labelRetentionPolicies.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelRetentionPolicies.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 68) 
$labelRetentionPolicies.Name = 'labelRetentionPolicies' 
$labelRetentionPolicies.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(158, 29) 
$labelRetentionPolicies.TabIndex = 28 
$labelRetentionPolicies.Text = 'Retention Policies:' 
$comboboxRetentionPolicies.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxRetentionPolicies.FormattingEnabled = $True 
$comboboxRetentionPolicies.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(176, 68) 
$comboboxRetentionPolicies.Name = 'comboboxRetentionPolicies' 
$comboboxRetentionPolicies.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(450, 29) 
$comboboxRetentionPolicies.Sorted = $True 
$comboboxRetentionPolicies.TabIndex = 27 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(148, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 30 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelInstructions.TabIndex = 29 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(380, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 26 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formRetentionPolicies.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formRetentionPolicies.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formRetentionPolicies.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formRetentionPolicies.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formRetentionPolicies.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formRetentionPolicies.Name = 'formRetentionPolicies' 
$formRetentionPolicies.Text = 'Retention Policies' 
$formRetentionPolicies.add_Load($formRetentionPolicies_Load)
$formRetentionPolicies.Controls.Add($labelRetentionPolicies)
$formRetentionPolicies.Controls.Add($comboboxRetentionPolicies)
$formRetentionPolicies.Controls.Add($buttonCancel)
$formRetentionPolicies.Controls.Add($LabelInstructions)
$formRetentionPolicies.Controls.Add($buttonOK)
$formRetentionPolicies.ResumeLayout($false) 
}
. InitializeComponent
