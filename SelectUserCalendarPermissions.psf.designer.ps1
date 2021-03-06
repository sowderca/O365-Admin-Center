[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formCalendarPermissions = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelUsersCalendarPermissions = $null
[System.Windows.Forms.ComboBox]$comboboxSelectCalendarPermissions = $null
[System.Windows.Forms.Button]$buttonCancelformCalendarPermissions = $null
[System.Windows.Forms.Label]$labelSelectCalendarPermissions = $null
[System.Windows.Forms.Button]$buttonformCalendarPermissions = $null
function InitializeComponent {

$labelUsersCalendarPermissions = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectCalendarPermissions = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformCalendarPermissions = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectCalendarPermissions = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformCalendarPermissions = (New-Object -TypeName 'System.Windows.Forms.Button')
$formCalendarPermissions.SuspendLayout()

$labelUsersCalendarPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelUsersCalendarPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 66) 
$labelUsersCalendarPermissions.Name = 'labelUsersCalendarPermissions' 
$labelUsersCalendarPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(75, 29) 
$labelUsersCalendarPermissions.TabIndex = 35 
$labelUsersCalendarPermissions.Text = 'Users:' 
$comboboxSelectCalendarPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectCalendarPermissions.FormattingEnabled = $True 
$comboboxSelectCalendarPermissions.Items = New-Object -TypeName 'System.Windows.Forms.ComboBox+ObjectCollection' -ArgumentList @(AuthorAvailabilityOnlyContributorEditorLimitedDetailsNonEditingAuthorOwnerPublishingAuthorPublishingEditorReviewer) 
$comboboxSelectCalendarPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(93, 66) 
$comboboxSelectCalendarPermissions.Name = 'comboboxSelectCalendarPermissions' 
$comboboxSelectCalendarPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(533, 29) 
$comboboxSelectCalendarPermissions.Sorted = $True 
$comboboxSelectCalendarPermissions.TabIndex = 33 
$buttonCancelformCalendarPermissions.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformCalendarPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformCalendarPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(132, 114) 
$buttonCancelformCalendarPermissions.Name = 'buttonCancelformCalendarPermissions' 
$buttonCancelformCalendarPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformCalendarPermissions.TabIndex = 36 
$buttonCancelformCalendarPermissions.Text = '&Cancel' 
$buttonCancelformCalendarPermissions.UseVisualStyleBackColor = $True 
$labelSelectCalendarPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectCalendarPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectCalendarPermissions.Name = 'labelSelectCalendarPermissions' 
$labelSelectCalendarPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 45) 
$labelSelectCalendarPermissions.TabIndex = 34 
$labelSelectCalendarPermissions.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformCalendarPermissions.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformCalendarPermissions.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformCalendarPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformCalendarPermissions.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(320, 114) 
$buttonformCalendarPermissions.Name = 'buttonformCalendarPermissions' 
$buttonformCalendarPermissions.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformCalendarPermissions.TabIndex = 32 
$buttonformCalendarPermissions.Text = '&OK' 
$buttonformCalendarPermissions.UseVisualStyleBackColor = $True 
$formCalendarPermissions.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formCalendarPermissions.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formCalendarPermissions.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$formCalendarPermissions.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formCalendarPermissions.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formCalendarPermissions.Name = 'formCalendarPermissions' 
$formCalendarPermissions.Text = 'Calendar Permissions' 
$formCalendarPermissions.add_Load($formCalendarPermissions_Load)
$formCalendarPermissions.Controls.Add($labelUsersCalendarPermissions)
$formCalendarPermissions.Controls.Add($comboboxSelectCalendarPermissions)
$formCalendarPermissions.Controls.Add($buttonCancelformCalendarPermissions)
$formCalendarPermissions.Controls.Add($labelSelectCalendarPermissions)
$formCalendarPermissions.Controls.Add($buttonformCalendarPermissions)
$formCalendarPermissions.ResumeLayout($false) 
}
. InitializeComponent
