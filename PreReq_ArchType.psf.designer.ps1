[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$ArchType = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonDontAsk = $null
[System.Windows.Forms.Label]$label = $null
[System.Windows.Forms.Button]$buttonOk = $null
function InitializeComponent {

$buttonDontAsk = (New-Object -TypeName 'System.Windows.Forms.Button')
$label = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOk = (New-Object -TypeName 'System.Windows.Forms.Button')
$ArchType.SuspendLayout()

$buttonDontAsk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonDontAsk.DialogResult = [System.Windows.Forms.DialogResult]::Abort 
$buttonDontAsk.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonDontAsk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(353, 114) 
$buttonDontAsk.Name = 'buttonDontAsk' 
$buttonDontAsk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(160, 37) 
$buttonDontAsk.TabIndex = 2 
$buttonDontAsk.Text = "&Don't Ask Again"
$buttonDontAsk.UseVisualStyleBackColor = $True 
$buttonDontAsk.add_Click($buttonDontAsk_Click)
$label.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$label.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$label.Name = 'label' 
$label.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(614, 85) 
$label.TabIndex = 37 
$label.Text = 'O365 Admin Center detected 32-bit architecture, please run on a 64-bit computer' 
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOk.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOk.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(167, 114) 
$buttonOk.Name = 'buttonOk' 
$buttonOk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOk.TabIndex = 1 
$buttonOk.Text = '&OK' 
$buttonOk.UseVisualStyleBackColor = $True 
$ArchType.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$ArchType.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$ArchType.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(638, 163) 
$ArchType.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$ArchType.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$ArchType.Name = 'ArchType' 
$ArchType.Text = 'ERROR: Architecture Type' 
$ArchType.add_Load($ArchType_Load)
$ArchType.Controls.Add($buttonDontAsk)
$ArchType.Controls.Add($label)
$ArchType.Controls.Add($buttonOk)
$ArchType.ResumeLayout($false) 
}
. InitializeComponent
