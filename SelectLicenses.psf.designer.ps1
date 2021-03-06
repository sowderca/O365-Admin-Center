[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formAvailableLicenses = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelAvailableLicenses = $null
[System.Windows.Forms.ComboBox]$comboboxSelectAvailableLicenses = $null
[System.Windows.Forms.Button]$buttonCancelformAvailableLicenses = $null
[System.Windows.Forms.Label]$labelSelectAvailableLicenses = $null
[System.Windows.Forms.Button]$buttonformAvailableLicenses = $null
function InitializeComponent {

$labelAvailableLicenses = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectAvailableLicenses = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformAvailableLicenses = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectAvailableLicenses = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformAvailableLicenses = (New-Object -TypeName 'System.Windows.Forms.Button')
$formAvailableLicenses.SuspendLayout()

$labelAvailableLicenses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelAvailableLicenses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(10, 69) 
$labelAvailableLicenses.Name = 'labelAvailableLicenses' 
$labelAvailableLicenses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(108, 29) 
$labelAvailableLicenses.TabIndex = 55 
$labelAvailableLicenses.Text = 'Licenses:' 
$comboboxSelectAvailableLicenses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectAvailableLicenses.FormattingEnabled = $True 
$comboboxSelectAvailableLicenses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(124, 69) 
$comboboxSelectAvailableLicenses.Name = 'comboboxSelectAvailableLicenses' 
$comboboxSelectAvailableLicenses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(502, 29) 
$comboboxSelectAvailableLicenses.Sorted = $True 
$comboboxSelectAvailableLicenses.TabIndex = 53 
$buttonCancelformAvailableLicenses.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformAvailableLicenses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformAvailableLicenses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(151, 114) 
$buttonCancelformAvailableLicenses.Name = 'buttonCancelformAvailableLicenses' 
$buttonCancelformAvailableLicenses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformAvailableLicenses.TabIndex = 56 
$buttonCancelformAvailableLicenses.Text = '&Cancel' 
$buttonCancelformAvailableLicenses.UseVisualStyleBackColor = $True 
$labelSelectAvailableLicenses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectAvailableLicenses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectAvailableLicenses.Name = 'labelSelectAvailableLicenses' 
$labelSelectAvailableLicenses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectAvailableLicenses.TabIndex = 54 
$labelSelectAvailableLicenses.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformAvailableLicenses.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformAvailableLicenses.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformAvailableLicenses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformAvailableLicenses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(382, 114) 
$buttonformAvailableLicenses.Name = 'buttonformAvailableLicenses' 
$buttonformAvailableLicenses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformAvailableLicenses.TabIndex = 52 
$buttonformAvailableLicenses.Text = '&OK' 
$buttonformAvailableLicenses.UseVisualStyleBackColor = $True 
$formAvailableLicenses.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formAvailableLicenses.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formAvailableLicenses.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formAvailableLicenses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formAvailableLicenses.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formAvailableLicenses.Name = 'formAvailableLicenses' 
$formAvailableLicenses.Text = 'Available Licenses' 
$formAvailableLicenses.add_Load($formAvailableLicenses_Load)
$formAvailableLicenses.Controls.Add($labelAvailableLicenses)
$formAvailableLicenses.Controls.Add($comboboxSelectAvailableLicenses)
$formAvailableLicenses.Controls.Add($buttonCancelformAvailableLicenses)
$formAvailableLicenses.Controls.Add($labelSelectAvailableLicenses)
$formAvailableLicenses.Controls.Add($buttonformAvailableLicenses)
$formAvailableLicenses.ResumeLayout($false) 
}
. InitializeComponent
