[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formDistributionGroups = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelDistroGroups = $null
[System.Windows.Forms.ComboBox]$comboboxSelectDistroGroups = $null
[System.Windows.Forms.Button]$buttonCancelformDistroGroups = $null
[System.Windows.Forms.Label]$labelSelectDistroGroup = $null
[System.Windows.Forms.Button]$buttonformDistroGroups = $null
function InitializeComponent {

$labelDistroGroups = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectDistroGroups = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformDistroGroups = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectDistroGroup = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformDistroGroups = (New-Object -TypeName 'System.Windows.Forms.Button')
$formDistributionGroups.SuspendLayout()

$labelDistroGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelDistroGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(3, 67) 
$labelDistroGroups.Name = 'labelDistroGroups' 
$labelDistroGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(171, 21) 
$labelDistroGroups.TabIndex = 40 
$labelDistroGroups.Text = 'Distribution Groups:' 
$comboboxSelectDistroGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectDistroGroups.FormattingEnabled = $True 
$comboboxSelectDistroGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(180, 64) 
$comboboxSelectDistroGroups.Name = 'comboboxSelectDistroGroups' 
$comboboxSelectDistroGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(446, 29) 
$comboboxSelectDistroGroups.Sorted = $True 
$comboboxSelectDistroGroups.TabIndex = 38 
$buttonCancelformDistroGroups.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformDistroGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformDistroGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(165, 114) 
$buttonCancelformDistroGroups.Name = 'buttonCancelformDistroGroups' 
$buttonCancelformDistroGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformDistroGroups.TabIndex = 41 
$buttonCancelformDistroGroups.Text = '&Cancel' 
$buttonCancelformDistroGroups.UseVisualStyleBackColor = $True 
$labelSelectDistroGroup.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectDistroGroup.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectDistroGroup.Name = 'labelSelectDistroGroup' 
$labelSelectDistroGroup.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectDistroGroup.TabIndex = 39 
$labelSelectDistroGroup.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformDistroGroups.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformDistroGroups.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformDistroGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformDistroGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(399, 114) 
$buttonformDistroGroups.Name = 'buttonformDistroGroups' 
$buttonformDistroGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformDistroGroups.TabIndex = 37 
$buttonformDistroGroups.Text = '&OK' 
$buttonformDistroGroups.UseVisualStyleBackColor = $True 
$formDistributionGroups.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formDistributionGroups.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formDistributionGroups.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formDistributionGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formDistributionGroups.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formDistributionGroups.Name = 'formDistributionGroups' 
$formDistributionGroups.Text = 'Distribution Groups' 
$formDistributionGroups.add_Load($formDistributionGroups_Load)
$formDistributionGroups.Controls.Add($labelDistroGroups)
$formDistributionGroups.Controls.Add($comboboxSelectDistroGroups)
$formDistributionGroups.Controls.Add($buttonCancelformDistroGroups)
$formDistributionGroups.Controls.Add($labelSelectDistroGroup)
$formDistributionGroups.Controls.Add($buttonformDistroGroups)
$formDistributionGroups.ResumeLayout($false) 
}
. InitializeComponent
