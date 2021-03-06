[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formSelectUser = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelUsers = $null
[System.Windows.Forms.ComboBox]$comboboxUsers = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
[System.Windows.Forms.FontDialog]$fontdialog1 = $null
function InitializeComponent {

$labelUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxUsers = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$fontdialog1 = (New-Object -TypeName 'System.Windows.Forms.FontDialog')
$formSelectUser.SuspendLayout()

$labelUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 64) 
$labelUsers.Name = 'labelUsers' 
$labelUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(70, 29) 
$labelUsers.TabIndex = 2 
$labelUsers.Text = 'Users:' 
$comboboxUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxUsers.FormattingEnabled = $True 
$comboboxUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(88, 64) 
$comboboxUsers.Name = 'comboboxUsers' 
$comboboxUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(538, 29) 
$comboboxUsers.Sorted = $True 
$comboboxUsers.TabIndex = 1 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(174, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 5 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelInstructions.TabIndex = 3 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(351, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 0 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$buttonOK.add_Click($buttonOK_Click)
$formSelectUser.AcceptButton = $buttonOK 
$formSelectUser.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formSelectUser.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formSelectUser.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formSelectUser.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formSelectUser.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formSelectUser.MaximizeBox = $False 
$formSelectUser.MinimizeBox = $False 
$formSelectUser.Name = 'formSelectUser' 
$formSelectUser.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen 
$formSelectUser.Text = 'Select User' 
$formSelectUser.add_Load($formSelectUser_Load)
$formSelectUser.Controls.Add($labelUsers)
$formSelectUser.Controls.Add($comboboxUsers)
$formSelectUser.Controls.Add($buttonCancel)
$formSelectUser.Controls.Add($LabelInstructions)
$formSelectUser.Controls.Add($buttonOK)
$formSelectUser.ResumeLayout($false) 
}
. InitializeComponent
