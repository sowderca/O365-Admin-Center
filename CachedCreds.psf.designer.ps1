[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formCachedCreds = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonDontAsk = $null
[System.Windows.Forms.Button]$buttonYes = $null
[System.Windows.Forms.Label]$label = $null
[System.Windows.Forms.Button]$buttonNo = $null
function InitializeComponent {

$buttonDontAsk = (New-Object -TypeName 'System.Windows.Forms.Button')
$buttonYes = (New-Object -TypeName 'System.Windows.Forms.Button')
$label = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonNo = (New-Object -TypeName 'System.Windows.Forms.Button')
$formCachedCreds.SuspendLayout()

$buttonDontAsk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonDontAsk.DialogResult = [System.Windows.Forms.DialogResult]::Abort 
$buttonDontAsk.FlatStyle = [System.Windows.Forms.FlatStyle]::System 
$buttonDontAsk.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonDontAsk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(461, 104) 
$buttonDontAsk.Name = 'buttonDontAsk' 
$buttonDontAsk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(166, 37) 
$buttonDontAsk.TabIndex = 44 
$buttonDontAsk.Text = '&Don't Ask Again' 
$buttonDontAsk.UseVisualStyleBackColor = $True 
$buttonDontAsk.add_Click($buttonDontAsk_Click)
$buttonYes.DialogResult = [System.Windows.Forms.DialogResult]::Yes 
$buttonYes.FlatStyle = [System.Windows.Forms.FlatStyle]::System 
$buttonYes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonYes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(71, 104) 
$buttonYes.Name = 'buttonYes' 
$buttonYes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonYes.TabIndex = 42 
$buttonYes.Text = '&Yes' 
$buttonYes.UseVisualStyleBackColor = $True 
$buttonYes.add_Click($buttonYes_Click)
$label.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$label.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 17) 
$label.Name = 'label' 
$label.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(667, 67) 
$label.TabIndex = 45 
$label.Text = 'Would you like to save these credentials? O365 Admin Center will auto connect you next time after you select a service to connect to.' 
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonNo.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonNo.DialogResult = [System.Windows.Forms.DialogResult]::No 
$buttonNo.FlatStyle = [System.Windows.Forms.FlatStyle]::System 
$buttonNo.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonNo.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(270, 104) 
$buttonNo.Name = 'buttonNo' 
$buttonNo.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonNo.TabIndex = 43 
$buttonNo.Text = '&No' 
$buttonNo.UseVisualStyleBackColor = $True 
$buttonNo.add_Click($buttonNo_Click)
$formCachedCreds.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formCachedCreds.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formCachedCreds.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(697, 158) 
$formCachedCreds.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formCachedCreds.Name = 'formCachedCreds' 
$formCachedCreds.Text = 'Save Credentials' 
$formCachedCreds.add_Load($formCachedCreds_Load)
$formCachedCreds.Controls.Add($buttonDontAsk)
$formCachedCreds.Controls.Add($buttonYes)
$formCachedCreds.Controls.Add($label)
$formCachedCreds.Controls.Add($buttonNo)
$formCachedCreds.ResumeLayout($false) 
}
. InitializeComponent
