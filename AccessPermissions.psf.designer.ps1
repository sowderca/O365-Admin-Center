[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formAccessPermissions = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelPermissions = $null
[System.Windows.Forms.ComboBox]$comboboxPermissions = $null
[System.Windows.Forms.Button]$buttonCancelformPermissions = $null
[System.Windows.Forms.Label]$labelAccessPermissions = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelPermissions = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxPermissions = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformPermissions = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelAccessPermissions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formAccessPermissions.SuspendLayout()

$labelPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 65) 
$labelPermissions.Name = 'labelPermissions' 
$labelPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(125, 28) 
$labelPermissions.TabIndex = 2 
$labelPermissions.Text = 'Permissions:' 
$comboboxPermissions.FormattingEnabled = $True 
$comboboxPermissions.Items = New-Object -TypeName 'System.Windows.Forms.ComboBox+ObjectCollection' -ArgumentList @(AuthorAvailabilityOnlyContributorEditorLimitedDetailsNonEditingAuthorOwnerPublishingAuthorPublishingEditorReviewer) 
$comboboxPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(143, 65) 
$comboboxPermissions.Name = 'comboboxPermissions' 
$comboboxPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(531, 27) 
$comboboxPermissions.Sorted = $True 
$comboboxPermissions.TabIndex = 1 
$buttonCancelformPermissions.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(182, 122) 
$buttonCancelformPermissions.Name = 'buttonCancelformPermissions' 
$buttonCancelformPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformPermissions.TabIndex = 6 
$buttonCancelformPermissions.Text = '&Cancel' 
$buttonCancelformPermissions.UseVisualStyleBackColor = $True 
$labelAccessPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelAccessPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelAccessPermissions.Name = 'labelAccessPermissions' 
$labelAccessPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(662, 53) 
$labelAccessPermissions.TabIndex = 1 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(423, 122) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 0 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formAccessPermissions.AcceptButton = $buttonOK 
$formAccessPermissions.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formAccessPermissions.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formAccessPermissions.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(686, 171) 
$formAccessPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formAccessPermissions.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formAccessPermissions.MaximizeBox = $False 
$formAccessPermissions.MinimizeBox = $False 
$formAccessPermissions.Name = 'formAccessPermissions' 
$formAccessPermissions.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen 
$formAccessPermissions.Text = 'Access Permissions' 
$formAccessPermissions.add_Load($formAccessPermissions_Load)
$formAccessPermissions.Controls.Add($labelPermissions)
$formAccessPermissions.Controls.Add($comboboxPermissions)
$formAccessPermissions.Controls.Add($buttonCancelformPermissions)
$formAccessPermissions.Controls.Add($labelAccessPermissions)
$formAccessPermissions.Controls.Add($buttonOK)
$formAccessPermissions.ResumeLayout($false) 
}
. InitializeComponent
