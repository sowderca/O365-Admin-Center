[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formSelectMailboxes = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelMailboxes = $null
[System.Windows.Forms.ComboBox]$comboboxSelectMailbox = $null
[System.Windows.Forms.Button]$buttonCancelformMailboxes = $null
[System.Windows.Forms.Label]$labelSelectMailboxes = $null
[System.Windows.Forms.Button]$buttonformMailboxes = $null
function InitializeComponent {

$labelMailboxes = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectMailbox = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformMailboxes = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectMailboxes = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformMailboxes = (New-Object -TypeName 'System.Windows.Forms.Button')
$formSelectMailboxes.SuspendLayout()

$labelMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 63) 
$labelMailboxes.Name = 'labelMailboxes' 
$labelMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(104, 29) 
$labelMailboxes.TabIndex = 25 
$labelMailboxes.Text = 'Mailboxes:' 
$comboboxSelectMailbox.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectMailbox.FormattingEnabled = $True 
$comboboxSelectMailbox.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(122, 63) 
$comboboxSelectMailbox.Name = 'comboboxSelectMailbox' 
$comboboxSelectMailbox.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(504, 29) 
$comboboxSelectMailbox.Sorted = $True 
$comboboxSelectMailbox.TabIndex = 23 
$buttonCancelformMailboxes.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(169, 114) 
$buttonCancelformMailboxes.Name = 'buttonCancelformMailboxes' 
$buttonCancelformMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformMailboxes.TabIndex = 26 
$buttonCancelformMailboxes.Text = '&Cancel' 
$buttonCancelformMailboxes.UseVisualStyleBackColor = $True 
$labelSelectMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectMailboxes.Name = 'labelSelectMailboxes' 
$labelSelectMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectMailboxes.TabIndex = 24 
$labelSelectMailboxes.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformMailboxes.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformMailboxes.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(394, 114) 
$buttonformMailboxes.Name = 'buttonformMailboxes' 
$buttonformMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformMailboxes.TabIndex = 22 
$buttonformMailboxes.Text = '&OK' 
$buttonformMailboxes.UseVisualStyleBackColor = $True 
$formSelectMailboxes.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formSelectMailboxes.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formSelectMailboxes.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formSelectMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formSelectMailboxes.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formSelectMailboxes.Name = 'formSelectMailboxes' 
$formSelectMailboxes.Text = 'Mailboxes' 
$formSelectMailboxes.add_Load($formSelectMailboxes_Load)
$formSelectMailboxes.Controls.Add($labelMailboxes)
$formSelectMailboxes.Controls.Add($comboboxSelectMailbox)
$formSelectMailboxes.Controls.Add($buttonCancelformMailboxes)
$formSelectMailboxes.Controls.Add($labelSelectMailboxes)
$formSelectMailboxes.Controls.Add($buttonformMailboxes)
$formSelectMailboxes.ResumeLayout($false) 
}
. InitializeComponent
