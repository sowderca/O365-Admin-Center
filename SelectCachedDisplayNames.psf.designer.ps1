[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formSelectUser = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelUsers = $null
[System.Windows.Forms.ComboBox]$comboboxNames = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxNames = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formSelectUser.SuspendLayout()

$labelUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 62) 
$labelUsers.Name = 'labelUsers' 
$labelUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(74, 29) 
$labelUsers.TabIndex = 18 
$labelUsers.Text = 'Users:' 
$comboboxNames.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxNames.FormattingEnabled = $True 
$comboboxNames.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(92, 62) 
$comboboxNames.Name = 'comboboxNames' 
$comboboxNames.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(534, 29) 
$comboboxNames.Sorted = $True 
$comboboxNames.TabIndex = 17 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(162, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 16 
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
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(373, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 15 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formSelectUser.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formSelectUser.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formSelectUser.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formSelectUser.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formSelectUser.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formSelectUser.Name = 'formSelectUser' 
$formSelectUser.Text = 'Select User' 
$formSelectUser.add_Load($formSelectUser_Load)
$formSelectUser.Controls.Add($labelUsers)
$formSelectUser.Controls.Add($comboboxNames)
$formSelectUser.Controls.Add($buttonCancel)
$formSelectUser.Controls.Add($LabelInstructions)
$formSelectUser.Controls.Add($buttonOK)
$formSelectUser.ResumeLayout($false) 
}
. InitializeComponent
