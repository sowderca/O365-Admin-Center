[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formAccessType = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelAccessType = $null
[System.Windows.Forms.ComboBox]$comboboxAccessType = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelAccessType = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxAccessType = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formAccessType.SuspendLayout()

$labelAccessType.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelAccessType.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 69) 
$labelAccessType.Name = 'labelAccessType' 
$labelAccessType.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 29) 
$labelAccessType.TabIndex = 33 
$labelAccessType.Text = 'Access Type:' 
$comboboxAccessType.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxAccessType.FormattingEnabled = $True 
$comboboxAccessType.Items = New-Object -TypeName 'System.Windows.Forms.ComboBox+ObjectCollection' -ArgumentList @(PrivatePublic) 
$comboboxAccessType.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(136, 69) 
$comboboxAccessType.Name = 'comboboxAccessType' 
$comboboxAccessType.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(481, 29) 
$comboboxAccessType.Sorted = $True 
$comboboxAccessType.TabIndex = 32 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(146, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 35 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(605, 45) 
$LabelInstructions.TabIndex = 34 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(359, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 31 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formAccessType.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formAccessType.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formAccessType.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formAccessType.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formAccessType.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formAccessType.Name = 'formAccessType' 
$formAccessType.Text = 'Access Type' 
$formAccessType.add_Load($formAccessType_Load)
$formAccessType.Controls.Add($labelAccessType)
$formAccessType.Controls.Add($comboboxAccessType)
$formAccessType.Controls.Add($buttonCancel)
$formAccessType.Controls.Add($LabelInstructions)
$formAccessType.Controls.Add($buttonOK)
$formAccessType.ResumeLayout($false) 
}
. InitializeComponent
