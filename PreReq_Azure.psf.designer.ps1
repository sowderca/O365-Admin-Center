[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$PreReq_Azure = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonDontAsk = $null
[System.Windows.Forms.Button]$buttonYes = $null
[System.Windows.Forms.Label]$labelAzure = $null
[System.Windows.Forms.Button]$buttonNo = $null
function InitializeComponent {

$buttonDontAsk = (New-Object -TypeName 'System.Windows.Forms.Button')
$buttonYes = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelAzure = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonNo = (New-Object -TypeName 'System.Windows.Forms.Button')
$PreReq_Azure.SuspendLayout()

$buttonDontAsk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonDontAsk.DialogResult = [System.Windows.Forms.DialogResult]::Abort 
$buttonDontAsk.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonDontAsk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(477, 109) 
$buttonDontAsk.Name = 'buttonDontAsk' 
$buttonDontAsk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(158, 37) 
$buttonDontAsk.TabIndex = 3 
$buttonDontAsk.Text = "&Don't Ask Again"
$buttonDontAsk.UseVisualStyleBackColor = $True 
$buttonDontAsk.add_Click($buttonDontAsk_Click)
$buttonYes.DialogResult = [System.Windows.Forms.DialogResult]::Yes 
$buttonYes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonYes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(87, 109) 
$buttonYes.Name = 'buttonYes' 
$buttonYes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonYes.TabIndex = 1 
$buttonYes.Text = '&Yes' 
$buttonYes.UseVisualStyleBackColor = $True 
$buttonYes.add_Click($buttonYes_Click)
$labelAzure.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelAzure.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelAzure.Name = 'labelAzure' 
$labelAzure.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(673, 97) 
$labelAzure.TabIndex = 29 
$labelAzure.Text = 'Azure module appears to not be installed. This module must be installed to continue. Would you like to install it now?' 
$labelAzure.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$labelAzure.add_Click($labelAzure_Click)
$buttonNo.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonNo.DialogResult = [System.Windows.Forms.DialogResult]::No 
$buttonNo.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonNo.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(282, 109) 
$buttonNo.Name = 'buttonNo' 
$buttonNo.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonNo.TabIndex = 2 
$buttonNo.Text = '&No' 
$buttonNo.UseVisualStyleBackColor = $True 
$PreReq_Azure.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$PreReq_Azure.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$PreReq_Azure.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(697, 158) 
$PreReq_Azure.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$PreReq_Azure.ForeColor = [System.Drawing.Color]::Black 
$PreReq_Azure.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$PreReq_Azure.Name = 'PreReq_Azure' 
$PreReq_Azure.Text = 'ERROR: Azure' 
$PreReq_Azure.add_Load($PreReq_Azure_Load)
$PreReq_Azure.Controls.Add($buttonDontAsk)
$PreReq_Azure.Controls.Add($buttonYes)
$PreReq_Azure.Controls.Add($labelAzure)
$PreReq_Azure.Controls.Add($buttonNo)
$PreReq_Azure.ResumeLayout($false) 
}
. InitializeComponent
