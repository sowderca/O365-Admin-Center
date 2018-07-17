[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formPublicFolderPermissi = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelPermissions = $null
[System.Windows.Forms.ComboBox]$comboboxTPs = $null
[System.Windows.Forms.Button]$buttonCancel = $null
[System.Windows.Forms.Label]$labelpermissions1 = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelPermissions = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxTPs = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancel = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelpermissions1 = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formPublicFolderPermissi.SuspendLayout()

$labelPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 69) 
$labelPermissions.Name = 'labelPermissions' 
$labelPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(114, 29) 
$labelPermissions.TabIndex = 38 
$labelPermissions.Text = 'Permissions' 
$comboboxTPs.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxTPs.FormattingEnabled = $True 
$comboboxTPs.Items = New-Object -TypeName 'System.Windows.Forms.ComboBox+ObjectCollection' -ArgumentList @(AuthorContributorCreateItemsCreateSubfoldersDeleteAllItemsDeleteOwnedItemsEditAllItemsEditorEditOwnedItemFolderContactFolderOwnerFolderVisibleNone NonEditingAuthorOwnerPublishingAuthorPublishingEditorReadItemsReviewer) 
$comboboxTPs.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(143, 69) 
$comboboxTPs.Name = 'comboboxTPs' 
$comboboxTPs.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(483, 29) 
$comboboxTPs.Sorted = $True 
$comboboxTPs.TabIndex = 37 
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancel.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancel.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(191, 114) 
$buttonCancel.Name = 'buttonCancel' 
$buttonCancel.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancel.TabIndex = 36 
$buttonCancel.Text = '&Cancel' 
$buttonCancel.UseVisualStyleBackColor = $True 
$labelpermissions1.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelpermissions1.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelpermissions1.Name = 'labelpermissions1' 
$labelpermissions1.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelpermissions1.TabIndex = 39 
$labelpermissions1.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(381, 114) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 35 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formPublicFolderPermissi.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formPublicFolderPermissi.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formPublicFolderPermissi.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formPublicFolderPermissi.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formPublicFolderPermissi.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formPublicFolderPermissi.Name = 'formPublicFolderPermissi' 
$formPublicFolderPermissi.Text = 'Public Folder Permissions' 
$formPublicFolderPermissi.add_Load($formPublicFolderPermissi_Load)
$formPublicFolderPermissi.Controls.Add($labelPermissions)
$formPublicFolderPermissi.Controls.Add($comboboxTPs)
$formPublicFolderPermissi.Controls.Add($buttonCancel)
$formPublicFolderPermissi.Controls.Add($labelpermissions1)
$formPublicFolderPermissi.Controls.Add($buttonOK)
$formPublicFolderPermissi.ResumeLayout($false) 
}
. InitializeComponent
