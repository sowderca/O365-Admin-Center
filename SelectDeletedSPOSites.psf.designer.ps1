[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formDeletedSharePointSit = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelSites = $null
[System.Windows.Forms.ComboBox]$comboboxDeletedSites = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelDeletedSites = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelSites = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxDeletedSites = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelDeletedSites = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formDeletedSharePointSit.SuspendLayout()

$labelSites.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSites.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 68) 
$labelSites.Name = 'labelSites' 
$labelSites.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(57, 29) 
$labelSites.TabIndex = 28 
$labelSites.Text = 'Sites:' 
$comboboxDeletedSites.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxDeletedSites.FormattingEnabled = $True 
$comboboxDeletedSites.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(75, 68) 
$comboboxDeletedSites.Name = 'comboboxDeletedSites' 
$comboboxDeletedSites.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(551, 29) 
$comboboxDeletedSites.Sorted = $True 
$comboboxDeletedSites.TabIndex = 27 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(150, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 30 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelDeletedSites.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelDeletedSites.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelDeletedSites.Name = 'LabelDeletedSites' 
$LabelDeletedSites.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelDeletedSites.TabIndex = 29 
$LabelDeletedSites.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(356, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 26 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formDeletedSharePointSit.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formDeletedSharePointSit.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formDeletedSharePointSit.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formDeletedSharePointSit.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formDeletedSharePointSit.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formDeletedSharePointSit.Name = 'formDeletedSharePointSit' 
$formDeletedSharePointSit.Text = 'Deleted SharePoint Sites' 
$formDeletedSharePointSit.add_Load($formDeletedSharePointSit_Load)
$formDeletedSharePointSit.Controls.Add($labelSites)
$formDeletedSharePointSit.Controls.Add($comboboxDeletedSites)
$formDeletedSharePointSit.Controls.Add($buttonCancel)
$formDeletedSharePointSit.Controls.Add($LabelDeletedSites)
$formDeletedSharePointSit.Controls.Add($buttonOK)
$formDeletedSharePointSit.ResumeLayout($false) 
}
. InitializeComponent
