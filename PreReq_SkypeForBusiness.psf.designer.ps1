[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$PreReq_S4B = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonDontAsk = $null
[System.Windows.Forms.Button]$buttonYes = $null
[System.Windows.Forms.Label]$labelMSonline = $null
[System.Windows.Forms.Button]$buttonNo = $null
function InitializeComponent {

$buttonDontAsk = (New-Object -TypeName 'System.Windows.Forms.Button')
$buttonYes = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelMSonline = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonNo = (New-Object -TypeName 'System.Windows.Forms.Button')
$PreReq_S4B.SuspendLayout()

$buttonDontAsk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonDontAsk.DialogResult = [System.Windows.Forms.DialogResult]::Abort 
$buttonDontAsk.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonDontAsk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(427, 114) 
$buttonDontAsk.Name = 'buttonDontAsk' 
$buttonDontAsk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(158, 37) 
$buttonDontAsk.TabIndex = 3 
$buttonDontAsk.Text = "&Don't Ask Again"
$buttonDontAsk.UseVisualStyleBackColor = $True 
$buttonDontAsk.add_Click($buttonDontAsk_Click)
$buttonYes.DialogResult = [System.Windows.Forms.DialogResult]::Yes 
$buttonYes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonYes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(58, 114) 
$buttonYes.Name = 'buttonYes' 
$buttonYes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonYes.TabIndex = 1 
$buttonYes.Text = 'Yes' 
$buttonYes.UseVisualStyleBackColor = $True 
$buttonYes.add_Click($buttonYes_Click)
$labelMSonline.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelMSonline.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelMSonline.Name = 'labelMSonline' 
$labelMSonline.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 85) 
$labelMSonline.TabIndex = 29 
$labelMSonline.Text = 'SkypeOnlineConnector module appears to not be installed. This module must be installed to continue. Would you like to install it now?' 
$labelMSonline.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonNo.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonNo.DialogResult = [System.Windows.Forms.DialogResult]::No 
$buttonNo.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonNo.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(245, 114) 
$buttonNo.Name = 'buttonNo' 
$buttonNo.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonNo.TabIndex = 2 
$buttonNo.Text = 'No' 
$buttonNo.UseVisualStyleBackColor = $True 
$PreReq_S4B.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$PreReq_S4B.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$PreReq_S4B.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$PreReq_S4B.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$PreReq_S4B.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$PreReq_S4B.Name = 'PreReq_S4B' 
$PreReq_S4B.Text = 'ERROR: Skype For Business' 
$PreReq_S4B.add_Load($PreReq_S4B_Load)
$PreReq_S4B.Controls.Add($buttonDontAsk)
$PreReq_S4B.Controls.Add($buttonYes)
$PreReq_S4B.Controls.Add($labelMSonline)
$PreReq_S4B.Controls.Add($buttonNo)
$PreReq_S4B.ResumeLayout($false) 
}
. InitializeComponent
