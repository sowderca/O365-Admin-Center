[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formUnlicensedUsers = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelUnlicensedUsers = $null
[System.Windows.Forms.ComboBox]$comboboxSelectUnlicensedUsers = $null
[System.Windows.Forms.Button]$buttonCancelformUnlicensedUsers = $null
[System.Windows.Forms.Label]$labelSelectUnlicensedUsers = $null
[System.Windows.Forms.Button]$buttonformUnlicensedUsers = $null
function InitializeComponent {

$labelUnlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectUnlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformUnlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectUnlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformUnlicensedUsers = (New-Object -TypeName 'System.Windows.Forms.Button')
$formUnlicensedUsers.SuspendLayout()

$labelUnlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelUnlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(10, 65) 
$labelUnlicensedUsers.Name = 'labelUnlicensedUsers' 
$labelUnlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(68, 29) 
$labelUnlicensedUsers.TabIndex = 60 
$labelUnlicensedUsers.Text = 'Users:' 
$comboboxSelectUnlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectUnlicensedUsers.FormattingEnabled = $True 
$comboboxSelectUnlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(84, 65) 
$comboboxSelectUnlicensedUsers.Name = 'comboboxSelectUnlicensedUsers' 
$comboboxSelectUnlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(542, 29) 
$comboboxSelectUnlicensedUsers.Sorted = $True 
$comboboxSelectUnlicensedUsers.TabIndex = 58 
$buttonCancelformUnlicensedUsers.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformUnlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformUnlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(132, 114) 
$buttonCancelformUnlicensedUsers.Name = 'buttonCancelformUnlicensedUsers' 
$buttonCancelformUnlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformUnlicensedUsers.TabIndex = 61 
$buttonCancelformUnlicensedUsers.Text = '&Cancel' 
$buttonCancelformUnlicensedUsers.UseVisualStyleBackColor = $True 
$labelSelectUnlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectUnlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(10, 9) 
$labelSelectUnlicensedUsers.Name = 'labelSelectUnlicensedUsers' 
$labelSelectUnlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(616, 45) 
$labelSelectUnlicensedUsers.TabIndex = 59 
$labelSelectUnlicensedUsers.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformUnlicensedUsers.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformUnlicensedUsers.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformUnlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformUnlicensedUsers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(364, 114) 
$buttonformUnlicensedUsers.Name = 'buttonformUnlicensedUsers' 
$buttonformUnlicensedUsers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformUnlicensedUsers.TabIndex = 57 
$buttonformUnlicensedUsers.Text = '&OK' 
$buttonformUnlicensedUsers.UseVisualStyleBackColor = $True 
$formUnlicensedUsers.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formUnlicensedUsers.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formUnlicensedUsers.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formUnlicensedUsers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formUnlicensedUsers.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formUnlicensedUsers.Name = 'formUnlicensedUsers' 
$formUnlicensedUsers.Text = 'Unlicensed Users' 
$formUnlicensedUsers.add_Load($formUnlicensedUsers_Load)
$formUnlicensedUsers.Controls.Add($labelUnlicensedUsers)
$formUnlicensedUsers.Controls.Add($comboboxSelectUnlicensedUsers)
$formUnlicensedUsers.Controls.Add($buttonCancelformUnlicensedUsers)
$formUnlicensedUsers.Controls.Add($labelSelectUnlicensedUsers)
$formUnlicensedUsers.Controls.Add($buttonformUnlicensedUsers)
$formUnlicensedUsers.ResumeLayout($false) 
}
. InitializeComponent
