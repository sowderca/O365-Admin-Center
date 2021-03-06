[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formSharedMailboxes = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelSharedMailboxes = $null
[System.Windows.Forms.ComboBox]$comboboxSharedMailboxes = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$LabelInstructions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelSharedMailboxes = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSharedMailboxes = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$LabelInstructions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formSharedMailboxes.SuspendLayout()

$labelSharedMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSharedMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 64) 
$labelSharedMailboxes.Name = 'labelSharedMailboxes' 
$labelSharedMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(168, 29) 
$labelSharedMailboxes.TabIndex = 23 
$labelSharedMailboxes.Text = 'Shared Mailboxes:' 
$comboboxSharedMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSharedMailboxes.FormattingEnabled = $True 
$comboboxSharedMailboxes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(186, 64) 
$comboboxSharedMailboxes.Name = 'comboboxSharedMailboxes' 
$comboboxSharedMailboxes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(440, 29) 
$comboboxSharedMailboxes.Sorted = $True 
$comboboxSharedMailboxes.TabIndex = 22 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(159, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 25 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$LabelInstructions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$LabelInstructions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$LabelInstructions.Name = 'LabelInstructions' 
$LabelInstructions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$LabelInstructions.TabIndex = 24 
$LabelInstructions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(384, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 21 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formSharedMailboxes.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formSharedMailboxes.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formSharedMailboxes.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formSharedMailboxes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formSharedMailboxes.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formSharedMailboxes.Name = 'formSharedMailboxes' 
$formSharedMailboxes.Text = 'Shared Mailboxes' 
$formSharedMailboxes.add_Load($formSharedMailboxes_Load)
$formSharedMailboxes.Controls.Add($labelSharedMailboxes)
$formSharedMailboxes.Controls.Add($comboboxSharedMailboxes)
$formSharedMailboxes.Controls.Add($buttonCancel)
$formSharedMailboxes.Controls.Add($LabelInstructions)
$formSharedMailboxes.Controls.Add($buttonOK)
$formSharedMailboxes.ResumeLayout($false) 
}
. InitializeComponent
