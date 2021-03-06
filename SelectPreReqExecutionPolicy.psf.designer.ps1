[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formExecutionPolicy = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonDontAsk = $null
[System.Windows.Forms.Label]$labelMSonline = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$buttonDontAsk = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelMSonline = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formExecutionPolicy.SuspendLayout()

$buttonDontAsk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonDontAsk.DialogResult = [System.Windows.Forms.DialogResult]::Abort 
$buttonDontAsk.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonDontAsk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(368, 85) 
$buttonDontAsk.Name = 'buttonDontAsk' 
$buttonDontAsk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(158, 37) 
$buttonDontAsk.TabIndex = 45 
$buttonDontAsk.Text = "&Don't Ask Again"
$buttonDontAsk.UseVisualStyleBackColor = $True 
$buttonDontAsk.add_Click($buttonDontAsk_Click)
$labelMSonline.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelMSonline.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelMSonline.Name = 'labelMSonline' 
$labelMSonline.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(654, 73) 
$labelMSonline.TabIndex = 46 
$labelMSonline.Text = "Execution Policy must be RemoteSigned or Unrestricted. Please open an elevated PowerShell session and enter 'Set-ExecutionPolicy RemoteSigned' or 'Set-ExecutionPolicy Unrestricted'"
$labelMSonline.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(148, 85) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 44 
$buttonOK.Text = 'OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$buttonOK.add_Click($buttonOK_Click)
$formExecutionPolicy.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formExecutionPolicy.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formExecutionPolicy.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(678, 134) 
$formExecutionPolicy.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formExecutionPolicy.Name = 'formExecutionPolicy' 
$formExecutionPolicy.Text = 'Execution policy' 
$formExecutionPolicy.add_Load($formExecutionPolicy_Load)
$formExecutionPolicy.Controls.Add($buttonDontAsk)
$formExecutionPolicy.Controls.Add($labelMSonline)
$formExecutionPolicy.Controls.Add($buttonOK)
$formExecutionPolicy.ResumeLayout($false) 
}
. InitializeComponent
