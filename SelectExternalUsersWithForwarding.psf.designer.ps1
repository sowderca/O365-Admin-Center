[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formExternalForwardingUs = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelUsers = $null
[System.Windows.Forms.ComboBox]$comboboxUsersWithForwarding = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxUsersWithForwarding = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formExternalForwardingUs.SuspendLayout()

$labelUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 67) 
$labelUsers.Name = 'labelUsers' 
$labelUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(97, 29) 
$labelUsers.TabIndex = 8 
$labelUsers.Text = 'Users:' 
$comboboxUsersWithForwarding.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxUsersWithForwarding.FormattingEnabled = $True 
$comboboxUsersWithForwarding.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(115, 67) 
$comboboxUsersWithForwarding.Name = 'comboboxUsersWithForwarding' 
$comboboxUsersWithForwarding.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(511, 29) 
$comboboxUsersWithForwarding.Sorted = $True 
$comboboxUsersWithForwarding.TabIndex = 7 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(138, 114) 
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
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(342, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 6 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formExternalForwardingUs.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formExternalForwardingUs.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formExternalForwardingUs.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formExternalForwardingUs.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formExternalForwardingUs.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formExternalForwardingUs.Name = 'formExternalForwardingUs' 
$formExternalForwardingUs.Text = 'External Forwarding Users' 
$formExternalForwardingUs.add_Load($formExternalForwardingUs_Load)
$formExternalForwardingUs.Controls.Add($labelUsers)
$formExternalForwardingUs.Controls.Add($comboboxUsersWithForwarding)
$formExternalForwardingUs.Controls.Add($buttonCancel)
$formExternalForwardingUs.Controls.Add($LabelInstructions)
$formExternalForwardingUs.Controls.Add($buttonOK)
$formExternalForwardingUs.ResumeLayout($false) 
}
. InitializeComponent
