[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formSelectUsertxt = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$label1 = $null
[System.Windows.Forms.ComboBox]$comboboxUPN = $null
[System.Windows.Forms.Button]$button1 = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
[System.Windows.Forms.Label]$labelUsers = $null
[System.Windows.Forms.Button]$buttonCancel = $null
function InitializeComponent {

$label1 = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxUPN = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$button1 = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$formSelectUsertxt.SuspendLayout()

$label1.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$label1.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(7, 64) 
$label1.Name = 'label1' 
$label1.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(75, 29) 
$label1.TabIndex = 13 
$label1.Text = 'Users:' 
$comboboxUPN.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxUPN.FormattingEnabled = $True 
$comboboxUPN.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(88, 64) 
$comboboxUPN.Name = 'comboboxUPN' 
$comboboxUPN.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(538, 29) 
$comboboxUPN.Sorted = $True 
$comboboxUPN.TabIndex = 12 
$button1.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$button1.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$button1.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(131, 114) 
$button1.Name = 'button1' 
$button1.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$button1.TabIndex = 1 
$button1.Text = '&Cancel' 
$button1.UseVisualStyleBackColor = $True 
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
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(332, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 0 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$labelUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Microsoft Sans Serif',  9) 
$labelUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(-86, 118) 
$labelUsers.Name = 'labelUsers' 
$labelUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(47, 21) 
$labelUsers.TabIndex = 8 
$labelUsers.Text = 'Users:' 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(26, 160) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(103, 23) 
$buttonCancel.TabIndex = 10 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$formSelectUsertxt.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formSelectUsertxt.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formSelectUsertxt.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formSelectUsertxt.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formSelectUsertxt.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formSelectUsertxt.Name = 'formSelectUsertxt' 
$formSelectUsertxt.Text = 'Select User' 
$formSelectUsertxt.add_Load($formSelectUsertxt_Load)
$formSelectUsertxt.Controls.Add($label1)
$formSelectUsertxt.Controls.Add($comboboxUPN)
$formSelectUsertxt.Controls.Add($button1)
$formSelectUsertxt.Controls.Add($LabelInstructions)
$formSelectUsertxt.Controls.Add($buttonOK)
$formSelectUsertxt.Controls.Add($labelUsers)
$formSelectUsertxt.Controls.Add($buttonCancel)
$formSelectUsertxt.ResumeLayout($false) 
}
. InitializeComponent
