[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formMailEnabledSecurityG = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelMailEnabledSecurityGroups = $null
[System.Windows.Forms.ComboBox]$comboboxSelectMailEnabledSecurityGroups = $null
[System.Windows.Forms.Button]$buttonCancelformMailEnabledSecurityGroups = $null
[System.Windows.Forms.Label]$labelSelectMailEnabledSecurityGroups = $null
[System.Windows.Forms.Button]$buttonformMailEnabledSecurityGroups = $null
function InitializeComponent {

$labelMailEnabledSecurityGroups = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectMailEnabledSecurityGroups = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformMailEnabledSecurityGroups = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectMailEnabledSecurityGroups = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformMailEnabledSecurityGroups = (New-Object -TypeName 'System.Windows.Forms.Button')
$formMailEnabledSecurityG.SuspendLayout()

$labelMailEnabledSecurityGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelMailEnabledSecurityGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 68) 
$labelMailEnabledSecurityGroups.Name = 'labelMailEnabledSecurityGroups' 
$labelMailEnabledSecurityGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(81, 29) 
$labelMailEnabledSecurityGroups.TabIndex = 50 
$labelMailEnabledSecurityGroups.Text = 'Groups:' 
$comboboxSelectMailEnabledSecurityGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectMailEnabledSecurityGroups.FormattingEnabled = $True 
$comboboxSelectMailEnabledSecurityGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(99, 68) 
$comboboxSelectMailEnabledSecurityGroups.Name = 'comboboxSelectMailEnabledSecurityGroups' 
$comboboxSelectMailEnabledSecurityGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(527, 29) 
$comboboxSelectMailEnabledSecurityGroups.Sorted = $True 
$comboboxSelectMailEnabledSecurityGroups.TabIndex = 48 
$buttonCancelformMailEnabledSecurityGroups.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformMailEnabledSecurityGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformMailEnabledSecurityGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(161, 114) 
$buttonCancelformMailEnabledSecurityGroups.Name = 'buttonCancelformMailEnabledSecurityGroups' 
$buttonCancelformMailEnabledSecurityGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformMailEnabledSecurityGroups.TabIndex = 51 
$buttonCancelformMailEnabledSecurityGroups.Text = '&Cancel' 
$buttonCancelformMailEnabledSecurityGroups.UseVisualStyleBackColor = $True 
$labelSelectMailEnabledSecurityGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectMailEnabledSecurityGroups.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$labelSelectMailEnabledSecurityGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectMailEnabledSecurityGroups.Name = 'labelSelectMailEnabledSecurityGroups' 
$labelSelectMailEnabledSecurityGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectMailEnabledSecurityGroups.TabIndex = 49 
$labelSelectMailEnabledSecurityGroups.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformMailEnabledSecurityGroups.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformMailEnabledSecurityGroups.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformMailEnabledSecurityGroups.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformMailEnabledSecurityGroups.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(376, 114) 
$buttonformMailEnabledSecurityGroups.Name = 'buttonformMailEnabledSecurityGroups' 
$buttonformMailEnabledSecurityGroups.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformMailEnabledSecurityGroups.TabIndex = 47 
$buttonformMailEnabledSecurityGroups.Text = '&OK' 
$buttonformMailEnabledSecurityGroups.UseVisualStyleBackColor = $True 
$formMailEnabledSecurityG.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formMailEnabledSecurityG.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formMailEnabledSecurityG.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formMailEnabledSecurityG.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formMailEnabledSecurityG.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formMailEnabledSecurityG.Name = 'formMailEnabledSecurityG' 
$formMailEnabledSecurityG.Text = 'Mail Enabled Security Groups' 
$formMailEnabledSecurityG.add_Load($formMailEnabledSecurityG_Load)
$formMailEnabledSecurityG.Controls.Add($labelMailEnabledSecurityGroups)
$formMailEnabledSecurityG.Controls.Add($comboboxSelectMailEnabledSecurityGroups)
$formMailEnabledSecurityG.Controls.Add($buttonCancelformMailEnabledSecurityGroups)
$formMailEnabledSecurityG.Controls.Add($labelSelectMailEnabledSecurityGroups)
$formMailEnabledSecurityG.Controls.Add($buttonformMailEnabledSecurityGroups)
$formMailEnabledSecurityG.ResumeLayout($false) 
}
. InitializeComponent
