[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$FormPreReqTFA_MSOLINE = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonDontAsk = $null
[System.Windows.Forms.Button]$buttonYes = $null
[System.Windows.Forms.Label]$labelMSonline = $null
[System.Windows.Forms.Button]$buttonNo = $null
function InitializeComponent {

$buttonDontAsk = (New-Object -TypeName 'System.Windows.Forms.Button')
$buttonYes = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelMSonline = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonNo = (New-Object -TypeName 'System.Windows.Forms.Button')
$FormPreReqTFA_MSOLINE.SuspendLayout()

$buttonDontAsk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonDontAsk.DialogResult = [System.Windows.Forms.DialogResult]::Abort 
$buttonDontAsk.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonDontAsk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(381, 109) 
$buttonDontAsk.Name = 'buttonDontAsk' 
$buttonDontAsk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(142, 35) 
$buttonDontAsk.TabIndex = 27 
$buttonDontAsk.Text = "&Don't Ask Again"
$buttonDontAsk.UseVisualStyleBackColor = $True 
$buttonDontAsk.add_Click($buttonDontAsk_Click)
$buttonYes.DialogResult = [System.Windows.Forms.DialogResult]::Yes 
$buttonYes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonYes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(48, 109) 
$buttonYes.Name = 'buttonYes' 
$buttonYes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(106, 35) 
$buttonYes.TabIndex = 25 
$buttonYes.Text = '&Yes' 
$buttonYes.UseVisualStyleBackColor = $True 
$buttonYes.add_Click($buttonYes_Click)
$labelMSonline.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelMSonline.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(11, 10) 
$labelMSonline.Name = 'labelMSonline' 
$labelMSonline.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(553, 83) 
$labelMSonline.TabIndex = 28 
$labelMSonline.Text = 'MSOnline Module must be updated to at least build 166. Would you like to download it now?' 
$labelMSonline.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonNo.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonNo.DialogResult = [System.Windows.Forms.DialogResult]::No 
$buttonNo.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonNo.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(217, 109) 
$buttonNo.Name = 'buttonNo' 
$buttonNo.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(106, 35) 
$buttonNo.TabIndex = 26 
$buttonNo.Text = '&No' 
$buttonNo.UseVisualStyleBackColor = $True 
$FormPreReqTFA_MSOLINE.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(9, 19) 
$FormPreReqTFA_MSOLINE.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font 
$FormPreReqTFA_MSOLINE.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(574, 155) 
$FormPreReqTFA_MSOLINE.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$FormPreReqTFA_MSOLINE.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$FormPreReqTFA_MSOLINE.Margin = New-Object -TypeName 'System.Windows.Forms.Padding' -ArgumentList @(7, 8, 7, 8) 
$FormPreReqTFA_MSOLINE.MaximizeBox = $False 
$FormPreReqTFA_MSOLINE.MinimizeBox = $False 
$FormPreReqTFA_MSOLINE.Name = 'FormPreReqTFA_MSOLINE' 
$FormPreReqTFA_MSOLINE.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen 
$FormPreReqTFA_MSOLINE.Text = 'MSONLINE 2FA' 
$FormPreReqTFA_MSOLINE.add_Load($FormPreReqTFA_MSOLINE_Load)
$FormPreReqTFA_MSOLINE.Controls.Add($buttonDontAsk)
$FormPreReqTFA_MSOLINE.Controls.Add($buttonYes)
$FormPreReqTFA_MSOLINE.Controls.Add($labelMSonline)
$FormPreReqTFA_MSOLINE.Controls.Add($buttonNo)
$FormPreReqTFA_MSOLINE.ResumeLayout($false) 
}
. InitializeComponent
