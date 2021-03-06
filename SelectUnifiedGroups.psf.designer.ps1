[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formUnifiedGroups = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelGroups = $null
[System.Windows.Forms.ComboBox]$comboboxUnifiedGroups = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelGroups = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxUnifiedGroups = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formUnifiedGroups.SuspendLayout()

$labelGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 67) 
$labelGroups.Name = 'labelGroups' 
$labelGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(80, 29) 
$labelGroups.TabIndex = 18 
$labelGroups.Text = 'Groups:' 
$comboboxUnifiedGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxUnifiedGroups.FormattingEnabled = $True 
$comboboxUnifiedGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(98, 67) 
$comboboxUnifiedGroups.Name = 'comboboxUnifiedGroups' 
$comboboxUnifiedGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(528, 29) 
$comboboxUnifiedGroups.Sorted = $True 
$comboboxUnifiedGroups.TabIndex = 17 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(136, 114) 
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
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(367, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 16 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formUnifiedGroups.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formUnifiedGroups.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formUnifiedGroups.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formUnifiedGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formUnifiedGroups.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formUnifiedGroups.Name = 'formUnifiedGroups' 
$formUnifiedGroups.Text = 'Unified Groups' 
$formUnifiedGroups.add_Load($formUnifiedGroups_Load)
$formUnifiedGroups.Controls.Add($labelGroups)
$formUnifiedGroups.Controls.Add($comboboxUnifiedGroups)
$formUnifiedGroups.Controls.Add($buttonCancel)
$formUnifiedGroups.Controls.Add($LabelInstructions)
$formUnifiedGroups.Controls.Add($buttonOK)
$formUnifiedGroups.ResumeLayout($false) 
}
. InitializeComponent
