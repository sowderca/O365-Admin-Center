[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formLicensedUsers = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labellicensedUsers = $null
[System.Windows.Forms.ComboBox]$comboboxSelectlicensedUsers = $null
[System.Windows.Forms.Button]$buttonCancelformlicensedUsers = $null
[System.Windows.Forms.Label]$labelSelectlicensedUsers = $null
[System.Windows.Forms.Button]$buttonformlicensedUsers = $null
function InitializeComponent {

$labellicensedUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.Button')
$formLicensedUsers.SuspendLayout()

$labellicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labellicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(10, 65) 
$labellicensedUsers.Name = 'labellicensedUsers' 
$labellicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(107, 29) 
$labellicensedUsers.TabIndex = 65 
$labellicensedUsers.Text = 'Users:' 
$comboboxSelectlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectlicensedUsers.FormattingEnabled = $True 
$comboboxSelectlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(123, 65) 
$comboboxSelectlicensedUsers.Name = 'comboboxSelectlicensedUsers' 
$comboboxSelectlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(503, 29) 
$comboboxSelectlicensedUsers.Sorted = $True 
$comboboxSelectlicensedUsers.TabIndex = 63 
$buttonCancelformlicensedUsers.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(146, 114) 
$buttonCancelformlicensedUsers.Name = 'buttonCancelformlicensedUsers' 
$buttonCancelformlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformlicensedUsers.TabIndex = 66 
$buttonCancelformlicensedUsers.Text = '&Cancel' 
$buttonCancelformlicensedUsers.UseVisualStyleBackColor = $True 
$labelSelectlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectlicensedUsers.Name = 'labelSelectlicensedUsers' 
$labelSelectlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectlicensedUsers.TabIndex = 64 
$labelSelectlicensedUsers.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformlicensedUsers.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformlicensedUsers.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(377, 114) 
$buttonformlicensedUsers.Name = 'buttonformlicensedUsers' 
$buttonformlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformlicensedUsers.TabIndex = 62 
$buttonformlicensedUsers.Text = '&OK' 
$buttonformlicensedUsers.UseVisualStyleBackColor = $True 
$formLicensedUsers.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formLicensedUsers.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formLicensedUsers.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formLicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formLicensedUsers.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formLicensedUsers.Name = 'formLicensedUsers' 
$formLicensedUsers.Text = 'Licensed Users' 
$formLicensedUsers.add_Load($formLicensedUsers_Load)
$formLicensedUsers.Controls.Add($labellicensedUsers)
$formLicensedUsers.Controls.Add($comboboxSelectlicensedUsers)
$formLicensedUsers.Controls.Add($buttonCancelformlicensedUsers)
$formLicensedUsers.Controls.Add($labelSelectlicensedUsers)
$formLicensedUsers.Controls.Add($buttonformlicensedUsers)
$formLicensedUsers.ResumeLayout($false) 
}
. InitializeComponent
