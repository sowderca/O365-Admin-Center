[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formPublicFolders = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelPF = $null
[System.Windows.Forms.ComboBox]$comboboxPF = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelPF = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxPF = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formPublicFolders.SuspendLayout()

$labelPF.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelPF.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(7, 66) 
$labelPF.Name = 'labelPF' 
$labelPF.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(137, 29) 
$labelPF.TabIndex = 18 
$labelPF.Text = 'Public Folders:' 
$comboboxPF.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxPF.FormattingEnabled = $True 
$comboboxPF.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(150, 66) 
$comboboxPF.Name = 'comboboxPF' 
$comboboxPF.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(476, 29) 
$comboboxPF.Sorted = $True 
$comboboxPF.TabIndex = 17 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(177, 114) 
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
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(380, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 16 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formPublicFolders.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formPublicFolders.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formPublicFolders.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formPublicFolders.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formPublicFolders.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formPublicFolders.Name = 'formPublicFolders' 
$formPublicFolders.Text = 'Public Folders' 
$formPublicFolders.add_Load($formPublicFolders_Load)
$formPublicFolders.Controls.Add($labelPF)
$formPublicFolders.Controls.Add($comboboxPF)
$formPublicFolders.Controls.Add($buttonCancel)
$formPublicFolders.Controls.Add($LabelInstructions)
$formPublicFolders.Controls.Add($buttonOK)
$formPublicFolders.ResumeLayout($false) 
}
. InitializeComponent
