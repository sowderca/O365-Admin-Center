[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formEmailAddresses = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelUserEmailAddresses = $null
[System.Windows.Forms.ComboBox]$comboboxSelectEmailAddresses = $null
[System.Windows.Forms.Button]$buttonCancelformEmailAddresses = $null
[System.Windows.Forms.Label]$labelSelectEmailAddresses = $null
[System.Windows.Forms.Button]$buttonformEmailAddresses = $null
function InitializeComponent {

$labelUserEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformEmailAddresses = (New-Object -TypeName 'System.Windows.Forms.Button')
$formEmailAddresses.SuspendLayout()

$labelUserEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelUserEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 70) 
$labelUserEmailAddresses.Name = 'labelUserEmailAddresses' 
$labelUserEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(178, 28) 
$labelUserEmailAddresses.TabIndex = 15 
$labelUserEmailAddresses.Text = 'Email Addresses:' 
$comboboxSelectEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectEmailAddresses.FormattingEnabled = $True 
$comboboxSelectEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(196, 70) 
$comboboxSelectEmailAddresses.Name = 'comboboxSelectEmailAddresses' 
$comboboxSelectEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(430, 29) 
$comboboxSelectEmailAddresses.Sorted = $True 
$comboboxSelectEmailAddresses.TabIndex = 13 
$buttonCancelformEmailAddresses.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(154, 114) 
$buttonCancelformEmailAddresses.Name = 'buttonCancelformEmailAddresses' 
$buttonCancelformEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformEmailAddresses.TabIndex = 16 
$buttonCancelformEmailAddresses.Text = '&Cancel' 
$buttonCancelformEmailAddresses.UseVisualStyleBackColor = $True 
$labelSelectEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectEmailAddresses.Name = 'labelSelectEmailAddresses' 
$labelSelectEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectEmailAddresses.TabIndex = 14 
$labelSelectEmailAddresses.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformEmailAddresses.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformEmailAddresses.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformEmailAddresses.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(385, 114) 
$buttonformEmailAddresses.Name = 'buttonformEmailAddresses' 
$buttonformEmailAddresses.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformEmailAddresses.TabIndex = 12 
$buttonformEmailAddresses.Text = '&OK' 
$buttonformEmailAddresses.UseVisualStyleBackColor = $True 
$formEmailAddresses.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formEmailAddresses.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formEmailAddresses.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formEmailAddresses.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formEmailAddresses.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formEmailAddresses.MaximizeBox = $False 
$formEmailAddresses.MinimizeBox = $False 
$formEmailAddresses.Name = 'formEmailAddresses' 
$formEmailAddresses.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen 
$formEmailAddresses.Text = 'Email Addresses' 
$formEmailAddresses.add_Load($formEmailAddresses_Load)
$formEmailAddresses.Controls.Add($labelUserEmailAddresses)
$formEmailAddresses.Controls.Add($comboboxSelectEmailAddresses)
$formEmailAddresses.Controls.Add($buttonCancelformEmailAddresses)
$formEmailAddresses.Controls.Add($labelSelectEmailAddresses)
$formEmailAddresses.Controls.Add($buttonformEmailAddresses)
$formEmailAddresses.ResumeLayout($false) 
}
. InitializeComponent
