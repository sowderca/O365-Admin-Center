[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formDistroGroupMembers = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelDistroGroupMembers = $null
[System.Windows.Forms.ComboBox]$comboboxSelectDistroGroupMembers = $null
[System.Windows.Forms.Button]$buttonCancelformDistroGroupMembers = $null
[System.Windows.Forms.Label]$labelSelectDistroGroupMembers = $null
[System.Windows.Forms.Button]$buttonformDistroGroupMembers = $null
function InitializeComponent {

$labelDistroGroupMembers = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectDistroGroupMembers = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformDistroGroupMembers = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectDistroGroupMembers = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformDistroGroupMembers = (New-Object -TypeName 'System.Windows.Forms.Button')
$formDistroGroupMembers.SuspendLayout()

$labelDistroGroupMembers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelDistroGroupMembers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 65) 
$labelDistroGroupMembers.Name = 'labelDistroGroupMembers' 
$labelDistroGroupMembers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(92, 29) 
$labelDistroGroupMembers.TabIndex = 45 
$labelDistroGroupMembers.Text = 'Members:' 
$comboboxSelectDistroGroupMembers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectDistroGroupMembers.FormattingEnabled = $True 
$comboboxSelectDistroGroupMembers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(110, 65) 
$comboboxSelectDistroGroupMembers.Name = 'comboboxSelectDistroGroupMembers' 
$comboboxSelectDistroGroupMembers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(507, 29) 
$comboboxSelectDistroGroupMembers.Sorted = $True 
$comboboxSelectDistroGroupMembers.TabIndex = 43 
$buttonCancelformDistroGroupMembers.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformDistroGroupMembers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformDistroGroupMembers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(165, 114) 
$buttonCancelformDistroGroupMembers.Name = 'buttonCancelformDistroGroupMembers' 
$buttonCancelformDistroGroupMembers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformDistroGroupMembers.TabIndex = 46 
$buttonCancelformDistroGroupMembers.Text = '&Cancel' 
$buttonCancelformDistroGroupMembers.UseVisualStyleBackColor = $True 
$labelSelectDistroGroupMembers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectDistroGroupMembers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(15, 10) 
$labelSelectDistroGroupMembers.Name = 'labelSelectDistroGroupMembers' 
$labelSelectDistroGroupMembers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(602, 45) 
$labelSelectDistroGroupMembers.TabIndex = 44 
$labelSelectDistroGroupMembers.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformDistroGroupMembers.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformDistroGroupMembers.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformDistroGroupMembers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformDistroGroupMembers.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(367, 114) 
$buttonformDistroGroupMembers.Name = 'buttonformDistroGroupMembers' 
$buttonformDistroGroupMembers.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformDistroGroupMembers.TabIndex = 42 
$buttonformDistroGroupMembers.Text = '&OK' 
$buttonformDistroGroupMembers.UseVisualStyleBackColor = $True 
$formDistroGroupMembers.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formDistroGroupMembers.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formDistroGroupMembers.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formDistroGroupMembers.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formDistroGroupMembers.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formDistroGroupMembers.Name = 'formDistroGroupMembers' 
$formDistroGroupMembers.Text = 'Distro Group Members' 
$formDistroGroupMembers.add_Load($formDistroGroupMembers_Load)
$formDistroGroupMembers.Controls.Add($labelDistroGroupMembers)
$formDistroGroupMembers.Controls.Add($comboboxSelectDistroGroupMembers)
$formDistroGroupMembers.Controls.Add($buttonCancelformDistroGroupMembers)
$formDistroGroupMembers.Controls.Add($labelSelectDistroGroupMembers)
$formDistroGroupMembers.Controls.Add($buttonformDistroGroupMembers)
$formDistroGroupMembers.ResumeLayout($false) 
}
. InitializeComponent
