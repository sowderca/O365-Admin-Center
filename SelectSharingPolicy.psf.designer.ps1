[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formSharingPolicies = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelSharingPolicies = $null
[System.Windows.Forms.ComboBox]$comboboxSharingPolicies = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelSharingPolicies = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSharingPolicies = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formSharingPolicies.SuspendLayout()

$labelSharingPolicies.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSharingPolicies.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 67) 
$labelSharingPolicies.Name = 'labelSharingPolicies' 
$labelSharingPolicies.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(142, 29) 
$labelSharingPolicies.TabIndex = 18 
$labelSharingPolicies.Text = 'Sharing Policies:' 
$comboboxSharingPolicies.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSharingPolicies.FormattingEnabled = $True 
$comboboxSharingPolicies.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(160, 67) 
$comboboxSharingPolicies.Name = 'comboboxSharingPolicies' 
$comboboxSharingPolicies.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(466, 29) 
$comboboxSharingPolicies.Sorted = $True 
$comboboxSharingPolicies.TabIndex = 17 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(145, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 20 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelInstructions.TabIndex = 19 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(376, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 16 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formSharingPolicies.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formSharingPolicies.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formSharingPolicies.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formSharingPolicies.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formSharingPolicies.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formSharingPolicies.Name = 'formSharingPolicies' 
$formSharingPolicies.Text = 'Sharing Policies' 
$formSharingPolicies.add_Load($formSharingPolicies_Load)
$formSharingPolicies.Controls.Add($labelSharingPolicies)
$formSharingPolicies.Controls.Add($comboboxSharingPolicies)
$formSharingPolicies.Controls.Add($buttonCancel)
$formSharingPolicies.Controls.Add($LabelInstructions)
$formSharingPolicies.Controls.Add($buttonOK)
$formSharingPolicies.ResumeLayout($false) 
}
. InitializeComponent
