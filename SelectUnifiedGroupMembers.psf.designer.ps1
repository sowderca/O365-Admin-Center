[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formGroupMembers = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelUsers = $null
[System.Windows.Forms.ComboBox]$comboboxUnifiedGroupMembers = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxUnifiedGroupMembers = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formGroupMembers.SuspendLayout()

$labelUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 70) 
$labelUsers.Name = 'labelUsers' 
$labelUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(76, 29) 
$labelUsers.TabIndex = 13 
$labelUsers.Text = 'Users:' 
$comboboxUnifiedGroupMembers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxUnifiedGroupMembers.FormattingEnabled = $True 
$comboboxUnifiedGroupMembers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(94, 70) 
$comboboxUnifiedGroupMembers.Name = 'comboboxUnifiedGroupMembers' 
$comboboxUnifiedGroupMembers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(532, 29) 
$comboboxUnifiedGroupMembers.Sorted = $True 
$comboboxUnifiedGroupMembers.TabIndex = 12 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(158, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 15 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelInstructions.TabIndex = 14 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(401, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 11 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formGroupMembers.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formGroupMembers.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formGroupMembers.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formGroupMembers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formGroupMembers.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formGroupMembers.Name = 'formGroupMembers' 
$formGroupMembers.Text = 'Group Members' 
$formGroupMembers.add_Load($formGroupMembers_Load)
$formGroupMembers.Controls.Add($labelUsers)
$formGroupMembers.Controls.Add($comboboxUnifiedGroupMembers)
$formGroupMembers.Controls.Add($buttonCancel)
$formGroupMembers.Controls.Add($LabelInstructions)
$formGroupMembers.Controls.Add($buttonOK)
$formGroupMembers.ResumeLayout($false) 
}
. InitializeComponent
