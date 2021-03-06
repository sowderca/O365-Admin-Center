[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$SelectCachedDistroGroups = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelGroups = $null
[System.Windows.Forms.ComboBox]$comboboxNames = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$labelSelectDistroGroup = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelGroups = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxNames = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectDistroGroup = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$SelectCachedDistroGroups.SuspendLayout()

$labelGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 62) 
$labelGroups.Name = 'labelGroups' 
$labelGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(86, 29) 
$labelGroups.TabIndex = 23 
$labelGroups.Text = 'Groups:' 
$comboboxNames.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxNames.FormattingEnabled = $True 
$comboboxNames.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(104, 62) 
$comboboxNames.Name = 'comboboxNames' 
$comboboxNames.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(522, 29) 
$comboboxNames.Sorted = $True 
$comboboxNames.TabIndex = 22 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(177, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 21 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$labelSelectDistroGroup.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectDistroGroup.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectDistroGroup.Name = 'labelSelectDistroGroup' 
$labelSelectDistroGroup.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectDistroGroup.TabIndex = 24 
$labelSelectDistroGroup.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(380, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 20 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$SelectCachedDistroGroups.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$SelectCachedDistroGroups.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$SelectCachedDistroGroups.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$SelectCachedDistroGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$SelectCachedDistroGroups.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$SelectCachedDistroGroups.Name = 'SelectCachedDistroGroups' 
$SelectCachedDistroGroups.Text = 'Distribution Groups' 
$SelectCachedDistroGroups.add_Load($SelectCachedDistroGroups_Load)
$SelectCachedDistroGroups.Controls.Add($labelGroups)
$SelectCachedDistroGroups.Controls.Add($comboboxNames)
$SelectCachedDistroGroups.Controls.Add($buttonCancel)
$SelectCachedDistroGroups.Controls.Add($labelSelectDistroGroup)
$SelectCachedDistroGroups.Controls.Add($buttonOK)
$SelectCachedDistroGroups.ResumeLayout($false) 
}
. InitializeComponent
