[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formSharePointSites = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelSpoSites = $null
[System.Windows.Forms.ComboBox]$comboboxSelectSPOSites = $null
[System.Windows.Forms.Button]$buttonCancelformDistroGroups = $null
[System.Windows.Forms.Label]$labelSelectSPOSites = $null
[System.Windows.Forms.Button]$buttonformDistroGroups = $null
function InitializeComponent {

$labelSpoSites = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectSPOSites = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformDistroGroups = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectSPOSites = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformDistroGroups = (New-Object -TypeName 'System.Windows.Forms.Button')
$formSharePointSites.SuspendLayout()

$labelSpoSites.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSpoSites.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 68) 
$labelSpoSites.Name = 'labelSpoSites' 
$labelSpoSites.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(62, 29) 
$labelSpoSites.TabIndex = 45 
$labelSpoSites.Text = 'Sites:' 
$comboboxSelectSPOSites.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectSPOSites.FormattingEnabled = $True 
$comboboxSelectSPOSites.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(80, 65) 
$comboboxSelectSPOSites.Name = 'comboboxSelectSPOSites' 
$comboboxSelectSPOSites.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(546, 29) 
$comboboxSelectSPOSites.Sorted = $True 
$comboboxSelectSPOSites.TabIndex = 43 
$buttonCancelformDistroGroups.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformDistroGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformDistroGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(145, 114) 
$buttonCancelformDistroGroups.Name = 'buttonCancelformDistroGroups' 
$buttonCancelformDistroGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformDistroGroups.TabIndex = 46 
$buttonCancelformDistroGroups.Text = '&Cancel' 
$buttonCancelformDistroGroups.UseVisualStyleBackColor = $True 
$labelSelectSPOSites.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectSPOSites.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(16, 9) 
$labelSelectSPOSites.Name = 'labelSelectSPOSites' 
$labelSelectSPOSites.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(610, 45) 
$labelSelectSPOSites.TabIndex = 44 
$labelSelectSPOSites.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformDistroGroups.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformDistroGroups.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformDistroGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformDistroGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(377, 114) 
$buttonformDistroGroups.Name = 'buttonformDistroGroups' 
$buttonformDistroGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformDistroGroups.TabIndex = 42 
$buttonformDistroGroups.Text = '&OK' 
$buttonformDistroGroups.UseVisualStyleBackColor = $True 
$formSharePointSites.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formSharePointSites.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formSharePointSites.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formSharePointSites.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formSharePointSites.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formSharePointSites.Name = 'formSharePointSites' 
$formSharePointSites.Text = 'SharePoint Sites' 
$formSharePointSites.add_Load($formSharePointSites_Load)
$formSharePointSites.Controls.Add($labelSpoSites)
$formSharePointSites.Controls.Add($comboboxSelectSPOSites)
$formSharePointSites.Controls.Add($buttonCancelformDistroGroups)
$formSharePointSites.Controls.Add($labelSelectSPOSites)
$formSharePointSites.Controls.Add($buttonformDistroGroups)
$formSharePointSites.ResumeLayout($false) 
}
. InitializeComponent
