[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formCurrentPermissions = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelCurrentPermissions = $null
[System.Windows.Forms.ComboBox]$comboboxSelectCurrentPermissions = $null
[System.Windows.Forms.Button]$buttonCancelCurrentPermissions = $null
[System.Windows.Forms.Label]$labelSelectCurrentPermissions = $null
[System.Windows.Forms.Button]$buttonformCurrentPermissions = $null
function InitializeComponent {

$labelCurrentPermissions = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectCurrentPermissions = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelCurrentPermissions = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectCurrentPermissions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformCurrentPermissions = (New-Object -TypeName 'System.Windows.Forms.Button')
$formCurrentPermissions.SuspendLayout()

$labelCurrentPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelCurrentPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 69) 
$labelCurrentPermissions.Name = 'labelCurrentPermissions' 
$labelCurrentPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(74, 29) 
$labelCurrentPermissions.TabIndex = 70 
$labelCurrentPermissions.Text = 'Users:' 
$comboboxSelectCurrentPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectCurrentPermissions.FormattingEnabled = $True 
$comboboxSelectCurrentPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(92, 69) 
$comboboxSelectCurrentPermissions.Name = 'comboboxSelectCurrentPermissions' 
$comboboxSelectCurrentPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(534, 29) 
$comboboxSelectCurrentPermissions.Sorted = $True 
$comboboxSelectCurrentPermissions.TabIndex = 68 
$buttonCancelCurrentPermissions.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelCurrentPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelCurrentPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(137, 114) 
$buttonCancelCurrentPermissions.Name = 'buttonCancelCurrentPermissions' 
$buttonCancelCurrentPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelCurrentPermissions.TabIndex = 71 
$buttonCancelCurrentPermissions.Text = '&Cancel' 
$buttonCancelCurrentPermissions.UseVisualStyleBackColor = $True 
$labelSelectCurrentPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectCurrentPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectCurrentPermissions.Name = 'labelSelectCurrentPermissions' 
$labelSelectCurrentPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectCurrentPermissions.TabIndex = 69 
$labelSelectCurrentPermissions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformCurrentPermissions.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformCurrentPermissions.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformCurrentPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformCurrentPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(376, 114) 
$buttonformCurrentPermissions.Name = 'buttonformCurrentPermissions' 
$buttonformCurrentPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformCurrentPermissions.TabIndex = 67 
$buttonformCurrentPermissions.Text = '&OK' 
$buttonformCurrentPermissions.UseVisualStyleBackColor = $True 
$formCurrentPermissions.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formCurrentPermissions.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formCurrentPermissions.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formCurrentPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formCurrentPermissions.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formCurrentPermissions.Name = 'formCurrentPermissions' 
$formCurrentPermissions.Text = 'Permissions' 
$formCurrentPermissions.add_Load($formCurrentPermissions_Load)
$formCurrentPermissions.Controls.Add($labelCurrentPermissions)
$formCurrentPermissions.Controls.Add($comboboxSelectCurrentPermissions)
$formCurrentPermissions.Controls.Add($buttonCancelCurrentPermissions)
$formCurrentPermissions.Controls.Add($labelSelectCurrentPermissions)
$formCurrentPermissions.Controls.Add($buttonformCurrentPermissions)
$formCurrentPermissions.ResumeLayout($false) 
}
. InitializeComponent
