[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$UpdateCheck = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonDontAsk = $null
[System.Windows.Forms.Button]$buttonYes = $null
[System.Windows.Forms.Label]$labelUpdateCheck = $null
[System.Windows.Forms.Button]$buttonNo = $null
function InitializeComponent {

$buttonDontAsk = (New-Object -TypeName 'System.Windows.Forms.Button')
$buttonYes = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelUpdateCheck = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonNo = (New-Object -TypeName 'System.Windows.Forms.Button')
$UpdateCheck.SuspendLayout()

$buttonDontAsk.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonDontAsk.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonDontAsk.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(475, 109) 
$buttonDontAsk.Name = 'buttonDontAsk' 
$buttonDontAsk.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(158, 37) 
$buttonDontAsk.TabIndex = 3 
$buttonDontAsk.Text = "&Don't Ask Again"
$buttonDontAsk.UseVisualStyleBackColor = $True 
$buttonDontAsk.add_Click($buttonDontAsk_Click)
$buttonYes.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonYes.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(77, 109) 
$buttonYes.Name = 'buttonYes' 
$buttonYes.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonYes.TabIndex = 1 
$buttonYes.Text = '&Yes' 
$buttonYes.UseVisualStyleBackColor = $True 
$buttonYes.add_Click($buttonYes_Click)
$labelUpdateCheck.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 22) 
$labelUpdateCheck.Name = 'labelUpdateCheck' 
$labelUpdateCheck.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(673, 67) 
$labelUpdateCheck.TabIndex = 29 
$labelUpdateCheck.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonNo.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonNo.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonNo.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(276, 109) 
$buttonNo.Name = 'buttonNo' 
$buttonNo.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonNo.TabIndex = 2 
$buttonNo.Text = "&No"
$buttonNo.UseVisualStyleBackColor = $True 
$buttonNo.add_Click($buttonNo_Click)
$UpdateCheck.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$UpdateCheck.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$UpdateCheck.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(697, 158) 
$UpdateCheck.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$UpdateCheck.Name = 'UpdateCheck' 
$UpdateCheck.Text = 'Update Check' 
$UpdateCheck.add_Load($UpdateCheck_Load)
$UpdateCheck.Controls.Add($buttonDontAsk)
$UpdateCheck.Controls.Add($buttonYes)
$UpdateCheck.Controls.Add($labelUpdateCheck)
$UpdateCheck.Controls.Add($buttonNo)
$UpdateCheck.ResumeLayout($false) 
}
. InitializeComponent
