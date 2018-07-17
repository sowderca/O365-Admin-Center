[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formERRORSharePoint = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonDontAsk = $null
[System.Windows.Forms.Button]$buttonYes = $null
[System.Windows.Forms.Label]$label = $null
[System.Windows.Forms.Button]$buttonNo = $null
function InitializeComponent {

$buttonDontAsk = (New-Object -TypeName 'System.Windows.Forms.Button')
$buttonYes = (New-Object -TypeName 'System.Windows.Forms.Button')
$label = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonNo = (New-Object -TypeName 'System.Windows.Forms.Button')
$formERRORSharePoint.SuspendLayout()

$buttonDontAsk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonDontAsk.DialogResult = [System.Windows.Forms.DialogResult]::Abort 
$buttonDontAsk.FlatStyle = [System.Windows.Forms.FlatStyle]::System 
$buttonDontAsk.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonDontAsk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(467, 109) 
$buttonDontAsk.Name = 'buttonDontAsk' 
$buttonDontAsk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(158, 37) 
$buttonDontAsk.TabIndex = 3 
$buttonDontAsk.Text = "&Don't Ask Again"
$buttonDontAsk.UseVisualStyleBackColor = $True 
$buttonDontAsk.add_Click($buttonDontAsk_Click)
$buttonYes.DialogResult = [System.Windows.Forms.DialogResult]::Yes 
$buttonYes.FlatStyle = [System.Windows.Forms.FlatStyle]::System 
$buttonYes.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonYes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(77, 109) 
$buttonYes.Name = 'buttonYes' 
$buttonYes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonYes.TabIndex = 1 
$buttonYes.Text = '&Yes' 
$buttonYes.UseVisualStyleBackColor = $True 
$buttonYes.add_Click($buttonYes_Click)
$label.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$label.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$label.Name = 'label' 
$label.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(673, 97) 
$label.TabIndex = 33 
$label.Text = 'SharePoint Online module appears to not be installed. This module must be installed to continue. Would you like to install it now?' 
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonNo.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonNo.DialogResult = [System.Windows.Forms.DialogResult]::No 
$buttonNo.FlatStyle = [System.Windows.Forms.FlatStyle]::System 
$buttonNo.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonNo.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(276, 109) 
$buttonNo.Name = 'buttonNo' 
$buttonNo.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonNo.TabIndex = 2 
$buttonNo.Text = '&No' 
$buttonNo.UseVisualStyleBackColor = $True 
$formERRORSharePoint.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formERRORSharePoint.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formERRORSharePoint.BackColor = [System.Drawing.Color]::WhiteSmoke 
$formERRORSharePoint.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(697, 158) 
$formERRORSharePoint.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$formERRORSharePoint.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formERRORSharePoint.Name = 'formERRORSharePoint' 
$formERRORSharePoint.Text = 'ERROR: SharePoint' 
$formERRORSharePoint.add_Load($formERRORSharePoint_Load)
$formERRORSharePoint.Controls.Add($buttonDontAsk)
$formERRORSharePoint.Controls.Add($buttonYes)
$formERRORSharePoint.Controls.Add($label)
$formERRORSharePoint.Controls.Add($buttonNo)
$formERRORSharePoint.ResumeLayout($false) 
}
. InitializeComponent
