[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formRoomMailboxes = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelRoomMailboxes = $null
[System.Windows.Forms.ComboBox]$comboboxSelectRoomMailbox = $null
[System.Windows.Forms.Button]$buttonCancelformRoomMailboxes = $null
[System.Windows.Forms.Label]$labelSelectRoomMailboxes = $null
[System.Windows.Forms.Button]$buttonformRoomMailboxes = $null
function InitializeComponent {

$labelRoomMailboxes = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectRoomMailbox = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformRoomMailboxes = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectRoomMailboxes = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformRoomMailboxes = (New-Object -TypeName 'System.Windows.Forms.Button')
$formRoomMailboxes.SuspendLayout()

$labelRoomMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelRoomMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(10, 64) 
$labelRoomMailboxes.Name = 'labelRoomMailboxes' 
$labelRoomMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(167, 29) 
$labelRoomMailboxes.TabIndex = 20 
$labelRoomMailboxes.Text = 'Room Mailboxes:' 
$comboboxSelectRoomMailbox.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectRoomMailbox.FormattingEnabled = $True 
$comboboxSelectRoomMailbox.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(183, 64) 
$comboboxSelectRoomMailbox.Name = 'comboboxSelectRoomMailbox' 
$comboboxSelectRoomMailbox.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(443, 29) 
$comboboxSelectRoomMailbox.Sorted = $True 
$comboboxSelectRoomMailbox.TabIndex = 18 
$buttonCancelformRoomMailboxes.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformRoomMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformRoomMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(134, 114) 
$buttonCancelformRoomMailboxes.Name = 'buttonCancelformRoomMailboxes' 
$buttonCancelformRoomMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformRoomMailboxes.TabIndex = 21 
$buttonCancelformRoomMailboxes.Text = '&Cancel' 
$buttonCancelformRoomMailboxes.UseVisualStyleBackColor = $True 
$labelSelectRoomMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectRoomMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectRoomMailboxes.Name = 'labelSelectRoomMailboxes' 
$labelSelectRoomMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectRoomMailboxes.TabIndex = 19 
$labelSelectRoomMailboxes.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformRoomMailboxes.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformRoomMailboxes.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformRoomMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformRoomMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(377, 114) 
$buttonformRoomMailboxes.Name = 'buttonformRoomMailboxes' 
$buttonformRoomMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformRoomMailboxes.TabIndex = 17 
$buttonformRoomMailboxes.Text = '&OK' 
$buttonformRoomMailboxes.UseVisualStyleBackColor = $True 
$formRoomMailboxes.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formRoomMailboxes.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formRoomMailboxes.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formRoomMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formRoomMailboxes.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formRoomMailboxes.Name = 'formRoomMailboxes' 
$formRoomMailboxes.Text = 'Room Mailboxes' 
$formRoomMailboxes.add_Load($formRoomMailboxes_Load)
$formRoomMailboxes.Controls.Add($labelRoomMailboxes)
$formRoomMailboxes.Controls.Add($comboboxSelectRoomMailbox)
$formRoomMailboxes.Controls.Add($buttonCancelformRoomMailboxes)
$formRoomMailboxes.Controls.Add($labelSelectRoomMailboxes)
$formRoomMailboxes.Controls.Add($buttonformRoomMailboxes)
$formRoomMailboxes.ResumeLayout($false) 
}
. InitializeComponent
