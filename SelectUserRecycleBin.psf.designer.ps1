[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formSelectUserRecycleBin = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelUserRecycleBin = $null
[System.Windows.Forms.ComboBox]$comboboxSelectRecycleBin = $null
[System.Windows.Forms.Button]$buttonCancelformRecycleBin = $null
[System.Windows.Forms.Label]$labelSelectRecycleBinUser = $null
[System.Windows.Forms.Button]$buttonformRecycleBin = $null
function InitializeComponent {

$labelUserRecycleBin = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectRecycleBin = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformRecycleBin = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectRecycleBinUser = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformRecycleBin = (New-Object -TypeName 'System.Windows.Forms.Button')
$formSelectUserRecycleBin.SuspendLayout()

$labelUserRecycleBin.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelUserRecycleBin.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 67) 
$labelUserRecycleBin.Name = 'labelUserRecycleBin' 
$labelUserRecycleBin.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(70, 29) 
$labelUserRecycleBin.TabIndex = 10 
$labelUserRecycleBin.Text = 'Users:' 
$comboboxSelectRecycleBin.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectRecycleBin.FormattingEnabled = $True 
$comboboxSelectRecycleBin.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(88, 67) 
$comboboxSelectRecycleBin.Name = 'comboboxSelectRecycleBin' 
$comboboxSelectRecycleBin.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(538, 29) 
$comboboxSelectRecycleBin.Sorted = $True 
$comboboxSelectRecycleBin.TabIndex = 8 
$buttonCancelformRecycleBin.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformRecycleBin.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformRecycleBin.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(170, 114) 
$buttonCancelformRecycleBin.Name = 'buttonCancelformRecycleBin' 
$buttonCancelformRecycleBin.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformRecycleBin.TabIndex = 11 
$buttonCancelformRecycleBin.Text = '&Cancel' 
$buttonCancelformRecycleBin.UseVisualStyleBackColor = $True 
$labelSelectRecycleBinUser.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectRecycleBinUser.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectRecycleBinUser.Name = 'labelSelectRecycleBinUser' 
$labelSelectRecycleBinUser.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectRecycleBinUser.TabIndex = 9 
$labelSelectRecycleBinUser.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformRecycleBin.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformRecycleBin.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformRecycleBin.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformRecycleBin.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(374, 114) 
$buttonformRecycleBin.Name = 'buttonformRecycleBin' 
$buttonformRecycleBin.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformRecycleBin.TabIndex = 7 
$buttonformRecycleBin.Text = '&OK' 
$buttonformRecycleBin.UseVisualStyleBackColor = $True 
$formSelectUserRecycleBin.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formSelectUserRecycleBin.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formSelectUserRecycleBin.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formSelectUserRecycleBin.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formSelectUserRecycleBin.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formSelectUserRecycleBin.MaximizeBox = $False 
$formSelectUserRecycleBin.MinimizeBox = $False 
$formSelectUserRecycleBin.Name = 'formSelectUserRecycleBin' 
$formSelectUserRecycleBin.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen 
$formSelectUserRecycleBin.Text = 'Select User' 
$formSelectUserRecycleBin.add_Load($formSelectUserRecycleBin_Load)
$formSelectUserRecycleBin.Controls.Add($labelUserRecycleBin)
$formSelectUserRecycleBin.Controls.Add($comboboxSelectRecycleBin)
$formSelectUserRecycleBin.Controls.Add($buttonCancelformRecycleBin)
$formSelectUserRecycleBin.Controls.Add($labelSelectRecycleBinUser)
$formSelectUserRecycleBin.Controls.Add($buttonformRecycleBin)
$formSelectUserRecycleBin.ResumeLayout($false) 
}
. InitializeComponent
