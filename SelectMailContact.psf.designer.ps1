[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formMailContacts = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelContacts = $null
[System.Windows.Forms.ComboBox]$comboboxSelectMailContacts = $null
[System.Windows.Forms.Button]$buttonCancelformMailContacts = $null
[System.Windows.Forms.Label]$labelSelectMailContacts = $null
[System.Windows.Forms.Button]$buttonformMailContacts = $null
function InitializeComponent {

$labelContacts = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectMailContacts = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformMailContacts = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectMailContacts = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformMailContacts = (New-Object -TypeName 'System.Windows.Forms.Button')
$formMailContacts.SuspendLayout()

$labelContacts.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelContacts.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 67) 
$labelContacts.Name = 'labelContacts' 
$labelContacts.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(97, 29) 
$labelContacts.TabIndex = 30 
$labelContacts.Text = 'Contacts:' 
$comboboxSelectMailContacts.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectMailContacts.FormattingEnabled = $True 
$comboboxSelectMailContacts.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(115, 67) 
$comboboxSelectMailContacts.Name = 'comboboxSelectMailContacts' 
$comboboxSelectMailContacts.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(511, 29) 
$comboboxSelectMailContacts.Sorted = $True 
$comboboxSelectMailContacts.TabIndex = 28 
$buttonCancelformMailContacts.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformMailContacts.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformMailContacts.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(148, 114) 
$buttonCancelformMailContacts.Name = 'buttonCancelformMailContacts' 
$buttonCancelformMailContacts.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformMailContacts.TabIndex = 31 
$buttonCancelformMailContacts.Text = '&Cancel' 
$buttonCancelformMailContacts.UseVisualStyleBackColor = $True 
$labelSelectMailContacts.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectMailContacts.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectMailContacts.Name = 'labelSelectMailContacts' 
$labelSelectMailContacts.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectMailContacts.TabIndex = 29 
$labelSelectMailContacts.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformMailContacts.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformMailContacts.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformMailContacts.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformMailContacts.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(351, 114) 
$buttonformMailContacts.Name = 'buttonformMailContacts' 
$buttonformMailContacts.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformMailContacts.TabIndex = 27 
$buttonformMailContacts.Text = '&OK' 
$buttonformMailContacts.UseVisualStyleBackColor = $True 
$formMailContacts.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formMailContacts.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formMailContacts.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formMailContacts.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formMailContacts.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formMailContacts.Name = 'formMailContacts' 
$formMailContacts.Text = 'Mail Contacts' 
$formMailContacts.add_Load($formMailContacts_Load)
$formMailContacts.Controls.Add($labelContacts)
$formMailContacts.Controls.Add($comboboxSelectMailContacts)
$formMailContacts.Controls.Add($buttonCancelformMailContacts)
$formMailContacts.Controls.Add($labelSelectMailContacts)
$formMailContacts.Controls.Add($buttonformMailContacts)
$formMailContacts.ResumeLayout($false) 
}
. InitializeComponent
