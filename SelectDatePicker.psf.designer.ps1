[void][System.Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][System.Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formDatePicker = New-Object -TypeName 'System.Windows.Forms.Form'
[System.Windows.Forms.Button]$buttonCancelformStartDate = $null
[System.Windows.Forms.Button]$buttonformStartDate = $null
[System.Windows.Forms.Label]$labelStartDate = $null
[System.Windows.Forms.MonthCalendar]$monthcalendar1 = $null
function InitializeComponent {

$buttonCancelformStartDate = (New-Object -TypeName 'System.Windows.Forms.Button')
$buttonformStartDate = (New-Object -TypeName 'System.Windows.Forms.Button')
$labelStartDate = (New-Object -TypeName 'System.Windows.Forms.Label')
$monthcalendar1 = (New-Object -TypeName 'System.Windows.Forms.MonthCalendar')
$formDatePicker.SuspendLayout()

$buttonCancelformStartDate.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$buttonCancelformStartDate.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonCancelformStartDate.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(18, 358) 
$buttonCancelformStartDate.Name = 'buttonCancelformStartDate' 
$buttonCancelformStartDate.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonCancelformStartDate.TabIndex = 48 
$buttonCancelformStartDate.Text = '&Cancel' 
$buttonCancelformStartDate.UseVisualStyleBackColor = $True 
$buttonformStartDate.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
$buttonformStartDate.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$buttonformStartDate.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$buttonformStartDate.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(211, 358) 
$buttonformStartDate.Name = 'buttonformStartDate' 
$buttonformStartDate.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(118, 37) 
$buttonformStartDate.TabIndex = 47 
$buttonformStartDate.Text = '&OK' 
$buttonformStartDate.UseVisualStyleBackColor = $True 
$buttonformStartDate.add_Click($buttonformStartDate_Click)
$labelStartDate.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$labelStartDate.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(18, 13) 
$labelStartDate.Name = 'labelStartDate' 
$labelStartDate.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(311, 72) 
$labelStartDate.TabIndex = 1 
$labelStartDate.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft 
$monthcalendar1.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI',  8) 
$monthcalendar1.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(18, 94) 
$monthcalendar1.MaxSelectionCount = 1 
$monthcalendar1.Name = 'monthcalendar1' 
$monthcalendar1.TabIndex = 0 
$formDatePicker.AutoScaleDimensions = New-Object -TypeName 'System.Drawing.SizeF' -ArgumentList @(144, 144) 
$formDatePicker.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi 
$formDatePicker.ClientSize = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(350, 407) 
$formDatePicker.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Arial',  8.25) 
$formDatePicker.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
$formDatePicker.Name = 'formDatePicker' 
$formDatePicker.Text = 'Date Picker' 
$formDatePicker.add_Load($formDatePicker_Load)
$formDatePicker.Controls.Add($buttonCancelformStartDate)
$formDatePicker.Controls.Add($buttonformStartDate)
$formDatePicker.Controls.Add($labelStartDate)
$formDatePicker.Controls.Add($monthcalendar1)
$formDatePicker.ResumeLayout($false) 
}
. InitializeComponent
