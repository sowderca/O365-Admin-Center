[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formFullAccessPermission = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelFullAccessUsers = $null
[System.Windows.Forms.ComboBox]$comboboxSelectFullAccessUsers = $null
[System.Windows.Forms.Button]$buttonCancelFullAccessUsers = $null
[System.Windows.Forms.Label]$labelSelectFullAccessUsers = $null
[System.Windows.Forms.Button]$buttonformFullAccessUsers = $null
function InitializeComponent {

$labelFullAccessUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectFullAccessUsers = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelFullAccessUsers = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectFullAccessUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformFullAccessUsers = (New-Object -TypeName 'System.Windows.Forms.Button')
$formFullAccessPermission.SuspendLayout()

$labelFullAccessUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelFullAccessUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 68) 
$labelFullAccessUsers.Name = 'labelFullAccessUsers' 
$labelFullAccessUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(68, 29) 
$labelFullAccessUsers.TabIndex = 65 
$labelFullAccessUsers.Text = 'Users:' 
$comboboxSelectFullAccessUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectFullAccessUsers.FormattingEnabled = $True 
$comboboxSelectFullAccessUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(86, 68) 
$comboboxSelectFullAccessUsers.Name = 'comboboxSelectFullAccessUsers' 
$comboboxSelectFullAccessUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(540, 29) 
$comboboxSelectFullAccessUsers.Sorted = $True 
$comboboxSelectFullAccessUsers.TabIndex = 63 
$buttonCancelFullAccessUsers.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelFullAccessUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelFullAccessUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(165, 114) 
$buttonCancelFullAccessUsers.Name = 'buttonCancelFullAccessUsers' 
$buttonCancelFullAccessUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelFullAccessUsers.TabIndex = 66 
$buttonCancelFullAccessUsers.Text = '&Cancel' 
$buttonCancelFullAccessUsers.UseVisualStyleBackColor = $True 
$labelSelectFullAccessUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectFullAccessUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectFullAccessUsers.Name = 'labelSelectFullAccessUsers' 
$labelSelectFullAccessUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectFullAccessUsers.TabIndex = 64 
$labelSelectFullAccessUsers.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformFullAccessUsers.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformFullAccessUsers.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformFullAccessUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformFullAccessUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(390, 114) 
$buttonformFullAccessUsers.Name = 'buttonformFullAccessUsers' 
$buttonformFullAccessUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformFullAccessUsers.TabIndex = 62 
$buttonformFullAccessUsers.Text = '&OK' 
$buttonformFullAccessUsers.UseVisualStyleBackColor = $True 
$formFullAccessPermission.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formFullAccessPermission.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formFullAccessPermission.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formFullAccessPermission.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formFullAccessPermission.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formFullAccessPermission.Name = 'formFullAccessPermission' 
$formFullAccessPermission.Text = 'Full Access Permissions' 
$formFullAccessPermission.add_Load($formFullAccessPermission_Load)
$formFullAccessPermission.Controls.Add($labelFullAccessUsers)
$formFullAccessPermission.Controls.Add($comboboxSelectFullAccessUsers)
$formFullAccessPermission.Controls.Add($buttonCancelFullAccessUsers)
$formFullAccessPermission.Controls.Add($labelSelectFullAccessUsers)
$formFullAccessPermission.Controls.Add($buttonformFullAccessUsers)
$formFullAccessPermission.ResumeLayout($false) 
}
. InitializeComponent
