[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formLocationCode = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Label]$labelLocationCode = $null
[System.Windows.Forms.ComboBox]$comboboxSelectLocationCode = $null
[System.Windows.Forms.Button]$buttonCancelformLocationCode = $null
[System.Windows.Forms.Label]$labelSelectLocationCode = $null
[System.Windows.Forms.Button]$buttonformLocationCode = $null
function InitializeComponent {

$labelLocationCode = (New-Object -TypeName 'System.Windows.Forms.Label')
$comboboxSelectLocationCode = (New-Object -TypeName 'System.Windows.Forms.ComboBox')
$buttonCancelformLocationCode = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelSelectLocationCode = (New-Object -TypeName 'System.Windows.Forms.Label')
$buttonformLocationCode = (New-Object -TypeName 'System.Windows.Forms.Button')
$formLocationCode.SuspendLayout()

$labelLocationCode.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelLocationCode.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 99) 
$labelLocationCode.Name = 'labelLocationCode' 
$labelLocationCode.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(164, 27) 
$labelLocationCode.TabIndex = 55 
$labelLocationCode.Text = 'Location Code:' 
$comboboxSelectLocationCode.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$comboboxSelectLocationCode.FormattingEnabled = $True 
$comboboxSelectLocationCode.Items = New-Object -TypeName 'System.Windows.Forms.ComboBox+ObjectCollection' -ArgumentList @(ADAEAFAGAIALAMANAOAQARASATAUAWAXAZBABBBDBEBFBGBHBIBJBLBMBNBOBRBSBTBVBWBYBZCACCCDCFCGCHCICKCLCMCNCOCRCUCVCXCYCZDEDJDKDMDODZECEEEGEHERESETFIFJFKFMFOFRGAGBGDGEGFGGGHGIGLGMGNGPGQGRGSGTGUGWGYHKHMHNHRHTHUIDIEILIMINIOIQIRISITJEJMJOJPKEKGKHKIKMKNKPKRKWKYKZLALBLCLILKLRLSLTLULVLYMAMCMDMEMFMGMHMKMLMMMNMOMPMQMRMSMTMUMVMWMXMYMZNANCNENFNGNINLNONPNRNUNZOMPAPEPFPGPHPKPLPMPNPRPSPTPWPYQARERORSRURWSASBSCSDSESGSHSISJSKSLSMSNSOSRSSSTSVSYSZTCTDTFTGTHTJTKTLTMTNTOTRTTTVTWTZUAUGUMUSUYUZVAVCVEVGVIVNVUWFWSYEYTZAZMZW) 
$comboboxSelectLocationCode.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(196, 99) 
$comboboxSelectLocationCode.Name = 'comboboxSelectLocationCode' 
$comboboxSelectLocationCode.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 29) 
$comboboxSelectLocationCode.Sorted = $True 
$comboboxSelectLocationCode.TabIndex = 53 
$buttonCancelformLocationCode.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformLocationCode.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformLocationCode.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(23, 165) 
$buttonCancelformLocationCode.Name = 'buttonCancelformLocationCode' 
$buttonCancelformLocationCode.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformLocationCode.TabIndex = 56 
$buttonCancelformLocationCode.Text = '&Cancel' 
$buttonCancelformLocationCode.UseVisualStyleBackColor = $True 
$labelSelectLocationCode.FlatStyle = [System.Windows.Forms.FlatStyle]::System 
$labelSelectLocationCode.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelSelectLocationCode.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(12, 9) 
$labelSelectLocationCode.Name = 'labelSelectLocationCode' 
$labelSelectLocationCode.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(302, 76) 
$labelSelectLocationCode.TabIndex = 54 
$labelSelectLocationCode.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$buttonformLocationCode.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformLocationCode.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformLocationCode.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformLocationCode.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(180, 165) 
$buttonformLocationCode.Name = 'buttonformLocationCode' 
$buttonformLocationCode.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformLocationCode.TabIndex = 52 
$buttonformLocationCode.Text = '&OK' 
$buttonformLocationCode.UseVisualStyleBackColor = $True 
$formLocationCode.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formLocationCode.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formLocationCode.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(326, 214) 
$formLocationCode.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formLocationCode.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formLocationCode.Name = 'formLocationCode' 
$formLocationCode.Text = 'Location Code' 
$formLocationCode.add_Load($formLocationCode_Load)
$formLocationCode.Controls.Add($labelLocationCode)
$formLocationCode.Controls.Add($comboboxSelectLocationCode)
$formLocationCode.Controls.Add($buttonCancelformLocationCode)
$formLocationCode.Controls.Add($labelSelectLocationCode)
$formLocationCode.Controls.Add($buttonformLocationCode)
$formLocationCode.ResumeLayout($false) 
}
. InitializeComponent
