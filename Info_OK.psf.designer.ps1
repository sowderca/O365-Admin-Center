[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formInformation = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelInformation = $null
[System.Windows.Forms.Button]$buttonOK = $null
function InitializeComponent {

$labelInformation = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonOK = (New-Object -TypeName 'System.Windows.Forms.Button')
$formInformation.SuspendLayout()

$labelInformation.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelInformation.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelInformation.Name = 'labelInformation' 
$labelInformation.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(431, 56) 
$labelInformation.TabIndex = 46 
$labelInformation.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonOK.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonOK.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonOK.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(157, 76) 
$buttonOK.Name = 'buttonOK' 
$buttonOK.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonOK.TabIndex = 1 
$buttonOK.Text = '&OK' 
$buttonOK.UseVisualStyleBackColor = $True 
$formInformation.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formInformation.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formInformation.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(455, 125) 
$formInformation.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formInformation.Name = 'formInformation' 
$formInformation.Text = 'Information' 
$formInformation.add_Load($formInformation_Load)
$formInformation.Controls.Add($labelInformation)
$formInformation.Controls.Add($buttonOK)
$formInformation.ResumeLayout($false) 
}
. InitializeComponent
