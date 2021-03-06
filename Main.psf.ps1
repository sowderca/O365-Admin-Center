#region Control Helper Functions
function Load-ComboBox
{
<#
	.SYNOPSIS
		This functions helps you load items into a ComboBox.

	.DESCRIPTION
		Use this function to dynamically load items into the ComboBox control.

	.PARAMETER  ComboBox
		The ComboBox control you want to add items to.

	.PARAMETER  Items
		The object or objects you wish to load into the ComboBox's Items collection.

	.PARAMETER  DisplayMember
		Indicates the property to display for the items in this control.
	
	.PARAMETER  Append
		Adds the item(s) to the ComboBox without clearing the Items collection.
	
	.EXAMPLE
		Load-ComboBox $combobox1 "Red", "White", "Blue"
	
	.EXAMPLE
		Load-ComboBox $combobox1 "Red" -Append
		Load-ComboBox $combobox1 "White" -Append
		Load-ComboBox $combobox1 "Blue" -Append
	
	.EXAMPLE
		Load-ComboBox $combobox1 (Get-Process) "ProcessName"
#>
	Param (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ComboBox]$ComboBox,
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		$Items,
		[Parameter(Mandatory = $false)]
		[string]$DisplayMember,
		[switch]$Append
	)
	
	if (-not $Append)
	{
		$ComboBox.Items.Clear()
	}
	
	if ($Items -is [Object[]])
	{
		$ComboBox.Items.AddRange($Items)
	}
	elseif ($Items -is [Array])
	{
		$ComboBox.BeginUpdate()
		foreach ($obj in $Items)
		{
			$ComboBox.Items.Add($obj)
		}
		$ComboBox.EndUpdate()
	}
	else
	{
		$ComboBox.Items.Add($Items)
	}
	
	$ComboBox.DisplayMember = $DisplayMember
}
#endregion

###GLOBAL Static VARIABLES###

#Version information
$Version = "4.1.2.0"
$UpdateDate = "4/27/2017"

$TempDir = $env:temp
$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")


###FORM ITEMS###

	#Form

$FormO365AdministrationCenter_Load = {
	$FormO365AdministrationCenter.Cursor = 'Default'
	
	$TenantConnectButton.Enabled = $False
	$PartnerComboBox.Enabled = $False
	
	$ArchPreReqPrompt = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name DisableArchPrompt).DisableArchPrompt
	#Arch Type
	$Archtype = ((Get-WmiObject Win32_OperatingSystem).OSArchitecture)
	
	
	If (($Archtype -eq '32-bit') -and ($ArchPreReqPrompt -ne 1))
	{
		Show-PreReq_ArchType_psf
		$FormO365AdministrationCenter.close()
	}
	Else
	{
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableArchPrompt -Value 1 -Force | Out-Null
	}
	
	#Sets the text for the button
	$ButtonConnectTo365.Text = "Connect to Office 365"
	
	#Sets the text for the button
	$ButtonDisconnect.Text = "Disconnect"
	
	#Sets the text for the form
	$FormO365AdministrationCenter.Text = "O365 Admin Center"
	
	#Allows copy/paste in the texbpx
	$TextboxResults.ShortcutsEnabled = $True
	
	#Sets the dialog result
	$ButtonRunCustomCommand.DialogResult = 'None'
	
	#Sets the default button
	$FormO365AdministrationCenter.acceptbutton = $ButtonRunCustomCommand
	
	#Disabled disconnect from partner button
	$ButtonDisconnect.Enabled = $False
	
	#Alphabitcally sorts combobox
	$PartnerComboBox.Sorted = $True
	
	#Disables word wrap on the text box
	$TextboxResults.WordWrap = $False
	
	#Disables the disconnect button
	$ButtonDisconnect.Enabled = $False
	
	#$ButtonConnectTo365.Enabled = $false 
	
	#Place objects on the bottom
	$ButtonConnectTo365.Anchor = 'Bottom'
	$Partner_Groupbox.Anchor = 'Bottom'
	$ButtonDisconnect.Anchor = 'Bottom'
	$ButtonRunCustomCommand.Anchor = 'Bottom'
	$groupboxO365Services.Anchor = 'Bottom'
	$TabPageMaster.Anchor = 'Bottom, Top, Left, Right'
	
	#$menustripCompliance.Size = "991, 24"
	
	#Make form sizable
	$FormO365AdministrationCenter.FormBorderStyle = 'Sizable'
	
	#Hide the progrss bar
	$progressbar1.Visible = $false
	
	
}

$PartnerComboBox_SelectedIndexChanged = {
	$checkboxComplianceCenter.Checked = $false
	$checkboxExchangeOnline.Checked = $true
	$checkboxSharepoint.Checked = $false
	$checkboxSkypeForBusiness.Checked = $false
	
	
}

$saveToFileToolStripMenuItem_Click = {
	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to File"
	$savedialog.filter = ".doc|*.doc|.txt|*.txt|.xls|*.xls"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		$TextboxResults.Text | out-file -Encoding Default $savedialog.filename
		
	}
	
}

$printToolStripMenuItem_Click = {
	$Printdialog = New-Object System.Windows.Forms.PrintDialog
	$Printdialog.ShowHelp = $False
	$Printdialog.AllowSelection = $true
	$Printdialog.AllowPrintToFile = $true
	$Printdialog.AllowSomePages = $false
	$Printdialog.ShowNetwork = $true
	$result = $Printdialog.ShowDialog(); $result
	If ($result -eq 'OK')
	{
		$TextboxResults.Text | Out-Printer $Printdialog.PrinterSettings.PrinterName
	}
	
}

$disconnectToolStripMenuItem_Click = {
	$FormO365AdministrationCenter.Cursor = 'WaitCursor'
	$TextboxResults.Text = ""
	$textboxDetails.Text = ""
	
	#Disconnects O365 Session
	Get-PSSession | Remove-PSSession
	
	#Enables the connect to partner Button
	#$PartnerConnectButton.Enabled = $True
	#Disabled the disconnect from partner button
	#$ButtonDisconnect.Enabled = $False
	#Sets custom button text
	$TenantConnectButton.Text = "Connect to Partner"
	#Sets the form name
	$FormO365AdministrationCenter.Text = "O365 Admin Center"
	#Enables the partner combobox
	$PartnerComboBox.Enabled = $True
	#Enables the connect to o365 button
	$ButtonConnectTo365.Enabled = $True
	#Clears the combobox
	#$PartnerComboBox.Items.clear()
		<# Creates a pop up box telling the user they are disconnected from the o365 session. This is commented out as it will show True every time as the command will never error out even if there 
		is no session to disconnect from #>
	#[void][System.Windows.Forms.MessageBox]::Show("You are disconnected from O365", "Message")
	
	$checkboxComplianceCenter.Checked = $false
	$checkboxExchangeOnline.Checked = $false
	$checkboxSharepoint.Checked = $false
	$checkboxSkypeForBusiness.Checked = $false
	$checkboxComplianceCenter.Enabled = $true
	$checkboxExchangeOnline.Enabled = $true
	$checkboxSharepoint.Enabled = $true
	$checkboxSkypeForBusiness.Enabled = $true
	$TenantConnectButton.Enabled = $True
	$FormO365AdministrationCenter.Cursor = 'Default'
	
}

$exitToolStripMenuItem_Click = {
	#Remove session
	Get-PSSession | Remove-PSSession
	
	#Deletes the old cached files
	$CachedFiles = ("$TempDir" + "\O365AdminCenter")
	Remove-Item $CachedFiles\* -recurse
	
	$FormO365AdministrationCenter.Close()
}

	#Buttons

$ButtonDisconnect_Click = {
	$TenantStatus = Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name TenantStatus | Select-Object -ExpandProperty TenantStatus
	If ($Tenantstatus -eq 1)
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		#Clear textboxes 
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		
		#Show progress bar
		$progressbar1.Visible = $true
		
		#Disconnects O365 Session
		$progressbar1.Value = 90
		Get-PSSession | Remove-PSSession
		$progressbar1.Value = 95
		
		#Sets custom button text
		$TenantConnectButton.Text = "Connect to Partner"
		$TenantConnectButton.Enabled = $True
		
		#Sets the form name
		$FormO365AdministrationCenter.Text = "O365 Admin Center"
		
		$PartnerComboBox.Enabled = $true
		
		#Enable the connect to tenant button
		#$TenantConnectButton.Enabled = $true
		
		$checkboxExchangeOnline.Checked = $true
		$checkboxComplianceCenter.Enabled = $false
		$checkboxExchangeOnline.Enabled = $false
		$checkboxSharepoint.Enabled = $false
		$checkboxSkypeForBusiness.Enabled = $false
		$progressbar1.Value = 100
		#Hide the progress bar
		$progressbar1.Visible = $false
		
		Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 0 -Force | Out-Null
		
		$ButtonDisconnect.Text = "Disconnect"
		
		$CachedPF = ("$TempDir" + "\O365AdminCenter" + "\pf.txt")
		If ((Test-Path $CachedPF) -eq $true)
		{
			Remove-Item $CachedPF -Force -Confirm:$false
		}
		Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
		Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Else
	{
		#Clears the combobox
		#$PartnerComboBox.Text = ""
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		#Clear textboxes 
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		
		#Show progress bar
		$progressbar1.Visible = $true
		
		#Disconnects O365 Session
		$progressbar1.Value = 90
		Get-PSSession | Remove-PSSession
		$progressbar1.Value = 95
		
		#Sets custom button text
		$TenantConnectButton.Text = "Connect to Partner"
		$TenantConnectButton.Enabled = $False
		$PartnerComboBox.Enabled = $False
		
		#Sets the form name
		$FormO365AdministrationCenter.Text = "O365 Admin Center"
		
		#Enables the partner combobox
		$PartnerComboBox.Enabled = $True
		$PartnerComboBox.Text = ""
		
		#Enable the connect to tenant button
		#$TenantConnectButton.Enabled = $true
		
		#Enables the connect to o365 button
		$ButtonConnectTo365.Enabled = $True
		$ButtonConnectTo365.Text = "Connect to O365"
		
		$ButtonDisconnect.Enabled = $False
		
		
		#Disables tenant combobox
		$PartnerComboBox.Enabled = $False
		
		$checkboxComplianceCenter.Checked = $false
		$checkboxExchangeOnline.Checked = $false
		$checkboxSharepoint.Checked = $false
		$checkboxSkypeForBusiness.Checked = $false
		$checkboxComplianceCenter.Enabled = $true
		$checkboxExchangeOnline.Enabled = $true
		$checkboxSharepoint.Enabled = $true
		$checkboxSkypeForBusiness.Enabled = $true
		#$TenantConnectButton.Enabled = $True
		$progressbar1.Value = 100
		
		#Hide the progress bar
		$progressbar1.Visible = $false
		
		Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 0 -Force | Out-Null
		
		$ButtonDisconnect.Text = "Disconnect"
		
		$CachedPF = ("$TempDir" + "\O365AdminCenter" + "\pf.txt")
		If ((Test-Path $CachedPF) -eq $true)
		{
			Remove-Item $CachedPF -Force -Confirm:$false
		}
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
}

$ButtonConnectTo365_Click = {
	$AzurePreReqPrompt = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name DisableAzurePrompt).DisableAzurePrompt
	$MSOnlinePreReqPrompt = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name DisableMSOnlinePrompt).DisableMSOnlinePrompt
	$SkypeOnlineConnectorPreReqPrompt = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name DisableSkypeOnlineConnectorPrompt).DisableSkypeOnlineConnectorPrompt
	$SharePointPreReqPrompt = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name DisableSharePointOnlinePrompt).DisableSharePointOnlinePrompt
	$ExecutionPolicy = Get-ExecutionPolicy
	$ExecutionPolicyPreReq = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name ExecutionPolicy).ExecutionPolicy
	$SignOnAss = Get-ItemProperty HKLM:\SOFTWARE\Classes\Installer\Products\0B39BA8DFBF60A4479F10C66B9A56EDD -Name ProductName | Select-Object -ExpandProperty ProductName
	$2FA = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name TFA).TFA
	$2FAPath = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name TFAPath).TFAPath
	$TFAMSONLINE = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name DisableMSOnlineTFA).DisableMSOnlineTFA
	try
	{
		If ($checkboxComplianceCenter.Checked -eq $False -and $checkboxExchangeOnline.Checked -eq $False -and $checkboxSharepoint.Checked -eq $False -and $checkboxSkypeForBusiness.Checked -eq $False)
		{
			[System.Windows.Forms.MessageBox]::Show("Please select a service to connect to", "Error")
		}
		ElseIf ($2FA -eq 1)
		{
			If ((((Get-Module -ListAvailable -Name MSOnline).Version.Build) -ge 166 ) -or ($TFAMSONLINE -eq 1) )
			{
				$Path = (Get-ChildItem -Recurse -Force "$env:LOCALAPPDATA\Apps\2.0" -ErrorAction SilentlyContinue | Where-Object { ($_.PSIsContainer -eq $false) -and ($_.Name -contains "Microsoft.Online.CSE.PSModule.Client.cdf-ms") }).Fullname
				$CleanPath = ($Path.TrimEnd("\Microsoft.Online.CSE.PSModule.Client.cdf-ms")) + "\"
				If ($2FAPath -notcontains "Apps")
				{
					
					#Show progress bar
					$progressbar1.Visible = $true
					
					#Disable the connect to o365 button
					$ButtonConnectTo365.Enabled = $False
					
					#Enable the disconnect button
					$ButtonDisconnect.Enabled = $True
					
					#Disable the checkboxes
					$checkboxExchangeOnline.Enabled = $False
					$checkboxSkypeForBusiness.Checked = $false
					$checkboxSkypeForBusiness.Enabled = $False
					$checkboxSharepoint.Checked = $False
					$checkboxSharepoint.Enabled = $False
					$checkboxComplianceCenter.Checked = $False
					$checkboxComplianceCenter.Enabled = $False
					
					$progressbar1.Value = 10
					$TextboxResults.Text = "Saving Module Path..."
					Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name 2FAPath -Value $CleanPath -Force | Out-Null
					$TextboxResults.Text = "Changing folder to 2FA Module..."
					Set-Location $CleanPath
					$progressbar1.Value = 20
					$TextboxResults.Text = "Importing 2FA Module..."
					Import-Module .\CreateExoPSSession.ps1
					$progressbar1.Value = 30
					$TextboxResults.Text = "Connecting to Office 365..."
					Connect-EXOPSSession
					$progressbar1.Value = 40
					Connect-MsolService
					#Change button text
					$ButtonConnectTo365.Text = "Connected to O365"
					$progressbar1.Value = 42
					#The first checked check box for services will load the appropriate tab as default. 
					
					$TabPageMaster.SelectedTab = $tabpageExchangeOnline
					
					$progressbar1.Value = 50
					#Set Tenant Status to 0 as we have not connected to any tenants yet
					Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 0 -Force | Out-Null
					$progressbar1.Value = 60
					
					$partnerTIDs = Get-MsolPartnerContract -All | Select-Object TenantID
					$progressbar1.Value = 70
					
					#If tenant domains are available then load combobox with all tenants
					<#
					If ($partnerTIDs -ne $Null)
					{
						#Enables the Tenant button
						$TenantConnectButton.Enabled = $True
						$PartnerComboBox.Enabled = $True
						
						$domains = @()
						foreach ($TID in $partnerTIDs)
						{
							$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.IsDefault -eq 'True' }
							#$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.Name -notlike '*.onmicrosoft*' -and $_.Name -notlike '*.microsoftonline*' -and $_.Status -eq "Verified" }
							#$domainName = Get-MsolDomain -TenantId $TID.TenantId
							$domain = New-Object -TypeName PSObject
							$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value ($domainName.Name | Select-Object -First 1) #Deals with Tenants with multiple domain names asociated
							#$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value $domainName.Name
							$domain | Add-Member -Name TenantID -MemberType NoteProperty -Value $TID.TenantId
							$domains += $domain
						}
						$progressbar1.Value = 60
						#Loads Combobox with Tenants
						Load-ComboBox $PartnerComboBox $domains -DisplayMember Name
						
						#Enable the connect to tenant button
						$TenantConnectButton.Enabled = $true
					}
					
					#If no tenant domains are available then do the following
					Else
					{
						#Clear the combobox of items
						$PartnerComboBox.Text = ""
						
						#Disable combobox
						$PartnerComboBox.Enabled = $False
						
						#Disable the connect to tenant button
						$TenantConnectButton.Enabled = $false
					}
					#>
					#Clear the combobox of items
					$PartnerComboBox.Text = ""
					
					#Disable combobox
					$PartnerComboBox.Enabled = $False
					
					#Disable the connect to tenant button
					$TenantConnectButton.Enabled = $false
					
					$progressbar1.Value = 80
					
					
					
					$TextboxResults.Text = "Caching Users..."
					$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
					$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
					Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
					$progressbar1.Value = 100
					$progressbar1.Enabled = $false
					
					$TextboxResults.Text = ""
				}
				Else
				{
					
					#Show progress bar
					$progressbar1.Visible = $true
					
					#Disable the connect to o365 button
					$ButtonConnectTo365.Enabled = $False
					
					#Enable the disconnect button
					$ButtonDisconnect.Enabled = $True
					
					#Disable the checkboxes
					#Disable the checkboxes
					$checkboxExchangeOnline.Enabled = $False
					$checkboxSkypeForBusiness.Checked = $false
					$checkboxSkypeForBusiness.Enabled = $False
					$checkboxSharepoint.Checked = $False
					$checkboxSharepoint.Enabled = $False
					$checkboxComplianceCenter.Checked = $False
					$checkboxComplianceCenter.Enabled = $False
					$progressbar1.Value = 10
					
					$TextboxResults.Text = "Changing folder to 2FA Module..."
					Set-Location $CleanPath
					$progressbar1.Value = 20
					$TextboxResults.Text = "Importing 2FA Module..."
					Import-Module .\CreateExoPSSession.ps1
					$progressbar1.Value = 30
					$TextboxResults.Text = "Connecting to Office 365"
					Connect-EXOPSSession
					$progressbar1.Value = 40
					Connect-MsolService
					#Change button text
					$ButtonConnectTo365.Text = "Connected to O365"
					$progressbar1.Value = 42
					#The first checked check box for services will load the appropriate tab as default. 
					
					$TabPageMaster.SelectedTab = $tabpageExchangeOnline
					
					$progressbar1.Value = 50
					#Set Tenant Status to 0 as we have not connected to any tenants yet
					Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 0 -Force | Out-Null
					$progressbar1.Value = 60
					
					$partnerTIDs = Get-MsolPartnerContract -All | Select-Object TenantID
					$progressbar1.Value = 70
					
					<#
					#If tenant domains are available then load combobox with all tenants
					If ($partnerTIDs -ne $Null)
					{
						#Enables the Tenant button
						$TenantConnectButton.Enabled = $True
						$PartnerComboBox.Enabled = $True
						
						$domains = @()
						foreach ($TID in $partnerTIDs)
						{
							$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.IsDefault -eq 'True' }
							#$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.Name -notlike '*.onmicrosoft*' -and $_.Name -notlike '*.microsoftonline*' -and $_.Status -eq "Verified" }
							#$domainName = Get-MsolDomain -TenantId $TID.TenantId
							$domain = New-Object -TypeName PSObject
							$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value ($domainName.Name | Select-Object -First 1) #Deals with Tenants with multiple domain names asociated
							#$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value $domainName.Name
							$domain | Add-Member -Name TenantID -MemberType NoteProperty -Value $TID.TenantId
							$domains += $domain
						}
						$progressbar1.Value = 60
						#Loads Combobox with Tenants
						Load-ComboBox $PartnerComboBox $domains -DisplayMember Name
						
						#Enable the connect to tenant button
						$TenantConnectButton.Enabled = $true
					}
					
					#If no tenant domains are available then do the following
					Else
					{
						#Clear the combobox of items
						$PartnerComboBox.Text = ""
						
						#Disable combobox
						$PartnerComboBox.Enabled = $False
						
						#Disable the connect to tenant button
						$TenantConnectButton.Enabled = $false
					}
					#>
					
					#Clear the combobox of items
					$PartnerComboBox.Text = ""
					
					#Disable combobox
					$PartnerComboBox.Enabled = $False
					
					#Disable the connect to tenant button
					$TenantConnectButton.Enabled = $false
					
					$progressbar1.Value = 80
					
					
					
					$TextboxResults.Text = "Caching Users..."
					$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
					$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
					Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
					$progressbar1.Value = 100
					$progressbar1.Enabled = $false
					
					$TextboxResults.Text = ""
				}
			}
			Else
			{
			Show-PreReqTFA_MSONLINE_psf
			}
		}
		Else
		{
			If (($ExecutionPolicy -eq "RemoteSigned") -or ($ExecutionPolicy -eq "Unrestricted") -or ($ExecutionPolicyPreReq -eq 1))
			{
				$CredMem = (Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name CredMem).CredMem
				If (!$CredMem)
				{
					$global:o365credentials = (Get-Credential -Message "Please enter your Office 365 credentials")
					Show-CachedCreds_psf
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Connecting to Office 365..."
					
					If (($SignOnAss -ne $Null) -or ($MSOnlinePreReqPrompt -eq 1))
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 1 -Force | Out-Null
						
						#$TextboxResults.Text = "Checking for the Azure module..."
						If ((Get-Module -ListAvailable -Name MSOnline) -or ($AzurePreReqPrompt -eq 1))
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 1 -Force | Out-Null
							
							#Show progress bar
							$progressbar1.Visible = $true
							
							#$TextboxResults.Text = "Connecting to O365..."
							$Ranges = 1 .. 50
							foreach ($range in $ranges)
							{
								$progressbar1.Value = $Range
							}
							
							Connect-MsolService -Credential $global:o365credentials
							$progressbar1.Value = 50
							
							
							#Disable the connect to o365 button
							$ButtonConnectTo365.Enabled = $False
							
							#Enable the disconnect button
							$ButtonDisconnect.Enabled = $True
							
							#Disable the checkboxes
							$checkboxExchangeOnline.Enabled = $false
							$checkboxSkypeForBusiness.Enabled = $false
							$checkboxSharepoint.Enabled = $false
							$checkboxComplianceCenter.Enabled = $False
							$progressbar1.Value = 51
							#Change button text
							$ButtonConnectTo365.Text = "Connected to O365"
							$progressbar1.Value = 52
							#The first checked check box for services will load the appropriate tab as default. 
							If ($checkboxComplianceCenter.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageComplianceCenter
							}
							elseif ($checkboxExchangeOnline.Checked)
							{
								$TabPageMaster.SelectedTab = $tabpageExchangeOnline
							}
							elseif ($checkboxSharepoint.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageSharePoint
							}
							elseif ($checkboxSkypeForBusiness.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageSkypeForBusiness
							}
							$progressbar1.Value = 53
							#Set Tenant Status to 0 as we have not connected to any tenants yet
							Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 0 -Force | Out-Null
							$progressbar1.Value = 54
							
							$partnerTIDs = Get-MsolPartnerContract -All | Select-Object TenantID
							$progressbar1.Value = 55
							
							#If tenant domains are available then load combobox with all tenants
							If ($partnerTIDs -ne $Null)
							{
								#Enables the Tenant button
								$TenantConnectButton.Enabled = $True
								$PartnerComboBox.Enabled = $True
								
								$domains = @()
								foreach ($TID in $partnerTIDs)
								{
									$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.IsDefault -eq 'True' }
									#$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.Name -notlike '*.onmicrosoft*' -and $_.Name -notlike '*.microsoftonline*' -and $_.Status -eq "Verified" }
									#$domainName = Get-MsolDomain -TenantId $TID.TenantId
									$domain = New-Object -TypeName PSObject
									$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value ($domainName.Name | Select-Object -First 1) #Deals with Tenants with multiple domain names asociated
									#$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value $domainName.Name
									$domain | Add-Member -Name TenantID -MemberType NoteProperty -Value $TID.TenantId
									$domains += $domain
								}
								$progressbar1.Value = 60
								#Loads Combobox with Tenants
								Load-ComboBox $PartnerComboBox $domains -DisplayMember Name
								
								#Enable the connect to tenant button
								$TenantConnectButton.Enabled = $true
							}
							
							#If no tenant domains are available then do the following
							Else
							{
								#Clear the combobox of items
								$PartnerComboBox.Text = ""
								
								#Disable combobox
								$PartnerComboBox.Enabled = $False
								
								#Disable the connect to tenant button
								$TenantConnectButton.Enabled = $false
							}
							
							$progressbar1.Value = 65
							
							#If compliance center checkbox is checked
							If ($checkboxComplianceCenter.Checked)
							{
								$TextboxResults.Text = "Connecting to Compliance Center..."
								$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
								Import-PSSession $ccSession
								$TextboxResults.Text = ""
							}
							
							$progressbar1.Value = 70
							
							#If exchange online checkbox is checked
							If ($checkboxExchangeOnline.Checked)
							{
								
								$TextboxResults.Text = "Connecting to Exchange Online..."
								$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
								Import-PSSession $exchangeSession -AllowClobber
								
								
								$TextboxResults.Text = "Caching Users..."
								$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
								$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
								Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
								
								
								$TextboxResults.Text = ""
							}
							
							$progressbar1.Value = 80
							
							If ($checkboxSharepoint.Checked -and $checkboxExchangeOnline.Checked)
							{
								$TextboxResults.Text = "Checking for the SharePoint Online module..."
								if ((Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) -or ($SharePointPreReqPrompt -eq 1))
								{
									Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 1 -Force | Out-Null
									
									$TextboxResults.Text = "Connecting to SharePoint Online..."
									#Grabs the Sharepoint URL attribtue with Absoluteuri header
									$SPOheaders = Get-OrganizationConfig | Select-Object -ExpandProperty SharepointUrl
									#Clears the header so we have a clean variable
									$SPOSite = $SPOheaders | Select-Object -ExpandProperty AbsoluteUri
									#Splits the URl into two parts so we can inject -admin
									$firsthalf = $SPOSite -split ('.sharepoint.com') | Select-Object -First 1
									$secondhalf = $SPOSite -split '(.sharepoint.com/)' | Select-Object -Last 2
									#Wrap it all up into a single URL with the -admin
									$SPOadminSite = "$Firsthalf" + "-admin" + "$secondhalf"
									$TextboxResults.Text = "Connecting to Sharepoint Online..."
									Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
									Connect-SPOService -Url $SPOadminSite -credential $global:o365credentials
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreRep_SharePoint_psf
								}
							}
							
							#If sharepoint checkbox is checked
							If ($checkboxSharepoint.Checked)
							{
								$TextboxResults.Text = "Checking for the SharePoint Online module..."
								if ((Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) -or ($SharePointPreReqPrompt -eq 1))
								{
									#$Sharepointdomain = Read-Host "Enter the domain name. EX: contoso, yahoo"
									#Connect to Exchange online so we can grab the Sharepoint URL attribute 
									$TextboxResults.Text = "Connecting to SharePoint Online..."
									$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
									Import-PSSession $exchangeSession -AllowClobber
									$progressbar1.Value = 83
									#Grabs the Sharepoint URL attribtue with Absoluteuri header
									$SPOheaders = Get-OrganizationConfig | Select-Object -ExpandProperty SharepointUrl
									#Clears the header so we have a clean variable
									$SPOSite = $SPOheaders | Select-Object -ExpandProperty AbsoluteUri
									#Splits the URl into two parts so we can inject -admin
									$firsthalf = $SPOSite -split ('.sharepoint.com') | Select-Object -First 1
									$secondhalf = $SPOSite -split '(.sharepoint.com/)' | Select-Object -Last 2
									#Wrap it all up into a single URL with the -admin
									$SPOadminSite = "$Firsthalf" + "-admin" + "$secondhalf"
									$TextboxResults.Text = "Connecting to Sharepoint Online..."
									Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
									Connect-SPOService -Url $SPOadminSite -credential $global:o365credentials
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreRep_SharePoint_psf
								}
							}
							
							$progressbar1.Value = 90
							
							#If skype for business checkbox is checked
							If ($checkboxSkypeForBusiness.Checked)
							{
								$TextboxResults.Text = "Checking for the SkypeOnlineConnector module..."
								if ((Get-Module -ListAvailable -Name SkypeOnlineConnector) -or ($SkypeOnlineConnectorPreReqPrompt -eq 1))
								{
									$TextboxResults.Text = "Connecting to Skype for Business.."
									Import-Module SkypeOnlineConnector
									#Skype for business session
									$sfboSession = New-CsOnlineSession -Credential $global:o365credentials
									#Import Skype For Business Session
									Import-PSSession $sfboSession
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreReq_SkypeForBusiness_psf
								}
								
								
							}
							
							$progressbar1.Value = 100
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
						Else
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							$PartnerComboBox.Enabled = $True
							$ButtonConnectTo365.Enabled = $True
							$ButtonDisconnect.Enabled = $False
							#$TenantConnectButton.Enabled = $True
							$checkboxComplianceCenter.Enabled = $true
							$checkboxExchangeOnline.Enabled = $true
							$checkboxSharepoint.Enabled = $true
							$checkboxComplianceCenter.Checked = $False
							$checkboxSharepoint.Checked = $False
							$checkboxSkypeForBusiness.Checked = $False
							$checkboxExchangeOnline.Checked = $False
							$checkboxSkypeForBusiness.Enabled = $True
							$FormO365AdministrationCenter.Cursor = 'Default'
							$ButtonConnectTo365.Text = "Connect to O365"
							Show-PreReq_Azure_psf
						}
					}
					Else
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						$PartnerComboBox.Enabled = $True
						$ButtonConnectTo365.Enabled = $True
						$ButtonDisconnect.Enabled = $False
						#$TenantConnectButton.Enabled = $True
						$checkboxComplianceCenter.Enabled = $true
						$checkboxExchangeOnline.Enabled = $true
						$checkboxSharepoint.Enabled = $true
						$checkboxComplianceCenter.Checked = $False
						$checkboxSharepoint.Checked = $False
						$checkboxSkypeForBusiness.Checked = $False
						$checkboxExchangeOnline.Checked = $False
						$checkboxSkypeForBusiness.Enabled = $True
						$FormO365AdministrationCenter.Cursor = 'Default'
						$ButtonConnectTo365.Text = "Connect to O365"
						
						Show-PreReq_MSOnline_psf
					}
					
				}
				ElseIf ($CredMem -eq 1)
				{
					$TempDir = $env:temp
					$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter_Creds")
					$CachedCredXML = "$O365AdminTempFolder\Creds.xml"
					$global:o365credentials = Import-Clixml -Path $CachedCredXML
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Connecting to Office 365..."
					
					If (($SignOnAss -ne $Null) -or ($MSOnlinePreReqPrompt -eq 1))
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 1 -Force | Out-Null
						
						#$TextboxResults.Text = "Checking for the Azure module..."
						If ((Get-Module -ListAvailable -Name MSOnline) -or ($AzurePreReqPrompt -eq 1))
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 1 -Force | Out-Null
							
							#Show progress bar
							$progressbar1.Visible = $true
							
							#$TextboxResults.Text = "Connecting to O365..."
							$Ranges = 1 .. 50
							foreach ($range in $ranges)
							{
								$progressbar1.Value = $Range
							}
							
							Connect-MsolService -Credential $global:o365credentials
							$progressbar1.Value = 50
							
							#Disable the connect to o365 button
							$ButtonConnectTo365.Enabled = $False
							
							#Enable the disconnect button
							$ButtonDisconnect.Enabled = $True
							
							#Disable the checkboxes
							$checkboxExchangeOnline.Enabled = $false
							$checkboxSkypeForBusiness.Enabled = $false
							$checkboxSharepoint.Enabled = $false
							$checkboxComplianceCenter.Enabled = $False
							$progressbar1.Value = 51
							#Change button text
							$ButtonConnectTo365.Text = "Connected to O365"
							$progressbar1.Value = 52
							#The first checked check box for services will load the appropriate tab as default. 
							If ($checkboxComplianceCenter.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageComplianceCenter
							}
							elseif ($checkboxExchangeOnline.Checked)
							{
								$TabPageMaster.SelectedTab = $tabpageExchangeOnline
							}
							elseif ($checkboxSharepoint.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageSharePoint
							}
							elseif ($checkboxSkypeForBusiness.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageSkypeForBusiness
							}
							$progressbar1.Value = 53
							#Set Tenant Status to 0 as we have not connected to any tenants yet
							Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 0 -Force | Out-Null
							$progressbar1.Value = 54
							
							$partnerTIDs = Get-MsolPartnerContract -All | Select-Object TenantID
							$progressbar1.Value = 55
							
							#If tenant domains are available then load combobox with all tenants
							If ($partnerTIDs -ne $Null)
							{
								#Enables the Tenant button
								$TenantConnectButton.Enabled = $True
								$PartnerComboBox.Enabled = $True
								
								$domains = @()
								foreach ($TID in $partnerTIDs)
								{
									$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.IsDefault -eq 'True' }
									#$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.Name -notlike '*.onmicrosoft*' -and $_.Name -notlike '*.microsoftonline*' -and $_.Status -eq "Verified" }
									#$domainName = Get-MsolDomain -TenantId $TID.TenantId
									$domain = New-Object -TypeName PSObject
									$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value ($domainName.Name | Select-Object -First 1) #Deals with Tenants with multiple domain names asociated
									#$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value $domainName.Name
									$domain | Add-Member -Name TenantID -MemberType NoteProperty -Value $TID.TenantId
									$domains += $domain
								}
								$progressbar1.Value = 60
								#Loads Combobox with Tenants
								Load-ComboBox $PartnerComboBox $domains -DisplayMember Name
								
								#Enable the connect to tenant button
								$TenantConnectButton.Enabled = $true
							}
							
							#If no tenant domains are available then do the following
							Else
							{
								#Clear the combobox of items
								$PartnerComboBox.Text = ""
								
								#Disable combobox
								$PartnerComboBox.Enabled = $False
								
								#Disable the connect to tenant button
								$TenantConnectButton.Enabled = $false
							}
							
							$progressbar1.Value = 65
							
							#If compliance center checkbox is checked
							If ($checkboxComplianceCenter.Checked)
							{
								$TextboxResults.Text = "Connecting to Compliance Center..."
								$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
								Import-PSSession $ccSession
								$TextboxResults.Text = ""
							}
							
							$progressbar1.Value = 70
							
							#If exchange online checkbox is checked
							If ($checkboxExchangeOnline.Checked)
							{
								
								$TextboxResults.Text = "Connecting to Exchange Online..."
								$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
								Import-PSSession $exchangeSession -AllowClobber
								
								
								$TextboxResults.Text = "Caching Users..."
								$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
								$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
								Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
								
								
								$TextboxResults.Text = ""
							}
							
							$progressbar1.Value = 80
							
							If ($checkboxSharepoint.Checked -and $checkboxExchangeOnline.Checked)
							{
								$TextboxResults.Text = "Checking for the SharePoint Online module..."
								if ((Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) -or ($SharePointPreReqPrompt -eq 1))
								{
									Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 1 -Force | Out-Null
									
									$TextboxResults.Text = "Connecting to SharePoint Online..."
									#Grabs the Sharepoint URL attribtue with Absoluteuri header
									$SPOheaders = Get-OrganizationConfig | Select-Object -ExpandProperty SharepointUrl
									#Clears the header so we have a clean variable
									$SPOSite = $SPOheaders | Select-Object -ExpandProperty AbsoluteUri
									#Splits the URl into two parts so we can inject -admin
									$firsthalf = $SPOSite -split ('.sharepoint.com') | Select-Object -First 1
									$secondhalf = $SPOSite -split '(.sharepoint.com/)' | Select-Object -Last 2
									#Wrap it all up into a single URL with the -admin
									$SPOadminSite = "$Firsthalf" + "-admin" + "$secondhalf"
									$TextboxResults.Text = "Connecting to Sharepoint Online..."
									Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
									Connect-SPOService -Url $SPOadminSite -credential $global:o365credentials
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreRep_SharePoint_psf
								}
							}
							
							#If sharepoint checkbox is checked
							If ($checkboxSharepoint.Checked)
							{
								$TextboxResults.Text = "Checking for the SharePoint Online module..."
								if ((Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) -or ($SharePointPreReqPrompt -eq 1))
								{
									#$Sharepointdomain = Read-Host "Enter the domain name. EX: contoso, yahoo"
									#Connect to Exchange online so we can grab the Sharepoint URL attribute 
									$TextboxResults.Text = "Connecting to SharePoint Online..."
									$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
									Import-PSSession $exchangeSession -AllowClobber
									$progressbar1.Value = 83
									#Grabs the Sharepoint URL attribtue with Absoluteuri header
									$SPOheaders = Get-OrganizationConfig | Select-Object -ExpandProperty SharepointUrl
									#Clears the header so we have a clean variable
									$SPOSite = $SPOheaders | Select-Object -ExpandProperty AbsoluteUri
									#Splits the URl into two parts so we can inject -admin
									$firsthalf = $SPOSite -split ('.sharepoint.com') | Select-Object -First 1
									$secondhalf = $SPOSite -split '(.sharepoint.com/)' | Select-Object -Last 2
									#Wrap it all up into a single URL with the -admin
									$SPOadminSite = "$Firsthalf" + "-admin" + "$secondhalf"
									$TextboxResults.Text = "Connecting to Sharepoint Online..."
									Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
									Connect-SPOService -Url $SPOadminSite -credential $global:o365credentials
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreRep_SharePoint_psf
								}
							}
							
							$progressbar1.Value = 90
							
							#If skype for business checkbox is checked
							If ($checkboxSkypeForBusiness.Checked)
							{
								$TextboxResults.Text = "Checking for the SkypeOnlineConnector module..."
								if ((Get-Module -ListAvailable -Name SkypeOnlineConnector) -or ($SkypeOnlineConnectorPreReqPrompt -eq 1))
								{
									$TextboxResults.Text = "Connecting to Skype for Business.."
									Import-Module SkypeOnlineConnector
									#Skype for business session
									$sfboSession = New-CsOnlineSession -Credential $global:o365credentials
									#Import Skype For Business Session
									Import-PSSession $sfboSession
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreReq_SkypeForBusiness_psf
								}
								
								
							}
							
							$progressbar1.Value = 100
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
						Else
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							$PartnerComboBox.Enabled = $True
							$ButtonConnectTo365.Enabled = $True
							$ButtonDisconnect.Enabled = $False
							#$TenantConnectButton.Enabled = $True
							$checkboxComplianceCenter.Enabled = $true
							$checkboxExchangeOnline.Enabled = $true
							$checkboxSharepoint.Enabled = $true
							$checkboxComplianceCenter.Checked = $False
							$checkboxSharepoint.Checked = $False
							$checkboxSkypeForBusiness.Checked = $False
							$checkboxExchangeOnline.Checked = $False
							$checkboxSkypeForBusiness.Enabled = $True
							$FormO365AdministrationCenter.Cursor = 'Default'
							$ButtonConnectTo365.Text = "Connect to O365"
							Show-PreReq_Azure_psf
						}
					}
					Else
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						$PartnerComboBox.Enabled = $True
						$ButtonConnectTo365.Enabled = $True
						$ButtonDisconnect.Enabled = $False
						#$TenantConnectButton.Enabled = $True
						$checkboxComplianceCenter.Enabled = $true
						$checkboxExchangeOnline.Enabled = $true
						$checkboxSharepoint.Enabled = $true
						$checkboxComplianceCenter.Checked = $False
						$checkboxSharepoint.Checked = $False
						$checkboxSkypeForBusiness.Checked = $False
						$checkboxExchangeOnline.Checked = $False
						$checkboxSkypeForBusiness.Enabled = $True
						$FormO365AdministrationCenter.Cursor = 'Default'
						$ButtonConnectTo365.Text = "Connect to O365"
						
						Show-PreReq_MSOnline_psf
					}
				}
				Elseif ($CredMem -eq 2)
				{
					$global:o365credentials = (Get-Credential -Message "Please enter your Office 365 credentials")
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Connecting to Office 365..."
					
					If (($SignOnAss -ne $Null) -or ($MSOnlinePreReqPrompt -eq 1))
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 1 -Force | Out-Null
						
						#$TextboxResults.Text = "Checking for the Azure module..."
						If ((Get-Module -ListAvailable -Name MSOnline) -or ($AzurePreReqPrompt -eq 1))
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 1 -Force | Out-Null
							
							#Show progress bar
							$progressbar1.Visible = $true
							
							#$TextboxResults.Text = "Connecting to O365..."
							$Ranges = 1 .. 50
							foreach ($range in $ranges)
							{
								$progressbar1.Value = $Range
							}
							
							Connect-MsolService -Credential $global:o365credentials
							$progressbar1.Value = 50
							
							#Disable the connect to o365 button
							$ButtonConnectTo365.Enabled = $False
							
							#Enable the disconnect button
							$ButtonDisconnect.Enabled = $True
							
							#Disable the checkboxes
							$checkboxExchangeOnline.Enabled = $false
							$checkboxSkypeForBusiness.Enabled = $false
							$checkboxSharepoint.Enabled = $false
							$checkboxComplianceCenter.Enabled = $False
							$progressbar1.Value = 51
							#Change button text
							$ButtonConnectTo365.Text = "Connected to O365"
							$progressbar1.Value = 52
							#The first checked check box for services will load the appropriate tab as default. 
							If ($checkboxComplianceCenter.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageComplianceCenter
							}
							elseif ($checkboxExchangeOnline.Checked)
							{
								$TabPageMaster.SelectedTab = $tabpageExchangeOnline
							}
							elseif ($checkboxSharepoint.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageSharePoint
							}
							elseif ($checkboxSkypeForBusiness.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageSkypeForBusiness
							}
							$progressbar1.Value = 53
							#Set Tenant Status to 0 as we have not connected to any tenants yet
							Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 0 -Force | Out-Null
							$progressbar1.Value = 54
							
							$partnerTIDs = Get-MsolPartnerContract -All | Select-Object TenantID
							$progressbar1.Value = 55
							
							#If tenant domains are available then load combobox with all tenants
							If ($partnerTIDs -ne $Null)
							{
								#Enables the Tenant button
								$TenantConnectButton.Enabled = $True
								$PartnerComboBox.Enabled = $True
								
								$domains = @()
								foreach ($TID in $partnerTIDs)
								{
									$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.IsDefault -eq 'True' }
									#$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.Name -notlike '*.onmicrosoft*' -and $_.Name -notlike '*.microsoftonline*' -and $_.Status -eq "Verified" }
									#$domainName = Get-MsolDomain -TenantId $TID.TenantId
									$domain = New-Object -TypeName PSObject
									$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value ($domainName.Name | Select-Object -First 1) #Deals with Tenants with multiple domain names asociated
									#$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value $domainName.Name
									$domain | Add-Member -Name TenantID -MemberType NoteProperty -Value $TID.TenantId
									$domains += $domain
								}
								$progressbar1.Value = 60
								#Loads Combobox with Tenants
								Load-ComboBox $PartnerComboBox $domains -DisplayMember Name
								
								#Enable the connect to tenant button
								$TenantConnectButton.Enabled = $true
							}
							
							#If no tenant domains are available then do the following
							Else
							{
								#Clear the combobox of items
								$PartnerComboBox.Text = ""
								
								#Disable combobox
								$PartnerComboBox.Enabled = $False
								
								#Disable the connect to tenant button
								$TenantConnectButton.Enabled = $false
							}
							
							$progressbar1.Value = 65
							
							#If compliance center checkbox is checked
							If ($checkboxComplianceCenter.Checked)
							{
								$TextboxResults.Text = "Connecting to Compliance Center..."
								$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
								Import-PSSession $ccSession
								$TextboxResults.Text = ""
							}
							
							$progressbar1.Value = 70
							
							#If exchange online checkbox is checked
							If ($checkboxExchangeOnline.Checked)
							{
								
								$TextboxResults.Text = "Connecting to Exchange Online..."
								$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
								Import-PSSession $exchangeSession -AllowClobber
								
								
								$TextboxResults.Text = "Caching Users..."
								$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
								$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
								Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
								
								
								$TextboxResults.Text = ""
							}
							
							$progressbar1.Value = 80
							
							If ($checkboxSharepoint.Checked -and $checkboxExchangeOnline.Checked)
							{
								$TextboxResults.Text = "Checking for the SharePoint Online module..."
								if ((Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) -or ($SharePointPreReqPrompt -eq 1))
								{
									Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 1 -Force | Out-Null
									
									$TextboxResults.Text = "Connecting to SharePoint Online..."
									#Grabs the Sharepoint URL attribtue with Absoluteuri header
									$SPOheaders = Get-OrganizationConfig | Select-Object -ExpandProperty SharepointUrl
									#Clears the header so we have a clean variable
									$SPOSite = $SPOheaders | Select-Object -ExpandProperty AbsoluteUri
									#Splits the URl into two parts so we can inject -admin
									$firsthalf = $SPOSite -split ('.sharepoint.com') | Select-Object -First 1
									$secondhalf = $SPOSite -split '(.sharepoint.com/)' | Select-Object -Last 2
									#Wrap it all up into a single URL with the -admin
									$SPOadminSite = "$Firsthalf" + "-admin" + "$secondhalf"
									$TextboxResults.Text = "Connecting to Sharepoint Online..."
									Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
									Connect-SPOService -Url $SPOadminSite -credential $global:o365credentials
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreRep_SharePoint_psf
								}
							}
							
							#If sharepoint checkbox is checked
							If ($checkboxSharepoint.Checked)
							{
								$TextboxResults.Text = "Checking for the SharePoint Online module..."
								if ((Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) -or ($SharePointPreReqPrompt -eq 1))
								{
									#$Sharepointdomain = Read-Host "Enter the domain name. EX: contoso, yahoo"
									#Connect to Exchange online so we can grab the Sharepoint URL attribute 
									$TextboxResults.Text = "Connecting to SharePoint Online..."
									$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
									Import-PSSession $exchangeSession -AllowClobber
									$progressbar1.Value = 83
									#Grabs the Sharepoint URL attribtue with Absoluteuri header
									$SPOheaders = Get-OrganizationConfig | Select-Object -ExpandProperty SharepointUrl
									#Clears the header so we have a clean variable
									$SPOSite = $SPOheaders | Select-Object -ExpandProperty AbsoluteUri
									#Splits the URl into two parts so we can inject -admin
									$firsthalf = $SPOSite -split ('.sharepoint.com') | Select-Object -First 1
									$secondhalf = $SPOSite -split '(.sharepoint.com/)' | Select-Object -Last 2
									#Wrap it all up into a single URL with the -admin
									$SPOadminSite = "$Firsthalf" + "-admin" + "$secondhalf"
									$TextboxResults.Text = "Connecting to Sharepoint Online..."
									Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
									Connect-SPOService -Url $SPOadminSite -credential $global:o365credentials
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreRep_SharePoint_psf
								}
							}
							
							$progressbar1.Value = 90
							
							#If skype for business checkbox is checked
							If ($checkboxSkypeForBusiness.Checked)
							{
								$TextboxResults.Text = "Checking for the SkypeOnlineConnector module..."
								if ((Get-Module -ListAvailable -Name SkypeOnlineConnector) -or ($SkypeOnlineConnectorPreReqPrompt -eq 1))
								{
									$TextboxResults.Text = "Connecting to Skype for Business.."
									Import-Module SkypeOnlineConnector
									#Skype for business session
									$sfboSession = New-CsOnlineSession -Credential $global:o365credentials
									#Import Skype For Business Session
									Import-PSSession $sfboSession
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreReq_SkypeForBusiness_psf
								}
								
								
							}
							
							$progressbar1.Value = 100
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
						Else
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							$PartnerComboBox.Enabled = $True
							$ButtonConnectTo365.Enabled = $True
							$ButtonDisconnect.Enabled = $False
							#$TenantConnectButton.Enabled = $True
							$checkboxComplianceCenter.Enabled = $true
							$checkboxExchangeOnline.Enabled = $true
							$checkboxSharepoint.Enabled = $true
							$checkboxComplianceCenter.Checked = $False
							$checkboxSharepoint.Checked = $False
							$checkboxSkypeForBusiness.Checked = $False
							$checkboxExchangeOnline.Checked = $False
							$checkboxSkypeForBusiness.Enabled = $True
							$FormO365AdministrationCenter.Cursor = 'Default'
							$ButtonConnectTo365.Text = "Connect to O365"
							Show-PreReq_Azure_psf
						}
					}
					Else
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						$PartnerComboBox.Enabled = $True
						$ButtonConnectTo365.Enabled = $True
						$ButtonDisconnect.Enabled = $False
						#$TenantConnectButton.Enabled = $True
						$checkboxComplianceCenter.Enabled = $true
						$checkboxExchangeOnline.Enabled = $true
						$checkboxSharepoint.Enabled = $true
						$checkboxComplianceCenter.Checked = $False
						$checkboxSharepoint.Checked = $False
						$checkboxSkypeForBusiness.Checked = $False
						$checkboxExchangeOnline.Checked = $False
						$checkboxSkypeForBusiness.Enabled = $True
						$FormO365AdministrationCenter.Cursor = 'Default'
						$ButtonConnectTo365.Text = "Connect to O365"
						
						Show-PreReq_MSOnline_psf
					}
				}
				Else
				{
					$global:o365credentials = (Get-Credential -Message "Please enter your Office 365 credentials")
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Connecting to Office 365..."
					
					If (($SignOnAss -ne $Null) -or ($MSOnlinePreReqPrompt -eq 1))
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 1 -Force | Out-Null
						
						#$TextboxResults.Text = "Checking for the Azure module..."
						If ((Get-Module -ListAvailable -Name MSOnline) -or ($AzurePreReqPrompt -eq 1))
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 1 -Force | Out-Null
							
							#Show progress bar
							$progressbar1.Visible = $true
							
							#$TextboxResults.Text = "Connecting to O365..."
							$Ranges = 1 .. 50
							foreach ($range in $ranges)
							{
								$progressbar1.Value = $Range
							}
							
							Connect-MsolService -Credential $global:o365credentials
							$progressbar1.Value = 50
							
							#Disable the connect to o365 button
							$ButtonConnectTo365.Enabled = $False
							
							#Enable the disconnect button
							$ButtonDisconnect.Enabled = $True
							
							#Disable the checkboxes
							$checkboxExchangeOnline.Enabled = $false
							$checkboxSkypeForBusiness.Enabled = $false
							$checkboxSharepoint.Enabled = $false
							$checkboxComplianceCenter.Enabled = $False
							$progressbar1.Value = 51
							#Change button text
							$ButtonConnectTo365.Text = "Connected to O365"
							$progressbar1.Value = 52
							#The first checked check box for services will load the appropriate tab as default. 
							If ($checkboxComplianceCenter.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageComplianceCenter
							}
							elseif ($checkboxExchangeOnline.Checked)
							{
								$TabPageMaster.SelectedTab = $tabpageExchangeOnline
							}
							elseif ($checkboxSharepoint.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageSharePoint
							}
							elseif ($checkboxSkypeForBusiness.checked)
							{
								$TabPageMaster.SelectedTab = $tabpageSkypeForBusiness
							}
							$progressbar1.Value = 53
							#Set Tenant Status to 0 as we have not connected to any tenants yet
							Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 0 -Force | Out-Null
							$progressbar1.Value = 54
							
							$partnerTIDs = Get-MsolPartnerContract -All | Select-Object TenantID
							$progressbar1.Value = 55
							
							#If tenant domains are available then load combobox with all tenants
							If ($partnerTIDs -ne $Null)
							{
								#Enables the Tenant button
								$TenantConnectButton.Enabled = $True
								$PartnerComboBox.Enabled = $True
								
								$domains = @()
								foreach ($TID in $partnerTIDs)
								{
									$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.IsDefault -eq 'True' }
									#$domainName = Get-MsolDomain -TenantId $TID.TenantId | Where-Object { $_.Name -notlike '*.onmicrosoft*' -and $_.Name -notlike '*.microsoftonline*' -and $_.Status -eq "Verified" }
									#$domainName = Get-MsolDomain -TenantId $TID.TenantId
									$domain = New-Object -TypeName PSObject
									$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value ($domainName.Name | Select-Object -First 1) #Deals with Tenants with multiple domain names asociated
									#$domain | Add-Member -Name 'Name' -MemberType NoteProperty -Value $domainName.Name
									$domain | Add-Member -Name TenantID -MemberType NoteProperty -Value $TID.TenantId
									$domains += $domain
								}
								$progressbar1.Value = 60
								#Loads Combobox with Tenants
								Load-ComboBox $PartnerComboBox $domains -DisplayMember Name
								
								#Enable the connect to tenant button
								$TenantConnectButton.Enabled = $true
							}
							
							#If no tenant domains are available then do the following
							Else
							{
								#Clear the combobox of items
								$PartnerComboBox.Text = ""
								
								#Disable combobox
								$PartnerComboBox.Enabled = $False
								
								#Disable the connect to tenant button
								$TenantConnectButton.Enabled = $false
							}
							
							$progressbar1.Value = 65
							
							#If compliance center checkbox is checked
							If ($checkboxComplianceCenter.Checked)
							{
								$TextboxResults.Text = "Connecting to Compliance Center..."
								$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
								Import-PSSession $ccSession
								$TextboxResults.Text = ""
							}
							
							$progressbar1.Value = 70
							
							#If exchange online checkbox is checked
							If ($checkboxExchangeOnline.Checked)
							{
								
								$TextboxResults.Text = "Connecting to Exchange Online..."
								$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
								Import-PSSession $exchangeSession -AllowClobber
								
								
								$TextboxResults.Text = "Caching Users..."
								$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
								$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
								Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
								
								
								$TextboxResults.Text = ""
							}
							
							$progressbar1.Value = 80
							
							If ($checkboxSharepoint.Checked -and $checkboxExchangeOnline.Checked)
							{
								$TextboxResults.Text = "Checking for the SharePoint Online module..."
								if ((Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) -or ($SharePointPreReqPrompt -eq 1))
								{
									Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 1 -Force | Out-Null
									
									$TextboxResults.Text = "Connecting to SharePoint Online..."
									#Grabs the Sharepoint URL attribtue with Absoluteuri header
									$SPOheaders = Get-OrganizationConfig | Select-Object -ExpandProperty SharepointUrl
									#Clears the header so we have a clean variable
									$SPOSite = $SPOheaders | Select-Object -ExpandProperty AbsoluteUri
									#Splits the URl into two parts so we can inject -admin
									$firsthalf = $SPOSite -split ('.sharepoint.com') | Select-Object -First 1
									$secondhalf = $SPOSite -split '(.sharepoint.com/)' | Select-Object -Last 2
									#Wrap it all up into a single URL with the -admin
									$SPOadminSite = "$Firsthalf" + "-admin" + "$secondhalf"
									$TextboxResults.Text = "Connecting to Sharepoint Online..."
									Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
									Connect-SPOService -Url $SPOadminSite -credential $global:o365credentials
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreRep_SharePoint_psf
								}
							}
							
							#If sharepoint checkbox is checked
							If ($checkboxSharepoint.Checked)
							{
								$TextboxResults.Text = "Checking for the SharePoint Online module..."
								if ((Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) -or ($SharePointPreReqPrompt -eq 1))
								{
									#$Sharepointdomain = Read-Host "Enter the domain name. EX: contoso, yahoo"
									#Connect to Exchange online so we can grab the Sharepoint URL attribute 
									$TextboxResults.Text = "Connecting to SharePoint Online..."
									$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
									Import-PSSession $exchangeSession -AllowClobber
									$progressbar1.Value = 83
									#Grabs the Sharepoint URL attribtue with Absoluteuri header
									$SPOheaders = Get-OrganizationConfig | Select-Object -ExpandProperty SharepointUrl
									#Clears the header so we have a clean variable
									$SPOSite = $SPOheaders | Select-Object -ExpandProperty AbsoluteUri
									#Splits the URl into two parts so we can inject -admin
									$firsthalf = $SPOSite -split ('.sharepoint.com') | Select-Object -First 1
									$secondhalf = $SPOSite -split '(.sharepoint.com/)' | Select-Object -Last 2
									#Wrap it all up into a single URL with the -admin
									$SPOadminSite = "$Firsthalf" + "-admin" + "$secondhalf"
									$TextboxResults.Text = "Connecting to Sharepoint Online..."
									Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
									Connect-SPOService -Url $SPOadminSite -credential $global:o365credentials
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreRep_SharePoint_psf
								}
							}
							
							$progressbar1.Value = 90
							
							#If skype for business checkbox is checked
							If ($checkboxSkypeForBusiness.Checked)
							{
								$TextboxResults.Text = "Checking for the SkypeOnlineConnector module..."
								if ((Get-Module -ListAvailable -Name SkypeOnlineConnector) -or ($SkypeOnlineConnectorPreReqPrompt -eq 1))
								{
									$TextboxResults.Text = "Connecting to Skype for Business.."
									Import-Module SkypeOnlineConnector
									#Skype for business session
									$sfboSession = New-CsOnlineSession -Credential $global:o365credentials
									#Import Skype For Business Session
									Import-PSSession $sfboSession
									$TextboxResults.Text = ""
								}
								Else
								{
									$TextboxResults.Text = ""
									$textboxDetails.Text = ""
									$PartnerComboBox.Enabled = $True
									$ButtonConnectTo365.Enabled = $True
									$ButtonDisconnect.Enabled = $False
									#$TenantConnectButton.Enabled = $True
									$checkboxComplianceCenter.Enabled = $true
									$checkboxExchangeOnline.Enabled = $true
									$checkboxSharepoint.Enabled = $true
									$checkboxComplianceCenter.Checked = $False
									$checkboxSharepoint.Checked = $False
									$checkboxSkypeForBusiness.Checked = $False
									$checkboxExchangeOnline.Checked = $False
									$checkboxSkypeForBusiness.Enabled = $True
									$FormO365AdministrationCenter.Cursor = 'Default'
									$ButtonConnectTo365.Text = "Connect to O365"
									Show-PreReq_SkypeForBusiness_psf
								}
								
								
							}
							
							$progressbar1.Value = 100
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
						Else
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							$PartnerComboBox.Enabled = $True
							$ButtonConnectTo365.Enabled = $True
							$ButtonDisconnect.Enabled = $False
							#$TenantConnectButton.Enabled = $True
							$checkboxComplianceCenter.Enabled = $true
							$checkboxExchangeOnline.Enabled = $true
							$checkboxSharepoint.Enabled = $true
							$checkboxComplianceCenter.Checked = $False
							$checkboxSharepoint.Checked = $False
							$checkboxSkypeForBusiness.Checked = $False
							$checkboxExchangeOnline.Checked = $False
							$checkboxSkypeForBusiness.Enabled = $True
							$FormO365AdministrationCenter.Cursor = 'Default'
							$ButtonConnectTo365.Text = "Connect to O365"
							Show-PreReq_Azure_psf
						}
					}
					Else
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						$PartnerComboBox.Enabled = $True
						$ButtonConnectTo365.Enabled = $True
						$ButtonDisconnect.Enabled = $False
						#$TenantConnectButton.Enabled = $True
						$checkboxComplianceCenter.Enabled = $true
						$checkboxExchangeOnline.Enabled = $true
						$checkboxSharepoint.Enabled = $true
						$checkboxComplianceCenter.Checked = $False
						$checkboxSharepoint.Checked = $False
						$checkboxSkypeForBusiness.Checked = $False
						$checkboxExchangeOnline.Checked = $False
						$checkboxSkypeForBusiness.Enabled = $True
						$FormO365AdministrationCenter.Cursor = 'Default'
						$ButtonConnectTo365.Text = "Connect to O365"
						
						Show-PreReq_MSOnline_psf
					}
				}
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'Default'
				Show-SelecPreReqExecutionPolicy_psf
			}
		}
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		$PartnerComboBox.Enabled = $True
		$ButtonConnectTo365.Enabled = $True
		$ButtonDisconnect.Enabled = $False
		#$TenantConnectButton.Enabled = $True
		$checkboxComplianceCenter.Enabled = $true
		$checkboxExchangeOnline.Enabled = $true
		$checkboxSharepoint.Enabled = $true
		$checkboxComplianceCenter.Checked = $False
		$checkboxSharepoint.Checked = $False
		$checkboxSkypeForBusiness.Checked = $False
		$checkboxExchangeOnline.Checked = $False
		$checkboxSkypeForBusiness.Enabled = $True
		$FormO365AdministrationCenter.Cursor = 'Default'
		$ButtonConnectTo365.Text = "Connect to O365"
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	#Hide the progress bar
	$progressbar1.Visible = $false
	
}

$TenantConnectButton_Click = {
	try
	{
		
		#Show the proress bar
		$progressbar1.Visible = $true
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$URI = "https://outlook.office365.com/powershell-liveid?DelegatedOrg=" + $PartnerComboBox.SelectedItem.Name
		
		#Remove all sessions
		Get-PSSession | Remove-PSSession
		$progressbar1.Value = 65
		
		#CONNECT TO EXCHANGE ONLINE
		$TextboxResults.Text = "Connecting to partner account..."
		$progressbar1.Value = 70
		$PartnerSession = New-PSSession -Name PartnerAccount -ConfigurationName Microsoft.Exchange -ConnectionUri $URI -Credential $global:o365credentials -Authentication Basic -AllowRedirection
		$progressbar1.Value = 75
		Import-PSSession $PartnerSession -AllowClobber
		$progressbar1.Value = 80
		
		Connect-MsolService -Credential $global:o365credentials
		
		$TextboxResults.Text = "Caching User Principal Names..."
		$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
		$UserListcombo = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
		Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
		
		$progressbar1.Value = 90
		
		#Disable the connect to tenant button
		$TenantConnectButton.Enabled = $false
		
		#Sets custom form text
		$FormO365AdministrationCenter.Text = "-Connected to " + $PartnerComboBox.SelectedItem.Name + "-"
		
		#Clear textboxes
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		
		#Disable the partner combobox
		$PartnerComboBox.Enabled = $false
		
		#Enable the disconnect button
		$ButtonDisconnect.Enabled = $True
		
		#Sets custom button text
		$TenantConnectButton.Text = "Connected to Partner"
		$progressbar1.Value = 100
		
		If ($checkboxComplianceCenter.checked)
		{
			$TabPageMaster.SelectedTab = $tabpageComplianceCenter
		}
		elseif ($checkboxExchangeOnline.Checked)
		{
			$TabPageMaster.SelectedTab = $tabpageExchangeOnline
		}
		elseif ($checkboxSharepoint.checked)
		{
			$TabPageMaster.SelectedTab = $tabpageSharePoint
		}
		elseif ($checkboxSkypeForBusiness.checked)
		{
			$TabPageMaster.SelectedTab = $tabpageSkypeForBusiness
		}
		
		Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name TenantStatus -Value 1 -Force | Out-Null
		
		#Disable the checkboxes
		$checkboxExchangeOnline.Enabled = $false
		$checkboxSkypeForBusiness.Enabled = $false
		$checkboxSharepoint.Enabled = $false
		$checkboxComplianceCenter.Enabled = $False
		
		$ButtonConnectTo365.Enabled = $false
		
		$ButtonDisconnect.Text = "Disconnect from Tenant"
		
		#Deletes the old pf  files
		$TempDir = $env:temp
		$CachedFiles = ("$TempDir" + "\O365AdminCenter\pf.txt")
		Remove-Item $CachedFiles
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	#Hide the progress bar
	$progressbar1.Visible = $false
}

$ButtonExportToFile_Click = {
<#	$SavedFile = Read-Host "Enter the Path for file (Eg. C:\DG.csv, C:\Users.txt, C:\output\info.doc)"
	try
	{
		$TextboxResults.Text | out-file $SavedFile
		[System.Windows.Forms.MessageBox]::Show("Saved $SavedFile", "Info")
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}

	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to File"
	$savedialog.filter = ".doc|*.doc|.csv|*.csv|.txt|*.txt"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		$TextboxResults.Text | Out-File -Encoding Default $savedialog.filename 
	}
	else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not save the file", "Error")
	}
	#>
}

$ButtonRunCustomCommand_Click = {
	$userinput = $TextboxResults.text
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		#Takes the user input to a variable and passes it to the shell
		$TextboxResults.text = Invoke-Expression $userinput | Out-String
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		$FormO365AdministrationCenter.Cursor = 'Default'
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}



###USERS###

	#User General Items

$createOutOfOfficeAutoReplyForAUserToolStripMenuItem_Click = {
	Do
	{
		#$OOOautoreplyUser = Read-Host "What user is the Out Of Office auto reply for?"
		$SelectUsersFormText = "Select the User you want to create an Out of Office Reply for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$GlobalUPNooouser = $SelectUsersForm_comboboxUsers
		$GlobalUPNooouser = $SelectCachedDisplayNames_comboboxNames
		
		Try
		{
			If (!$GlobalUPNooouser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("Please select a user you want to create an Out of Office Reply for", "Error")
			}
			Else
			{
				$OOOInternal = Read-Host "What is the Internal Message"
				If (!$OOOInternal)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("Please enter an Internal out of office message", "Error")
				}
				Else
				{
					$OOOExternal = Read-Host "What is the External Message"
					If (!$OOOExternal)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("Please enter an External Out of Office Reply", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Creating an Out of Office reply for $GlobalUPNooouser..."
						$textboxDetails.Text = "Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Enabled -ExternalMessage $OOOExternal -InternalMessage $OOOInternal"
						Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Enabled -ExternalMessage $OOOExternal -InternalMessage $OOOInternal
						$TextboxResults.Text = Get-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser | Format-List | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create an Out of Office Message for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableOutOfOfficeReplyForAUserToolStripMenuItem_Click = {
	Do
	{
		#$OOOautoreplyUser = Read-Host "What user is the Out Of Office auto reply for?"
		$SelectUsersFormText = "Select the user you want to disable an Out of Office reply for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$GlobalUPNooouser = $SelectUsersForm_comboboxUsers
		$GlobalUPNooouser = $SelectCachedDisplayNames_comboboxNames
		
		Try
		{
			If (!$GlobalUPNooouser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
				
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling an Out of Office reply for $GlobalUPNooouser..."
				$textboxDetails.Text = "Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Disabled"
				Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Disabled
				$TextboxResults.Text = Get-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable an Out of Office reply for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getListOfUsersToolStripMenuItem_Click = {
	Try
	{
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting list of users..."
			$textboxDetails.Text = "Get-MSOLUser -All | Sort-Object DisplayName |  Format-Table DisplayName, UserPrincipalName -AutoSize"
			$TextboxResults.text = Get-MSOLUser -All | Sort-Object DisplayName | Format-Table DisplayName, UserPrincipalName -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting list of users..."
			$textboxDetails.Text = "Get-MSOLUser -TenantId $TenantText -All | Sort-Object DisplayName |  Format-Table DisplayName, UserPrincipalName -AutoSize "
			$TextboxResults.text = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Sort-Object DisplayName | Format-Table DisplayName, UserPrincipalName -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting list of users..."
			$textboxDetails.Text = "Get-MSOLUser -All | Sort-Object DisplayName |  Format-Table DisplayName, UserPrincipalName -AutoSize"
			$TextboxResults.text = Get-MSOLUser -All | Sort-Object DisplayName | Format-Table DisplayName, UserPrincipalName -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getDetailedInfoForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to view detailed information for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPN = $SelectUsersForm_comboboxUsers
		$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
		Try
		{
			If (!$GlobalUPN)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			ElseIf (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed info for $GlobalUPN..."
				$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $GlobalUPN | Format-List"
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed info for $GlobalUPN..."
				$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $GlobalUPN -TenantId $TenantText | Format-List"
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed info for $GlobalUPN..."
				$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $GlobalUPN | Format-List"
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN | Format-List | Out-String -Width 2147483647
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get detailed information for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$changeUsersLoginNameToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to change the User Principal Name for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPN = $SelectUsersForm_comboboxUsers
		$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
		$NewUserUPN = Read-Host "What would you like the new username to be?"
		Try
		{
			If ((!$GlobalUPN) -or (!$NewUserUPN))
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("One of the values appears to be empty. Please select a user that you want to change the UPN for and enter a valid new UPN.", "Error")
			}
			ElseIf (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Changing $GlobalUPN UPN to $NewUserUPN..."
				$textboxDetails.Text = "Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -NewUserPrincipalName $NewUserUPN"
				Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -NewUserPrincipalName $NewUserUPN
				$TextboxResults.text = Get-MSOLUser -UserPrincipalName $NewUserUPN | Format-List UserPrincipalName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TenantText = $PartnerComboBox.text
				$TextboxResults.Text = "Changing $GlobalUPN UPN to $NewUserUPN..."
				$textboxDetails.Text = "Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -TenantId $TenantText -NewUserPrincipalName $NewUserUPN"
				Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -TenantId $PartnerComboBox.SelectedItem.TenantID -NewUserPrincipalName $NewUserUPN
				$TextboxResults.text = Get-MSOLUser -UserPrincipalName $NewUserUPN -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List UserPrincipalName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Changing $GlobalUPN UPN to $NewUserUPN..."
				$textboxDetails.Text = "Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -NewUserPrincipalName $NewUserUPN"
				Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -NewUserPrincipalName $NewUserUPN
				$TextboxResults.text = Get-MSOLUser -UserPrincipalName $NewUserUPN | Format-List UserPrincipalName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
			
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to change the UPN for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$deleteAUserToolStripMenuItem_Click = {
	Do
	{
		#$DeleteUser = Read-Host "Enter the UPN of the user you want to delete"
		$SelectUsersFormText = "Select the User you want to delete"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPNdelete = $SelectUsersForm_comboboxUsers
		$GlobalUPNdelete = $SelectCachedUserPrincipalName_comboboxUPN
		Try
		{
			If (!$GlobalUPNdelete)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $GlobalUPNdelete ?", "Warning!", 4)
				If ($OUTPUT -eq "YES")
				{
					#What to do if connected to main o365 account
					If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Deleting $GlobalUPNdelete..."
						$textboxDetails.Text = "Remove-MsolUser –UserPrincipalName $GlobalUPNdelete"
						$TextboxResults.text = Remove-MsolUser –UserPrincipalName $GlobalUPNdelete | Format-List UserPrincipalName | Out-String -Width 2147483647
						$TempDir = $env:temp
						$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
						$FullFile = "$O365AdminTempFolder\upn.txt"
						Remove-Item $FullFile -Force
						#$TextboxResults.Text = "re-caching Users..."
						$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
						$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
						Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
						$FormO365AdministrationCenter.Cursor = 'Default'
						$TextboxResults.Text = "$GlobalUPNdelete was deleted"
					}
					#What to do if connected to partner account
					ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
					{
						$TenantText = $PartnerComboBox.text
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Deleting $GlobalUPNdelete..."
						$textboxDetails.Text = "Remove-MsolUser –UserPrincipalName $GlobalUPNdelete -TenantId $TenantText"
						$TextboxResults.text = Remove-MsolUser –UserPrincipalName $GlobalUPNdelete -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List UserPrincipalName | Out-String -Width 2147483647
						$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
						$FullFile = "$O365AdminTempFolder\upn.txt"
						Remove-Item $FullFile -Force
						#$TextboxResults.Text = "re-caching Users..."
						$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
						$UserListcombo = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
						Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
						$FormO365AdministrationCenter.Cursor = 'Default'
						$TextboxResults.Text = "$GlobalUPNdelete was deleted"
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Deleting $GlobalUPNdelete..."
						$textboxDetails.Text = "Remove-MsolUser –UserPrincipalName $GlobalUPNdelete"
						$TextboxResults.text = Remove-MsolUser –UserPrincipalName $GlobalUPNdelete | Format-List UserPrincipalName | Out-String -Width 2147483647
						$TempDir = $env:temp
						$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
						$FullFile = "$O365AdminTempFolder\upn.txt"
						Remove-Item $FullFile -Force
						#$TextboxResults.Text = "re-caching Users..."
						$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
						$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
						Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
						$FormO365AdministrationCenter.Cursor = 'Default'
						$TextboxResults.Text = "$GlobalUPNdelete was deleted"
					}
				}
				Else
				{
					[System.Windows.Forms.MessageBox]::Show("$GlobalUPNdelete was not deleted", "Info")
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to delete another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$createANewUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$Firstname = Read-Host "Enter the First Name for the new User"
			If (!$Firstname)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No first name was entered for the new User. Please enter a valid first name", "Error")
				
			}
			Else
			{
				$LastName = Read-Host "Enter the Last Name for the new User"
				If (!$LastName)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No last name was entered for the new User. Please enter a valid last name", "Error")
				}
				Else
				{
					$DisplayName = Read-Host "Enter the Display Name for the new User"
					If (!$DisplayName)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Display Name was entered for the new User. Please enter a valid Display Name", "Error")
					}
					Else
					{
						$NewUser = Read-Host "Enter the UPN for the new user"
						If (!$NewUser)
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							[System.Windows.Forms.MessageBox]::Show("No UPN was entered for the new User. Please enter a valid UPN", "Error")
						}
						Else
						{
							#What to do if connected to main o365 account
							If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
							{
								$FormO365AdministrationCenter.Cursor = 'WaitCursor'
								$TextboxResults.Text = "Creating user $NewUser..."
								$textboxDetails.Text = "New-MsolUser -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName"
								$TextboxResults.text = New-MsolUser -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName | Format-List | Out-String -Width 2147483647
								$TempDir = $env:temp
								$upns = ("$TempDir" + "\O365AdminCenter\upn.txt")
								$names = ("$TempDir" + "\O365AdminCenter\names.txt")
								Remove-Item $upns -Force
								Remove-Item $names -Force
								#$TextboxResults.Text = "re-caching Users..."
								$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
								$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
								Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
								$FormO365AdministrationCenter.Cursor = 'Default'
							}
							#What to do if connected to partner account
							ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
							{
								$TenantText = $PartnerComboBox.text
								$FormO365AdministrationCenter.Cursor = 'WaitCursor'
								$TextboxResults.Text = "Creating user $NewUser..."
								$textboxDetails.Text = "New-MsolUser -TenantId $TenantText -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName"
								$TextboxResults.text = New-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName | Format-List | Out-String -Width 2147483647
								$TempDir = $env:temp
								$upns = ("$TempDir" + "\O365AdminCenter\upn.txt")
								$names = ("$TempDir" + "\O365AdminCenter\names.txt")
								Remove-Item $upns -Force
								Remove-Item $names -Force
								#$TextboxResults.Text = "re-caching User Principal Names..."
								$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
								$UserListcombo = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
								Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
								$FormO365AdministrationCenter.Cursor = 'Default'
							}
							Else
							{
								$FormO365AdministrationCenter.Cursor = 'WaitCursor'
								$TextboxResults.Text = "Creating user $NewUser..."
								$textboxDetails.Text = "New-MsolUser -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName"
								$TextboxResults.text = New-MsolUser -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName | Format-List | Out-String -Width 2147483647
								$TempDir = $env:temp
								$upns = ("$TempDir" + "\O365AdminCenter\upn.txt")
								$names = ("$TempDir" + "\O365AdminCenter\names.txt")
								Remove-Item $upns -Force
								Remove-Item $names -Force
								#$TextboxResults.Text = "re-caching Users..."
								$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
								$UserListcombo = Get-MSOLUser -All | Select-Object -ExpandProperty UserPrincipalName | Out-File "$O365AdminTempFolder\upn.txt"
								Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
								$FormO365AdministrationCenter.Cursor = 'Default'
							}
						}
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableUserAccountToolStripMenuItem_Click = {
	Do
	{
		#$BlockUser = Read-Host "Enter the UPN of the user you want to disable"
		$SelectUsersFormText = "Select the User you want to disable"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPNdisable = $SelectUsersForm_comboboxUsers
		$GlobalUPNdisable = $SelectCachedUserPrincipalName_comboboxUPN
		#What to do if connected to main o365 account
		Try
		{
			If (!$GlobalUPNdisable)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Disabling $GlobalUPNdisable..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential `$True"
					Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential $True
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdisable | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Disabling $GlobalUPNdisable..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential `$True -TenantId $TenantText"
					Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential $True -TenantId $PartnerComboBox.SelectedItem.TenantID
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdisable -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Disabling $GlobalUPNdisable..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential `$True"
					Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential $True
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdisable | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableAccountToolStripMenuItem_Click = {
	Do
	{
		#$EnableUser = Read-Host "Enter the UPN of the user you want to enable"
		$SelectUsersFormText = "Select the User you want to enable"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPNenable = $SelectUsersForm_comboboxUsers
		$GlobalUPNenable = $SelectCachedUserPrincipalName_comboboxUPN
		Try
		{
			If (!$GlobalUPNenable)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Enabling $GlobalUPNenable..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential `$False"
					Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential $False
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNenable | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Enabling $GlobalUPNenable..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential `$False -TenantId $TenantText"
					Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential $False -TenantId $PartnerComboBox.SelectedItem.TenantID
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNenable -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Enabling $GlobalUPNenable..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential `$False"
					Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential $False
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNenable | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getDetailedMailboxInfoToolStripMenuItem_Click = {
	Do
	{
		#$GetDetailedMailboxInfoUser = Read-Host "Enter the UPN of the user you want to view detailed info for"
		$SelectUsersFormText = "Select the User you want to get detailed Mailbox information for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$GlobalUPNdetailedmailbox = $SelectUsersForm_comboboxUsers
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed Mailbox info for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Get-mailbox -identity $GlobalUPNdetailedmailbox | Format-List"
				$TextboxResults.Text = Get-mailbox -identity $GlobalUPNdetailedmailbox | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get detailed Mailbox information for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$searchForAnEmailAddressToolStripMenuItem_Click = {
	Do
	{
		$SpecificEmail = Read-Host "Enter the E-mail Address you're looking for. Accepts wildcards (d*@bwya77.com, d*@*.com)"
		Try
		{
			If (!$SpecificEmail)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No E-mail was entered, please enter a valid E-mail Address.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Finding an E-mail Address like $SpecificEmail..."
				$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited -Identity * | Where-Object { `$_.EmailAddresses -like 'smtp:$SpecificEmail'' } | Sort-Object Identity | Format-List Identity, EmailAddresses, PrimarySmtpAddress, RecipientType"
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited -Identity * | Where-Object { $_.EmailAddresses -like "smtp:$SpecificEmail" } | Sort-Object Identity | Format-List Identity, EmailAddresses, PrimarySmtpAddress, RecipientType | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to search for another E-mail Address?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Last Logon

$getAllUsersLastLogonToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users last logon timestamp..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | ForEach-Object { Get-MailboxStatistics `$_.Identity | Select-Object DisplayName, LastLogonTime } | Format-Table -AutoSize "
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | ForEach-Object { Get-MailboxStatistics $_.Identity | Select-Object DisplayName, LastLogonTime } | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAUsersLastLogonToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to get get last logon timestamp for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$LastLogonUser = $SelectUsersForm_comboboxUsers
		$LastLogonUser = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$LastLogonUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting last logon timestamp for $LastLogonUser..."
				$textboxDetails.Text = "Get-MailboxStatistics -identity $LastLogonUser | Select-Object DisplayName, LastLogonTime | Format-Table -AutoSize "
				$TextboxResults.Text = Get-MailboxStatistics -identity $LastLogonUser | Select-Object DisplayName, LastLogonTime | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the Last Logon for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#GAL

$hideAUserFromTheGALToolStripMenuItem_Click = {
	Do
	{
		#$HidefromGALUser = Read-Host "Enter the UPN of the user you want to hide from the GAL"
		$SelectUsersFormText = "Select the User you want to hide from the Global Address List"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$GlobalUPNhideGAL = $SelectUsersForm_comboboxUsers
		$GlobalUPNhideGAL = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNhideGAL)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Hiding $GlobalUPNhideGAL from the GAL..."
				$textboxDetails.Text = "set-Mailbox -Identity $GlobalUPNhideGAL -HiddenFromAddressListsEnabled `$True"
				set-Mailbox -Identity $GlobalUPNhideGAL -HiddenFromAddressListsEnabled $True
				$TextboxResults.Text = Get-Mailbox -Identity $GlobalUPNhideGAL | Format-List DisplayName, HiddenFromAddressListsEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to hide another User from the Global Address List?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getUsersThatAreHiddenFromTheGALToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all mailboxes hidden from the GAL..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.HiddenFromAddressListsEnabled -eq `$True } | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.HiddenFromAddressListsEnabled -eq $True } | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getUsersThatAreNotHiddenFromTheGALToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all mailboxes not hidden from the GAL..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.HiddenFromAddressListsEnabled -eq `$False } | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.HiddenFromAddressListsEnabled -eq $False } | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$unhideAUserFromTheGALToolStripMenuItem_Click = {
	Do
	{
		#$unHidefromGALUser = Read-Host "Enter the UPN of the user you want to unhide from the GAL"
		$SelectUsersFormText = "Select the User you want to unhide from the Global Address List"
		Show-SelectCachedDisplayNames_psf
		#Call-SelectUsersForm_psf
		#$GlobalUPNunhideGAL = $SelectUsersForm_comboboxUsers
		$GlobalUPNunhideGAL = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNunhideGAL)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Unhiding $GlobalUPNunhideGAL from the Global Address List..."
				$textboxDetails.Text = "Set-Mailbox -Identity $GlobalUPNunhideGAL -HiddenFromAddressListsEnabled `$False"
				set-Mailbox -Identity $GlobalUPNunhideGAL -HiddenFromAddressListsEnabled $False
				$TextboxResults.Text = Get-Mailbox -Identity $GlobalUPNunhideGAL | Format-List DisplayName, HiddenFromAddressListsEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to unhide another User from the Global Address List?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Quota

$getUserQuotaToolStripMenuItem_Click = {
	Do
	{
		#$QuotaUser = Read-Host "Enter the Email of the user you want to view Quota information for"
		$SelectUsersFormText = "Select the User you want to view Quota information for"
		Show-SelectCachedDisplayNames_psf
		#Call-SelectUsersForm_psf
		#$GlobalUPNviewQuota = $SelectUsersForm_comboboxUsers
		$GlobalUPNviewQuota = $SelectCachedDisplayNames_comboboxNames
		try
		{
			If (!$GlobalUPNviewQuota)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting user Quota for $GlobalUPNviewQuota..."
				$textboxDetails.Text = "Get-Mailbox -identity $GlobalUPNviewQuota | Format-List DisplayName, UserPrincipalName, *Quota"
				$TextboxResults.text = Get-Mailbox -identity $GlobalUPNviewQuota | Format-List DisplayName, UserPrincipalName, *Quota | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view Quota information for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllUsersQuotaToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting quota for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Format-List DisplayName, UserPrincipalName, *Quota -AutoSize"
		$TextboxResults.text = Get-Mailbox -ResultSize unlimited | Sort-Object DisplayName | Format-Table DisplayName, UserPrincipalName, *Quota -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$setUserMailboxQuotaToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$MailboxSetQuota = Read-Host "Enter the UPN of the user you want to edit quota for"
			$SelectUsersFormText = "Select the User you want to edit the Quota for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$GlobalUPNeditQuota = $SelectUsersForm_comboboxUsers
			$GlobalUPNeditQuota = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalUPNeditQuota)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$ProhibitSendReceiveQuota = Read-Host "Enter the ProhibitSendReceiveQuota value (EX: '50GB') Max:50GB"
				If (!$ProhibitSendReceiveQuota)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Prohibit Send and Receive Quota value was entered. Please enter a valid number.", "Error")
				}
				Else
				{
					$ProhibitSendQuota = Read-Host "Enter the ProhibitSendQuota value (EX: '48GB') Max:50GB"
					If (!$ProhibitSendQuota)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Prohibit Send Quota value was entered. Please enter a valid number.", "Error")
					}
					Else
					{
						$IssueWarningQuota = Read-Host "Enter theIssueWarningQuota value (EX: '45GB') Max:50GB"
						If (!$IssueWarningQuota)
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							[System.Windows.Forms.MessageBox]::Show("No Issue Warning Quota value was entered. Please enter a valid number.", "Error")
						}
						Else
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							$TextboxResults.Text = "Setting quota for $GlobalUPNeditQuota... "
							$textboxDetails.Text = "Set-Mailbox -identity $GlobalUPNeditQuota -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota -ProhibitSendQuota $ProhibitSendQuota -IssueWarningQuota $IssueWarningQuota"
							Set-Mailbox -identity $GlobalUPNeditQuota -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota -ProhibitSendQuota $ProhibitSendQuota -IssueWarningQuota $IssueWarningQuota
							$TextboxResults.text = Get-Mailbox $GlobalUPNeditQuota | Format-List DisplayName, UserPrincipalName, *Quota | Out-String -Width 2147483647
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify the Quota for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$setMailboxQuotaForAllToolStripMenuItem_Click = {
	Try
	{
		$ProhibitSendReceiveQuota2 = Read-Host "Enter (GB) the ProhibitSendReceiveQuota value (EX: '50GB') Max:50GB"
		If (!$ProhibitSendReceiveQuota2)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No Prohibit Send and Receive Quota value was entered. Please enter a valid number.", "Error")
		}
		Else
		{
			$ProhibitSendQuota2 = Read-Host "Enter (GB) the ProhibitSendQuota value (EX: '48GB') Max:50GB"
			If (!$ProhibitSendQuota2)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Prohibit Send Quota value was entered. Please enter a valid number.", "Error")
			}
			Else
			{
				$IssueWarningQuota2 = Read-Host "Enter (GB) theIssueWarningQuota value (EX: '45GB') Max:50GB"
				If (!$IssueWarningQuota2)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Issue Warning Quota value was entered. Please enter a valid number.", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting quota for all... "
					$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-Mailbox -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota2 -ProhibitSendQuota $ProhibitSendQuota2 -IssueWarningQuota $IssueWarningQuota2"
					Get-Mailbox -ResultSize unlimited | Set-Mailbox -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota2 -ProhibitSendQuota $ProhibitSendQuota2 -IssueWarningQuota $IssueWarningQuota2
					$TextboxResults.text = Get-Mailbox -ResultSize unlimited | Format-List DisplayName, UserPrincipalName, *Quota | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

#Licenses

$getLicensedUsersToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users with a license..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -eq `$TRUE } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize"
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -eq $True } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Getting all users with a license..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantID $TenantText | Where-Object { `$_.isLicensed -eq `$TRUE } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize"
			$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.isLicensed -eq $True } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users with a license..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -eq `$TRUE } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize"
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -eq $True } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$displayAllUsersWithoutALicenseToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users without a license..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -like `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize"
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -like "False" } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users without a license..."
			$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -All | Where-Object { `$_.isLicensed -like `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize"
			$TextboxResults.text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Where-Object { $_.isLicensed -like $False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users without a license..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -like `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize"
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -like "False" } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeAllUnlicensedUsersToolStripMenuItem_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove all unlicensed users?", "Warning!", 4)
		If ($OUTPUT -eq "YES")
		{
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all users without a license..."
				$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -ne `$True } | Remove-MsolUser -Force"
				Get-MsolUser -All | Where-Object { $_.isLicensed -ne $True } | Remove-MsolUser -Force
				$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -like $True } | Format-List UserPrincipalName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all users without a license..."
				$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -All | Where-Object { `$_.isLicensed -ne `$True } | Remove-MsolUser -Force"
				Get-MsolUser -all -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Where-Object { $_.isLicensed -ne $True } | Remove-MsolUser -Force -TenantId $PartnerComboBox.SelectedItem.TenantID
				$TextboxResults.text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Where-Object { $_.isLicensed -like $True } | Format-List UserPrincipalName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all users without a license..."
				$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -ne `$True } | Remove-MsolUser -Force"
				Get-MsolUser -All | Where-Object { $_.isLicensed -ne $True } | Remove-MsolUser -Force
				$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -like $True } | Format-List UserPrincipalName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("No users were removed", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$displayAllLicenseInfoToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all license information..."
			$textboxDetails.Text = "Get-MsolAccountSku | Format-Table"
			$TextboxResults.text = Get-MsolAccountSku | Select-Object -Property AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, @{
				Name = 'Unused'
				Expression = {
					$_.ActiveUnits - $_.ConsumedUnits
				}
			} | Sort-Object Unused | Format-Table AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, Unused -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all license information..."
			$textboxDetails.Text = "Get-MsolAccountSku -TenantId $TenantText | Format-Table"
			$TextboxResults.text = Get-MsolAccountSku -TenantId $PartnerComboBox.SelectedItem.TenantID | Select-Object -Property AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, @{
				Name = 'Unused'
				Expression = {
					$_.ActiveUnits - $_.ConsumedUnits
				}
			} | Sort-Object Unused | Format-Table AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, Unused -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all license information..."
			$textboxDetails.Text = "Get-MsolAccountSku | Format-Table"
			$TextboxResults.text = Get-MsolAccountSku | Select-Object -Property AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, @{
				Name = 'Unused'
				Expression = {
					$_.ActiveUnits - $_.ConsumedUnits
				}
			} | Sort-Object Unused | Format-Table AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, Unused -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$addALicenseToAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				#$LicenseUserAdd = Read-Host "Enter the User Principal Name of the User you want to license"
				$SelectUsersFormText = "Select the User you want to add a license to"
				Show-SelectUnlicensedUsers_psf
				$LicenseUserAdd = $SelectUnlicensedUsers_comboboxSelectUnlicensedUsers
				If (!$LicenseUserAdd)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
				}
				Else
				{
					#$LicenseUserAddLocation = Read-Host "Enter the 2 digit location code for the user. Example: US"
					$locationCodeText = "Select the 2 digit location code"
					Show-SelectLocationCode_psf
					$LicenseUserAddLocation = $SelectLocationCode_comboboxSelectLocationCode_SelectedItem
					If (!$LicenseUserAddLocation)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No location was selected. Please enter a valid location code.", "Error")
					}
					Else
					{
						#$TextboxResults.text = Get-MsolAccountSku | Format-Table | Out-String
						#$LicenseType = Read-Host "Enter the AccountSku of the License you want to assign to this user"
						$LicensesText = "Select a license for $LicenseUserAdd"
						Show-SelectLicenses_psf
						$LicenseType = $SelectLicenses_comboboxSelectAvailableLicenses
						If (!$LicenseType)
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							[System.Windows.Forms.MessageBox]::Show("No license was selected. Please select a valid license", "Error")
						}
						Else
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							$TextboxResults.Text = "Adding $LicenseType license to $LicenseUserAdd..."
							
							$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
Set-MsolUserLicense -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType"
							Set-MsolUser -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
							Set-MsolUserLicense -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType
							$TextboxResults.Text = Get-MsolUser -UserPrincipalName $LicenseUserAdd | Format-List DisplayName, Licenses | Out-String -Width 2147483647
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
					}
				}
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				
				#$LicenseUserAdd = Read-Host "Enter the User Principal Name of the User you want to license"
				$SelectUsersFormText = "Select the user you want to add a license to"
				Show-SelectUnlicensedUsers_psf
				$LicenseUserAdd = $SelectUnlicensedUsers_comboboxSelectUnlicensedUsers
				If (!$LicenseUserAdd)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
				}
				Else
				{
					#$LicenseUserAddLocation = Read-Host "Enter the 2 digit location code for the user. Example: US"
					$locationCodeText = "Select the 2 digit location code"
					Show-SelectLocationCode_psf
					$LicenseUserAddLocation = $SelectLocationCode_comboboxSelectLocationCode_SelectedItem
					If (!$LicenseUserAddLocation)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No location was selected. Please enter a valid location code.", "Error")
					}
					Else
					{
						#$TextboxResults.text = Get-MsolAccountSku -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-Table | Out-String
						#$LicenseType = Read-Host "Enter the AccountSku of the License you want to assign to this user"
						$LicensesText = "Select a license for $LicenseUserAdd"
						Show-SelectLicenses_psf
						$LicenseType = $SelectLicenses_comboboxSelectAvailableLicenses
						If (!$LicenseType)
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							[System.Windows.Forms.MessageBox]::Show("No license was selected. Please select a valid license", "Error")
						}
						Else
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							$TextboxResults.Text = "Adding $LicenseType license to $LicenseUserAdd..."
							$textboxDetails.Text = "Set-MsolUser -TenantId $TenantText -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
Set-MsolUserLicense -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType"
							Set-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
							Set-MsolUserLicense -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType
							$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $LicenseUserAdd | Format-List DisplayName, Licenses | Out-String -Width 2147483647
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
					}
				}
			}
			Else
			{
				#$LicenseUserAdd = Read-Host "Enter the User Principal Name of the User you want to license"
				$SelectUsersFormText = "Select the user you want to add a license to"
				Show-SelectUnlicensedUsers_psf
				$LicenseUserAdd = $SelectUnlicensedUsers_comboboxSelectUnlicensedUsers
				If (!$LicenseUserAdd)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
				}
				Else
				{
					#$LicenseUserAddLocation = Read-Host "Enter the 2 digit location code for the user. Example: US"
					$locationCodeText = "Select the 2 digit location code"
					Show-SelectLocationCode_psf
					$LicenseUserAddLocation = $SelectLocationCode_comboboxSelectLocationCode_SelectedItem
					If (!$LicenseUserAddLocation)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No location was selected. Please enter a valid location code.", "Error")
					}
					Else
					{
						#$TextboxResults.text = Get-MsolAccountSku | Format-Table | Out-String
						#$LicenseType = Read-Host "Enter the AccountSku of the License you want to assign to this user"
						$LicensesText = "Select a license for $LicenseUserAdd"
						Show-SelectLicenses_psf
						$LicenseType = $SelectLicenses_comboboxSelectAvailableLicenses
						If (!$LicenseType)
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							[System.Windows.Forms.MessageBox]::Show("No license was selected. Please select a valid license", "Error")
						}
						Else
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							$TextboxResults.Text = "Adding $LicenseType license to $LicenseUserAdd..."
							
							$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
Set-MsolUserLicense -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType"
							Set-MsolUser -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
							Set-MsolUserLicense -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType
							$TextboxResults.Text = Get-MsolUser -UserPrincipalName $LicenseUserAdd | Format-List DisplayName, Licenses | Out-String -Width 2147483647
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add a License to another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeLicenseFromAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				#$RemoveLicenseFromUser = Read-Host "Enter the User Principal Name of the user you want to remove a license from"
				$SelectUsersFormText = "Select the User you want to remove a License from"
				#Call-SelectUsersForm_psf
				Show-SelectCachedUserPrincipalName_psf
				#$RemoveLicenseFromUser = $SelectUsersForm_comboboxUsers
				$RemoveLicenseFromUser = $SelectCachedUserPrincipalName_comboboxUPN
				If (!$RemoveLicenseFromUser)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
				}
				Else
				{
					#$TextboxResults.Text = Get-MsolUser -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String
					#$RemoveLicenseType = Read-Host "Enter the AccountSku of the license you want to remove"
					$UserLicenseText = "Select a license to remove from $RemoveLicenseFromUser"
					Show-SelectUserLicenses_psf
					$RemoveLicenseType = $SelectUserLicenses_comboboxSelectCurrentLicense
					If (!$RemoveLicenseType)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No License was selected. Please select a valid License", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Removing the $RemoveLicenseType license from $RemoveLicenseFromUser..."
						
						$textboxDetails.Text = "Set-MsolUserLicense -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType"
						Set-MsolUserLicense -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType
						$TextboxResults.Text = Get-MsolUser -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				
				#$RemoveLicenseFromUser = Read-Host "Enter the User Principal Name of the user you want to remove a license from"
				$SelectUsersFormText = "Select the User you want to remove a License from"
				#Call-SelectUsersForm_psf
				Show-SelectCachedUserPrincipalName_psf
				#$RemoveLicenseFromUser = $SelectUsersForm_comboboxUsers
				$RemoveLicenseFromUser = $SelectCachedUserPrincipalName_comboboxUPN
				#$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String
				If (!$RemoveLicenseFromUser)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					#$RemoveLicenseType = Read-Host "Enter the AccountSku of the license you want to remove"
					$UserLicenseText = "Select a license to remove from $RemoveLicenseFromUser"
					Show-SelectUserLicenses_psf
					$RemoveLicenseType = $SelectUserLicenses_comboboxSelectCurrentLicense
					If (!$RemoveLicenseType)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No License was selected. Please select a valid License", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Removing the $RemoveLicenseType license from $RemoveLicenseFromUser..."
						
						$textboxDetails.Text = "Set-MsolUserLicense -TenantId $TenantText -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType"
						Set-MsolUserLicense -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType
						$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
			Else
			{
				#$RemoveLicenseFromUser = Read-Host "Enter the User Principal Name of the user you want to remove a license from"
				$SelectUsersFormText = "Select the User you want to remove a License from"
				#Call-SelectUsersForm_psf
				Show-SelectCachedUserPrincipalName_psf
				#$RemoveLicenseFromUser = $SelectUsersForm_comboboxUsers
				$RemoveLicenseFromUser = $SelectCachedUserPrincipalName_comboboxUPN
				If (!$RemoveLicenseFromUser)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
				}
				Else
				{
					#$TextboxResults.Text = Get-MsolUser -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String
					#$RemoveLicenseType = Read-Host "Enter the AccountSku of the license you want to remove"
					$UserLicenseText = "Select a license to remove from $RemoveLicenseFromUser"
					Show-SelectUserLicenses_psf
					$RemoveLicenseType = $SelectUserLicenses_comboboxSelectCurrentLicense
					If (!$RemoveLicenseType)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No License was selected. Please select a valid License", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Removing the $RemoveLicenseType license from $RemoveLicenseFromUser..."
						
						$textboxDetails.Text = "Set-MsolUserLicense -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType"
						Set-MsolUserLicense -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType
						$TextboxResults.Text = Get-MsolUser -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove a License for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAUsersLicenseToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$licensedUsersText = "Select the User you want to view Licenses for"
			#Show-SelectLicensedUsers_psf
			Show-SelectCachedUserPrincipalName_psf
			#$UserLicInfo = $SelectLicensedUsers_comboboxSelectlicensedUsers
			$UserLicInfo = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$UserLicInfo)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $UserLicInfo | Select-Object Licenses"
					$TextboxResults.Text = Get-MsolUser -UserPrincipalName $UserLicInfo | Select-Object Licenses | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
					
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $UserLicInfo -TenantId $TenantText | Select-Object Licenses"
					$TextboxResults.Text = Get-MsolUser -UserPrincipalName $UserLicInfo -TenantId $PartnerComboBox.SelectedItem.TenantID | Select-Object Licenses | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $UserLicInfo | Select-Object Licenses"
					$TextboxResults.Text = Get-MsolUser -UserPrincipalName $UserLicInfo | Select-Object Licenses | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
					
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view Licenses for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Calendar Items

$AddCalendarPermissionsForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$Calendaruser = Read-Host "Enter the UPN of the user whose Calendar you want to give access to"
			$SelectUsersFormText = "Select the user you want to modify calendar permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$Calendaruserchangepermission = $SelectUsersForm_comboboxUsers
			$Calendaruserchangepermission = $SelectCachedDisplayNames_comboboxNames
			If (!$Calendaruserchangepermission)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				#$Calendaruser2 = Read-Host "Enter the UPN of the user who you want to give access to"
				$SelectUsersFormText = "Select the user you want to give permission to $Calendaruserchangepermission calendar"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$Calendarusergrantpermission = $SelectUsersForm_comboboxUsers
				$Calendarusergrantpermission = $SelectCachedDisplayNames_comboboxNames
				If (!$Calendarusergrantpermission)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
				}
				Else
				{
					$LabelPermissionsText = "Select the level of access you want $Calendarusergrantpermission to have on $Calendaruserchangepermission  calendar"
					Show-AccessPermissions_psf
					$level = $AccessPermissions_comboboxPermissions_SelectedItem
					If (!$level)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No level of access was selected, please select a valid level of access", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Adding $Calendarusergrantpermission to $Calendaruserchangepermission calender with $level permissions..."
						$textboxDetails.Text = "Add-MailboxFolderPermission -Identity ${Calendaruserchangepermission}:\calendar -user $Calendarusergrantpermission -AccessRights $level"
						Remove-MailboxFolderPermission -identity ${Calendaruserchangepermission}:\calendar -user $Calendarusergrantpermission -Confirm:$False
						Add-MailboxFolderPermission -Identity ${Calendaruserchangepermission}:\calendar -user $Calendarusergrantpermission -AccessRights $level
						$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${Calendaruserchangepermission}:\calendar | Sort-Object User, AccessRights | Format-Table User, AccessRights, Identity, FolderName, IsValid -AutoSize | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify Calendar Permissions for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$GetUsersCalendarPermissionsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$CalUserPermissions = Read-Host "What user would you like calendar permissions for?"
			$SelectUsersFormText = "Select the user you want to view calendar permissions for"
			Show-SelectCachedDisplayNames_psf
			$CalUserPermissions = $SelectCachedDisplayNames_comboboxNames
			If (!$CalUserPermissions)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting $CalUserPermissions calendar permissions..."
				$textboxDetails.Text = "Get-MailboxFolderPermission -Identity ${CalUserPermissions}:\calendar | Sort-Object User, AccessRights | Format-Table User, AccessRights, Identity, FolderName, IsValid -AutoSize"
				$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${CalUserPermissions}:\calendar | Sort-Object User, AccessRights | Format-Table User, AccessRights, Identity, FolderName, IsValid -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view Calendar Permissions for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$AddASingleUserPermissionsOnAllCalendarsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$MasterUser = Read-Host "Enter the UPN of the user you want permission on all users calendars"
			$SelectUsersFormText = "Select the user you want permission on all users calendars"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$MasterUser = $SelectUsersForm_comboboxUsers
			$MasterUser = $SelectCachedDisplayNames_comboboxNames
			If (!$MasterUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$LabelPermissionsText = "Select the level of access you want $MasterUser to have on all calendars"
				Show-AccessPermissions_psf
				$level2 = $AccessPermissions_comboboxPermissions_SelectedItem
				If (!$level2)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No level of access was selected, please select a valid level of access", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding $MasterUser to everyones calendars with $level2 permissions..."
					$textboxDetails.Text = "(Get-Mailbox) | Foreach-Object { Set-MailboxFolderPermission `$_':\Calendar' -User $MasterUser -AccessRights $level2 }"
					(Get-Mailbox) | Foreach-Object { Set-MailboxFolderPermission $_":\Calendar" -User $MasterUser -AccessRights $level2 }
					
						#(Get-Mailbox) | Foreach-Object Set-MailboxFolderPermission "$($_):\Calendar" -user $MasterUser -AccessRights $level2
					
					$TextboxResults.Text = "Successfully added $MasterUser to everyones calendars with $level2 permissions"
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add another User on everyones calendar?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAUserFromAllCalendarsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveUserFromAll = Read-Host "Enter the UPN of the user you want to remove from all calendars"
			$SelectUsersFormText = "Select the user you want to remove from all calendars"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$RemoveUserFromAll = $SelectUsersForm_comboboxUsers
			$RemoveUserFromAll = $SelectCachedDisplayNames_comboboxNames
			If (!$RemoveUserFromAll)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing $RemoveUserFromAll from all users calendar..."
				$textboxDetails.Text = "`$users = Get-Mailbox -ResultSize unlimited | Select-Object -ExpandProperty Alias
Foreach (`$user in `$users) { Remove-MailboxFolderPermission `${user}:\Calendar -user $RemoveUserFromAll -Confirm:`$false}﻿"
				$users = Get-Mailbox -ResultSize unlimited | Select-Object -ExpandProperty Alias
				Foreach ($user in $users)
				{
					Remove-MailboxFolderPermission "$($user):\Calendar" -user $RemoveUserFromAll -Confirm:$false
				}
				$TextboxResults.Text = "Successfully removed $RemoveUserFromAll from all users calendar..."
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		#Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another User from everyones Calendar?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAUserFromSomeonesCalendarToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$Calendaruserremove = Read-Host "Enter the UPN of the user whose calendar you want to remove access to"
			$SelectUsersFormText = "Select the user you want to modify calendar permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$GlobalCalUser = $SelectUsersForm_comboboxUsers
			$GlobalCalUser = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalCalUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				#$Calendaruser2remove = Read-Host "Enter the UPN of the user who you want to remove access"
				$CalendarPermissionsText = "Select the user you want to remove from $GlobalCalUser calendar"
				Show-SelectUserCalendarPermissions_psf
				$Calendaruser2remove = $SelectUserCalendarPermissions_comboboxSelectCalendarPermissions
				If (!$Calendaruser2remove)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing $Calendaruser2remove from $GlobalCalUser calendar..."
					$textboxDetails.Text = "Remove-MailboxFolderPermission -Identity ${GlobalCalUser}:\calendar -user $Calendaruser2remove"
					Remove-MailboxFolderPermission -Identity ${GlobalCalUser}:\calendar -user $Calendaruser2remove
					$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${GlobalCalUser}:\calendar | Sort-Object User, AccessRights | Format-Table User, AccessRights, Identity, FolderName, IsValid -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another User from someones Calendar?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Calendar Repair

$disableCalendarRepairForAllUsersToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to disable Calendar Repair for all users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		Try
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling Calendar Repair for all mailboxes..."
			$TextboxDetails.Text = "Get-mailbox -ResultSize unlimited | Set-Mailbox -CalendarRepairDisabled `$true"
			Get-mailbox -ResultSize unlimited | Set-Mailbox -CalendarRepairDisabled $true
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$TextboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("Calendar Repair has not been modified", "Info")
	}
	
	
}

$enableCalendarRepairForAllUsersToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to enable Calendar Repair for all users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		Try
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Enabling Calendar Repair for all mailboxes..."
			$TextboxDetails.Text = "Get-mailbox -ResultSize unlimited | Set-Mailbox -CalendarRepairDisabled `$false"
			Get-mailbox -ResultSize unlimited | Set-Mailbox -CalendarRepairDisabled $false
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$TextboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("Calendar Repair has not been modified", "Info")
	}
	
}

$disableCalendarRepairForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the user you want disable Calendar Repair for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$DisableCalRepairUser = $SelectUsersForm_comboboxUsers
			$DisableCalRepairUser = $SelectCachedDisplayNames_comboboxNames
			If (!$DisableCalRepairUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling Calendar Repair for $DisableCalRepairUser..."
				$TextboxDetails.Text = "Set-Mailbox -identity $DisableCalRepairUser -CalendarRepairDisabled `$true"
				Set-Mailbox -identity $DisableCalRepairUser -CalendarRepairDisabled $true
				$TextboxResults.Text = Get-Mailbox -identity $DisableCalRepairUser | Select-Object DisplayName, CalendarRepairDisabled | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$TextboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable Calendar Repair for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableCalendarRepairForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the user you want disable Calendar Repair for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$EnableCalRepairUser = $SelectUsersForm_comboboxUsers
			$EnableCalRepairUser = $SelectCachedDisplayNames_comboboxNames
			If (!$EnableCalRepairUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling Calendar Repair for $EnableCalRepairUser..."
				$TextboxDetails.Text = "Set-Mailbox -identity $EnableCalRepairUser -CalendarRepairDisabled `$false"
				Set-Mailbox -identity $EnableCalRepairUser -CalendarRepairDisabled $false
				$TextboxResults.Text = Get-Mailbox -identity $EnableCalRepairUser | Select-Object DisplayName, CalendarRepairDisabled | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$TextboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable Calendar Repair for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllUsersWithCalendarRepairEnabledToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users that have Calendar Repair enabled..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.CalendarRepairDisabled -eq `$false | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.CalendarRepairDisabled -eq $false } | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$TextboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllUsersWithCalendarRepairDisabledToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users that have Calendar Repair enabled..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.CalendarRepairDisabled -eq `$true | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.CalendarRepairDisabled -eq $true } | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$TextboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getCalendarRepairInfoForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the User you want get Calendar Repair info for"
			Show-SelectCachedDisplayNames_psf
			#$CalRepairUserinfo = $SelectUsersForm_comboboxUsers
			$CalRepairUserinfo = $SelectCachedDisplayNames_comboboxNames
			If (!$CalRepairUserinfo)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Calendar Repair info for $CalRepairUserinfo..."
				$TextboxDetails.Text = "Get-Mailbox -identity $CalRepairUserinfo | Select-Object DisplayName, CalendarRepairDisabled"
				$TextboxResults.Text = Get-Mailbox -identity $CalRepairUserinfo | Select-Object DisplayName, CalendarRepairDisabled | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$TextboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Calendar Repair status for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Clutter

$disableClutterForAllToolStripMenuItem_Click = {
	$TenantStatus = Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name TenantStatus | Select-Object -ExpandProperty TenantStatus
	If ($TenantStatus -eq 0)
	{
		try
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling Clutter for all users..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-Clutter -Enable `$false"
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-Clutter | Sort-Object MailboxIdentity | Format-Table IsEnabled, MailboxIdentity -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	elseif ($TenantStatus -eq 1)
	{
		[System.Windows.Forms.MessageBox]::Show("Microsoft currently does not support configuring Clutter when connected to a tenant", "Info")
	}
}

$enableClutterForAllToolStripMenuItem_Click = {
	$TenantStatus = Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name TenantStatus | Select-Object -ExpandProperty TenantStatus
	If ($TenantStatus -eq 0)
	{
		try
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Enabling Clutter for all users..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-Clutter -Enable `$True | Format-List MailboxIdentity, IsEnabled -AutoSize"
			$TextboxResults.text = Get-Mailbox -ResultSize unlimited | Set-Clutter -Enable $True | Format-Table MailboxIdentity, IsEnabled -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	elseif ($TenantStatus -eq 1)
	{
		[System.Windows.Forms.MessageBox]::Show("Microsoft currently does not support configuring Clutter when connected to a tenant", "Info")
	}
}

$enableClutterForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TenantStatus = Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name TenantStatus | Select-Object -ExpandProperty TenantStatus
			If ($TenantStatus -eq 0)
			{
				
				#$UserEnableClutter = Read-Host "Which user would you like to enable Clutter for?"
				$SelectUsersFormText = "Select the User you want to enable Clutter for"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$GlobalUPNenableClutter = $SelectUsersForm_comboboxUsers
				$GlobalUPNenableClutter = $SelectCachedDisplayNames_comboboxNames
				If (!$GlobalUPNenableClutter)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Enabling Clutter for $GlobalUPNenableClutter..."
					$textboxDetails.Text = "Get-Mailbox $GlobalUPNenableClutter | Set-Clutter -Enable `$True"
					$TextboxResults.text = Get-Mailbox $GlobalUPNenableClutter | Set-Clutter -Enable $True | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				
			}
			elseif ($TenantStatus -eq 1)
			{
				[System.Windows.Forms.MessageBox]::Show("Microsoft currently does not support configuring Clutter when connected to a tenant", "Info")
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable Clutter for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableClutterForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TenantStatus = Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name TenantStatus | Select-Object -ExpandProperty TenantStatus
			If ($TenantStatus -eq 0)
			{
				
				#$UserDisableClutter = Read-Host "Which user would you like to disable Clutter for?"
				$SelectUsersFormText = "Select the User you want to disable Clutter for"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$GlobalUPNdisableClutter = $SelectUsersForm_comboboxUsers
				$GlobalUPNdisableClutter = $SelectCachedDisplayNames_comboboxNames
				If (!$GlobalUPNdisableClutter)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Disabling Clutter for $GlobalUPNdisableClutter..."
					$textboxDetails.Text = "Set-Clutter -Identity $GlobalUPNdisableClutter -Enable `$False"
					$TextboxResults.text = Set-Clutter -Identity $GlobalUPNdisableClutter -Enable $False | Format-Table MailboxIdentity, IsEnabled -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			elseif ($TenantStatus -eq 1)
			{
				[System.Windows.Forms.MessageBox]::Show("Microsoft currently does not support configuring Clutter when connected to a tenant", "Info")
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Disable Clutter for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getClutterInfoForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TenantStatus = Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name TenantStatus | Select-Object -ExpandProperty TenantStatus
			If ($TenantStatus -eq 0)
			{
				#$GetCluterInfoUser = Read-Host "What user would you like to view Clutter information about?"
				$SelectUsersFormText = "Select the User you want to get Clutter information for"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$GlobalUPNinfoClutter = $SelectUsersForm_comboboxUsers
				$GlobalUPNinfoClutter = $SelectCachedDisplayNames_comboboxNames
				If (!$GlobalUPNinfoClutter)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting Clutter information for $GlobalUPNinfoClutter..."
					$textboxDetails.Text = "Get-Clutter -Identity $GlobalUPNinfoClutter"
					$TextboxResults.Text = Get-Clutter -Identity $GlobalUPNinfoClutter | Format-Table MailboxIdentity, IsEnabled -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			elseif ($TenantStatus -eq 1)
			{
				[System.Windows.Forms.MessageBox]::Show("Microsoft currently does not support configuring/viewing Clutter when connected to a tenant", "Info")
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Clutter status for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Recycle Bin

$displayAllDeletedUsersToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all deleted users..."
			$textboxDetails.Text = "Get-MsolUser -All -ReturnDeletedUsers |  Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize "
			$TextboxResults.Text = Get-MsolUser -All -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all deleted users..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText -ReturnDeletedUsers |  Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize "
			$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID -ReturnDeletedUsers | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, ObjectID -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all deleted users..."
			$textboxDetails.Text = "Get-MsolUser -All -ReturnDeletedUsers |  Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize "
			$TextboxResults.Text = Get-MsolUser -All -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$deleteAllUsersInRecycleBinToolStripMenuItem_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete all users in the recycle bin?.", "Warning!", 4)
		If ($OUTPUT -eq "YES")
		{
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Deleting all users in the recycle bin..."
				$textboxDetails.Text = "Get-MsolUser -ReturnDeletedUsers -All | Remove-MsolUser -RemoveFromRecycleBin –Force"
				$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers -All | Remove-MsolUser -RemoveFromRecycleBin –Force | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Deleting all users in the recycle bin..."
				$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -ReturnDeletedUsers -All | Remove-MsolUser -RemoveFromRecycleBin –Force"
				$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -ReturnDeletedUsers -All | Remove-MsolUser -RemoveFromRecycleBin –Force | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Deleting all users in the recycle bin..."
				$textboxDetails.Text = "Get-MsolUser -ReturnDeletedUsers -All | Remove-MsolUser -RemoveFromRecycleBin –Force"
				$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers -All | Remove-MsolUser -RemoveFromRecycleBin –Force | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("All users in the recycle bin have not been deleted", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$deleteSpecificUsersInRecycleBinToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DeletedUserRecycleBin = Read-Host "Please enter the User Principal Name of the user you want to permanently delete"
			$AliasRecycleBinText = "Select the User you want to delete from the Recycle Bin"
			Show-SelectUserRecycleBin_psf
			$GlobalUPNdeleteRecycle = $SelectUserRecycleBin_comboboxSelectRecycleBin
			$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $GlobalUPNdeleteRecycle ?", "Warning!", 4)
			If ($OUTPUT -eq "YES")
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Deleting  $GlobalUPNdeleteRecycle from the Recycle Bin..."
					$textboxDetails.Text = "Remove-MsolUser -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force"
					Remove-MsolUser -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force
					$TextboxResults.Text = "Getting users in the recycle bin..."
					$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Deleting  $GlobalUPNdeleteRecycle from the Recycle Bin..."
					$textboxDetails.Text = "Remove-MsolUser -TenantId $TenantText -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force"
					Remove-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force
					$TextboxResults.Text = "Getting users in the recycle bin..."
					$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Deleting  $GlobalUPNdeleteRecycle from the Recycle Bin..."
					$textboxDetails.Text = "Remove-MsolUser -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force"
					Remove-MsolUser -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force
					$TextboxResults.Text = "Getting users in the recycle bin..."
					$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				[System.Windows.Forms.MessageBox]::Show("$GlobalUPNdeleteRecycle was not deleted", "Info")
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to delete another User from the Recycle Bin?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$restoreDeletedUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RestoredUserFromRecycleBin = Read-Host "Enter the User Principal Name of the user you want to restore"
			$SelectUsersFormText = "Select the User you want to restore from the Recycle Bin"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrestoreuser = $SelectUsersForm_comboboxUsers
			$GlobalUPNrestoreuser = $SelectCachedUserPrincipalName_comboboxUPN
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Restoring $GlobalUPNrestoreuser from the Recycle Bin..."
				$textboxDetails.Text = "Restore-MsolUser –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts"
				Restore-MsolUser –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts
				$TextboxResults.Text = "Getting list of deleted users"
				$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Restoring $GlobalUPNrestoreuser from the Recycle Bin..."
				$textboxDetails.Text = "Restore-MsolUser -TenantId $TenantText –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts"
				Restore-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts
				$TextboxResults.Text = "Getting list of deleted users"
				$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Restoring $GlobalUPNrestoreuser from the Recycle Bin..."
				$textboxDetails.Text = "Restore-MsolUser –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts"
				Restore-MsolUser –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts
				$TextboxResults.Text = "Getting list of deleted users"
				$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to restore another User from the Recycle Bin?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$restoreAllDeletedUsersToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Restoring all deleted users..."
			$textboxDetails.Text = "Get-MsolUser -All -ReturnDeletedUsers | Restore-MsolUser"
			Get-MsolUser -ReturnDeletedUsers -All | Restore-MsolUser
			$TextboxResults.Text = "Users that were deleted have now been restored"
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Restoring all deleted users..."
			$textboxDetails.Text = "Get-MsolUser -ReturnDeletedUsers -TenantID $TenantText -All | Restore-MsolUser"
			Get-MsolUser -ReturnDeletedUsers -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Restore-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID
			$TextboxResults.Text = "Users that were deleted have now been restored"
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Restoring all deleted users..."
			$textboxDetails.Text = "Get-MsolUser -All -ReturnDeletedUsers | Restore-MsolUser"
			Get-MsolUser -ReturnDeletedUsers -All | Restore-MsolUser
			$TextboxResults.Text = "Users that were deleted have now been restored"
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

#Quarentine

$getQuarantineBetweenDatesToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$StartDateQuarentine = Read-Host "Enter the beginning date. (Format MM/DD/YYYY)"
			$StartDateText = "Select the beginning date to view quarantine"
			$StartDateFormText = "Start Date"
			Show-SelectDatePicker_psf
			$startdate = $SelectDatePicker_monthcalendar1
			$StartDateQuarentine = "$startdate".trimend('00:00:00')
			If (!$startdate)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No beginning date was selected, please enter a beginning date", "Error")
			}
			Else
			{
				#$EndDateQuarentine = Read-Host "Enter the end date. (Format MM/DD/YYYY)"
				$StartDateText = "Select the ending date to view quarantine"
				$StartDateFormText = "End Date"
				Show-SelectDatePicker_psf
				$enddate = $SelectDatePicker_monthcalendar1
				$EndDateQuarentine = "$enddate".trimend('00:00:00')
				If (!$enddate)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No ending date was selected, please enter a ending date", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting quarantine between $StartDateQuarentine and $EndDateQuarentine..."
					$textboxDetails.Text = "Get-QuarantineMessage -StartReceivedDate $StartDateQuarentine -EndReceivedDate $EndDateQuarentine | Format-List ReceivedTime, SenderAddress, RecipientAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction "
					$TextboxResults.Text = Get-QuarantineMessage -StartReceivedDate $StartDateQuarentine -EndReceivedDate $EndDateQuarentine | Format-List ReceivedTime, SenderAddress, RecipientAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the Quarentine for another time?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getQuarantineFromASpecificUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$QuarentineFromUser = Read-Host "Enter the E-mail Address you want to see quarentine from"
			If (!$QuarentineFromUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No E-mail Address was entered, please enter a valid E-mail Address", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Quarantine sent from $QuarentineFromUser ..."
				$textboxDetails.Text = "Get-QuarantineMessage -SenderAddress $QuarentineFromUser | Format-List ReceivedTime, SenderAddress, RecipientAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction"
				$TextboxResults.Text = Get-QuarantineMessage -SenderAddress $QuarentineFromUser | Format-List ReceivedTime, SenderAddress, RecipientAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view the Quarantine from a different E-mail Address?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getQuarantineToASpecificUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$QuarentineInfoForUser = Read-Host "Enter the email of the user you want to view quarantine for"
			$AllUsersEmailsText = "Select the E-mail Address or enter in one you want to view Quarantine for"
			Show-SelectAllEmailPrimaryAddresses_psf
			$QuarentineInfoForUser = $SelectAllEmailPrimaryAddresses_comboboxSelectAllEmailAddresses
			If (!$QuarentineInfoForUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No E-mail Address was selected, please select a valid E-mail Address", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Auarantine sent to $QuarentineInfoForUser..."
				$textboxDetails.Text = " Get-QuarantineMessage -RecipientAddress $QuarentineInfoForUser | Format-List ReceivedTime, SenderAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction"
				$TextboxResults.Text = Get-QuarantineMessage -RecipientAddress $QuarentineInfoForUser | Format-List ReceivedTime, SenderAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view the Quarantine sent to another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Passwords

$enableStrongPasswordForAUserToolStripMenuItem_Click = {
	Do
	{
		#$UserEnableStrongPasswords = Read-Host "Enter the User Principal Name of the user you want to enable strong password policy for"
		$SelectUsersFormText = "Select the User you want to enable Strong Password Policy for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPNespp = $SelectUsersForm_comboboxUsers
		$GlobalUPNespp = $SelectCachedUserPrincipalName_comboboxUPN
		If (!$GlobalUPNespp)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
		}
		Else
		{
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling Strong Password Policy for $GlobalUPNespp..."
				$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired `$True"
				Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired $True
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNespp | Format-List UserPrincipalName, StrongPasswordRequired | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling Strong Password Policy for $GlobalUPNespp..."
				$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired `$True -TenantId $TenantText"
				Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired $True -TenantId $PartnerComboBox.SelectedItem.TenantID
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNespp -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List UserPrincipalName, StrongPasswordRequired | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling Strong Password Policy for $GlobalUPNespp..."
				$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired `$True"
				Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired $True
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNespp | Format-List UserPrincipalName, StrongPasswordRequired | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable Strong Password Policy for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllUsersStrongPasswordPolicyInfoToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Sort-Object DisplayName | Format-Table DisplayName, strongpasswordrequired -AutoSize"
			$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText  | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize"
			$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object DisplayName | Format-Table DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Sort-Object DisplayName | Format-Table DisplayName, strongpasswordrequired -AutoSize"
			$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableStrongPasswordsForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UserdisableStrongPasswords = Read-Host "Enter the User Principal Name of the user you want to disable strong password policy for"
			$SelectUsersFormText = "Select the User you want to disable Strong Password Policy for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNdspp = $SelectUsersForm_comboboxUsers
			$GlobalUPNdspp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNdspp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Disabling Strong Password Policy for $GlobalUPNdspp..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired `$False"
					Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired $False
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdspp | Format-List UserPrincipalName, StrongPasswordRequired | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Disabling Strong Password Policy for $GlobalUPNdspp..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired `$False -TenantID $TenantText"
					Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired $False -TenantId $PartnerComboBox.SelectedItem.TenantID
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdspp -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List UserPrincipalName, StrongPasswordRequired | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Disabling Strong Password Policy for $GlobalUPNdspp..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired `$False"
					Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired $False
					$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdspp | Format-List UserPrincipalName, StrongPasswordRequired | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable Strong Password Policy for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableStrongPasswordsForAllToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Enabling strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired `$True"
			Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired $True
			$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Enabling strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Set-MsolUser -StrongPasswordRequired -TenantId $TenantText `$True"
			Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Set-MsolUser -StrongPasswordRequired $True -TenantId $PartnerComboBox.SelectedItem.TenantID
			$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Enabling strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired `$True"
			Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired $True
			$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableStrongPasswordsForAllToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired `$False"
			Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired $False
			$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Set-MsolUser -StrongPasswordRequired `$False -TenantId $TenantText"
			Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Set-MsolUser -StrongPasswordRequired $False -TenantId $PartnerComboBox.SelectedItem.TenantID
			$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling strong password policy for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired `$False"
			Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired $False
			$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$resetPasswordForAUserToolStripMenuItem1_Click = {
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to reset the password for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$NewPassword = Read-Host "What would you like the new password to be?"
				If (!$NewPassword)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No password was entered for $GlobalUPNrpp, please enter a password", "Error")
				}
				Else
				{
					#What to do if connected to main o365 account
					If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Resetting $GlobalUPNrpp password to $NewPassword..."
						$textboxDetails.Text = "Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword `$False"
						Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword $False
						$TextboxResults.Text = "The password for $GlobalUPNrpp has been set to $NewPassword"
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					#What to do if connected to partner account
					ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
					{
						$TenantText = $PartnerComboBox.text
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Resetting $GlobalUPNrpp password to $NewPassword..."
						$textboxDetails.Text = "Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword `$False -TenantId $TenantText"
						Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword $False -TenantId $PartnerComboBox.SelectedItem.TenantID
						$TextboxResults.Text = "The password for $GlobalUPNrpp has been set to $NewPassword"
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Resetting $GlobalUPNrpp password to $NewPassword..."
						$textboxDetails.Text = "Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword `$False"
						Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword $False
						$TextboxResults.Text = "The password for $GlobalUPNrpp has been set to $NewPassword"
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to reset another Users password?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$setPasswordToNeverExpireForAllToolStripMenuItem1_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to set everyones password to never expire?", "Warning!", 4)
		If ($OUTPUT -eq "YES")
		{
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Setting password to never expire for all..."
				$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires `$True"
				Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires $True
				$TextboxResults.text = Get-MSOLUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Setting password to never expire for all..."
				$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Set-MsolUser –PasswordNeverExpires `$True -TenantId $TenantText"
				Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Set-MsolUser –PasswordNeverExpires $True -TenantId $PartnerComboBox.SelectedItem.TenantID
				$TextboxResults.text = Get-MSOLUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Setting password to never expire for all..."
				$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires `$True"
				Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires $True
				$TextboxResults.text = Get-MSOLUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("No changes have been made", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$setPasswordToExpireForAllToolStripMenuItem1_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to set everyones password to expire?", "Warning!", 4)
		If ($OUTPUT -eq "YES")
		{
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Setting password to expire for all..."
				$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires `$False"
				Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires $False
				$TextboxResults.text = Get-MSOLUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Setting password to expire for all..."
				$textboxDetails.Text = "Get-MsolUser -All -Tenant $TenantText | Set-MsolUser –PasswordNeverExpires `$False -TenantId $TenantText"
				Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Set-MsolUser –PasswordNeverExpires $False -TenantId $PartnerComboBox.SelectedItem.TenantID
				$TextboxResults.text = Get-MSOLUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Setting password to expire for all..."
				$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires `$False"
				Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires $False
				$TextboxResults.text = Get-MSOLUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("No changes have been made", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$resetPasswordForAllToolStripMenuItem_Click = {
	Try
	{
		$SetPasswordforAll = Read-Host "What password would you like to set for all users?"
		If (!$SetPasswordforAll)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No password was entered, please enter a valid password", "Error")
		}
		Else
		{
			$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to change all users password to $SetPasswordforAll", "Warning!", 4)
			If ($OUTPUT -eq "YES")
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Resetting all users passwords to $SetPasswordforAll..."
					$textboxDetails.Text = "Get-MsolUser -All | ForEach-Object{ 
Set-MsolUserPassword -userPrincipalName `$_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword `$False }"
					Get-MsolUser -All | ForEach-Object{ Set-MsolUserPassword -UserPrincipalName $_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword $False }
					$TextboxResults.Text = "Password for all users has been set to $SetPasswordforAll"
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Resetting all users passwords to $SetPasswordforAll..."
					$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | ForEach-Object{ 
Set-MsolUserPassword -TenantId $TenantText -userPrincipalName `$_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword `$False }"
					Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | ForEach-Object { Set-MsolUserPassword -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword $False }
					$TextboxResults.Text = "Password for all users has been set to $SetPasswordforAll"
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Resetting all users passwords to $SetPasswordforAll..."
					$textboxDetails.Text = "Get-MsolUser -All | ForEach-Object{ 
Set-MsolUserPassword -userPrincipalName `$_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword `$False }"
					Get-MsolUser -All | ForEach-Object{ Set-MsolUserPassword -UserPrincipalName $_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword $False }
					$TextboxResults.Text = "Password for all users has been set to $SetPasswordforAll"
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				[System.Windows.Forms.MessageBox]::Show("No user passwords have not been changed", "Info")
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$setATemporaryPasswordForAllToolStripMenuItem_Click = {
	Try
	{
		$SetTempPasswordforAll = Read-Host "What password would you like to set for all users?"
		If (!$SetTempPasswordforAll)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No password was entered, please enter a valid password", "Error")
		}
		Else
		{
			$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want change all users passwords to $SetTempPasswordforAll", "Warning!", 4)
			If ($OUTPUT -eq "YES")
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting $SetTempPasswordforAll as the temporary password for all users..."
					$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUserPassword –NewPassword $SetTempPasswordforAll -ForceChangePassword `$True"
					Get-MsolUser -All | Set-MsolUserPassword –NewPassword $SetTempPasswordforAll -ForceChangePassword $True
					$TextboxResults.Text = "Temporary password has been set to $SetTempPasswordforAll Please note that users will be prompted to change it upon logon"
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting $SetTempPasswordforAll as the temporary password for all users..."
					$textboxDetails.Text = "Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Set-MsolUserPassword -TenantId $TenantText –NewPassword $SetTempPasswordforAll -ForceChangePassword `$True"
					Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Set-MsolUserPassword -TenantId $PartnerComboBox.SelectedItem.TenantID –NewPassword $SetTempPasswordforAll -ForceChangePassword $True
					$TextboxResults.Text = "Temporary password has been set to $SetTempPasswordforAll Please note that users will be prompted to change it upon logon"
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting $SetTempPasswordforAll as the temporary password for all users..."
					$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUserPassword –NewPassword $SetTempPasswordforAll -ForceChangePassword `$True"
					Get-MsolUser -All | Set-MsolUserPassword –NewPassword $SetTempPasswordforAll -ForceChangePassword $True
					$TextboxResults.Text = "Temporary password has been set to $SetTempPasswordforAll Please note that users will be prompted to change it upon logon"
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				[System.Windows.Forms.MessageBox]::Show("No user passwords have not been changed", "Info")
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$TemporaryPasswordForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ResetPasswordUser2 = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to reset the password for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrtp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrtp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrtp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$NewPassword2 = Read-Host "What would you like the new password to be?"
				If (!$NewPassword2)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No password was entered, please enter a valid password", "Error")
				}
				Else
				{
					#What to do if connected to main o365 account
					If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Setting $NewPassword2 as the temporary password for $GlobalUPNrtp..."
						$textboxDetails.Text = "Set-MsolUserPassword –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword `$True"
						Set-MsolUserPassword –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword $True
						$TextboxResults.Text = "Temporary password has been set to $NewPassword2 Please note that $GlobalUPNrtp will be prompted to change it upon logon"
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					#What to do if connected to partner account
					ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
					{
						$TenantText = $PartnerComboBox.text
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Setting $NewPassword2 as the temporary password for $GlobalUPNrtp..."
						$textboxDetails.Text = "Set-MsolUserPassword -TenantId $TenantText –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword `$True"
						Set-MsolUserPassword -TenantId $PartnerComboBox.SelectedItem.TenantID –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword $True
						$TextboxResults.Text = "Temporary password has been set to $NewPassword2 Please note that $GlobalUPNrtp will be prompted to change it upon logon"
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Setting $NewPassword2 as the temporary password for $GlobalUPNrtp..."
						$textboxDetails.Text = "Set-MsolUserPassword –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword `$True"
						Set-MsolUserPassword –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword $True
						$TextboxResults.Text = "Temporary password has been set to $NewPassword2 Please note that $GlobalUPNrtp will be prompted to change it upon logon"
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to set a temporary password for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getPasswordResetDateForAUserToolStripMenuItem_Click = {
	Try
	{
		#$GetPasswordInfoUser = Read-Host "Enter the UPN of the user you want to view the password last changed date for"
		$SelectUsersFormText = "Select the user you want to view last password changed date for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPNgpifu = $SelectUsersForm_comboboxUsers
		$GlobalUPNgpifu = $SelectCachedUserPrincipalName_comboboxUPN
		If (!$GlobalUPNgpifu)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
		}
		Else
		{
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting last password reset date for $GlobalUPNgpifu..."
				$textboxDetails.Text = "Get-MsolUser -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp"
				$TextboxResults.Text = Get-MsolUser -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting last password reset date for $GlobalUPNgpifu..."
				$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp"
				$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting last password reset date for $GlobalUPNgpifu..."
				$textboxDetails.Text = "Get-MsolUser -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp"
				$TextboxResults.Text = Get-MsolUser -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getPasswordLastResetDateForAllToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last password reset date for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize "
			$TextboxResults.Text = Get-MsolUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last password reset date for all users..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize "
			$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last password reset date for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize "
			$TextboxResults.Text = Get-MsolUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$setPasswordToExpireForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$PasswordtoExpireforUser = Read-Host "Enter the UPN of the user you want the password to expire for"
			$SelectUsersFormText = "Select the User you want to set password to expire for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNspte = $SelectUsersForm_comboboxUsers
			$GlobalUPNspte = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNspte)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting password to expire for $GlobalUPNspte..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires `$False"
					Set-MsolUser -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires $False
					$TextboxResults.text = Get-MSOLUser -UserPrincipalName $GlobalUPNspte | Format-List UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting password to expire for $GlobalUPNspte..."
					$textboxDetails.Text = "Set-MsolUser -TenantId $TenantText -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires `$False"
					Set-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires $False
					$TextboxResults.text = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPNspte | Format-List UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting password to expire for $GlobalUPNspte..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires `$False"
					Set-MsolUser -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires $False
					$TextboxResults.text = Get-MSOLUser -UserPrincipalName $GlobalUPNspte | Format-List UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to set the password to expire for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$setPasswordToNeverExpireForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$PasswordtoNeverExpireforUser = Read-Host "Enter the UPN of the user you want the password to never expire for"
			$SelectUsersFormText = "Select the User you want to set the password to never expire"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$PasswordtoNeverExpireforUser = $SelectUsersForm_comboboxUsers
			$PasswordtoNeverExpireforUser = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$PasswordtoNeverExpireforUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting password to never expire for $PasswordtoNeverExpireforUser..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires `$True"
					Set-MsolUser -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires $True
					$TextboxResults.text = Get-MSOLUser -UserPrincipalName $PasswordtoNeverExpireforUser | Format-List UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
					
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting password to never expire for $PasswordtoNeverExpireforUser..."
					$textboxDetails.Text = "Set-MsolUser -TenantId $TenantText -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires `$True"
					Set-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires $True
					$TextboxResults.text = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $PasswordtoNeverExpireforUser | Format-List UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting password to never expire for $PasswordtoNeverExpireforUser..."
					$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires `$True"
					Set-MsolUser -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires $True
					$TextboxResults.text = Get-MSOLUser -UserPrincipalName $PasswordtoNeverExpireforUser | Format-List UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
					
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to set the password to never expire for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getUsersWhosPasswordNeverExpiresToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting users where the password is set to never expire..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.PasswordNeverExpires -eq `$True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.PasswordNeverExpires -eq $True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting users where the password is set to never expire..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Where-Object { `$_.PasswordNeverExpires -eq `$True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
			$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.PasswordNeverExpires -eq $True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting users where the password is set to never expire..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.PasswordNeverExpires -eq `$True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.PasswordNeverExpires -eq $True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getUsersWhosPasswordWillExpireToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting users where the password is set to expire..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.PasswordNeverExpires -eq `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.PasswordNeverExpires -eq $False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting users where the password is set to expire..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Where-Object { `$_.PasswordNeverExpires -eq `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
			$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.PasswordNeverExpires -eq $False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
			}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting users where the password is set to expire..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.PasswordNeverExpires -eq `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.PasswordNeverExpires -eq $False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getPasswordLastResetDateForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$GetPasswordInfoUser = Read-Host "Enter the UPN of the user you want to view the password last changed date for"
			$SelectUsersFormText = "Select the User you want to view the password last changed date for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GetPasswordInfoUser = $SelectUsersForm_comboboxUsers
			$GetPasswordInfoUser = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GetPasswordInfoUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting last password reset date for $GetPasswordInfoUser..."
					$textboxDetails.Text = "Get-MsolUser -userprincipalname $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp"
					$TextboxResults.Text = Get-MsolUser -userprincipalname $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting last password reset date for $GetPasswordInfoUser..."
					$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -UserPrincipalName $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp"
					$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -userprincipalname $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting last password reset date for $GetPasswordInfoUser..."
					$textboxDetails.Text = "Get-MsolUser -userprincipalname $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp"
					$TextboxResults.Text = Get-MsolUser -userprincipalname $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the last password reset date for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getUsersNextPasswordResetDateToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$NextUserResetDateUser = Read-Host "Enter the UPN of the user"
			$SelectUsersFormText = "Select the User you want to view the next password reset date for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$NextUserResetDateUser = $SelectUsersForm_comboboxUsers
			$NextUserResetDateUser = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$NextUserResetDateUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$VarDate = Read-Host "Enter days before passwords expires. EX: 90"
				If (!$VarDate)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No number was entered, please enter a valid number", "Error")
				}
				Else
				{
					#What to do if connected to main o365 account
					If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Getting $NextUserResetDateUser next password reset date..."
						$textboxDetails.Text = "(Get-MSOLUser -All -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime"
						$TextboxResults.Text = (Get-MSOLUser -All -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					#What to do if connected to partner account
					ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
					{
						$TenantText = $PartnerComboBox.text
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Getting $NextUserResetDateUser next password reset date..."
						$textboxDetails.Text = "(Get-MSOLUser -All -TenantId $TenantText -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime"
						$TextboxResults.Text = (Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Getting $NextUserResetDateUser next password reset date..."
						$textboxDetails.Text = "(Get-MSOLUser -All -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime"
						$TextboxResults.Text = (Get-MSOLUser -All -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the next password reset date for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

#Mailbox Permissions

$addFullPermissionsToAMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the User you are changing permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$mailboxAccess = $SelectUsersForm_comboboxUsers
			$mailboxAccess = $SelectCachedDisplayNames_comboboxNames
			#$mailboxAccess = read-host "Mailbox you want to give full-access to"
			If (!$mailboxAccess)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$SelectUsersFormText = "Select the User you want to give full access to $mailboxAccess"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$mailboxUser = $SelectUsersForm_comboboxUsers
				$mailboxUser = $SelectCachedDisplayNames_comboboxNames
				#$mailboxUser = read-host "Enter the UPN of the user that will have full access"
				If (!$mailboxUser)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Assigning full access permissions to $mailboxUser for the account $mailboxAccess..."
					$textboxDetails.Text = "Add-MailboxPermission -identity $mailboxAccess -User $mailboxUser -AccessRights FullAccess -InheritanceType All"
					$TextboxResults.text = Add-MailboxPermission -identity $mailboxAccess -User $mailboxUser -AccessRights FullAccess -InheritanceType All | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$addSendAsPermissionToAMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$SendAsAccess = read-host "Mailbox you want to give Send As access to"
			$SelectUsersFormText = "Select the User you want to modify Send As access permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$SendAsAccess = $SelectUsersForm_comboboxUsers
			$SendAsAccess = $SelectCachedDisplayNames_comboboxNames
			If (!$SendAsAccess)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#$mailboxUserAccess = read-host "Enter the UPN of the user that will have Send As access"
				$SelectUsersFormText = "Select the User you want to give Send As access to $SendAsAccess"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$mailboxUserAccess = $SelectUsersForm_comboboxUsers
				$mailboxUserAccess = $SelectCachedDisplayNames_comboboxNames
				If (!$mailboxUserAccess)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Assigning Send-As access to $mailboxUserAccess for the account $SendAsAccess..."
					$textboxDetails.Text = "Add-RecipientPermission $SendAsAccess -Trustee $mailboxUserAccess -AccessRights SendAs"
					$TextboxResults.text = Add-RecipientPermission $SendAsAccess -Trustee $mailboxUserAccess -AccessRights SendAs | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$assignSendOnBehalfPermissionsForAMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$SendonBehalfof = read-host "Mailbox you want to give Send on Behalf access to"
			$SelectUsersFormText = "Select the User you want to modify Send on Behalf permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$SendonBehalfof = $SelectUsersForm_comboboxUsers
			$SendonBehalfof = $SelectCachedDisplayNames_comboboxNames
			If (!$SendonBehalfof)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#$mailboxUserSendonBehalfAccess = read-host "Enter the UPN of the user that will have Send As access"
				$SelectUsersFormText = "Select the User you want to give Send on Behalf permissions for $SendonBehalfof"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$mailboxUserSendonBehalfAccess = $SelectUsersForm_comboboxUsers
				$mailboxUserSendonBehalfAccess = $SelectCachedDisplayNames_comboboxNames
				If (!$mailboxUserSendonBehalfAccess)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Assigning Send On Behalf of permissions to $mailboxUserSendonBehalfAccess for the account $SendonBehalfof..."
					$textboxDetails.Text = "Set-Mailbox -Identity $SendonBehalfof -GrantSendOnBehalfTo $mailboxUserSendonBehalfAccess"
					Set-Mailbox -Identity $SendonBehalfof -GrantSendOnBehalfTo $mailboxUserSendonBehalfAccess
					$TextboxResults.text = Get-Mailbox -Identity $SendonBehalfof | Format-List Identity, GrantSendOnBehalfTo | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$displayMailboxPermissionsForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$MailboxUserFullAccessPermission = Read-Host "Enter the UPN of the user want to view Full Access permissions for"
			$SelectUsersFormText = "Select the user you want to view Full Access permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$MailboxUserFullAccessPermission = $SelectUsersForm_comboboxUsers
			$MailboxUserFullAccessPermission = $SelectCachedDisplayNames_comboboxNames
			If (!$MailboxUserFullAccessPermission)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Full Access permissions for $MailboxUserFullAccessPermission..."
				$textboxDetails.Text = "Get-MailboxPermission $MailboxUserFullAccessPermission | Where-Object { (`$_.IsInherited -eq `$False) -and (`$_.User -notcontains 'NT AUTHORITY\SELF') } | Sort-Object User | Format-Table -AutoSize"
				$TextboxResults.text = Get-MailboxPermission $MailboxUserFullAccessPermission | Where-Object { ($_.IsInherited -eq $False) -and ($_.User -notcontains 'NT AUTHORITY\SELF') } | Sort-Object User | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view Mailboxes permission for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

<# $displaySendAsPermissionForAMailboxToolStripMenuItem_Click = {
	#$MailboxUserSendAsPermission = Read-Host "Enter the UPN of the user you want to view Send As permissions for"
	$SelectUsersFormText = "Select the user you want to view Send As permissions for"
	Call-SelectUsersForm_psf
	$MailboxUserSendAsPermission = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting Send As Permissions for $MailboxUserSendAsPermission..."
		$textboxDetails.Text = "Get-RecipientPermission $MailboxUserSendAsPermission | Where-Object { (`$_.IsInherited -eq `$False) -and -not (`$_.Trustee -like 'NT AUTHORITY\SELF') } | Sort-Object User | Format-Table -AutoSize"
		$TextboxResults.text = Get-RecipientPermission $MailboxUserSendAsPermission | Where-Object { ($_.IsInherited -eq $False) -and -not ($_.Trustee -like "NT AUTHORITY\SELF") } | Sort-Object User | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}

}
#>

<#
$displaySendOnBehalfPermissionsForMailboxToolStripMenuItem_Click = {
	#$MailboxUserSendonPermission = Read-Host "Enter the UPN of the user you want to view Send On Behalf Of permission for"
	$SelectUsersFormText = "Select the user you want to view Send on Behalf permissions for"
	Call-SelectUsersForm_psf
	$MailboxUserSendonPermission = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting Send On Behalf permissions for $MailboxUserSendonPermission..."
		$textboxDetails.Text = "Get-RecipientPermission $MailboxUserSendonPermission | Where-Object { (`$_.IsInherited -eq `$False) -and -not (`$_.Trustee -like 'NT AUTHORITY\SELF') } | Sort-Object User | Format-Table"
		$TextboxResults.text = Get-RecipientPermission $MailboxUserSendonPermission | Where-Object { ($_.IsInherited -eq $False) -and -not ($_.Trustee -like "NT AUTHORITY\SELF") } | Sort-Object User | Format-Table | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}
#>

$removeFullAccessPermissionsForAMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UserRemoveFullAccessRights = Read-Host "What user mailbox would you like modify Full Access rights to"
			$SelectUsersFormText = "Select the User you want to modify Full Access rights for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$UserRemoveFullAccessRights = $SelectUsersForm_comboboxUsers
			$UserRemoveFullAccessRights = $SelectCachedDisplayNames_comboboxNames
			If (!$UserRemoveFullAccessRights)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#$RemoveFullAccessRightsUser = Read-Host "Enter the UPN of the user you want to remove"
				$FullPermissionsText = "Select the User you want to remove"
				Show-SelectUserFullPermissions_psf
				$RemoveFullAccessRightsUser = $SelectUserFullPermissions_comboboxSelectFullAccessUsers
				If (!$RemoveFullAccessRightsUser)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing Full Access Permissions for $RemoveFullAccessRightsUser on account $UserRemoveFullAccessRights..."
					$textboxDetails.Text = "Remove-MailboxPermission  $UserRemoveFullAccessRights -User $RemoveFullAccessRightsUser -AccessRights FullAccess -Confirm:`$False -ea 1"
					Remove-MailboxPermission  $UserRemoveFullAccessRights -User $RemoveFullAccessRightsUser -AccessRights FullAccess -Confirm:$False -ea 1
					$TextboxResults.text = Get-MailboxPermission $UserRemoveFullAccessRights | Where-Object { ($_.IsInherited -eq $False) -and -not ($_.User -like "NT AUTHORITY\SELF") } | Sort-Object User | Format-Table | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$revokeSendAsPermissionsForAMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UserDeleteSendAsAccessOn = Read-Host "What user mailbox would you like to modify Send As permission for?"
			$SelectUsersFormText = "Select the User you want to modify Send As permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$GlobalUserCurrentPermissions = $SelectUsersForm_comboboxUsers
			$GlobalUserCurrentPermissions = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalUserCurrentPermissions)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#$UserDeleteSendAsAccess = Read-Host "Enter the UPN of the user you want to remove Send As access to?"
				$CurrentMailboxPermissionsText = "Select the user you want to remove Send As access to"
				Show-SelectExistingMailboxPermissions_psf
				$UserDeleteSendAsAccess = $SelectExistingMailboxPermissions_comboboxSelectCurrentPermissions
				If (!$UserDeleteSendAsAccess)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing Send As permission for $UserDeleteSendAsAccess on account $GlobalUserCurrentPermissions..."
					$textboxDetails.Text = "Remove-RecipientPermission $GlobalUserCurrentPermissions -AccessRights SendAs -Trustee $UserDeleteSendAsAccess"
					$TextboxResults.Text = Remove-RecipientPermission $GlobalUserCurrentPermissions -AccessRights SendAs -Trustee $UserDeleteSendAsAccess | Sort-Object User | Format-Table | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
					
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$viewAllMailboxesAUserHasFullAccessToToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ViewAllFullAccess = Read-Host "Enter the UPN of the account you want to view"
			$SelectUsersFormText = "Select the User you want to view"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$ViewAllFullAccess = $SelectUsersForm_comboboxUsers
			$ViewAllFullAccess = $SelectCachedDisplayNames_comboboxNames
			If (!$ViewAllFullAccess)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all mailboxes $ViewAllFullAccess has Full Access permissions to..."
				$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Get-MailboxPermission -User $ViewAllFullAccess |  Sort-Object Identity | Format-Table"
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-MailboxPermission -User $ViewAllFullAccess | Sort-Object Identity | Format-Table | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view all Mailboxes another user has Full Access to?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$viewAllMailboxesAUserHasSendAsPermissionsToToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ViewSendAsAccess = Read-Host "Enter the UPN of the account you want to view"
			$SelectUsersFormText = "Select the user you want to view all accounts they have Send As permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			$ViewSendAsAccess = $SelectUsersForm_comboboxUsers
			$ViewSendAsAccess = $SelectCachedDisplayNames_comboboxNames
			If (!$ViewSendAsAccess)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all mailboxes $ViewSendAsAccess has Send As permissions to..."
				$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Get-RecipientPermission -Trustee $ViewSendAsAccess | Sort-Object Identity | Format-Table"
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-RecipientPermission -Trustee $ViewSendAsAccess | Sort-Object Identity | Format-Table | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view all Mailboxes another user has Send As Permission to?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$viewAllMailboxesAUserHasSendOnBehaldPermissionsToToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ViewSendonBehalf = Read-Host "Enter the Name of the account you want to view"
			$SelectUsersFormText = "Select the User you want to view all accounts they have Send On Behalf Of permissiosn for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$ViewSendonBehalf = $SelectUsersForm_comboboxUsers
			$ViewSendonBehalf = $SelectCachedDisplayNames_comboboxNames
			If (!$ViewSendonBehalf)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all mailboxes $ViewSendonBehalf has Send On Behalf permissions to..."
				$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.GrantSendOnBehalfTo -match $ViewSendonBehalf } | Sort-Object DisplayName | Format-Table DisplayName, GrantSendOnBehalfTo, PrimarySmtpAddress, RecipientType"
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.GrantSendOnBehalfTo -match $ViewSendonBehalf } | Sort-Object DisplayName | Format-Table DisplayName, GrantSendOnBehalfTo, PrimarySmtpAddress, RecipientType | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view all Mailboxes another user has Send on Behalf to?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAllPermissionsToAMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UserDeleteAllAccessOn = Read-Host "What user mailbox would you like to modify permissions for?"
			$SelectUsersFormText = "Select the User you want to modify permissions for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$GlobalUserCurrentPermissions = $SelectUsersForm_comboboxUsers
			$GlobalUserCurrentPermissions = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalUserCurrentPermissions)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#$UserDeleteAllAccess = Read-Host "Enter the UPN of the user you want to remove access to?"
				$CurrentMailboxPermissionsText = "Select the User you want to remove access to"
				Show-SelectExistingMailboxPermissions_psf
				$UserDeleteAllAccess = $SelectExistingMailboxPermissions_comboboxSelectCurrentPermissions
				If (!$UserDeleteAllAccess)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing all permissions for $UserDeleteAllAccess on account $GlobalUserCurrentPermissions..."
					$textboxDetails.Text = "Remove-MailboxPermission -Identity $GlobalUserCurrentPermissions -User $UserDeleteAllAccess -AccessRights FullAccess -InheritanceType All"
					Remove-MailboxPermission -Identity $GlobalUserCurrentPermissions -User $UserDeleteAllAccess -AccessRights FullAccess -InheritanceType All
					$TextboxResults.Text = "Getting mailbox permissions for $GlobalUserCurrentPermissions..."
					$TextboxResults.Text = Get-MailboxPermission -Identity $GlobalUserCurrentPermissions | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Forwarding

$getAllUsersForwardinToInternalRecipientToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users forwarding to internal users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.ForwardingAddress -ne `$Null -and `$_.RecipientType -eq 'UserMailbox' } | Sort-Object Name | Format-Table Name, ForwardingAddress, DeliverToMailboxAndForward -AutoSize"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.ForwardingAddress -ne $Null -and $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, ForwardingAddress, DeliverToMailboxAndForward -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		$FormO365AdministrationCenter.Cursor = 'Default'
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardToInternalRecipientAndDontSaveLocalCopyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UsertoFWD2 = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
			$SelectUsersFormText = "Select the user you want to modify fowarding for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$UsertoFWD2 = $SelectUsersForm_comboboxUsers
			$UsertoFWD2 = $SelectCachedDisplayNames_comboboxNames
			If (!$UsertoFWD2)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a user", "Error")
			}
			Else
			{
				#$Fwd2me2 = Read-Host "Enter the Name, Display Name, Alias, or Email Address of the user to forward to"
				$SelectUsersFormText = "Select the User you want $UsertoFWD2 to forward to"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$Fwd2me2 = $SelectUsersForm_comboboxUsers
				$Fwd2me2 = $SelectCachedDisplayNames_comboboxNames
				If (!$Fwd2me2)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting up forwarding from $UsertoFWD2 to $Fwd2me2..."
					$textboxDetails.Text = "Set-Mailbox  $UsertoFWD2 -ForwardingAddress $Fwd2me2 -DeliverToMailboxAndForward `$False"
					Set-Mailbox  $UsertoFWD2 -ForwardingAddress $Fwd2me2 -DeliverToMailboxAndForward $False
					$TextboxResults.Text = Get-Mailbox $UsertoFWD2 | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify forwarding for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$forwardToExternalAddressAndSaveLocalCopyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UsertoFWD3 = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
			$SelectUsersFormText = "Select the User you want to modify fowarding for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$UsertoFWD3 = $SelectUsersForm_comboboxUsers
			$UsertoFWD3 = $SelectCachedDisplayNames_comboboxNames
			If (!$UsertoFWD3)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$Fwd2me2External = Read-Host "Enter the external Email Address to forward to"
				If (!$Fwd2me2External)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No external E-mail Address was entered, please enter a valid E-mail Address", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting up forwarding from $UsertoFWD3 to $Fwd2me2External..."
					$textboxDetails.Text = "Set-Mailbox $UsertoFWD3 -ForwardingsmtpAddress $Fwd2me2External -DeliverToMailboxAndForward `$true"
					Set-Mailbox $UsertoFWD3 -ForwardingsmtpAddress $Fwd2me2External -DeliverToMailboxAndForward $true
					$TextboxResults.Text = Get-Mailbox $UsertoFWD3 | Format-List Name, DeliverToMailboxAndForward, ForwardingSmtpAddress | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify forwarding for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$forwardToExternalAddressAndDontSaveLocalCopyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UsertoFWD4 = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
			$SelectUsersFormText = "Select the User you want to modify fowarding for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$UsertoFWD4 = $SelectUsersForm_comboboxUsers
			$UsertoFWD4 = $SelectCachedDisplayNames_comboboxNames
			If (!$UsertoFWD4)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$Fwd2me2External2 = Read-Host "Enter the external Email Address to forward to"
				If (!$Fwd2me2External2)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No external E-mail Address was entered, please enter a valid external E-mail Address", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting up forwarding from $UsertoFWD4 to $Fwd2me2External2..."
					$textboxDetails.Text = "Set-Mailbox $UsertoFWD4 -ForwardingsmtpAddress $Fwd2me2External2 -DeliverToMailboxAndForward `$False"
					Set-Mailbox $UsertoFWD4 -ForwardingsmtpAddress $Fwd2me2External2 -DeliverToMailboxAndForward $False
					$TextboxResults.Text = Get-Mailbox $UsertoFWD4 | Format-List Name, DeliverToMailboxAndForward, ForwardingSmtpAddress | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify forwarding for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getForwardingInfoForAUserToolStripMenuItem_Click = {
	Do
	{
		try
		{
			#$UserFwdInfo = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user"
			$SelectUsersFormText = "Select the user you want view Forwarding information for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$UserFwdInfo = $SelectUsersForm_comboboxUsers
			$UserFwdInfo = $SelectCachedDisplayNames_comboboxNames
			If (!$UserFwdInfo)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting forwarding info for $UserFwdInfo..."
				$textboxDetails.Text = "Get-Mailbox $UserFwdInfo | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress, ForwardingSmtpAddress"
				$TextboxResults.Text = Get-Mailbox $UserFwdInfo | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress, ForwardingSmtpAddress | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get forwarding information for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeExternalForwadingForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveFWDfromUserExternal = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address"
			$SelectUsersWithForwardingFormText = "Select the user you want remove forwarding for"
			Show-SelectExternalUsersWithForwarding_psf
			$RemoveFWDfromUserExternal = $SelectExternalUsersWithForwarding_comboboxUsersWithForwarding
			If (!$RemoveFWDfromUserExternal)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all external forwarding from $RemoveFWDfromUserExternal..."
				$textboxDetails.Text = "Set-Mailbox $RemoveFWDfromUserExternal -ForwardingSmtpAddress `$Null"
				Set-Mailbox $RemoveFWDfromUserExternal -ForwardingSmtpAddress $Null
				$TextboxResults.Text = Get-Mailbox $RemoveFWDfromUserExternal | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove all external forwarding for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAllForwardingForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveAllFWDforUser = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address"
			$SelectUsersAllForwaringFormText = "Select the user you want to remove forwarding for"
			Show-SelectUsersAnyForwarding_psf
			$RemoveAllFWDforUser = $SelectUsersForm_comboboxUsers
			If (!$RemoveAllFWDforUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all forwarding from $RemoveAllFWDforUser..."
				$textboxDetails.Text = "Set-Mailbox $RemoveAllFWDforUser -ForwardingAddress `$Null -ForwardingSmtpAddress `$Null"
				Set-Mailbox $RemoveAllFWDforUser -ForwardingAddress $Null -ForwardingSmtpAddress $Null
				$TextboxResults.Text = Get-Mailbox $RemoveAllFWDforUser | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress, ForwardingSmtpAddress | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove all forwarding another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeInternalForwardingForUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveFWDfromUser = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address"
			$SelectUsersInternalForwaringFormText = "Select the User to remove forwarding for"
			Show-SelectUsersInternalForwarding_psf
			$RemoveFWDfromUser = $SelectUsersInternalForwarding_comboboxUsersInternalForwarding
			If (!$RemoveFWDfromUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all internal forwarding from $RemoveFWDfromUser..."
				$textboxDetails.Text = "Set-Mailbox $RemoveFWDfromUser -ForwardingAddress `$Null"
				Set-Mailbox $RemoveFWDfromUser -ForwardingAddress $Null
				$TextboxResults.Text = Get-Mailbox $RemoveFWDfromUser | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove all internal forwarding another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$forwardToInternalRecipientAndSaveLocalCopyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UsertoFWD = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
			$SelectUsersFormText = "Select the User you want to modify fowarding for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$UsertoFWD = $SelectUsersForm_comboboxUsers
			$UsertoFWD = $SelectCachedDisplayNames_comboboxNames
			If (!$UsertoFWD)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				#$Fwd2me = Read-Host "Enter the Name, Display Name, Alias, or Email Address of the user to forward to"
				$SelectUsersFormText = "Select the User you want to $UsertoFWD to forward to"
				#Call-SelectUsersForm_psf
				Show-SelectCachedDisplayNames_psf
				#$Fwd2me = $SelectUsersForm_comboboxUsers
				$Fwd2me = $SelectCachedDisplayNames_comboboxNames
				If (!$Fwd2me)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting up forwarding from $UsertoFWD to $Fwd2me..."
					$textboxDetails.Text = "Set-Mailbox  $UsertoFWD -ForwardingAddress $Fwd2me -DeliverToMailboxAndForward `$True"
					Set-Mailbox  $UsertoFWD -ForwardingAddress $Fwd2me -DeliverToMailboxAndForward $True
					$TextboxResults.Text = Get-Mailbox $UsertoFWD | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify forwarding for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllUsersForwardingToExternalRecipientToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users forwarding to external users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.ForwardingSmtpAddress -ne `$Null -and `$_.RecipientType -eq 'UserMailbox' } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.ForwardingSmtpAddress -ne $Null -and $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$removeAllForwardingForAllUsersToolStripMenuItem_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove all forwarding from all users?", "Warning!", 4)
		If ($OUTPUT -eq "YES")
		{
			Try
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all forwarding from all users..."
				$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingAddress `$Null -ForwardingSmtpAddress `$Null"
				$AllMailboxes = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingAddress $Null -ForwardingSmtpAddress $Null
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingAddress, ForwardingSmtpAddress -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Catch
			{
				$FormO365AdministrationCenter.Cursor = 'Default'
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("$_", "Error")
			}
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("All users forwarding has not been changed", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeExternalForwardingForAllUsersToolStripMenuItem_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove external forwarding for all users?", "Warning!", 4)
		If ($OUTPUT -eq "YES")
		{
			Try
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all external forwarding from all users..."
				$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingSmtpAddress `$Null"
				Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingSmtpAddress $Null
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Catch
			{
				$FormO365AdministrationCenter.Cursor = 'Default'
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("$_", "Error")
			}
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("External forwarding for all users has not been changed", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$removeInternalForwardingForAllUsersToolStripMenuItem_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove internal forwarding for all users?", "Warning!", 4)
		If ($OUTPUT -eq "YES")
		{
			Try
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing all internal forwarding from all users..."
				$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingAddress `$Null"
				Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingAddress $Null
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingAddress -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Catch
			{
				$FormO365AdministrationCenter.Cursor = 'Default'
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("$_", "Error")
			}
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("Internal forwarding for all users has not been changed", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$forwardAllUsersEmailToExternalRecipientAndSaveALocalCopyToolStripMenuItem_Click = {
	Try
	{
		$ForwardAllToExternal = Read-Host "Enter the email to forward all email to"
		If (!$ForwardAllToExternal)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No e-mail address was entered, please enter a valid e-mail address", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Setting up forwarding for all users to $ForwardAllToExternal..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingsmtpAddress $ForwardAllToExternal -DeliverToMailboxAndForward `$True"
			Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingsmtpAddress $ForwardAllToExternal -DeliverToMailboxAndForward $True
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardAllUsersEmailToExternalRecipientAndDontSaveALocalCopyToolStripMenuItem_Click = {
	Try
	{
		$ForwardAllToExternal2 = Read-Host "Enter the email to forward all email to"
		If (!$ForwardAllToExternal2)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No e-mail was entered, please enter a valid e-mail", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Setting up forwarding for all users to $ForwardAllToExternal2..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingsmtpAddress $ForwardAllToExternal2 -DeliverToMailboxAndForward `$False"
			Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingsmtpAddress $ForwardAllToExternal2 -DeliverToMailboxAndForward $False
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardAllUsersEmailToInternalRecipientAndSaveLocalCopyToolStripMenuItem_Click = {
	Try
	{
		#$ForwardAllToInternal = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
		$SelectUsersFormText = "Select the user you want to forward all email to"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$ForwardAllToInternal = $SelectUsersForm_comboboxUsers
		$ForwardAllToInternal = $SelectCachedDisplayNames_comboboxNames
		If (!$ForwardAllToInternal)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Setting up forwarding for all users to $ForwardAllToInternal..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingAddress $ForwardAllToInternal -DeliverToMailboxAndForward `$True"
			Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingAddress $ForwardAllToInternal -DeliverToMailboxAndForward $True
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardAllUsersEmailToInternalRecipientAndDontSaveLocalCopyToolStripMenuItem_Click = {
	Try
	{
		#$ForwardAllToInternal2 = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
		$SelectUsersFormText = "Select the user you want to forward all email to"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$ForwardAllToInternal2 = $SelectUsersForm_comboboxUsers
		$ForwardAllToInternal2 = $SelectCachedDisplayNames_comboboxNames
		If (!$ForwardAllToInternal2)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Setting up forwarding for all users to $ForwardAllToInternal2..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingAddress $ForwardAllToInternal2 -DeliverToMailboxAndForward `$True"
			Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingAddress $ForwardAllToInternal2 -DeliverToMailboxAndForward $True
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingAddress -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

#Aliases

$addEmailAddressForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$AddAliasforUser = Read-Host "Enter the UPN of the user you want to add an alias for"
			$SelectUsersFormText = "Select the User you want to add an Alias for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$AddAliasforUser = $SelectUsersForm_comboboxUsers
			$AddAliasforUser = $SelectCachedDisplayNames_comboboxNames
			If (!$AddAliasforUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$AddAlias = Read-Host "Enter the Alias Address"
				If (!$AddAlias)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Alias Address was entered, please enter a valid Alias Address", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding $AddAlias as an Alias for $AddAliasforUser..."
					$textboxDetails.Text = "Set-Mailbox $AddAliasforUser -EmailAddresses @{ add = '$AddAlias' }"
					Set-Mailbox $AddAliasforUser -EmailAddresses @{ add = $AddAlias }
					$TextboxResults.Text = "Getting all aliases for $AddAliasforUser..."
					$TextboxResults.Text = Get-Mailbox $AddAliasforUser | Format-List EmailAddresses | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add an Alias for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAnEmailAddressForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveAliasforUser = Read-Host "Enter the UPN of the user you want to remove an alias for"
			$SelectUsersFormText = "Select the user you want to remove an Alias for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$EmailAddressUser = $SelectUsersForm_comboboxUsers
			$EmailAddressUser = $SelectCachedDisplayNames_comboboxNames
			If (!$EmailAddressUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user", "Error")
			}
			Else
			{
				$EmailAddressText = "Select the users Alias you want to remove"
				Show-SelectEmailAddresses_psf
				$removeAlias = $SelectEmailAddresses_comboboxSelectEmailAddresses
				#$removeAlias = Read-Host "Enter the alias address"
				If (!$removeAlias)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Alias was selected, please select a valid Alias address you want to remove", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing $removeAlias as an Alias for $EmailAddressUser..."
					$textboxDetails.Text = "Set-Mailbox $EmailAddressUser -EmailAddresses @{ remove = '$removeAlias' }"
					Set-Mailbox $EmailAddressUser -EmailAddresses @{ remove = $removeAlias }
					$TextboxResults.Text = "Getting all aliases for $EmailAddressUser..."
					$TextboxResults.Text = Get-Mailbox $EmailAddressUser | Format-List EmailAddresses | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove an Alias for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAUsersEmailAddressesToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ViewAliasforaUser = Read-Host "Enter the UPN of the user you want to view email addresses for"
			$SelectUsersFormText = "Select the User you want to view all Email Addresses for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedDisplayNames_psf
			#$ViewAliasforaUser = $SelectUsersForm_comboboxUsers
			$ViewAliasforaUser = $SelectCachedDisplayNames_comboboxNames
			If (!$ViewAliasforaUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all Email Addresses for $ViewAliasforaUser..."
				$textboxDetails.Text = "Get-Mailbox -identity $ViewAliasforaUser | Format-List EmailAddresses"
				$TextboxResults.Text = Get-Mailbox -identity $ViewAliasforaUser | Format-List EmailAddresses | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view all Email Addresses for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}



###GROUPS###

	#Distribution Groups

$displayDistributionGroupsToolStripMenuItem_Click = {
	try
	{
		$TempDir = $env:temp
		$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
		If ((Test-Path $O365AdminTempFolder) -eq $false)
		{
			$Textboxresults.text = "Caching Distribution Groups…"
			(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
			$Textboxresults.text = ""
			
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all Distribution Groups..."
			$textboxDetails.Text = "Get-DistributionGroup -ResultSize unlimited | Where-Object { `$_.GroupType -notlike 'Universal, SecurityEnabled'} | Sort-Object DisplayName | Format-Table DisplayName -AutoSize"
			#$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
			$TextboxResults.Text = Get-Content $O365AdminTempFolder | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all Distribution Groups..."
			$textboxDetails.Text = "Get-DistributionGroup -ResultSize unlimited | Where-Object { `$_.GroupType -notlike 'Universal, SecurityEnabled'} | Sort-Object DisplayName | Format-Table DisplayName -AutoSize"
			#$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
			$TextboxResults.Text = Get-Content $O365AdminTempFolder | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$createADistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewDistroGroup = Read-Host "What is the name of the new Distribution Group?"
			If (!$NewDistroGroup)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group name was entered, please enter a valid name", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Creating the $NewDistroGroup Distribution Group..."
				$textboxDetails.Text = "New-DistributionGroup -Name $NewDistroGroup | Format-List"
				$TextboxResults.Text = New-DistributionGroup -Name $NewDistroGroup | Format-List | Out-String -Width 2147483647
				$TempDir = $env:temp
				$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
				Remove-Item $O365AdminTempFolder -Force
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$deleteADistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				#$DeleteDistroGroup = Read-Host "Enter the name of the Distribtuion group you want deleted."
				$DistroGroupsText = "Select the Distribution Group you want to delete"
				Show-SelectCachedDistroGroups_psf
				$DeleteDistroGroup = $SelectCachedDistroGroups_comboboxNames
				If (!$DeleteDistroGroup)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group to delete", "Error")
				}
				Else
				{
					$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $DeleteDistroGroup ?", "Warning!", 4)
					If ($OUTPUT -eq "YES")
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Deleting the $DeleteDistroGroup Distribution Group..."
						$textboxDetails.Text = "Remove-DistributionGroup $DeleteDistroGroup"
						Remove-DistributionGroup $DeleteDistroGroup
						$TextboxResults.Text = "Getting list of distribution groups"
						$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
						$TempDir = $env:temp
						$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
						Remove-Item $O365AdminTempFolder -Force
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					Else
					{
						[System.Windows.Forms.MessageBox]::Show("$DeleteDistroGroup was not deleted", "Info")
					}
				}
			}
			Else
			{
				
				#$DeleteDistroGroup = Read-Host "Enter the name of the Distribtuion group you want deleted."
				$DistroGroupsText = "Select the Distribution Group you want to delete"
				Show-SelectCachedDistroGroups_psf
				$DeleteDistroGroup = $SelectCachedDistroGroups_comboboxNames
				If (!$DeleteDistroGroup)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group to delete", "Error")
				}
				Else
				{
					$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $DeleteDistroGroup ?", "Warning!", 4)
					If ($OUTPUT -eq "YES")
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Deleting the $DeleteDistroGroup Distribution Group..."
						$textboxDetails.Text = "Remove-DistributionGroup $DeleteDistroGroup"
						Remove-DistributionGroup $DeleteDistroGroup
						$TextboxResults.Text = "Getting list of distribution groups"
						$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
						$TempDir = $env:temp
						$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
						Remove-Item $O365AdminTempFolder -Force
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					Else
					{
						[System.Windows.Forms.MessageBox]::Show("$DeleteDistroGroup was not deleted", "Info")
					}
				}
			}
		}
		
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to delete another Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$allowDistributionGroupToReceiveExternalEmailToolStripMenuItem_Click = {
	Try
	{
		$TempDir = $env:temp
		$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
		If ((Test-Path $O365AdminTempFolder) -eq $false)
		{
			$Textboxresults.text = "Caching Distribution Groups…"
			(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File $O365AdminTempFolder
			$Textboxresults.text = ""
			#$AllowExternalEmail = Read-Host "Enter the name of the Distribtuion Group you want to allow external email to"
			$DistroGroupsText = "Select the Distribution Group you want to allow External Email to"
			Show-SelectCachedDistroGroups_psf
			$AllowExternalEmail = $SelectCachedDistroGroups_comboboxNames
			If (!$AllowExternalEmail)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to allow external e-mail to", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Allowing extneral senders for the $AllowExternalEmail Distribution Group..."
				$textboxDetails.Text = "Set-DistributionGroup $AllowExternalEmail -RequireSenderAuthenticationEnabled `$False"
				Set-DistributionGroup $AllowExternalEmail -RequireSenderAuthenticationEnabled $False
				$TextboxResults.text = Get-DistributionGroup $AllowExternalEmail | Format-List Name, RequireSenderAuthenticationEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			#$AllowExternalEmail = Read-Host "Enter the name of the Distribtuion Group you want to allow external email to"
			$DistroGroupsText = "Select the Distribution Group you want to allow External Email to"
			Show-SelectCachedDistroGroups_psf
			$AllowExternalEmail = $SelectCachedDistroGroups_comboboxNames
			If (!$AllowExternalEmail)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to allow external e-mail to", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Allowing extneral senders for the $AllowExternalEmail Distribution Group..."
				$textboxDetails.Text = "Set-DistributionGroup $AllowExternalEmail -RequireSenderAuthenticationEnabled `$False"
				Set-DistributionGroup $AllowExternalEmail -RequireSenderAuthenticationEnabled $False
				$TextboxResults.text = Get-DistributionGroup $AllowExternalEmail | Format-List Name, RequireSenderAuthenticationEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$hideDistributionGroupFromGALToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				#$GroupHideGAL = Read-Host "Enter the name of the Distribtuion Group you want to hide from the GAL"
				$DistroGroupsText = "Select the Distribution Group you want to hide from the Global Address List"
				Show-SelectCachedDistroGroups_psf
				$GroupHideGAL = $SelectCachedDistroGroups_comboboxNames
				If (!$GroupHideGAL)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to hide from the Global Address List", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Hiding the $GroupHideGAL from the Global Address List..."
					$textboxDetails.Text = "Set-DistributionGroup $GroupHideGAL -HiddenFromAddressListsEnabled `$True"
					Set-DistributionGroup $GroupHideGAL -HiddenFromAddressListsEnabled $True
					$TextboxResults.text = Get-DistributionGroup $GroupHideGAL | Format-List Name, HiddenFromAddressListsEnabled | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				#$GroupHideGAL = Read-Host "Enter the name of the Distribtuion Group you want to hide from the GAL"
				$DistroGroupsText = "Select the Distribution Group you want to hide from the Global Address List"
				Show-SelectCachedDistroGroups_psf
				$GroupHideGAL = $SelectCachedDistroGroups_comboboxNames
				If (!$GroupHideGAL)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to hide from the Global Address List", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Hiding the $GroupHideGAL from the Global Address List..."
					$textboxDetails.Text = "Set-DistributionGroup $GroupHideGAL -HiddenFromAddressListsEnabled `$True"
					Set-DistributionGroup $GroupHideGAL -HiddenFromAddressListsEnabled $True
					$TextboxResults.text = Get-DistributionGroup $GroupHideGAL | Format-List Name, HiddenFromAddressListsEnabled | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to hide another Distribution Group from the Global Address List?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$displayDistributionGroupMembersToolStripMenuItem_Click = {
	Try
	{
		$TempDir = $env:temp
		$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
		If ((Test-Path $O365AdminTempFolder) -eq $false)
		{
			$Textboxresults.text = "Caching Distribution Groups…"
			(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
			$Textboxresults.text = ""
			
			#$ListDistributionGroupMembers = Read-Host "Enter the name of the Distribution Group you want to list members of"
			$DistroGroupsText = "Select the Distribution Group you want to view the members of"
			Show-SelectCachedDistroGroups_psf
			$ListDistributionGroupMembers = $SelectCachedDistroGroups_comboboxNames
			If (!$ListDistributionGroupMembers)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to view members of", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all members of the $ListDistributionGroupMembers Distrubution Group..."
				$textboxDetails.Text = "Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize"
				$TextboxResults.Text = Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			#$ListDistributionGroupMembers = Read-Host "Enter the name of the Distribution Group you want to list members of"
			$DistroGroupsText = "Select the Distribution Group you want to view the members of"
			Show-SelectCachedDistroGroups_psf
			$ListDistributionGroupMembers = $SelectCachedDistroGroups_comboboxNames
			If (!$ListDistributionGroupMembers)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to view members of", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all members of the $ListDistributionGroupMembers Distrubution Group..."
				$textboxDetails.Text = "Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize"
				$TextboxResults.Text = Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$addAUserToADistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				#$DistroGroupAdd = Read-Host "Enter the name of the Distribution Group"
				$DistroGroupsText = "Select the Distribution Group you want to add a user to"
				Show-SelectCachedDistroGroups_psf
				$DistroGroupAdd = $SelectCachedDistroGroups_comboboxNames
				If (!$DistroGroupAdd)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to add a user to", "Error")
				}
				Else
				{
					#$DistroGroupAddUser = Read-Host "Enter the UPN of the user you wish to add to $DistroGroupAdd"
					$SelectUsersFormText = "Select the user you want to add to $DistroGroupAdd"
					Show-SelectCachedDisplayNames_psf
					$DistroGroupAddUser = $SelectCachedDisplayNames_comboboxNames
					If (!$DistroGroupAddUser)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user you want to add to $DistroGroupAdd", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Adding $DistroGroupAddUser to the $DistroGroupAdd Distribution Group..."
						$textboxDetails.Text = "Add-DistributionGroupMember -Identity $DistroGroupAdd -Member $DistroGroupAddUser"
						Add-DistributionGroupMember -Identity $DistroGroupAdd -Member $DistroGroupAddUser
						$TextboxResults.Text = "Getting members of $DistroGroupAdd..."
						$TextboxResults.Text = Get-DistributionGroupMember $DistroGroupAdd | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
			Else
			{
				#$DistroGroupAdd = Read-Host "Enter the name of the Distribution Group"
				$DistroGroupsText = "Select the Distribution Group you want to add a user to"
				Show-SelectCachedDistroGroups_psf
				$DistroGroupAdd = $SelectCachedDistroGroups_comboboxNames
				If (!$DistroGroupAdd)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to add a user to", "Error")
				}
				Else
				{
					#$DistroGroupAddUser = Read-Host "Enter the UPN of the user you wish to add to $DistroGroupAdd"
					$SelectUsersFormText = "Select the user you want to add to $DistroGroupAdd"
					Show-SelectCachedDisplayNames_psf
					$DistroGroupAddUser = $SelectCachedDisplayNames_comboboxNames
					If (!$DistroGroupAddUser)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user you want to add to $DistroGroupAdd", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Adding $DistroGroupAddUser to the $DistroGroupAdd Distribution Group..."
						$textboxDetails.Text = "Add-DistributionGroupMember -Identity $DistroGroupAdd -Member $DistroGroupAddUser"
						Add-DistributionGroupMember -Identity $DistroGroupAdd -Member $DistroGroupAddUser
						$TextboxResults.Text = "Getting members of $DistroGroupAdd..."
						$TextboxResults.Text = Get-DistributionGroupMember $DistroGroupAdd | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add another User to a Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAUserADistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				#$DistroGroupRemove = Read-Host "Enter the name of the Distribution Group"
				$DistroGroupsText = "Select the Distribution Group you want to remove a user from"
				Show-SelectCachedDistroGroups_psf
				$GlobalDistroGroupMembers = $SelectCachedDistroGroups_comboboxNames
				If (!$GlobalDistroGroupMembers)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to remove a user from", "Error")
				}
				Else
				{
					#$DistroGroupRemoveUser = Read-Host "Enter the UPN of the user you wish to remove from $GlobalDistroGroupMembers"
					$DistroGroupMembersText = "Select the User you want to remove from $GlobalDistroGroupMembers"
					Show-SelectCachedDistroGroups_psf
					$DistroGroupRemoveUser = $SelectCachedDistroGroups_comboboxNames
					If (!$DistroGroupRemoveUser)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user you want to remove from $GlobalDistroGroupMembers", "Error")
					}
					Else
					{
						$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove $DistroGroupRemoveUser from $GlobalDistroGroupMembers ?", "Warning!", 4)
						If ($OUTPUT -eq "YES")
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							$TextboxResults.Text = "Removing $DistroGroupRemoveUser from the $GlobalDistroGroupMembers Distribution Group..."
							$textboxDetails.Text = "Remove-DistributionGroupMember -Identity $GlobalDistroGroupMembers -Member $DistroGroupRemoveUser"
							Remove-DistributionGroupMember -Identity $GlobalDistroGroupMembers -Member $DistroGroupRemoveUser
							$TextboxResults.Text = "Getting members of $GlobalDistroGroupMembers"
							$TextboxResults.Text = Get-DistributionGroupMember $GlobalDistroGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
						Else
						{
							[System.Windows.Forms.MessageBox]::Show("$DistroGroupRemoveUser was not removed from $DistroGroupRemove ?", "Info")
						}
					}
				}
			}
			Else
			{
				#$DistroGroupRemove = Read-Host "Enter the name of the Distribution Group"
				$DistroGroupsText = "Select the Distribution Group you want to remove a user from"
				Show-SelectCachedDistroGroups_psf
				$GlobalDistroGroupMembers = $SelectCachedDistroGroups_comboboxNames
				If (!$GlobalDistroGroupMembers)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to remove a user from", "Error")
				}
				Else
				{
					#$DistroGroupRemoveUser = Read-Host "Enter the UPN of the user you wish to remove from $GlobalDistroGroupMembers"
					$DistroGroupMembersText = "Select the User you want to remove from $GlobalDistroGroupMembers"
					Show-SelectDistroGroupMembers_psf
					$DistroGroupRemoveUser = $SelectDistroGroupMembers_comboboxSelectDistroGroupMembers
					If (!$DistroGroupRemoveUser)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user you want to remove from $GlobalDistroGroupMembers", "Error")
					}
					Else
					{
						$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove $DistroGroupRemoveUser from $GlobalDistroGroupMembers ?", "Warning!", 4)
						If ($OUTPUT -eq "YES")
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							$TextboxResults.Text = "Removing $DistroGroupRemoveUser from the $GlobalDistroGroupMembers Distribution Group..."
							$textboxDetails.Text = "Remove-DistributionGroupMember -Identity $GlobalDistroGroupMembers -Member $DistroGroupRemoveUser"
							Remove-DistributionGroupMember -Identity $GlobalDistroGroupMembers -Member $DistroGroupRemoveUser
							$TextboxResults.Text = "Getting members of $GlobalDistroGroupMembers"
							$TextboxResults.Text = Get-DistributionGroupMember $GlobalDistroGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
						Else
						{
							[System.Windows.Forms.MessageBox]::Show("$DistroGroupRemoveUser was not removed from $DistroGroupRemove ?", "Info")
						}
					}
				}
			}
		}
		catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another user from a Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$addAllUsersToADistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				$users = Get-Mailbox -ResultSize unlimited | Select-Object -ExpandProperty Alias
				#$AddAllUsersToSingleDistro = Read-Host "Enter the name of the Distribution Group you want to add all users to"
				$DistroGroupsText = "Select the Distribution Group you want to add all users too"
				Show-SelectCachedDistroGroups_psf
				$AddAllUsersToSingleDistro = $SelectCachedDistroGroups_comboboxNames
				If (!$AddAllUsersToSingleDistro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to add all users too", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding all users to the $AddAllUsersToSingleDistro distribution group..."
					$textboxDetails.Text = "Foreach (`$user in `$users) { Add-DistributionGroupMember -Identity $AddAllUsersToSingleDistro -Member `$user }"
					Foreach ($user in $users) { Add-DistributionGroupMember -Identity $AddAllUsersToSingleDistro -Member $user }
					$TextboxResults.Text = "Getting members of $AddAllUsersToSingleDistro"
					$TextboxResults.Text = Get-DistributionGroupMember $AddAllUsersToSingleDistro | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				$users = Get-Mailbox -ResultSize unlimited | Select-Object -ExpandProperty Alias
				#$AddAllUsersToSingleDistro = Read-Host "Enter the name of the Distribution Group you want to add all users to"
				$DistroGroupsText = "Select the Distribution Group you want to add all users too"
				Show-SelectCachedDistroGroups_psf
				$AddAllUsersToSingleDistro = $SelectCachedDistroGroups_comboboxNames
				If (!$AddAllUsersToSingleDistro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to add all users too", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding all users to the $AddAllUsersToSingleDistro distribution group..."
					$textboxDetails.Text = "Foreach (`$user in `$users) { Add-DistributionGroupMember -Identity $AddAllUsersToSingleDistro -Member `$user }"
					Foreach ($user in $users) { Add-DistributionGroupMember -Identity $AddAllUsersToSingleDistro -Member $user }
					$TextboxResults.Text = "Getting members of $AddAllUsersToSingleDistro"
					$TextboxResults.Text = Get-DistributionGroupMember $AddAllUsersToSingleDistro | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add all Users to another Distribtuion Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getDetailedInfoForDistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				#$DetailedInfoMailDistroGroup = Read-Host "Enter the group name"
				$DistroGroupsText = "Select the Distribution Group you want to view more information on"
				Show-SelectCachedDistroGroups_psf
				$DetailedInfoMailDistroGroup = $SelectCachedDistroGroups_comboboxNames
				If (!$DetailedInfoMailDistroGroup)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to view detailed information for", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting detailed info about the $DetailedInfoMailDistroGroup group..."
					$textboxDetails.Text = "Get-DistributionGroup $DetailedInfoMailDistroGroup | Format-List"
					$TextboxResults.text = Get-DistributionGroup $DetailedInfoMailDistroGroup | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				#$DetailedInfoMailDistroGroup = Read-Host "Enter the group name"
				$DistroGroupsText = "Select the Distribution Group you want to view more information on"
				Show-SelectCachedDistroGroups_psf
				$DetailedInfoMailDistroGroup = $SelectCachedDistroGroups_comboboxNames
				If (!$DetailedInfoMailDistroGroup)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to view detailed information for", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting detailed info about the $DetailedInfoMailDistroGroup group..."
					$textboxDetails.Text = "Get-DistributionGroup $DetailedInfoMailDistroGroup | Format-List"
					$TextboxResults.text = Get-DistributionGroup $DetailedInfoMailDistroGroup | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get information on another Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$allowAllDistributionGroupsToReceiveExternalEmailToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Allowing extneral senders for all Distribution Groups..."
		$textboxDetails.Text = "Get-DistributionGroup -ResultSize unlimited | Set-DistributionGroup -RequireSenderAuthenticationEnabled `$False"
		Get-DistributionGroup -ResultSize unlimited | Set-DistributionGroup -RequireSenderAuthenticationEnabled $False
		$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$denyDistributionGroupFromReceivingExternalEmailToolStripMenuItem_Click = {
	Try
	{
		$TempDir = $env:temp
		$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
		If ((Test-Path $O365AdminTempFolder) -eq $false)
		{
			$Textboxresults.text = "Caching Distribution Groups…"
			(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
			$Textboxresults.text = ""
			
			#$DenyExternalEmail = Read-Host "Enter the name of the Distribtuion Group you want to deny external email to"
			$DistroGroupsText = "Select the Distribution Group you want to deny external email to"
			Show-SelectCachedDistroGroups_psf
			$DenyExternalEmail = $SelectCachedDistroGroups_comboboxNames
			If (!$DenyExternalEmail)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group selected, please select a valid Distribution Group you want to deny external email to", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Denying extneral senders for the $DenyExternalEmail Distribution Group..."
				$textboxDetails.Text = "Set-DistributionGroup $DenyExternalEmail -RequireSenderAuthenticationEnabled `$True"
				Set-DistributionGroup $DenyExternalEmail -RequireSenderAuthenticationEnabled $True
				$TextboxResults.text = Get-DistributionGroup $DenyExternalEmail | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				}
		}
		Else
		{
			#$DenyExternalEmail = Read-Host "Enter the name of the Distribtuion Group you want to deny external email to"
			$DistroGroupsText = "Select the Distribution Group you want to deny external email to"
			Show-SelectCachedDistroGroups_psf
			$DenyExternalEmail = $SelectCachedDistroGroups_comboboxNames
			If (!$DenyExternalEmail)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group selected, please select a valid Distribution Group you want to deny external email to", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Denying extneral senders for the $DenyExternalEmail Distribution Group..."
				$textboxDetails.Text = "Set-DistributionGroup $DenyExternalEmail -RequireSenderAuthenticationEnabled `$True"
				Set-DistributionGroup $DenyExternalEmail -RequireSenderAuthenticationEnabled $True
				$TextboxResults.text = Get-DistributionGroup $DenyExternalEmail | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$denyAllDistributionGroupsFromReceivingExternalEmailToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Denying extneral senders for all Distribution Groups..."
		$textboxDetails.Text = "Get-DistributionGroup -ResultSize unlimited | Set-DistributionGroup -RequireSenderAuthenticationEnabled `$True"
		Get-DistributionGroup -ResultSize unlimited | Set-DistributionGroup -RequireSenderAuthenticationEnabled $True
		$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Sort-Objects Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getExternalEmailStatusForADistributionGroupToolStripMenuItem_Click = {
	Try
	{
		$TempDir = $env:temp
		$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
		If ((Test-Path $O365AdminTempFolder) -eq $false)
		{
			$Textboxresults.text = "Caching Distribution Groups…"
			(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
			$Textboxresults.text = ""
			
			#$ExternalEmailStatus = Read-Host "Enter the Distribution Group"
			$DistroGroupsText = "Select the Distribution Group you want to view external email status for"
			Show-SelectCachedDistroGroups_psf
			$ExternalEmailStatus = $SelectCachedDistroGroups_comboboxNames
			If (!$ExternalEmailStatus)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to view external email status for", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting external email status for $ExternalEmailStatus..."
				$textboxDetails.Text = "Get-DistributionGroup $ExternalEmailStatus | Format-List Name, RequireSenderAuthenticationEnabled"
				$TextboxResults.text = Get-DistributionGroup $ExternalEmailStatus | Format-List Name, RequireSenderAuthenticationEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			#$ExternalEmailStatus = Read-Host "Enter the Distribution Group"
			$DistroGroupsText = "Select the Distribution Group you want to view external email status for"
			Show-SelectCachedDistroGroups_psf
			$ExternalEmailStatus = $SelectCachedDistroGroups_comboboxNames
			If (!$ExternalEmailStatus)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to view external email status for", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting external email status for $ExternalEmailStatus..."
				$textboxDetails.Text = "Get-DistributionGroup $ExternalEmailStatus | Format-List Name, RequireSenderAuthenticationEnabled"
				$TextboxResults.text = Get-DistributionGroup $ExternalEmailStatus | Format-List Name, RequireSenderAuthenticationEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getExternalEmailStatusForAllDistributionGroupsToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting external email status for all distribution groups..."
		$textboxDetails.Text = "Get-DistributionGroup -ResultSize unlimited | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize"
		$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDistributionGroupsAcceptMessagesFromInfoToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				$DistroGroupsText = "Select the distro group you want to view Accept Messages Only From info for"
				Show-SelectCachedDistroGroups_psf
				$distro = $SelectCachedDistroGroups_comboboxNames
				If (!$distro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxDetails.Text = "Get-DistributionGroup -Identity $distro | Format-List Identity, AcceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMember"
					$TextboxResults.Text = "Getting delivery restriction information for $distro..."
					$TextboxResults.text = Get-DistributionGroup -Identity $distro | Format-List Identity, AcceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMembers | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				$DistroGroupsText = "Select the distro group you want to view Accept Messages Only From info for"
				Show-SelectCachedDistroGroups_psf
				$distro = $SelectCachedDistroGroups_comboboxNames
				If (!$distro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxDetails.Text = "Get-DistributionGroup -Identity $distro | Format-List Identity, AcceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMember"
					$TextboxResults.Text = "Getting delivery restriction information for $distro..."
					$TextboxResults.text = Get-DistributionGroup -Identity $distro | Format-List Identity, AcceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMembers | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view another Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getDistributionGroupsRejectMessagesFromInfoToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				$DistroGroupsText = "Select the distro group you want to view Reject Messages Only From info for"
				Show-SelectCachedDistroGroups_psf
				$distro = $SelectCachedDistroGroups_comboboxNames
				If (!$distro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxDetails.Text = "Get-DistributionGroup -Identity $distro | Format-List Identity, RejectMessagesFrom, RejectMessagesFromDLMembers, RejectMessagesFromSendersOrMembers"
					$TextboxResults.Text = "Getting delivery restriction information for $distro..."
					$TextboxResults.text = Get-DistributionGroup -Identity $distro | Format-List Identity, RejectMessagesFrom, RejectMessagesFromDLMembers, RejectMessagesFromSendersOrMembers | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				$DistroGroupsText = "Select the distro group you want to view Reject Messages Only From info for"
				Show-SelectCachedDistroGroups_psf
				$distro = $SelectCachedDistroGroups_comboboxNames
				If (!$distro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxDetails.Text = "Get-DistributionGroup -Identity $distro | Format-List Identity, RejectMessagesFrom, RejectMessagesFromDLMembers, RejectMessagesFromSendersOrMembers"
					$TextboxResults.Text = "Getting delivery restriction information for $distro..."
					$TextboxResults.text = Get-DistributionGroup -Identity $distro | Format-List Identity, RejectMessagesFrom, RejectMessagesFromDLMembers, RejectMessagesFromSendersOrMembers | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view another Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$getAllGroupsAndAllMembersToCSVToolStripMenuItem1_Click = {
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			#Constant Variables 
			$OutputFile = $savedialog.filename
			$TextboxResults.Text = "Getting all groups and members..."
			$arrDLMembers = @{ }
			
			#Prepare Output file with headers 
			Out-File -FilePath $OutputFile -InputObject "Distribution Group DisplayName,Distribution Group Email,Member DisplayName, Member Email, Member Type" -Encoding UTF8
			
			#Get all Distribution Groups from Office 365 
			$objDistributionGroups = Get-DistributionGroup -ResultSize Unlimited
			
			#Iterate through all groups, one at a time     
			Foreach ($objDistributionGroup in $objDistributionGroups)
			{
				
				#write-host "Processing $($objDistributionGroup.DisplayName)..."
				
				#Get members of this group 
				$objDGMembers = Get-DistributionGroupMember -Identity $($objDistributionGroup.PrimarySmtpAddress)
				
				#write-host "Found $($objDGMembers.Count) members..."
				
				#Iterate through each member 
				Foreach ($objMember in $objDGMembers)
				{
					Out-File -FilePath $OutputFile -InputObject "$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)" -Encoding UTF8 -append
					#write-host "`t$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)"
				}
			}
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		$TextboxResults.Text = ""
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getADistributionGroupsMembersToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				
				#$ListDistributionGroupMembers = Read-Host "Enter the name of the Distribution Group you want to list members of"
				$DistroGroupsText = "Select the Distribution Group you want to view the members of"
				Show-SelectCachedDistroGroups_psf
				$ListDistributionGroupMembers = $SelectCachedDistroGroups_comboboxNames
				If (!$ListDistributionGroupMembers)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to view the members of", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting all members of the $ListDistributionGroupMembers Distrubution Group..."
					$textboxDetails.Text = "Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize"
					$TextboxResults.Text = Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				#$ListDistributionGroupMembers = Read-Host "Enter the name of the Distribution Group you want to list members of"
				$DistroGroupsText = "Select the Distribution Group you want to view the members of"
				Show-SelectCachedDistroGroups_psf
				$ListDistributionGroupMembers = $SelectCachedDistroGroups_comboboxNames
				If (!$ListDistributionGroupMembers)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group you want to view the members of", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting all members of the $ListDistributionGroupMembers Distrubution Group..."
					$textboxDetails.Text = "Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize"
					$TextboxResults.Text = Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Members of another Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllDisabledUsersThatAreStillMembersOfDistroGroupsToCSVToolStripMenuItem_Click = {
	Try
	{
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			$TextboxResults.Text = "Getting all users that are disabled and still members of distro groups..."
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				
				#Get All Groups 
				$Groups = Get-MsolGroup -All
				
				#Build Hash of all disabled users 
				$MSOLDisabledUsers = Get-MsolUser -All -EnabledFilter DisabledOnly | Select-Object ObjectId
				$AllDisabledUsers = @()
				$MSOLDisabledUsers | ForEach-Object { $AllDisabledUsers += $_.ObjectID.Guid }
				
				$DisabledUserMembers = @()
				
				foreach ($Group in $Groups)
				{
					#$TextboxResults.Text = "Processing $($Group.DisplayName)..."
					#Get All Members and Loop through them 
					$GroupMembers = Get-MsolGroupMember -All -GroupObjectID $Group.ObjectID
					foreach ($Member in $GroupMembers)
					{
						#Is this member in our disabled list? 
						if ($AllDisabledUsers -contains $Member.ObjectId)
						{
							#$TextboxResults.Text = "`tFound $($Member.DisplayName)"
							#Add them to the list 
							$DisabledUserMembers += (
								$Object = [pscustomobject][ordered] @{
									GroupName = $Group.DisplayName
									GroupEmail = $Group.EmailAddress
									UserName = $Member.DisplayName
									EmailAddress = $Member.EmailAddress
								}
							)
						}
					}
				}
				$DisabledUserMembers | Export-CSV -NoTypeInformation $savedialog.filename
				$TextboxResults.Text = ""
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			$TextboxResults.Text = "Getting all users that are disabled and still members of distro groups..."
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				
				#Get All Groups 
				$Groups = Get-MsolGroup -All -TenantId $PartnerComboBox.SelectedItem.TenantID
				
				#Build Hash of all disabled users 
				$MSOLDisabledUsers = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID -EnabledFilter DisabledOnly | Select-Object ObjectId
				$AllDisabledUsers = @()
				$MSOLDisabledUsers | ForEach-Object { $AllDisabledUsers += $_.ObjectID.Guid }
				
				$DisabledUserMembers = @()
				
				foreach ($Group in $Groups)
				{
					#$TextboxResults.Text = "Processing $($Group.DisplayName)..."
					#Get All Members and Loop through them 
					$GroupMembers = Get-MsolGroupMember -All -GroupObjectID $Group.ObjectID -TenantId $PartnerComboBox.SelectedItem.TenantID
					foreach ($Member in $GroupMembers)
					{
						#Is this member in our disabled list? 
						if ($AllDisabledUsers -contains $Member.ObjectId)
						{
							#$TextboxResults.Text = "`tFound $($Member.DisplayName)"
							#Add them to the list 
							$DisabledUserMembers += (
								$Object = [pscustomobject][ordered] @{
									GroupName = $Group.DisplayName
									GroupEmail = $Group.EmailAddress
									UserName = $Member.DisplayName
									EmailAddress = $Member.EmailAddress
								}
							)
						}
					}
				}
				$DisabledUserMembers | Export-CSV -NoTypeInformation $savedialog.filename
				$TextboxResults.Text = ""
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			$TextboxResults.Text = "Getting all users that are disabled and still members of distro groups..."
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				
				#Get All Groups 
				$Groups = Get-MsolGroup -All
				
				#Build Hash of all disabled users 
				$MSOLDisabledUsers = Get-MsolUser -All -EnabledFilter DisabledOnly | Select-Object ObjectId
				$AllDisabledUsers = @()
				$MSOLDisabledUsers | ForEach-Object { $AllDisabledUsers += $_.ObjectID.Guid }
				
				$DisabledUserMembers = @()
				
				foreach ($Group in $Groups)
				{
					#$TextboxResults.Text = "Processing $($Group.DisplayName)..."
					#Get All Members and Loop through them 
					$GroupMembers = Get-MsolGroupMember -All -GroupObjectID $Group.ObjectID
					foreach ($Member in $GroupMembers)
					{
						#Is this member in our disabled list? 
						if ($AllDisabledUsers -contains $Member.ObjectId)
						{
							#$TextboxResults.Text = "`tFound $($Member.DisplayName)"
							#Add them to the list 
							$DisabledUserMembers += (
								$Object = [pscustomobject][ordered] @{
									GroupName = $Group.DisplayName
									GroupEmail = $Group.EmailAddress
									UserName = $Member.DisplayName
									EmailAddress = $Member.EmailAddress
								}
							)
						}
					}
				}
				$DisabledUserMembers | Export-CSV -NoTypeInformation $savedialog.filename
				$TextboxResults.Text = ""
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$rejectMessagesFromSpecificSenderForGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				$DistroGroupsText = "Select the distro group you want to modify delivery restriction for"
				Show-SelectCachedDistroGroups_psf
				$distro = $SelectCachedDistroGroups_comboboxNames
				If (!$distro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$DistroGroupsText = "Select the distro group you don't want the members to be able to send to $distro"
					Show-SelectCachedDistroGroups_psf
					$rejectfrom = $SelectCachedDistroGroups_comboboxNames
					If (!$rejectfrom)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$textboxDetails.Text = "Set-DistributionGroup -Identity $distro -RejectMessagesFrom `@{ Add = $Rejectfrom }"
						$TextboxResults.Text = "Modifying delivery restriction information for $distro"
						Set-DistributionGroup -Identity $distro -RejectMessagesFromDLMembers @{ Add = $Rejectfrom }
						$TextboxResults.text = Get-DistributionGroup -Identity $distro | Format-List Identity, RejectMessagesFrom, RejectMessagesFromDLMembers, RejectMessagesFromSendersOrMembers | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
			Else
			{
				
				$DistroGroupsText = "Select the distro group you want to modify delivery restriction for"
				Show-SelectCachedDistroGroups_psf
				$distro = $SelectCachedDistroGroups_comboboxNames
				If (!$distro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$DistroGroupsText = "Select the distro group you don't want the members to be able to send to $distro"
					Show-SelectCachedDistroGroups_psf
					$rejectfrom = $SelectCachedDistroGroups_comboboxNames
					If (!$rejectfrom)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$textboxDetails.Text = "Set-DistributionGroup -Identity $distro -RejectMessagesFrom `@{ Add = $Rejectfrom }"
						$TextboxResults.Text = "Modifying delivery restriction information for $distro"
						Set-DistributionGroup -Identity $distro -RejectMessagesFromDLMembers @{ Add = $Rejectfrom }
						$TextboxResults.text = Get-DistributionGroup -Identity $distro | Format-List Identity, RejectMessagesFrom, RejectMessagesFromDLMembers, RejectMessagesFromSendersOrMembers | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify another Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$acceptMessagesForAGroupFromMembersOfAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TempDir = $env:temp
			$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
			If ((Test-Path $O365AdminTempFolder) -eq $false)
			{
				$Textboxresults.text = "Caching Distribution Groups…"
				(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
				$Textboxresults.text = ""
				
				$DistroGroupsText = "Select the distro group you want to modify delivery restriction for"
				Show-SelectCachedDistroGroups_psf
				$distro = $SelectCachedDistroGroups_comboboxNames
				If (!$distro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$DistroGroupsText = "Select the distro group you want the members to be able to send to $distro"
					Show-SelectCachedDistroGroups_psf
					$rejectfrom = $SelectCachedDistroGroups_comboboxNames
					If (!$rejectfrom)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$textboxDetails.Text = "Set-DistributionGroup -Identity $distro -AllowMessagesFrom `@{ Add = $Rejectfrom }"
						$TextboxResults.Text = "Modifying delivery restriction information for $distro"
						Set-DistributionGroup -Identity $distro -AcceptMessagesOnlyFromDLMembers @{ Add = $Rejectfrom }
						$TextboxResults.text = Get-DistributionGroup -Identity $distro | Format-List Identity, AcceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMembers | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
			Else
			{
				$DistroGroupsText = "Select the distro group you want to modify delivery restriction for"
				Show-SelectCachedDistroGroups_psf
				$distro = $SelectCachedDistroGroups_comboboxNames
				If (!$distro)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$DistroGroupsText = "Select the distro group you want the members to be able to send to $distro"
					Show-SelectCachedDistroGroups_psf
					$rejectfrom = $SelectCachedDistroGroups_comboboxNames
					If (!$rejectfrom)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$textboxDetails.Text = "Set-DistributionGroup -Identity $distro -AllowMessagesFrom `@{ Add = $Rejectfrom }"
						$TextboxResults.Text = "Modifying delivery restriction information for $distro"
						Set-DistributionGroup -Identity $distro -AcceptMessagesOnlyFromDLMembers @{ Add = $Rejectfrom }
						$TextboxResults.text = Get-DistributionGroup -Identity $distro | Format-List Identity, AcceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMembers | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify another Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Unified Groups

$getListOfUnifiedGroupsToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting list of all unified groups..."
		$textboxDetails.Text = "Get-UnifiedGroup | Sort-Object Name | Format-Table -AutoSize"
		$TextboxResults.Text = Get-UnifiedGroup | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$listMembersOfAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$GetUnifiedGroupMembers = Read-Host "Enter the name of the group you want to view members for."
			$SelectUnifiedGroupsText = "Select the Unified Group you want to view members for"
			Show-SelectUnifiedGroups_psf
			$GetUnifiedGroupMembers = $SelectUnifiedGroups_comboboxUnifiedGroups
			If (!$GetUnifiedGroupMembers)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Unified Group was selected, please enter a valid Unified Group you want to view members for", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all members of the $GetUnifiedGroupMembers group..."
				$textboxDetails.Text = "Get-UnifiedGroupLinks –Identity $GetUnifiedGroupMembers –LinkType Members | Sort-Object DisplayName | Format-Table DisplayName -AutoSize"
				$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $GetUnifiedGroupMembers –LinkType Members | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Members of another Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveUnifiedGroup = Read-Host "Enter the name of the group you want to remove"
			$SelectUnifiedGroupsText = "Select the Unified Group you want to remove"
			Show-SelectUnifiedGroups_psf
			$RemoveUnifiedGroup = $SelectUnifiedGroups_comboboxUnifiedGroups
			If (!$RemoveUnifiedGroup)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Unified Group was selected, please select a valid Unified Group to remove", "Error")
			}
			Else
			{
				$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $RemoveUnifiedGroup ?", "Warning!", 4)
				
				If ($OUTPUT -eq "YES")
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing the $RemoveUnifiedGroup group..."
					$textboxDetails.Text = "Remove-UnifiedGroup $RemoveUnifiedGroup"
					Remove-UnifiedGroup $RemoveUnifiedGroup
					$TextboxResults.Text = "Getting list of unified groups..."
					$TextboxResults.Text = Get-UnifiedGroup | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
					
				}
				Else
				{
					[System.Windows.Forms.MessageBox]::Show("$RemoveUnifiedGroup was not deleted", "Info")
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$addAUserToAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UnifiedGroupAddUser = Read-Host "Enter the name of the group you want to add a user to"
			$SelectUnifiedGroupsText = "Select the Unified Group you want to add a user to"
			Show-SelectUnifiedGroups_psf
			$UnifiedGroupAddUser = $SelectUnifiedGroups_comboboxUnifiedGroups
			If (!$UnifiedGroupAddUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Unified Group was selected, please select a valid Unified Group you want to add a user to", "Error")
			}
			Else
			{
				#$UnifiedGroupUserAdd = Read-Host "Enter the UPN of the user you want to add to the $UnifiedGroupAddUser group."
				$SelectUsersFormText = "Select the user you want add to $UnifiedGroupAddUser"
				Show-SelectCachedDisplayNames_psf
				$UnifiedGroupUserAdd = $SelectCachedDisplayNames_comboboxNames
				If (!$UnifiedGroupUserAdd)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user you want to add to $UnifiedGroupAddUser", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding $UnifiedGroupUserAdd as a member of the $UnifiedGroupAddUser group..."
					$textboxDetails.Text = "Add-UnifiedGroupLinks $UnifiedGroupAddUser –Links $UnifiedGroupUserAdd –LinkType Members"
					Add-UnifiedGroupLinks $UnifiedGroupAddUser –Links $UnifiedGroupUserAdd –LinkType Members
					$TextboxResults.Text = "Getting members for $UnifiedGroupAddUser..."
					$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $UnifiedGroupAddUser –LinkType Members | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add another User to a Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$createANewGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewUnifiedGroupName = Read-Host "Enter the Display Name of the new group"
			If (!$NewUnifiedGroupName)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Display Name was entered, please enter a valid display name for the new group", "Error")
			}
			Else
			{
				#$NewUnifiedGroupAccessType = Read-Host "Enter the Access Type for the group $NewUnifiedGroupName (Public or Private)"
				$UnifiedGroupAccessTypeText = "Select the Access Type for the group $NewUnifiedGroupName"
				Show-SelectUnifiedGroupAccessType_psf
				$NewUnifiedGroupAccessType = $SelectUnifiedGroupAccessType_comboboxAccessType_SelectedItem
				If (!$NewUnifiedGroupAccessType)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Access Type was selected, please select a valid access type", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Creating a the $NewUnifiedGroupName group..."
					$textboxDetails.Text = "New-UnifiedGroup –DisplayName $NewUnifiedGroupName -AccessType $NewUnifiedGroupAccessType"
					New-UnifiedGroup –DisplayName $NewUnifiedGroupName -AccessType $NewUnifiedGroupAccessType
					$TextboxResults.Text = Get-UnifiedGroup $NewUnifiedGroupName | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create a new Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$listOwnersOfAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$GetUnifiedGroupOwners = Read-Host "Enter the name of the group you want to view members for."
			$SelectUnifiedGroupsText = "Select the Unified Group you want to view owners for"
			Show-SelectUnifiedGroups_psf
			$GetUnifiedGroupOwners = $SelectUnifiedGroups_comboboxUnifiedGroups
			If (!$GetUnifiedGroupOwners)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Unified Group was selected, please select a valid Unified Group you want to view owners for", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all owners of the $GetUnifiedGroupOwners group..."
				$textboxDetails.Text = "Get-UnifiedGroupLinks –Identity $GetUnifiedGroupOwners –LinkType Owners | Format-List DisplayName | Format-Table -AutoSize"
				$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $GetUnifiedGroupOwners –LinkType Owners | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Owners for another Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$listSubscribersOfAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$GetUnifiedGroupSubscribers = Read-Host "Enter the name of the group you want to view members for."
			$SelectUnifiedGroupsText = "Select the Unified Group you want to view members for"
			Show-SelectUnifiedGroups_psf
			$GetUnifiedGroupSubscribers = $SelectUnifiedGroups_comboboxUnifiedGroups
			If (!$GetUnifiedGroupSubscribers)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Unified Group was selected, please select a valid Unified Group", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting all subscribers of the $GetUnifiedGroupSubscribers group..."
				$textboxDetails.Text = "Get-UnifiedGroupLinks –Identity $GetUnifiedGroupSubscribers –LinkType Subscribers | Sort-Object DisplayName | Format-Table -AutoSize"
				$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $GetUnifiedGroupSubscribers –LinkType Subscribers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Subscribers of another Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$addAnOwnerToAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$TextboxResults.Text = "Important! The user must be a member of the group prior to becoming an owner"
			#$UnifiedGroupAddOwner = Read-Host "Enter the name of the group you want to modify ownership for"
			$SelectUnifiedGroupsText = "Select the Unified Group you want to modify ownership for"
			Show-SelectUnifiedGroups_psf
			$UnifiedGroupModify = $SelectUnifiedGroups_comboboxUnifiedGroups
			If (!$UnifiedGroupModify)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Unified Group was selected, please select a Unified Group you want to modify ownership for", "Error")
			}
			Else
			{
				#$AddUnifiedGroupOwner = Read-Host "Enter the UPN of the user you want to become an owner"
				$UnifiedGroupMembersText = "Select the user you want to add as a owner to $UnifiedGroupModify"
				Show-SelectUnifiedGroupMembers_psf
				$AddUnifiedGroupOwner = $SelectUnifiedGroupMembers_comboboxUnifiedGroupMembers
				If (!$AddUnifiedGroupOwner)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user you want to be an owner of $UnifiedGroupModify", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding $AddUnifiedGroupOwner as an owner of the $UnifiedGroupModify group..."
					$textboxDetails.Text = "Add-UnifiedGroupLinks -Identity $UnifiedGroupModify -LinkType Owners -Links $AddUnifiedGroupOwner"
					Add-UnifiedGroupLinks -Identity $UnifiedGroupModify -LinkType Owners -Links $AddUnifiedGroupOwner
					$TextboxResults.Text = "Getting list of owners for $UnifiedGroupModify..."
					$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $UnifiedGroupModify –LinkType Owners | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add another User as an Owner of a Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$addASubscriberToAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$UnifiedGroupAddSubscriber = Read-Host "Enter the name of the group you want to add a subscriber for"
			$SelectUnifiedGroupsText = "Select the Unified Group you want to add a subscriber to"
			Show-SelectUnifiedGroups_psf
			$UnifiedGroupAddSubscriber = $SelectUnifiedGroups_comboboxUnifiedGroups
			If (!$UnifiedGroupAddSubscriber)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Unified Group was selected, please select a valid Unified Group", "Error")
			}
			Else
			{
				#$AddUnifiedGroupSubscriber = Read-Host "Enter the UPN of the user you want to add as a subscriber"
				$SelectUsersFormText = "Select the user you want to add as a subscriber to $UnifiedGroupAddSubscriber"
				Show-SelectCachedDisplayNames_psf
				$AddUnifiedGroupSubscriber = $SelectCachedDisplayNames_comboboxNames
				If (!$AddUnifiedGroupSubscriber)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a valid user you want to add as a subscriber to $UnifiedGroupAddSubscriber", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding $AddUnifiedGroupSubscriber as a subscriber to the $UnifiedGroupAddSubscriber group..."
					$textboxDetails.Text = "Add-UnifiedGroupLinks -Identity $UnifiedGroupAddSubscriber -LinkType Owners -Links $AddUnifiedGroupSubscriber"
					Add-UnifiedGroupLinks -Identity $UnifiedGroupAddSubscriber -LinkType Owners -Links $AddUnifiedGroupSubscriber
					$TextboxResults.Text = "Getting list of subscribers for $UnifiedGroupAddSubscriber..."
					$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $UnifiedGroupAddSubscriber –LinkType Subscribers | Sort-Object DisplayName | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add a Subscriber to another Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAMemberFromAGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUnifiedGroupsText = "Select the Unified Group you want to remove a member from"
			Show-SelectUnifiedGroups_psf
			$UnifiedGroupModify = $SelectUnifiedGroups_comboboxUnifiedGroups
			If (!$UnifiedGroupModify)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Unified Group was selected, please select a Unified Group you want to remove a member from", "Error")
			}
			Else
			{
				$UnifiedGroupMembersText = "Select the user you want to remove from $UnifiedGroupModify"
				Show-SelectUnifiedGroupMembers_psf
				$RemoveUserFromUnifiedGroup = $SelectUnifiedGroupMembers_comboboxUnifiedGroupMembers
				If (!$RemoveUserFromUnifiedGroup)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a user to remove from $UnifiedGroupModify", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing $RemoveUserFromUnifiedGroup from the $UnifiedGroupModify group..."
					$textboxDetails.Text = "Remove-UnifiedGroupLinks -Identity $UnifiedGroupModify -LinkType Members -Links $RemoveUserFromUnifiedGroup"
					Remove-UnifiedGroupLinks -Identity $UnifiedGroupModify -LinkType Members -Links $RemoveUserFromUnifiedGroup
					$TextboxResults.Text = "Getting members of $UnifiedGroupModify..."
					$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $UnifiedGroupModify –LinkType Members | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Member from a Unified Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Security Groups

$createARegularSecurityGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SecurityGroupName = Read-Host "Enter a name for the new Security Group"
			If (!$SecurityGroupName)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Name was entered, please enter a valid name for the Security Group", "Error")
			}
			Else
			{
				#What to do if connected to main o365 account
				If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Creating the $SecurityGroupName security group..."
					$textboxDetails.Text = "New-MsolGroup -DisplayName $SecurityGroupName "
					$TextboxResults.Text = New-MsolGroup -DisplayName $SecurityGroupName | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				#What to do if connected to partner account
				ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
				{
					$TenantText = $PartnerComboBox.text
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Creating the $SecurityGroupName security group..."
					$textboxDetails.Text = "New-MsolGroup -DisplayName $SecurityGroupName -TenantId $TenantText"
					$TextboxResults.Text = New-MsolGroup -DisplayName $SecurityGroupName -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Creating the $SecurityGroupName security group..."
					$textboxDetails.Text = "New-MsolGroup -DisplayName $SecurityGroupName "
					$TextboxResults.Text = New-MsolGroup -DisplayName $SecurityGroupName | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Security Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllRegularSecurityGroupsToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting list of all Security groups..."
			$textboxDetails.Text = "Get-MsolGroup -All -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize"
			$TextboxResults.Text = Get-MsolGroup -All -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting list of all Security groups..."
			$textboxDetails.Text = "Get-MsolGroup -All -TenantId $TenantText -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize"
			$TextboxResults.Text = Get-MsolGroup -All -TenantId $PartnerComboBox.SelectedItem.TenantID -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting list of all Security groups..."
			$textboxDetails.Text = "Get-MsolGroup -All -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize"
			$TextboxResults.Text = Get-MsolGroup -All -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getAllMailEnabledSecurityGroupsToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all Mail Enabled Security Groups..."
		$textboxDetails.Text = "Get-DistributionGroup -ResultSize unlimited | Where-Object { `$_.GroupType -like 'Universal, SecurityEnabled' } | Sort-Object DisplayName | Format-Table DisplayName, SamAccountName, GroupType, IsDirSynced, EmailAddresses -AutoSize "
		$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -like "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName, SamAccountName, GroupType, IsDirSynced, EmailAddresses -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$createAMailEnabledSecurityGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$MailEnabledSecurityGroup = Read-Host "Enter the name of the Security Group"
			If (!$MailEnabledSecurityGroup)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please enter a valid name for the new Security Group", "Error")
			}
			Else
			{
				$MailEnabledSMTPAddress = Read-Host "Enter the Primary SMTP address for $MailEnabledSecurityGroup"
				If (!$MailEnabledSMTPAddress)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Primary SMTP address was entered, please enter a valid Primary SMTP address", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Creating the $MailEnabledSecurityGroup security group..."
					$textboxDetails.Text = "New-DistributionGroup -Name $MailEnabledSecurityGroup -Type Security -PrimarySmtpAddress $MailEnabledSMTPAddress"
					$TextboxResults.Text = New-DistributionGroup -Name $MailEnabledSecurityGroup -Type Security -PrimarySmtpAddress $MailEnabledSMTPAddress | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Mail Enabled Security Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$addAUserToAMailEnabledSecurityGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$MailEnabledGroupAdd = Read-Host "Enter the name of the Group"
			$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to add a user to"
			Show-SelectMailEnabledSecurityGroups_psf
			$MailEnabledGroupAdd = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
			If (!$MailEnabledGroupAdd)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Mail Enabled Security Group was selected, please select a valid Mail Enabled Security Group", "Error")
			}
			Else
			{
				#$MailEnabledGroupAddUser = Read-Host "Enter the UPN of the user you wish to add to $MailEnabledGroupAdd"
				$SelectUsersFormText = "Select the user you want to add to $MailEnabledGroupAdd"
				Show-SelectCachedDisplayNames_psf
				$MailEnabledGroupAddUser = $SelectCachedDisplayNames_comboboxNames
				If (!$MailEnabledGroupAddUser)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a valid user to add to $MailEnabledGroupAdd", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding $MailEnabledGroupAddUser to the $MailEnabledGroupAdd Group..."
					$textboxDetails.Text = "Add-DistributionGroupMember -Identity $MailEnabledGroupAdd -Member $MailEnabledGroupAddUser"
					Add-DistributionGroupMember -Identity $MailEnabledGroupAdd -Member $MailEnabledGroupAddUser
					$TextboxResults.Text = "Getting members of $MailEnabledGroupAdd..."
					$TextboxResults.Text = Get-DistributionGroupMember $MailEnabledGroupAdd | Sort-Object DisplayName | Format-Table Displayname -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add another User to a Mail Enabled Security Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$allowSecurityGroupToRecieveExternalMailToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$AllowExternalEmailSecurity = Read-Host "Enter the name of the Group you want to allow external email to"
			$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to allow external email to"
			Show-SelectMailEnabledSecurityGroups_psf
			$AllowExternalEmailSecurity = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
			If (!$AllowExternalEmailSecurity)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Mail Enabled Security Group was selected, please select a valid Mail Enabled Security Group", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Allowing extneral senders for the $AllowExternalEmailSecurity Group..."
				$textboxDetails.Text = "Set-DistributionGroup $AllowExternalEmailSecurity -RequireSenderAuthenticationEnabled `$False"
				Set-DistributionGroup $AllowExternalEmailSecurity -RequireSenderAuthenticationEnabled $False
				$TextboxResults.text = Get-DistributionGroup $AllowExternalEmailSecurity | Format-List Name, RequireSenderAuthenticationEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Allow another Security Group to Recieve External Mail?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getDetailedInfoForMailEnabledSecurityGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DetailedInfoMailEnabledSecurityGroup = Read-Host "Enter the group name"
			$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to get detailed information for"
			Show-SelectMailEnabledSecurityGroups_psf
			$DetailedInfoMailEnabledSecurityGroup = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
			If (!$DetailedInfoMailEnabledSecurityGroup)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Mail Enabled Security Group was selected, please select a valid Mail Enabled Security Group to view detailed information about", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed info about the $DetailedInfoMailEnabledSecurityGroup group..."
				$textboxDetails.Text = "Get-DistributionGroup $DetailedInfoMailEnabledSecurityGroup | Format-List"
				$TextboxResults.text = Get-DistributionGroup $DetailedInfoMailEnabledSecurityGroup | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get detailed information for another Security Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeMailENabledSecurityGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DeleteMailEnabledSecurityGroup = Read-Host "Enter the name of the group you want deleted."
			$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to remove"
			Show-SelectMailEnabledSecurityGroups_psf
			$DeleteMailEnabledSecurityGroup = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
			If (!$DeleteMailEnabledSecurityGroup)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Mail Enabled Security Group was selected, please select a Mail Enabled Security Group that you want to delete", "Error")
			}
			Else
			{
				
				$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $DeleteMailEnabledSecurityGroup ?", "Warning!", 4)
				
				If ($OUTPUT -eq "YES")
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Deleting the $DeleteMailEnabledSecurityGroup Group..."
					$textboxDetails.Text = "Remove-DistributionGroup $DeleteMailEnabledSecurityGroup"
					Remove-DistributionGroup $DeleteMailEnabledSecurityGroup
					$TextboxResults.Text = "Getting list of mail enabled security groups..."
					$TextboxResults.text = Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -like "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					[System.Windows.Forms.MessageBox]::Show("$DeleteMailEnabledSecurityGroup was not deleted", "Info")
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Mail Enabled Security Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$denySecurityGroupFromRecievingExternalEmailToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DenyExternalEmailSecurity = Read-Host "Enter the name of the Group you want to deny external email to"
			$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to deny external email to"
			Show-SelectMailEnabledSecurityGroups_psf
			$DenyExternalEmailSecurity = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
			If (!$DenyExternalEmailSecurity)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Mail Enabled Security Group was selected, please select a valid Mail Enabled Security Group", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Denying extneral senders for the $DenyExternalEmailSecurity Group..."
				$textboxDetails.Text = "Set-DistributionGroup $DenyExternalEmailSecurity -RequireSenderAuthenticationEnabled `$True"
				Set-DistributionGroup $DenyExternalEmailSecurity -RequireSenderAuthenticationEnabled $True
				$TextboxResults.text = Get-DistributionGroup $DenyExternalEmailSecurity | Format-List Name, RequireSenderAuthenticationEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Deny another Security Group from recieving External Email?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}



###RESOURCE MAILBOX###

	#Booking Options

$allowConflictMeetingsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ConflictMeetingAllow = Read-Host "Enter the Room Name of the Resource Calendar you want to allow conflicts"
			$RoomMailboxText = "Select a Room Mailbox to allow conflict meetings for"
			Show-SelectRoomMailbox_psf
			$ConflictMeetingAllow = $SelectRoomMailbox_comboboxSelectRoomMailbox
			If (!$ConflictMeetingAllow)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Room Mailbox was selected, please select a valid Room Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Allowing conflict meetings $ConflictMeetingAllow..."
				$textboxDetails.Text = "Set-CalendarProcessing $ConflictMeetingAllow -AllowConflicts `$True"
				Set-CalendarProcessing $ConflictMeetingAllow -AllowConflicts $True
				$TextboxResults.Text = Get-CalendarProcessing -identity $ConflictMeetingAllow | Format-List Identity, AllowConflicts | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to allow conflict meetings on another Resource Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$denyConflictMeetingsForAllResourceMailboxesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Denying conflict meeting for all room calendars..."
		$textboxDetails.Text = "Get-MailBox -ResultSize unlimited | Where-Object { `$_.ResourceType -eq 'Room' } | Set-CalendarProcessing -AllowConflicts `$False"
		Get-MailBox -ResultSize unlimited | Where-Object { $_.ResourceType -eq "Room" } | Set-CalendarProcessing -AllowConflicts $False
		$TextboxResults.Text = Get-MailBox -ResultSize unlimited | Where-Object { $_.ResourceType -eq "Room" } | Get-CalendarProcessing | Sort-Object Identity | Format-Table Identity, AllowConflicts -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$allowConflicMeetingsForAllResourceMailboxesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Allowing conflict meeting for all room calendars..."
		$textboxDetails.Text = "Get-MailBox -ResultSize unlimited | Where-Object { `$_.ResourceType -eq 'Room' } | Set-CalendarProcessing -AllowConflicts `$True"
		Get-MailBox -ResultSize unlimited | Where-Object { $_.ResourceType -eq "Room" } | Set-CalendarProcessing -AllowConflicts $True
		$TextboxResults.Text = Get-MailBox -ResultSize unlimited | Where-Object { $_.ResourceType -eq "Room" } | Get-CalendarProcessing | Sort-Object Identity | Format-Table Identity, AllowConflicts -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disallowconflictmeetingsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ConflictMeetingDeny = Read-Host "Enter the Room Name of the Resource Calendar you want to disallow conflicts"
			$RoomMailboxText = "Select a Room Mailbox to disallow conflict meetings for"
			Show-SelectRoomMailbox_psf
			$ConflictMeetingDeny = $SelectRoomMailbox_comboboxSelectRoomMailbox
			If (!$ConflictMeetingDeny)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Room Mailbox was selected, please select a valid Room Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Denying conflict meetings for $ConflictMeetingDeny..."
				$textboxDetails.Text = "Set-CalendarProcessing $ConflictMeetingDeny -AllowConflicts `$False"
				Set-CalendarProcessing $ConflictMeetingDeny -AllowConflicts $False
				$TextboxResults.Text = Get-CalendarProcessing -identity $ConflictMeetingDeny | Format-List Identity, AllowConflicts | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to deny conflict meetings on another Resource Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableAutomaticBookingForAllResourceMailboxToolStripMenuItem1_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling automatic booking on all room calendars..."
		$textboxDetails.Text = "Get-MailBox -ResultSize unlimited | Where-Object { `$_.ResourceType -eq 'Room' } | Set-CalendarProcessing -AutomateProcessing:AutoAccept"
		Get-MailBox -ResultSize unlimited | Where-Object { $_.ResourceType -eq "Room" } | Set-CalendarProcessing -AutomateProcessing:AutoAccept
		$TextboxResults.Text = Get-MailBox -ResultSize unlimited | Where-Object { $_.ResourceType -eq "Room" } | Get-CalendarProcessing | Sort-Object Identity | Format-Table Identity, AutomateProcessing -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$GetRoomMailBoxCalendarProcessingToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RoomMailboxCalProcessing = Read-Host "Enter the Calendar Name you want to view calendar processing information for"
			$RoomMailboxText = "Select a Room Mailbox to view calendar processing for"
			Show-SelectRoomMailbox_psf
			$RoomMailboxCalProcessing = $SelectRoomMailbox_comboboxSelectRoomMailbox
			If (!$RoomMailboxCalProcessing)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Room Mailbox was selected, please select a valid Room Mailox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting calendar processing information for $RoomMailboxCalProcessing..."
				$textboxDetails.Text = "Get-Mailbox $RoomMailboxCalProcessing | Get-CalendarProcessing | Format-List"
				$TextboxResults.Text = Get-Mailbox $RoomMailboxCalProcessing | Get-CalendarProcessing | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Calendar Processing for another Resource Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Room Mailbox

$convertAMailboxToARoomMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$MailboxtoRoom = Read-Host "What user would you like to convert to a Room Mailbox? Please enter the full email address"
			$MailboxText = "Select a Mailbox to convert to a Room Mailbox"
			Show-SelectMailboxes_psf
			$MailboxtoRoom = $SelectMailboxes_comboboxSelectMailbox
			If (!$MailboxtoRoom)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Mailbox was selected, please select a valid Mailbox to convert to a Room Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Converting $MailboxtoRoom to a Room Mailbox..."
				$textboxDetails.Text = "Set-Mailbox $MailboxtoRoom -Type Room"
				Set-Mailbox $MailboxtoRoom -Type Room
				$TextboxResults.Text = Get-MailBox $MailboxtoRoom | Format-List Name, ResourceType, PrimarySmtpAddress, EmailAddresses, UserPrincipalName, IsMailboxEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to convert another Mailbox to a Room Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$createANewRoomMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewRoomMailbox = Read-Host "Enter the name of the new Room Mailbox"
			If (!$NewRoomMailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered for the new Room Mailbox, please enter a valid name", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Creating the $NewRoomMailbox Room Mailbox..."
				$textboxDetails.Text = "New-Mailbox -Name $NewRoomMailbox -Room "
				$TextboxResults.Text = New-Mailbox -Name $NewRoomMailbox -Room | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Room Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getListOfRoomMailboxesToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting list of all Room Mailboxes..."
		$textboxDetails.Text = "Get-MailBox -ResultSize unlimited | Where-Object { `$_.ResourceType -eq 'Room' } | Sort-Object Name | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailBox -ResultSize unlimited | Where-Object { $_.ResourceType -eq "Room" } | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeARoomMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveRoomMailbox = Read-Host "Enter the name of the room mailbox"
			$RoomMailboxText = "Select a Room Mailbox to remove"
			Show-SelectRoomMailbox_psf
			$RemoveRoomMailbox = $SelectRoomMailbox_comboboxSelectRoomMailbox
			If (!$RemoveRoomMailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Room Mailbox was selected, please select a valid Room Mailbox to remove", "Error")
			}
			Else
			{
				
				$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove $RemoveRoomMailbox ?", "Warning!", 4)
				
				If ($OUTPUT -eq "YES")
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing the $RemoveRoomMailbox Room Mailbox..."
					$textboxDetails.Text = "Remove-Mailbox $RemoveRoomMailbox"
					Remove-Mailbox $RemoveRoomMailbox
					$TextboxResults.Text = "Getting list of Room Mailboxes..."
					$TextboxResults.Text = Get-MailBox -ResultSize unlimited | Where-Object { $_.ResourceType -eq "Room" } | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					[System.Windows.Forms.MessageBox]::Show("$RemoveRoomMailbox was not removed", "Info")
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Room Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}




###JUNK EMAIL CONFIGURATION###

	#Blacklist

$blacklistDomainForAllToolStripMenuItem_Click = {
	Try
	{
		$BlacklistDomain = Read-Host "Enter the domain you want to blacklist for all users. EX: google.com"
		If (!$BlacklistDomain)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No domain was entered, please enter a valid domain you want to blacklist for all users", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Blacklisting $BlacklistDomain for all users..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-MailboxJunkEmailConfiguration -BlockedSendersAndDomains `@{ Add = $BlacklistDomain }"
			Get-Mailbox -ResultSize unlimited | Set-MailboxJunkEmailConfiguration -BlockedSendersAndDomains @{ Add = $BlacklistDomain }
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-Table Identity, BlockedSendersAndDomains, Enabled -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$blacklistDomainForASingleUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$Blockeddomainuser = Read-Host "Enter the UPN of the user you want to modify junk email for"
			$SelectUsersFormText = "Select the User you want to modify the blacklist for"
			Show-SelectCachedDisplayNames_psf
			$Blockeddomainuser = $SelectCachedDisplayNames_comboboxNames
			If (!$Blockeddomainuser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$BlockedDomain2 = Read-Host "Enter the Domain you want to blacklist"
				If (!$BlockedDomain2)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Domain was entered, please enter a valid Domain to blacklist", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Blacklisting $BlockedDomain2 for $Blockeddomainuser..."
					$textboxDetails.Text = "Set-MailboxJunkEmailConfiguration -Identity $Blockeddomainuser -BlockedSendersAndDomains `@{ Add = $BlockedDomain2 } "
					Set-MailboxJunkEmailConfiguration -Identity $Blockeddomainuser -BlockedSendersAndDomains @{ Add = $BlockedDomain2 }
					$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $Blockeddomainuser | Format-List Identity, BlockedSendersAndDomains | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify the blacklist for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$blacklistASpecificEmailAddressForAllToolStripMenuItem_Click = {
	Try
	{
		$BlockSpecificEmailForAll = Read-Host "Enter the email address you want to blacklist for all"
		If (!$BlockSpecificEmailForAll)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No e-mail address was entered, please enter a valid e-mail address you want to blacklist for all users", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Blacklisting $BlockSpecificEmailForAll for all users..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-MailboxJunkEmailConfiguration -BlockedSendersAndDomains `@{ Add = $BlockSpecificEmailForAll }"
			Get-Mailbox -ResultSize unlimited | Set-MailboxJunkEmailConfiguration -BlockedSendersAndDomains @{ Add = $BlockSpecificEmailForAll }
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-Table Identity, BlockedSendersAndDomains, Enabled -Autosize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$blacklistASpecificEmailAddressForASingleUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ModifyblacklistforaUser = Read-Host "Enter the user you want to modify the blacklist for"
			$SelectUsersFormText = "Select the User you want to modify the blacklist for"
			Show-SelectCachedDisplayNames_psf
			$ModifyblacklistforaUser = $SelectCachedDisplayNames_comboboxNames
			If (!$ModifyblacklistforaUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$DenySpecificEmailForOne = Read-Host "Enter the E-mail Address you want to blacklist for $ModifyblacklistforaUser"
				If (!$DenySpecificEmailForOne)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No E-mail Address was entered, please enter a valid E-mail Address to blacklist for $ModifyblacklistforaUser", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Blacklisting $DenySpecificEmailForOne for $ModifyblacklistforaUser..."
					$textboxDetails.Text = "Set-MailboxJunkEmailConfiguration -Identity $ModifyblacklistforaUser -BlockedSendersAndDomains `@{ Add = $DenySpecificEmailForOne }"
					Set-MailboxJunkEmailConfiguration -Identity $ModifyblacklistforaUser -BlockedSendersAndDomains @{ Add = $DenySpecificEmailForOne }
					$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $ModifyblacklistforaUser | Format-List Identity, BlockedSendersAndDomains, Enabled | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify the blacklist for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Junk Email General Items

$checkSafeAndBlockedSendersForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$CheckSpamUser = Read-Host "Enter the UPN of the user you want to check blocked and allowed senders for"
			$SelectUsersFormText = "Select the User you want to check safe and blocked senders for"
			Show-SelectCachedDisplayNames_psf
			$GlobalUPN = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalUPN)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting safe and blocked senders for $GlobalUPN..."
				$textboxDetails.Text = "Get-MailboxJunkEmailConfiguration -Identity $GlobalUPN | Format-List Identity, TrustedListsOnly, ContactsTrusted, TrustedSendersAndDomains, BlockedSendersAndDomains, TrustedRecipientsAndDomains, IsValid "
				$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $GlobalUPN | Format-List Identity, TrustedListsOnly, ContactsTrusted, TrustedSendersAndDomains, BlockedSendersAndDomains, TrustedRecipientsAndDomains, IsValid | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to check Safe and Blocked Senders for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$checkSafeAndBlockedSendersForAllToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting safe and blocked senders for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-List Identity, TrustedListsOnly, ContactsTrusted, TrustedSendersAndDomains, BlockedSendersAndDomains, TrustedRecipientsAndDomains, IsValid"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-List Identity, TrustedListsOnly, ContactsTrusted, TrustedSendersAndDomains, BlockedSendersAndDomains, TrustedRecipientsAndDomains, IsValid | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Whitelist

$whitelistDomainForAllToolStripMenuItem_Click = {
	Try
	{
		$AllowedDomain = Read-Host "Enter the domain you want to whitelist for all users. EX: google.com"
		If (!$AllowedDomain)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No domain was entered, please enter a valid domain to whitelist for all users", "Error")
		}
		
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Whitelisting $AllowedDomain for all..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains `@{ Add = $AllowedDomain }"
			Get-Mailbox -ResultSize unlimited | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains @{ Add = $AllowedDomain }
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-Table Identity, TrustedSendersAndDomains, TrustedRecipientsAndDomains -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$whitelistDomainForASingleUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$Alloweddomainuser = Read-Host "Enter the UPN of the user you want to modify junk email for"
			$SelectUsersFormText = "Select the User you want to modify the whitelist for"
			Show-SelectCachedDisplayNames_psf
			$Alloweddomainuser = $SelectCachedDisplayNames_comboboxNames
			If (!$Alloweddomainuser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$AllowedDomain2 = Read-Host "Enter the Domain you want to whitelist for $Alloweddomainuser"
				If (!$AllowedDomain2)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Domain was entered, please enter a valid Domain you want to whitelist for $Alloweddomainuser", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Whitelisting $AllowedDomain2 for $Alloweddomainuser..."
					$textboxDetails.Text = "Set-MailboxJunkEmailConfiguration -Identity $Alloweddomainuser -TrustedSendersAndDomains `@{ Add = $AllowedDomain2 }"
					Set-MailboxJunkEmailConfiguration -Identity $Alloweddomainuser -TrustedSendersAndDomains @{ Add = $AllowedDomain2 }
					$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $Alloweddomainuser | Format-List Identity, TrustedSendersAndDomains, TrustedRecipientsAndDomains | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify the Whitelist for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$whitelistASpecificEmailAddressForAllToolStripMenuItem_Click = {
	Try
	{
		$AllowSpecificEmailForAll = Read-Host "Enter the email address you want to whitelist for all"
		If (!$AllowSpecificEmailForAll)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No e-mail address was entered, please enter a valid e-mail address you want to whitelist for all users", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Whitelisting $AllowSpecificEmailForAll for all..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains @{ Add = $AllowSpecificEmailForAll }"
			Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq 'UserMailbox' } | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains @{ Add = $AllowSpecificEmailForAll }
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Where-Object { $_.RecipientType -eq 'UserMailbox' } | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-Table Identity, TrustedSendersAndDomains, TrustedRecipientsAndDomains -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$whitelistASpecificEmailAddressForASingleUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ModifyWhitelistforaUser = Read-Host "Enter the user you want to modify the whitelist for"
			$SelectUsersFormText = "Select the User you want to modify the Whitelist for"
			Show-SelectCachedDisplayNames_psf
			$ModifyWhitelistforaUser = $SelectCachedDisplayNames_comboboxNames
			If (!$ModifyWhitelistforaUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was slected, Please select a valid user you want to modify the Whitelist for", "Error")
			}
			Else
			{
				$AllowSpecificEmailForOne = Read-Host "Enter the E-mail Address you want to Whitelist for $ModifyWhitelistforaUser"
				If (!$AllowSpecificEmailForOne)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No E-mail Address was entered, please enter a valid E-mail address to add to the Whitelist for $ModifyWhitelistforaUser", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Whitelisting $AllowSpecificEmailForOne for $ModifyWhitelistforaUser..."
					$textboxDetails.Text = "Set-MailboxJunkEmailConfiguration -Identity $ModifyWhitelistforaUser -TrustedSendersAndDomains `@{ Add = $AllowSpecificEmailForOne }"
					Set-MailboxJunkEmailConfiguration -Identity $ModifyWhitelistforaUser -TrustedSendersAndDomains @{ Add = $AllowSpecificEmailForOne }
					$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $ModifyWhitelistforaUser | Format-List Identity, TrustedSendersAndDomains, TrustedRecipientsAndDomains, Enabled | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify the Whitelist for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}


###CONTACTS FOLDER PERMISSIONS

$addContactsPermissionsForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the User you want to modify contacts permissions for"
			Show-SelectCachedDisplayNames_psf
			$GlobalUPNmodifycontacts = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalUPNmodifycontacts)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$SelectUsersFormText = "Select the User you want to add to $GlobalUPNmodifycontacts contacts"
				Show-SelectCachedDisplayNames_psf
				$GlobalUPNadd2contacts = $SelectCachedDisplayNames_comboboxNames
				If (!$GlobalUPNadd2contacts)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
				}
				Else
				{
					$LabelPermissionsText = "Select the level of access"
					Show-AccessPermissions_psf
					$GlobalContactsPermissions = $AccessPermissions_comboboxPermissions_SelectedItem
					If (!$GlobalContactsPermissions)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Access Level was selected, please select a valid Access Level", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Adding $GlobalUPNadd2contacts to $GlobalUPNmodifycontacts contacts folder with $GlobalContactsPermissions permissions..."
						$textboxDetails.Text = "Add-MailboxFolderPermission -Identity ${GlobalUPNmodifycontacts}:\contacts -user $GlobalUPNadd2contacts -AccessRights $GlobalContactsPermissions"
						Remove-MailboxFolderPermission -identity ${$GlobalUPNmodifycontacts}:\contacts -user $GlobalUPNadd2contacts -Confirm:$False
						Add-MailboxFolderPermission -Identity ${GlobalUPNmodifycontacts}:\contacts -user $GlobalUPNadd2contacts -AccessRights $GlobalContactsPermissions
						$TextboxResults.Text = "Getting contact folder permissions for $GlobalUPNmodifycontacts..."
						$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${GlobalUPNmodifycontacts}:\contacts | Sort-Object User, AccessRights | Format-Table User, AccessRights, FolderName -AutoSize | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify another Users Contacts Folder permissions?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getUsersContactsPermissionsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ContactsUserPermissions = Read-Host "What user would you like contacts folder permissions for?"
			$SelectUsersFormText = "Select the user you want to view contacts permissions for"
			Show-SelectUsersForm_psf
			$GlobalUPNremovecontacts = $SelectUsersForm_comboboxUsers
			If (!$GlobalUPNremovecontacts)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user was selected, please select a valid users", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting $GlobalUPNremovecontacts contacts permissions..."
				$textboxDetails.Text = "Get-MailboxFolderPermission -Identity ${GlobalUPNremovecontacts}:\contacts | Sort-Object User, AccessRights | Format-Table User, AccessRights, FolderName "
				$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${GlobalUPNremovecontacts}:\contacts | Sort-Object User, AccessRights | Format-Table User, AccessRights, FolderName -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Contacts Folder permission for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAUserFromSomeonesContactsPermissionsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the user whose contacts you want to remove access to"
			Show-SelectCachedDisplayNames_psf
			$GlobalUPNremove = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalUPNremove)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid Users", "Error")
			}
			Else
			{
				$SelectUsersFormText = "Select the user you want to remove access to the contacts of $GlobalUPNremove"
				Show-SelectCachedDisplayNames_psf
				$GlobalUPN2remove = $SelectCachedDisplayNames_comboboxNames
				If (!$GlobalUPN2remove)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing $GlobalUPN2remove from $GlobalUPNremove contacts folder..."
					$textboxDetails.Text = "Remove-MailboxFolderPermission -Identity ${GlobalUPNremove}:\contacts -user $GlobalUPN2remove"
					Remove-MailboxFolderPermission -Identity ${GlobalUPNremove}:\contacts -user $GlobalUPN2remove
					$TextboxResults.Text = "Getting contact folder permissions for $GlobalUPNremove..."
					$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${GlobalUPNremove}:\contacts | Sort-Object User, AccessRights | Format-Table User, AccessRights, FolderName -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions for the Contacts Folder for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAUserFromAllContactsFoldersToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveUserFromAllContacts = Read-Host "Enter the UPN of the user you want to remove from all contacts folders"
			$SelectUsersFormText = "Select the user you want to remove from all users contacts folder"
			Show-SelectCachedDisplayNames_psf
			$GlobalUPNremovefromallcontacts = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalUPNremovefromallcontacts)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing $GlobalUPNremovefromallcontacts from all users contacts folders..."
				$textboxDetails.Text = "`$users = Get-Mailbox -ResultSize unlimited | Select-Object -ExpandProperty Alias
Foreach (`$user in `$users) { Remove-MailboxFolderPermission `${user}:\Contacts -user $GlobalUPNremovefromallcontacts -Confirm:`$false}﻿"
				$users = Get-Mailbox -ResultSize unlimited | Select-Object -ExpandProperty Alias
				Foreach ($user in $users) { Remove-MailboxFolderPermission ${user}:\Contacts -user $GlobalUPNremovefromallcontacts -Confirm:$false }﻿
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			#[System.Windows.Forms.MessageBox]::Show("$_", "Error")
			$TextboxResults.Text = ""
		}
		$TextboxResults.Text = ""
		
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another user from everyones Contacts Folder?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$addASingleUserPermissionsOnAllContactsFoldersToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the user you want to add to everyones contacts folder"
			Show-SelectCachedDisplayNames_psf
			$GlobalUPNremoveaddtoallcontacts = $SelectCachedDisplayNames_comboboxNames
			If (!$GlobalUPNremoveaddtoallcontacts)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$LabelPermissionsText = "Select the level of access"
				Show-AccessPermissions_psf
				$GlobalContactsPermissions2 = $AccessPermissions_comboboxPermissions_SelectedItem
				If (!$GlobalContactsPermissions2)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Access Level was selected, please select a valid Access Level", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Adding $GlobalUPNremoveaddtoallcontacts to everyones contacts folder with $GlobalContactsPermissions2 permissions..."
					$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Select-Object -ExpandProperty Alias
Foreach (`$user in `$users) { Add-MailboxFolderPermission `${user}:\Contacts -user $GlobalUPNremoveaddtoallcontacts -accessrights $GlobalContactsPermissions2 }﻿"
					$users = Get-Mailbox -ResultSize unlimited | Select-Object -ExpandProperty Alias
					Foreach ($user in $users) { Add-MailboxFolderPermission ${user}:\Contacts -user $GlobalUPNremoveaddtoallcontacts -accessrights $GlobalContactsPermissions2 }﻿
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add another User to everyones Contacts Folder?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}



###ADMIN###

	#OWA

$disableAccessToOWAForASingleUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DisableOWAforUser = Read-Host "Enter the UPN of the user you want to disable OWA access for"
			$SelectUsersFormText = "Select the user you want to disable OWA access for"
			Show-SelectCachedDisplayNames_psf
			$DisableOWAforUser = $SelectCachedDisplayNames_comboboxNames
			If (!$DisableOWAforUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling OWA access for $DisableOWAforUser..."
				$textboxDetails.Text = "Set-CASMailbox $DisableOWAforUser -OWAEnabled `$False"
				Set-CASMailbox $DisableOWAforUser -OWAEnabled $False
				$TextboxResults.Text = Get-CASMailbox $DisableOWAforUser | Format-List DisplayName, OWAEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Disable OWA Access for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableOWAAccessForASingleUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$EnableOWAforUser = Read-Host "Enter the UPN of the user you want to enable OWA access for"
			$SelectUsersFormText = "Select the user you want to enable OWA access for"
			Show-SelectCachedDisplayNames_psf
			$EnableOWAforUser = $SelectCachedDisplayNames_comboboxNames
			If (!$EnableOWAforUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling OWA access for $EnableOWAforUser..."
				$textboxDetails.Text = "Set-CASMailbox $EnableOWAforUser -OWAEnabled `$True"
				Set-CASMailbox $EnableOWAforUser -OWAEnabled $True
				$TextboxResults.Text = Get-CASMailbox $EnableOWAforUser | Format-List DisplayName, OWAEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Enable OWA Access for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$disableOWAAccessForAllToolStripMenuItem_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to disable OWA for all users?", "Warning!", 4)
		
		If ($OUTPUT -eq "YES")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling OWA access for all..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-CASMailbox -OWAEnabled `$False"
			Get-Mailbox -ResultSize unlimited | Set-CASMailbox -OWAEnabled $False
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, OWAEnabled -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("ActiveSync has not been disabled for all users", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$enableOWAAccessForAllToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling OWA access for all..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-CASMailbox -OWAEnabled `$True"
		Get-Mailbox -ResultSize unlimited | Set-CASMailbox -OWAEnabled $True
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, OWAEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getOWAAccessForAllToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting OWA info for all users..."
		$textboxDetails.Text = "Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, OWAEnabled, OwaMailboxPolicy, OWAforDevicesEnabled -Autosize"
		$TextboxResults.Text = Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, OWAEnabled, OwaMailboxPolicy, OWAforDevicesEnabled -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getOWAInfoForASingleUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$OWAAccessUser = Read-Host "Enter the UPN for the User you want to view OWA info for"
			$SelectUsersFormText = "Select the user you want to view OWA information for"
			Show-SelectCachedDisplayNames_psf
			$OWAAccessUser = $SelectCachedDisplayNames_comboboxNames
			If (!$OWAAccessUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting OWA Access for $OWAAccessUser..."
				$textboxDetails.Text = "Get-CASMailbox -identity $OWAAccessUser | Format-List DisplayName, OWAEnabled, OwaMailboxPolicy, OWAforDevicesEnabled"
				$TextboxResults.Text = Get-CASMailbox -identity $OWAAccessUser | Format-List DisplayName, OWAEnabled, OwaMailboxPolicy, OWAforDevicesEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get OWA information for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#ActiveSync

$getActiveSyncDevicesForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ActiveSyncDevicesUser = Read-Host "Enter the UPN of the user you wish to see ActiveSync Devices for"
			$SelectUsersFormText = "Select the user you want to view ActiveSync devices for"
			Show-SelectCachedDisplayNames_psf
			$ActiveSyncDevicesUser = $SelectCachedDisplayNames_comboboxNames
			If (!$ActiveSyncDevicesUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting ActiveSync device info for $ActiveSyncDevicesUser..."
				$textboxDetails.Text = "Get-MobileDeviceStatistics -Mailbox $ActiveSyncDevicesUser | Format-List DeviceFriendlyName, DeviceModel, DeviceOS, DeviceMobileOperator, DeviceType, Status, FirstSyncTime, LastPolicyUpdateTime, LastSyncAttemptTime, LastSuccessSync, LastPingHeartbeat, DeviceAccessState, IsValid "
				$TextboxResults.Text = Get-MobileDeviceStatistics -Mailbox $ActiveSyncDevicesUser | Format-List DeviceFriendlyName, DeviceModel, DeviceOS, DeviceMobileOperator, DeviceType, Status, FirstSyncTime, LastPolicyUpdateTime, LastSyncAttemptTime, LastSuccessSync, LastPingHeartbeat, DeviceAccessState, IsValid | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get all ActiveSync devices for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableActiveSyncForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DisableActiveSyncForUser = Read-Host "Enter the UPN of the user you wish to disable ActiveSync for"
			$SelectUsersFormText = "Select the user you want to disable ActiveSync for"
			Show-SelectCachedDisplayNames_psf
			$DisableActiveSyncForUser = $SelectCachedDisplayNames_comboboxNames
			If (!$DisableActiveSyncForUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling ActiveSync for $DisableActiveSyncForUser..."
				$textboxDetails.Text = "Set-CASMailbox $DisableActiveSyncForUser -ActiveSyncEnabled `$False"
				Set-CASMailbox $DisableActiveSyncForUser -ActiveSyncEnabled $False
				$TextboxResults.Text = Get-CASMailbox -Identity $DisableActiveSyncForUser | Format-List DisplayName, ActiveSyncEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Disable ActiveSync for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableActiveSyncForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$EnableActiveSyncForUser = Read-Host "Enter the UPN of the user you wish to enable ActiveSync for"
			$SelectUsersFormText = "Select the user you want to enable ActiveSync for"
			Show-SelectCachedDisplayNames_psf
			$EnableActiveSyncForUser = $SelectCachedDisplayNames_comboboxNames
			If (!$EnableActiveSyncForUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling ActiveSync for $EnableActiveSyncForUser... "
				$textboxDetails.Text = "Set-CASMailbox $EnableActiveSyncForUser -ActiveSyncEnabled `$True"
				Set-CASMailbox $EnableActiveSyncForUser -ActiveSyncEnabled $True
				$TextboxResults.Text = Get-CASMailbox -Identity $EnableActiveSyncForUser | Format-List DisplayName, ActiveSyncEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Enable ActiveSync for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$viewActiveSyncInfoForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ActiveSyncInfoForUser = Read-Host "Enter the UPN for the user you want to view ActiveSync info for"
			$SelectUsersFormText = "Select the user you want to view ActiveSync information for"
			Show-SelectCachedDisplayNames_psf
			$ActiveSyncInfoForUser = $SelectCachedDisplayNames_comboboxNames
			If (!$ActiveSyncInfoForUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting ActiveSync info for $ActiveSyncInfoForUser..."
				$textboxDetails.Text = "Get-CASMailbox -Identity $ActiveSyncInfoForUser | Format-List DisplayName, ActiveSyncEnabled, ActiveSyncAllowedDeviceIDs, ActiveSyncBlockedDeviceIDs, ActiveSyncMailboxPolicy, ActiveSyncMailboxPolicyIsDefaulted, ActiveSyncDebugLogging, HasActiveSyncDevicePartnership"
				$TextboxResults.Text = Get-CASMailbox -Identity $ActiveSyncInfoForUser | Format-List DisplayName, ActiveSyncEnabled, ActiveSyncAllowedDeviceIDs, ActiveSyncBlockedDeviceIDs, ActiveSyncMailboxPolicy, ActiveSyncMailboxPolicyIsDefaulted, ActiveSyncDebugLogging, HasActiveSyncDevicePartnership | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view ActiveSync information for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableActiveSyncForAllToolStripMenuItem_Click = {
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to disable ActiveSync for all users?", "Warning!", 4)
		
		If ($OUTPUT -eq "YES")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling ActiveSync for all..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Set-CASMailbox -ActiveSyncEnabled `$False"
			Get-Mailbox -ResultSize unlimited | Set-CASMailbox -ActiveSyncEnabled $False
			$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, ActiveSyncEnabled -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("ActiveSync has not been disabled for all users", "Info")
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getActiveSyncInfoForAllToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting ActiveSync info for all..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, ActiveSyncEnabled -AutoSize"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, ActiveSyncEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		
	}
}

$enableActiveSyncForAllToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling ActiveSync for all.."
		$textboxDetails.Text = "Get-Mailbox | Set-CASMailbox -ActiveSyncEnabled `$True"
		Get-Mailbox -ResultSize unlimited | Set-CASMailbox -ActiveSyncEnabled $True
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, ActiveSyncEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#PowerShell

$disableAccessToPowerShellForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DisablePowerShellforUser = Read-Host "Enter the UPN of the user you want to disable PowerShell access for"
			$SelectUsersFormText = "Select the user you want to disable PowerShell access for"
			Show-SelectCachedDisplayNames_psf
			$DisablePowerShellforUser = $SelectCachedDisplayNames_comboboxNames
			If (!$DisablePowerShellforUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling PowerShell access for $DisablePowerShellforUser..."
				$textboxDetails.Text = "Set-User $DisablePowerShellforUser -RemotePowerShellEnabled `$False"
				Set-User $DisablePowerShellforUser -RemotePowerShellEnabled $False
				$TextboxResults.Text = Get-User $DisablePowerShellforUser | Format-List DisplayName, RemotePowerShellEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Disable PowerShell Access for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$displayPowerShellRemotingStatusForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$PowerShellRemotingStatusUser = Read-Host "Enter the UPN of the user you want to view PowerShell Remoting for"
			$SelectUsersFormText = "Select the user you want to view PowerShell remoting for"
			Show-SelectCachedDisplayNames_psf
			$PowerShellRemotingStatusUser = $SelectCachedDisplayNames_comboboxNames
			If (!$PowerShellRemotingStatusUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting PowerShell info for $PowerShellRemotingStatusUser..."
				$textboxDetails.Text = "Get-User $PowerShellRemotingStatusUser | Format-List DisplayName, RemotePowerShellEnabled"
				$TextboxResults.Text = Get-User $PowerShellRemotingStatusUser | Format-List DisplayName, RemotePowerShellEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get PowerShell Access for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableAccessToPowerShellForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$EnablePowerShellforUser = Read-Host "Enter the UPN of the user you want to enable PowerShell access for"
			$SelectUsersFormText = "Select the user you want to enable PowerShell access for"
			Show-SelectCachedDisplayNames_psf
			$EnablePowerShellforUser = $SelectCachedDisplayNames_comboboxNames
			If (!$EnablePowerShellforUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling PowerShell access for $EnablePowerShellforUser..."
				$textboxDetails.Text = "Set-User $EnablePowerShellforUser -RemotePowerShellEnabled `$True"
				Set-User $EnablePowerShellforUser -RemotePowerShellEnabled $True
				$TextboxResults.Text = Get-User $EnablePowerShellforUser | Format-List DisplayName, RemotePowerShellEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable PowerShell Access for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getPowerShellRemotingStatusForAllToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting PowerShell info for all users..."
		$textboxDetails.Text = "Get-User -ResultSize unlimited | Sort-Object DisplayName | Format-Table DisplayName, RemotePowerShellEnabled -AutoSize"
		$TextboxResults.Text = Get-User -ResultSize unlimited | Sort-Object DisplayName | Format-Table DisplayName, RemotePowerShellEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}


	#Message Trace

$messageTraceToolStripMenuItem_Click = {
	
}

$GetAllRecentToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting recent messages..."
		$textboxDetails.Text = "Get-MessageTrace | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
		$TextboxResults.Text = Get-MessageTrace | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$fromACertainSenderToolStripMenuItem1_Click = {
	Do
	{
		Try
		{
			$MessageTraceSender = Read-Host "Enter the senders email address"
			If (!$MessageTraceSender)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No e-mail was entered, please enter a valid sender e-mail", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting messages from $MessageTraceSender..."
				$textboxDetails.Text = "Get-MessageTrace -SenderAddress $MessageTraceSender | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
				$TextboxResults.Text = Get-MessageTrace -SenderAddress $MessageTraceSender | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to run another message trace?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$toACertainRecipientToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$MessageTraceRecipient = Read-Host "Enter the recipients email address"
			If (!$MessageTraceRecipient)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No recipient e-mail was entered, please enter a valid e-mail address", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting messages sent to $MessageTraceRecipient..."
				$textboxDetails.Text = "Get-MessageTrace -RecipientAddress $MessageTraceRecipient | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
				$TextboxResults.Text = Get-MessageTrace -RecipientAddress $MessageTraceRecipient | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to run another message trace?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getFailedMessagesToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting failed messages..."
		$textboxDetails.Text = "Get-MessageTrace -Status 'Failed' | Format-Table Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
		$TextboxResults.Text = Get-MessageTrace -Status "Failed" | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$GetMessagesBetweenDatesToolStripMenuItem_Click = {
	Do
	{
		#$MessageTraceStartDate = Read-Host "Enter the start date. EX: 06/13/2015 or 09/01/2015 5:00 PM"
		$StartDateText = "Select the beginning date for the message trace"
		$StartDateFormText = "Start Date"
		Show-SelectDatePicker_psf
		$startdate = $SelectDatePicker_monthcalendar1
		$MessageTraceStartDate = "$startdate".trimend('00:00:00')
		
		#$MessageTraceEndDate = Read-Host "Enter the end date. EX: 06/15/2015 or 09/01/2015 5:00 PM"
		$StartDateText = "Select the ending date for the message trace"
		$StartDateFormText = "End Date"
		Show-SelectDatePicker_psf
		$enddate = $SelectDatePicker_monthcalendar1
		$MessageTraceEndDate = "$enddate".trimend('00:00:00')
		
		try
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting messages between $MessageTraceStartDate and $MessageTraceEndDate..."
			$textboxDetails.Text = "Get-MessageTrace -StartDate $MessageTraceStartDate -EndDate $MessageTraceEndDate | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
			$TextboxResults.Text = Get-MessageTrace -StartDate $MessageTraceStartDate -EndDate $MessageTraceEndDate | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to run another message trace?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Company Info

$getTechnicalNotificationEmailToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting technical account info..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List TechnicalNotificationEmails"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List TechnicalNotificationEmails | Out-String
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting technical account info..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List TechnicalNotificationEmails"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List TechnicalNotificationEmails | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting technical account info..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List TechnicalNotificationEmails"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List TechnicalNotificationEmails | Out-String
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$lastDirSyncTimeToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last DirSync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastDirSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastDirSyncTime | Out-String
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last DirSync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List LastDirSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List LastDirSyncTime | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last DirSync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastDirSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastDirSyncTime | Out-String
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getLastPasswordSyncTimeToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last password sync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastPasswordSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastPasswordSyncTime | Out-String
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last password sync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText  | Format-List LastPasswordSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List LastPasswordSyncTime | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last password sync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastPasswordSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastPasswordSyncTime | Out-String
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllCompanyInfoToolStripMenuItem_Click = {
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all company info..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List "
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List | Out-String
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all company info..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all company info..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List "
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List | Out-String
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

#Sharing Policy

$getSharingPolicyToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all sharing policies..."
		$textboxDetails.Text = "Get-SharingPolicy | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState"
		$TextboxResults.Text = Get-SharingPolicy | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableASharingPolicyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DisableSharingPolicy = Read-Host "Enter the name of the policy you want to disable"
			$SharingPolicyText = "Select the Sharing Policy you want to disable"
			Show-SelectSharingPolicy_psf
			$DisableSharingPolicy = $SelectSharingPolicy_comboboxSharingPolicies
			If (!$DisableSharingPolicy)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Sharing Policy was selected, please selected a valid Sharing Policy to disable", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling the sharing policy $DisableSharingPolicy..."
				$textboxDetails.Text = "Set-SharingPolicy -Identity $DisableSharingPolicy -Enabled `$False"
				Set-SharingPolicy -Identity $DisableSharingPolicy -Enabled $False
				$TextboxResults.Text = Get-SharingPolicy -Identity $DisableSharingPolicy | Format-List Name, Enabled, ObjectState | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable another Sharing Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableASharingPolicyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$EnableSharingPolicy = Read-Host "Enter the name of the policy you want to Enable"
			$SharingPolicyText = "Select the Sharing Policy you want to enable"
			Show-SelectSharingPolicy_psf
			$EnableSharingPolicy = $SelectSharingPolicy_comboboxSharingPolicies
			If (!$EnableSharingPolicy)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Sharing Policy was selected, please select a valid Sharing Policy to enable", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling the sharing policy $EnableSharingPolicy..."
				$textboxDetails.Text = "Set-SharingPolicy -Identity $EnableSharingPolicy -Enabled `$True"
				Set-SharingPolicy -Identity $EnableSharingPolicy -Enabled $True
				$TextboxResults.Text = Get-SharingPolicy -Identity $EnableSharingPolicy | Format-List Name, Enabled, ObjectState | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable another Sharing Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$createANewSharingPolicyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TextboxResults.Text = "You may need to enable organization customization if customization status is dehydrated."
			$TextboxResults.Text = Get-OrganizationConfig | Format-List  Identity, IsDehydrated | Out-String
			$NewSharingPolicyName = Read-Host "Enter the name for the Sharing Policy"
			If (!$NewSharingPolicyName)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please enter a valid name for the new Sharing Policy", "Error")
			}
			Else
			{
				$TextboxResults.Text = "The following Sharing Policy Action Values can be used:
CalendarSharingFreeBusySimple: Share free/busy hours only
CalendarSharingFreeBusyDetail: Share free/busy hours, subject, and location
CalendarSharingFreeBusyReviewer: Share free/busy hours, subject, location, and the body of the message or calendar item
ContactsSharing: Share contacts only

EXAMPLE: mail.contoso.com: CalendarSharingFreeBusyDetail, ContactsSharing "
				$SharingPolicy = Read-Host "Enter the domain this policy will apply to and the value"
				If (!$SharingPolicy)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Sharing Policy Action Value was entered, please enter a valid Sharing Policy Action Value", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Creating a new sharing policy $NewSharingPolicyName..."
					$textboxDetails.Text = "New-SharingPolicy -Name $NewSharingPolicyName -Domains $SharingPolicy"
					New-SharingPolicy -Name $NewSharingPolicyName -Domains $SharingPolicy
					$TextboxResults.Text = Get-SharingPolicy -Identity $NewSharingPolicyName | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Sharing Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getInfoForASingleSharingPolicyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DetailedInfoForSharingPolicy = Read-Host "Enter the name of the policy you want info for"
			$SharingPolicyText = "Select the Sharing Policy you want to view detailed information for"
			Show-SelectSharingPolicy_psf
			$DetailedInfoForSharingPolicy = $SelectSharingPolicy_comboboxSharingPolicies
			If (!$DetailedInfoForSharingPolicy)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Sharing Policy was selected, please select a valid Sharing Policy to get detailed information on", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting info for the sharing policy $DetailedInfoForSharingPolicy..."
				$textboxDetails.Text = "Get-SharingPolicy -Identity $DetailedInfoForSharingPolicy | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState"
				$TextboxResults.Text = Get-SharingPolicy -Identity $DetailedInfoForSharingPolicy | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get information about another Sharing Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Configuration 

$enableCustomizationToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling customization..."
		$textboxDetails.Text = "Enable-OrganizationCustomization"
		Enable-OrganizationCustomization
		$TextboxResults.Text = "Success"
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getCustomizationStatusToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting customization status..."
		$textboxDetails.Text = "Get-OrganizationConfig | Format-Table  Identity, IsDehydrated -AutoSize "
		$TextboxResults.Text = Get-OrganizationConfig | Format-Table  Identity, IsDehydrated -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getOrganizationCustomizationToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting customization information..."
		$textboxDetails.Text = "Get-OrganizationConfig | Format-List"
		$TextboxResults.Text = Get-OrganizationConfig | Format-List | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getSharepointSiteToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting sharepoint URL..."
		$textboxDetails.Text = "Get-OrganizationConfig | Format-List SharePointUrl"
		$TextboxResults.Text = Get-OrganizationConfig | Format-List SharePointUrl | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}



###REPORTING###

$getAllMailboxSizesToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Generating mailbox sizes report..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Select-Object DisplayName,`@{name = 'TotalItemSize (MB)'; expression = {[math]::Round( `
(`$_.TotalItemSize.ToString().Split('(')[1].Split(' ')[0].Replace(', ', '')/1MB), 2)}}, `
ItemCount | Sort-Object 'TotalItemSize (MB)' -Descending | Format-Table -AutoSize"
		$TextboxResults.Text =
		Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Select-Object DisplayName, `
		
		@{
			name = "TotalItemSize (MB)"; expression = {
				[math]::Round( `
					($_.TotalItemSize.ToString().Split("(")[1].Split(" ")[0].Replace(",", "")/1MB), 2)
			}
		}, `
		
		ItemCount | Sort-Object "TotalItemSize (MB)" -Descending | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getLicenceReconciliationReportToolStripMenuItem_Click = {
	$textboxDetails.Text = ""
	$TextboxResults.Text = ""
	Try
	{
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$LogFile = $savedialog.filename
				$TextboxResults.Text = "Getting License Report..."
				
				# Define Hashtables for lookup 
				$Sku = @{
					"DESKLESSPACK" = "Office 365 (Plan K1)"
					"DESKLESSWOFFPACK" = "Office 365 (Plan K2)"
					"LITEPACK" = "Office 365 (Plan P1)"
					"EXCHANGESTANDARD" = "Office 365 Exchange Online Only"
					"STANDARDPACK" = "Office 365 (Plan E1)"
					"STANDARDWOFFPACK" = "Office 365 (Plan E2)"
					"ENTERPRISEPACK" = "Office 365 (Plan E3)"
					"ENTERPRISEPACKLRG" = "Office 365 (Plan E3)"
					"ENTERPRISEWITHSCAL" = "Office 365 (Plan E4)"
					"STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students"
					"STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students"
					"ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
					"ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
					"STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty"
					"STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty"
					"ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
					"ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
					"ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
					"STANDARD_B_PILOT" = "Office 365 (Small Business Preview)"
				}
				
				# Get a list of all licences that exist within the tenant 
				$licensetype = Get-MsolAccountSku | Where-Object { $_.ConsumedUnits -ge 1 }
				
				# Loop through all licence types found in the tenant 
				foreach ($license in $licensetype)
				{
					# Build and write the Header for the CSV file 
					$headerstring = "DisplayName,UserPrincipalName,AccountSku"
					
					foreach ($row in $($license.ServiceStatus))
					{
						
						# Build header string 
						switch -wildcard ($($row.ServicePlan.servicename))
						{
							"EXC*" { $thisLicence = "Exchange Online" }
							"MCO*" { $thisLicence = "Lync Online" }
							"LYN*" { $thisLicence = "Lync Online" }
							"OFF*" { $thisLicence = "Office Profesional Plus" }
							"SHA*" { $thisLicence = "Sharepoint Online" }
							"*WAC*" { $thisLicence = "Office Web Apps" }
							"WAC*" { $thisLicence = "Office Web Apps" }
							default { $thisLicence = $row.ServicePlan.servicename }
						}
						
						$headerstring = ($headerstring + "," + $thisLicence)
					}
					
					Out-File -FilePath $LogFile -InputObject $headerstring -Encoding UTF8 -append
					
					# Gather users for this particular AccountSku 
					$users = Get-MsolUser -all | Where-Object { $_.isLicensed -eq "True" -and $_.licenses[0].accountskuid.tostring() -eq $license.accountskuid }
					
					# Loop through all users and write them to the CSV file 
					foreach ($user in $users)
					{
						
						#write-host ("Processing " + $user.displayname)
						
						$datastring = ($user.displayname + "," + $user.userprincipalname + "," + $Sku.Item($user.licenses[0].AccountSku.SkuPartNumber))
						
						foreach ($row in $($user.licenses[0].servicestatus))
						{
							
							# Build data string 
							$datastring = ($datastring + "," + $($row.provisioningstatus))
						}
						
						Out-File -FilePath $LogFile -InputObject $datastring -Encoding UTF8 -append
						
					}
				}
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
			$TextboxResults.Text = ""
		}
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$LogFile = $savedialog.filename
				$TextboxResults.Text = "Getting License Report..."
				
				# Define Hashtables for lookup 
				$Sku = @{
					"DESKLESSPACK" = "Office 365 (Plan K1)"
					"DESKLESSWOFFPACK" = "Office 365 (Plan K2)"
					"LITEPACK" = "Office 365 (Plan P1)"
					"EXCHANGESTANDARD" = "Office 365 Exchange Online Only"
					"STANDARDPACK" = "Office 365 (Plan E1)"
					"STANDARDWOFFPACK" = "Office 365 (Plan E2)"
					"ENTERPRISEPACK" = "Office 365 (Plan E3)"
					"ENTERPRISEPACKLRG" = "Office 365 (Plan E3)"
					"ENTERPRISEWITHSCAL" = "Office 365 (Plan E4)"
					"STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students"
					"STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students"
					"ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
					"ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
					"STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty"
					"STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty"
					"ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
					"ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
					"ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
					"STANDARD_B_PILOT" = "Office 365 (Small Business Preview)"
				}
				
				# Get a list of all licences that exist within the tenant 
				$licensetype = Get-MsolAccountSku -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.ConsumedUnits -ge 1 }
				
				# Loop through all licence types found in the tenant 
				foreach ($license in $licensetype)
				{
					# Build and write the Header for the CSV file 
					$headerstring = "DisplayName,UserPrincipalName,AccountSku"
					
					foreach ($row in $($license.ServiceStatus))
					{
						
						# Build header string 
						switch -wildcard ($($row.ServicePlan.servicename))
						{
							"EXC*" { $thisLicence = "Exchange Online" }
							"MCO*" { $thisLicence = "Lync Online" }
							"LYN*" { $thisLicence = "Lync Online" }
							"OFF*" { $thisLicence = "Office Profesional Plus" }
							"SHA*" { $thisLicence = "Sharepoint Online" }
							"*WAC*" { $thisLicence = "Office Web Apps" }
							"WAC*" { $thisLicence = "Office Web Apps" }
							default { $thisLicence = $row.ServicePlan.servicename }
						}
						
						$headerstring = ($headerstring + "," + $thisLicence)
					}
					
					Out-File -FilePath $LogFile -InputObject $headerstring -Encoding UTF8 -append
					
					# Gather users for this particular AccountSku 
					$users = Get-MsolUser -all -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.isLicensed -eq "True" -and $_.licenses[0].accountskuid.tostring() -eq $license.accountskuid }
					
					# Loop through all users and write them to the CSV file 
					foreach ($user in $users)
					{
						
						#write-host ("Processing " + $user.displayname)
						
						$datastring = ($user.displayname + "," + $user.userprincipalname + "," + $Sku.Item($user.licenses[0].AccountSku.SkuPartNumber))
						
						foreach ($row in $($user.licenses[0].servicestatus))
						{
							
							# Build data string 
							$datastring = ($datastring + "," + $($row.provisioningstatus))
						}
						
						Out-File -FilePath $LogFile -InputObject $datastring -Encoding UTF8 -append
						
					}
				}
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
			$TextboxResults.Text = ""
		}
		Else
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$LogFile = $savedialog.filename
				$TextboxResults.Text = "Getting License Report..."
				
				# Define Hashtables for lookup 
				$Sku = @{
					"DESKLESSPACK" = "Office 365 (Plan K1)"
					"DESKLESSWOFFPACK" = "Office 365 (Plan K2)"
					"LITEPACK" = "Office 365 (Plan P1)"
					"EXCHANGESTANDARD" = "Office 365 Exchange Online Only"
					"STANDARDPACK" = "Office 365 (Plan E1)"
					"STANDARDWOFFPACK" = "Office 365 (Plan E2)"
					"ENTERPRISEPACK" = "Office 365 (Plan E3)"
					"ENTERPRISEPACKLRG" = "Office 365 (Plan E3)"
					"ENTERPRISEWITHSCAL" = "Office 365 (Plan E4)"
					"STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students"
					"STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students"
					"ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
					"ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
					"STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty"
					"STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty"
					"ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
					"ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
					"ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
					"STANDARD_B_PILOT" = "Office 365 (Small Business Preview)"
				}
				
				# Get a list of all licences that exist within the tenant 
				$licensetype = Get-MsolAccountSku | Where-Object { $_.ConsumedUnits -ge 1 }
				
				# Loop through all licence types found in the tenant 
				foreach ($license in $licensetype)
				{
					# Build and write the Header for the CSV file 
					$headerstring = "DisplayName,UserPrincipalName,AccountSku"
					
					foreach ($row in $($license.ServiceStatus))
					{
						
						# Build header string 
						switch -wildcard ($($row.ServicePlan.servicename))
						{
							"EXC*" { $thisLicence = "Exchange Online" }
							"MCO*" { $thisLicence = "Lync Online" }
							"LYN*" { $thisLicence = "Lync Online" }
							"OFF*" { $thisLicence = "Office Profesional Plus" }
							"SHA*" { $thisLicence = "Sharepoint Online" }
							"*WAC*" { $thisLicence = "Office Web Apps" }
							"WAC*" { $thisLicence = "Office Web Apps" }
							default { $thisLicence = $row.ServicePlan.servicename }
						}
						
						$headerstring = ($headerstring + "," + $thisLicence)
					}
					
					Out-File -FilePath $LogFile -InputObject $headerstring -Encoding UTF8 -append
					
					# Gather users for this particular AccountSku 
					$users = Get-MsolUser -all | Where-Object { $_.isLicensed -eq "True" -and $_.licenses[0].accountskuid.tostring() -eq $license.accountskuid }
					
					# Loop through all users and write them to the CSV file 
					foreach ($user in $users)
					{
						
						#write-host ("Processing " + $user.displayname)
						
						$datastring = ($user.displayname + "," + $user.userprincipalname + "," + $Sku.Item($user.licenses[0].AccountSku.SkuPartNumber))
						
						foreach ($row in $($user.licenses[0].servicestatus))
						{
							
							# Build data string 
							$datastring = ($datastring + "," + $($row.provisioningstatus))
						}
						
						Out-File -FilePath $LogFile -InputObject $datastring -Encoding UTF8 -append
						
					}
				}
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
			$TextboxResults.Text = ""
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllGroupsAndAllMembersToCSVToolStripMenuItem_Click = {
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			#Constant Variables 
			$OutputFile = $savedialog.filename
			$TextboxResults.Text = "Getting all groups and members..."
			$arrDLMembers = @{ }
			
			#Prepare Output file with headers 
			Out-File -FilePath $OutputFile -InputObject "Distribution Group DisplayName,Distribution Group Email,Member DisplayName, Member Email, Member Type" -Encoding UTF8
			
			#Get all Distribution Groups from Office 365 
			$objDistributionGroups = Get-DistributionGroup -ResultSize Unlimited
			
			#Iterate through all groups, one at a time     
			Foreach ($objDistributionGroup in $objDistributionGroups)
			{
				
				#write-host "Processing $($objDistributionGroup.DisplayName)..."
				
				#Get members of this group 
				$objDGMembers = Get-DistributionGroupMember -Identity $($objDistributionGroup.PrimarySmtpAddress)
				
				#write-host "Found $($objDGMembers.Count) members..."
				
				#Iterate through each member 
				Foreach ($objMember in $objDGMembers)
				{
					Out-File -FilePath $OutputFile -InputObject "$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)" -Encoding UTF8 -append
					#write-host "`t$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)"
				}
			}
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		$TextboxResults.Text = ""
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllUsersLastLogonTimestampToCSVToolStripMenuItem_Click = {
	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to CSV"
	$savedialog.filter = ".csv|*.csv"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users last logon timestamp..."
		$textboxDetails.Text = "(Get-Mailbox) | ForEach-Object { Get-MailboxStatistics $_.Identity | Select-Object DisplayName, LastLogonTime } "
		(Get-Mailbox) | ForEach-Object { Get-MailboxStatistics $_.Identity | Select-Object DisplayName, LastLogonTime } | Export-CSV $savedialog.filename -Encoding utf8 -NoTypeInformation -Delimiter ","
		$TextboxResults.Text = ""
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	else
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllMailboxPermissionsToCSVToolStripMenuItem_Click = {
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$OutputFile = $savedialog.filename
			$TextboxResults.Text = "Getting all mailbox permissions..."
			
			#$OutputFile = Read-Host "Enter the location and name for the CSV. EX: C:\Scripts\UserPerms.csv"
			$textboxDetails.Text = ""
			
			#Main
			Function Main
			{
				
				
				
				#Prepare Output file with headers
				Out-File -FilePath $OutputFile -InputObject "UserPrincipalName,ObjectWithAccess,ObjectType,AccessType,Inherited,AllowOrDeny" -Encoding UTF8
				
				
				$objUsers = get-mailbox -ResultSize Unlimited | Select-Object UserPrincipalName
				
				
				#Iterate through all users	
				Foreach ($objUser in $objUsers)
				{
					#Connect to the users mailbox
					$objUserMailbox = get-mailboxpermission -Identity $($objUser.UserPrincipalName) | Select-Object User, AccessRights, Deny, IsInherited
					
					#Prepare UserPrincipalName variable
					$strUserPrincipalName = $objUser.UserPrincipalName
					
					#Loop through each permission
					foreach ($objPermission in $objUserMailbox)
					{
						#Get the remaining permission details (We're only interested in real users, not built in system accounts/groups)
						if (($objPermission.user.tolower().contains("\domain admin")) -or ($objPermission.user.tolower().contains("\enterprise admin")) -or ($objPermission.user.tolower().contains("\organization management")) -or ($objPermission.user.tolower().contains("\administrator")) -or ($objPermission.user.tolower().contains("\exchange servers")) -or ($objPermission.user.tolower().contains("\public folder management")) -or ($objPermission.user.tolower().contains("nt authority")) -or ($objPermission.user.tolower().contains("\exchange trusted subsystem")) -or ($objPermission.user.tolower().contains("\discovery management")) -or ($objPermission.user.tolower().contains("s-1-5-21")))
						{ }
						Else
						{
							$objRecipient = (get-recipient $($objPermission.user) -EA SilentlyContinue)
							
							if ($objRecipient)
							{
								$strUserWithAccess = $($objRecipient.DisplayName) + " (" + $($objRecipient.PrimarySMTPAddress) + ")"
								$strObjectType = $objRecipient.RecipientType
							}
							else
							{
								$strUserWithAccess = $($objPermission.user)
								$strObjectType = "Other"
							}
							
							$strAccessType = $($objPermission.AccessRights) -replace ",", ";"
							
							if ($objPermission.Deny -eq $true)
							{
								$strAllowOrDeny = "Deny"
							}
							else
							{
								$strAllowOrDeny = "Allow"
							}
							
							$strInherited = $objPermission.IsInherited
							
							#Prepare the user details in CSV format for writing to file
							$strUserDetails = "$strUserPrincipalName,$strUserWithAccess,$strObjectType,$strAccessType,$strInherited,$strAllowOrDeny"
							
							$TextboxResults.Text = $strUserDetails
							
							#Append the data to file
							Out-File -FilePath $OutputFile -InputObject $strUserDetails -Encoding UTF8 -append
						}
					}
				}
				
				
			}
			
			# Start script
			. Main
			$TextboxResults.Text = ""
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllDIsabledUsersThatAreStillMembersOfDistroGroupsToolStripMenuItem_Click = {
	Try
	{
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		$TextboxResults.Text = "Getting all users that are disabled and still members of distro groups..."
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				
				#Get All Groups 
				$Groups = Get-MsolGroup -All
				
				#Build Hash of all disabled users 
				$MSOLDisabledUsers = Get-MsolUser -All -EnabledFilter DisabledOnly | Select-Object ObjectId
				$AllDisabledUsers = @()
				$MSOLDisabledUsers | ForEach-Object { $AllDisabledUsers += $_.ObjectID.Guid }
				
				$DisabledUserMembers = @()
				
				foreach ($Group in $Groups)
				{
					#$TextboxResults.Text = "Processing $($Group.DisplayName)..."
					#Get All Members and Loop through them 
					$GroupMembers = Get-MsolGroupMember -All -GroupObjectID $Group.ObjectID
					foreach ($Member in $GroupMembers)
					{
						#Is this member in our disabled list? 
						if ($AllDisabledUsers -contains $Member.ObjectId)
						{
							#$TextboxResults.Text = "`tFound $($Member.DisplayName)"
							#Add them to the list 
							$DisabledUserMembers += (
								$Object = [pscustomobject][ordered] @{
									GroupName = $Group.DisplayName
									GroupEmail = $Group.EmailAddress
									UserName = $Member.DisplayName
									EmailAddress = $Member.EmailAddress
								}
							)
						}
					}
				}
				$DisabledUserMembers | Export-CSV -NoTypeInformation $savedialog.filename
				$TextboxResults.Text = ""
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$savedialog = New-Object windows.forms.savefiledialog
				$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
				$savedialog.title = "Export to File"
				$savedialog.filter = ".csv|*.csv"
				$savedialog.ShowHelp = $True
				$result = $savedialog.ShowDialog(); $result
				$TextboxResults.Text = "Getting all users that are disabled and still members of distro groups..."
				if ($result -eq "OK")
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					
					#Get All Groups 
					$Groups = Get-MsolGroup -All
					
					#Build Hash of all disabled users 
					$MSOLDisabledUsers = Get-MsolUser -All -EnabledFilter DisabledOnly | Select-Object ObjectId
					$AllDisabledUsers = @()
					$MSOLDisabledUsers | ForEach-Object { $AllDisabledUsers += $_.ObjectID.Guid }
					
					$DisabledUserMembers = @()
					
					foreach ($Group in $Groups)
					{
						#$TextboxResults.Text = "Processing $($Group.DisplayName)..."
						#Get All Members and Loop through them 
						$GroupMembers = Get-MsolGroupMember -TenantId $PartnerComboBox.SelectedItem.TenantID -All -GroupObjectID $Group.ObjectID
						foreach ($Member in $GroupMembers)
						{
							#Is this member in our disabled list? 
							if ($AllDisabledUsers -contains $Member.ObjectId)
							{
								#$TextboxResults.Text = "`tFound $($Member.DisplayName)"
								#Add them to the list 
								$DisabledUserMembers += (
									$Object = [pscustomobject][ordered] @{
										GroupName = $Group.DisplayName
										GroupEmail = $Group.EmailAddress
										UserName = $Member.DisplayName
										EmailAddress = $Member.EmailAddress
									}
								)
							}
						}
					}
					$DisabledUserMembers | Export-CSV -NoTypeInformation $savedialog.filename
					$TextboxResults.Text = ""
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				$savedialog = New-Object windows.forms.savefiledialog
				$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
				$savedialog.title = "Export to File"
				$savedialog.filter = ".csv|*.csv"
				$savedialog.ShowHelp = $True
				$result = $savedialog.ShowDialog(); $result
				$TextboxResults.Text = "Getting all users that are disabled and still members of distro groups..."
				if ($result -eq "OK")
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					
					#Get All Groups 
					$Groups = Get-MsolGroup -All
					
					#Build Hash of all disabled users 
					$MSOLDisabledUsers = Get-MsolUser -All -EnabledFilter DisabledOnly | Select-Object ObjectId
					$AllDisabledUsers = @()
					$MSOLDisabledUsers | ForEach-Object { $AllDisabledUsers += $_.ObjectID.Guid }
					
					$DisabledUserMembers = @()
					
					foreach ($Group in $Groups)
					{
						#$TextboxResults.Text = "Processing $($Group.DisplayName)..."
						#Get All Members and Loop through them 
						$GroupMembers = Get-MsolGroupMember -All -GroupObjectID $Group.ObjectID
						foreach ($Member in $GroupMembers)
						{
							#Is this member in our disabled list? 
							if ($AllDisabledUsers -contains $Member.ObjectId)
							{
								#$TextboxResults.Text = "`tFound $($Member.DisplayName)"
								#Add them to the list 
								$DisabledUserMembers += (
									$Object = [pscustomobject][ordered] @{
										GroupName = $Group.DisplayName
										GroupEmail = $Group.EmailAddress
										UserName = $Member.DisplayName
										EmailAddress = $Member.EmailAddress
									}
								)
							}
						}
					}
					$DisabledUserMembers | Export-CSV -NoTypeInformation $savedialog.filename
					$TextboxResults.Text = ""
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
}

$UsersGetLicensesRecoReportToolStripMenuItem1_Click = {
	$textboxDetails.Text = ""
	$TextboxResults.Text = ""
	Try
	{
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				
				$LogFile = $savedialog.filename
				$TextboxResults.Text = "Getting License Report..."
				
				# Define Hashtables for lookup 
				$Sku = @{
					"DESKLESSPACK" = "Office 365 (Plan K1)"
					"DESKLESSWOFFPACK" = "Office 365 (Plan K2)"
					"LITEPACK" = "Office 365 (Plan P1)"
					"EXCHANGESTANDARD" = "Office 365 Exchange Online Only"
					"STANDARDPACK" = "Office 365 (Plan E1)"
					"STANDARDWOFFPACK" = "Office 365 (Plan E2)"
					"ENTERPRISEPACK" = "Office 365 (Plan E3)"
					"ENTERPRISEPACKLRG" = "Office 365 (Plan E3)"
					"ENTERPRISEWITHSCAL" = "Office 365 (Plan E4)"
					"STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students"
					"STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students"
					"ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
					"ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
					"STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty"
					"STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty"
					"ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
					"ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
					"ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
					"STANDARD_B_PILOT" = "Office 365 (Small Business Preview)"
				}
				
				# Get a list of all licences that exist within the tenant 
				$licensetype = Get-MsolAccountSku | Where-Object { $_.ConsumedUnits -ge 1 }
				
				# Loop through all licence types found in the tenant 
				foreach ($license in $licensetype)
				{
					# Build and write the Header for the CSV file 
					$headerstring = "DisplayName,UserPrincipalName,AccountSku"
					
					foreach ($row in $($license.ServiceStatus))
					{
						
						# Build header string 
						switch -wildcard ($($row.ServicePlan.servicename))
						{
							"EXC*" { $thisLicence = "Exchange Online" }
							"MCO*" { $thisLicence = "Lync Online" }
							"LYN*" { $thisLicence = "Lync Online" }
							"OFF*" { $thisLicence = "Office Profesional Plus" }
							"SHA*" { $thisLicence = "Sharepoint Online" }
							"*WAC*" { $thisLicence = "Office Web Apps" }
							"WAC*" { $thisLicence = "Office Web Apps" }
							default { $thisLicence = $row.ServicePlan.servicename }
						}
						
						$headerstring = ($headerstring + "," + $thisLicence)
					}
					
					Out-File -FilePath $LogFile -InputObject $headerstring -Encoding UTF8 -append
					
					# Gather users for this particular AccountSku 
					$users = Get-MsolUser -all | Where-Object { $_.isLicensed -eq "True" -and $_.licenses[0].accountskuid.tostring() -eq $license.accountskuid }
					
					# Loop through all users and write them to the CSV file 
					foreach ($user in $users)
					{
						
						$datastring = ($user.displayname + "," + $user.userprincipalname + "," + $Sku.Item($user.licenses[0].AccountSku.SkuPartNumber))
						
						foreach ($row in $($user.licenses[0].servicestatus))
						{
							
							# Build data string 
							$datastring = ($datastring + "," + $($row.provisioningstatus))
						}
						
						Out-File -FilePath $LogFile -InputObject $datastring -Encoding UTF8 -append
						
					}
				}
				$TextboxResults.Text = ""
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				
				$LogFile = $savedialog.filename
				$TextboxResults.Text = "Getting License Report..."
				
				# Define Hashtables for lookup 
				$Sku = @{
					"DESKLESSPACK" = "Office 365 (Plan K1)"
					"DESKLESSWOFFPACK" = "Office 365 (Plan K2)"
					"LITEPACK" = "Office 365 (Plan P1)"
					"EXCHANGESTANDARD" = "Office 365 Exchange Online Only"
					"STANDARDPACK" = "Office 365 (Plan E1)"
					"STANDARDWOFFPACK" = "Office 365 (Plan E2)"
					"ENTERPRISEPACK" = "Office 365 (Plan E3)"
					"ENTERPRISEPACKLRG" = "Office 365 (Plan E3)"
					"ENTERPRISEWITHSCAL" = "Office 365 (Plan E4)"
					"STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students"
					"STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students"
					"ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
					"ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
					"STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty"
					"STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty"
					"ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
					"ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
					"ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
					"STANDARD_B_PILOT" = "Office 365 (Small Business Preview)"
				}
				
				# Get a list of all licences that exist within the tenant 
				$licensetype = Get-MsolAccountSku -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.ConsumedUnits -ge 1 }
				
				# Loop through all licence types found in the tenant 
				foreach ($license in $licensetype)
				{
					# Build and write the Header for the CSV file 
					$headerstring = "DisplayName,UserPrincipalName,AccountSku"
					
					foreach ($row in $($license.ServiceStatus))
					{
						
						# Build header string 
						switch -wildcard ($($row.ServicePlan.servicename))
						{
							"EXC*" { $thisLicence = "Exchange Online" }
							"MCO*" { $thisLicence = "Lync Online" }
							"LYN*" { $thisLicence = "Lync Online" }
							"OFF*" { $thisLicence = "Office Profesional Plus" }
							"SHA*" { $thisLicence = "Sharepoint Online" }
							"*WAC*" { $thisLicence = "Office Web Apps" }
							"WAC*" { $thisLicence = "Office Web Apps" }
							default { $thisLicence = $row.ServicePlan.servicename }
						}
						
						$headerstring = ($headerstring + "," + $thisLicence)
					}
					
					Out-File -FilePath $LogFile -InputObject $headerstring -Encoding UTF8 -append
					
					# Gather users for this particular AccountSku 
					$users = Get-MsolUser -all -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.isLicensed -eq "True" -and $_.licenses[0].accountskuid.tostring() -eq $license.accountskuid }
					
					# Loop through all users and write them to the CSV file 
					foreach ($user in $users)
					{
						
						$datastring = ($user.displayname + "," + $user.userprincipalname + "," + $Sku.Item($user.licenses[0].AccountSku.SkuPartNumber))
						
						foreach ($row in $($user.licenses[0].servicestatus))
						{
							
							# Build data string 
							$datastring = ($datastring + "," + $($row.provisioningstatus))
						}
						
						Out-File -FilePath $LogFile -InputObject $datastring -Encoding UTF8 -append
						
					}
				}
				$TextboxResults.Text = ""
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			$savedialog = New-Object windows.forms.savefiledialog
			$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
			$savedialog.title = "Export to File"
			$savedialog.filter = ".csv|*.csv"
			$savedialog.ShowHelp = $True
			$result = $savedialog.ShowDialog(); $result
			if ($result -eq "OK")
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				
				$LogFile = $savedialog.filename
				$TextboxResults.Text = "Getting License Report..."
				
				# Define Hashtables for lookup 
				$Sku = @{
					"DESKLESSPACK" = "Office 365 (Plan K1)"
					"DESKLESSWOFFPACK" = "Office 365 (Plan K2)"
					"LITEPACK" = "Office 365 (Plan P1)"
					"EXCHANGESTANDARD" = "Office 365 Exchange Online Only"
					"STANDARDPACK" = "Office 365 (Plan E1)"
					"STANDARDWOFFPACK" = "Office 365 (Plan E2)"
					"ENTERPRISEPACK" = "Office 365 (Plan E3)"
					"ENTERPRISEPACKLRG" = "Office 365 (Plan E3)"
					"ENTERPRISEWITHSCAL" = "Office 365 (Plan E4)"
					"STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students"
					"STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students"
					"ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
					"ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
					"STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty"
					"STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty"
					"ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
					"ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
					"ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
					"STANDARD_B_PILOT" = "Office 365 (Small Business Preview)"
				}
				
				# Get a list of all licences that exist within the tenant 
				$licensetype = Get-MsolAccountSku | Where-Object { $_.ConsumedUnits -ge 1 }
				
				# Loop through all licence types found in the tenant 
				foreach ($license in $licensetype)
				{
					# Build and write the Header for the CSV file 
					$headerstring = "DisplayName,UserPrincipalName,AccountSku"
					
					foreach ($row in $($license.ServiceStatus))
					{
						
						# Build header string 
						switch -wildcard ($($row.ServicePlan.servicename))
						{
							"EXC*" { $thisLicence = "Exchange Online" }
							"MCO*" { $thisLicence = "Lync Online" }
							"LYN*" { $thisLicence = "Lync Online" }
							"OFF*" { $thisLicence = "Office Profesional Plus" }
							"SHA*" { $thisLicence = "Sharepoint Online" }
							"*WAC*" { $thisLicence = "Office Web Apps" }
							"WAC*" { $thisLicence = "Office Web Apps" }
							default { $thisLicence = $row.ServicePlan.servicename }
						}
						
						$headerstring = ($headerstring + "," + $thisLicence)
					}
					
					Out-File -FilePath $LogFile -InputObject $headerstring -Encoding UTF8 -append
					
					# Gather users for this particular AccountSku 
					$users = Get-MsolUser -all | Where-Object { $_.isLicensed -eq "True" -and $_.licenses[0].accountskuid.tostring() -eq $license.accountskuid }
					
					# Loop through all users and write them to the CSV file 
					foreach ($user in $users)
					{
						
						$datastring = ($user.displayname + "," + $user.userprincipalname + "," + $Sku.Item($user.licenses[0].AccountSku.SkuPartNumber))
						
						foreach ($row in $($user.licenses[0].servicestatus))
						{
							
							# Build data string 
							$datastring = ($datastring + "," + $($row.provisioningstatus))
						}
						
						Out-File -FilePath $LogFile -InputObject $datastring -Encoding UTF8 -append
						
					}
				}
				$TextboxResults.Text = ""
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllGroupsAndAllMembersToolStripMenuItem_Click = {
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			#Constant Variables 
			$OutputFile = $savedialog.filename
			$TextboxResults.Text = "Getting all groups and members..."
			$arrDLMembers = @{ }
			
			#Prepare Output file with headers 
			Out-File -FilePath $OutputFile -InputObject "Distribution Group DisplayName,Distribution Group Email,Member DisplayName, Member Email, Member Type" -Encoding UTF8
			
			#Get all Distribution Groups from Office 365 
			$objDistributionGroups = Get-DistributionGroup -ResultSize Unlimited
			
			#Iterate through all groups, one at a time     
			Foreach ($objDistributionGroup in $objDistributionGroups)
			{
				
				#write-host "Processing $($objDistributionGroup.DisplayName)..."
				
				#Get members of this group 
				$objDGMembers = Get-DistributionGroupMember -Identity $($objDistributionGroup.PrimarySmtpAddress)
				
				#write-host "Found $($objDGMembers.Count) members..."
				
				#Iterate through each member 
				Foreach ($objMember in $objDGMembers)
				{
					Out-File -FilePath $OutputFile -InputObject "$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)" -Encoding UTF8 -append
					#write-host "`t$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)"
				}
			}
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		$TextboxResults.Text = ""
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$exportAllEmailAddressesToCSVToolStripMenuItem_Click = {
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$OutputFile = $savedialog.filename
			$textboxDetails.Text = "Get-Recipient -ResultSize Unlimited | Select-Object DisplayName, RecipientType, EmailAddresses"
			$TextboxResults.Text = "Exporting list of all email addresses..."
			Get-Recipient -ResultSize Unlimited | select-object DisplayName, RecipientType, EmailAddresses | Export-Csv $OutputFile -NoTypeInformation
			$TextboxResults.Text = ""
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

#Mail Malware Report

$getMailMalwareReportToolStripMenuItem1_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting mail malware report..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport | Format-List"
		$TextboxResults.Text = Get-MailDetailMalwareReport | Format-List | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailMalwareReportFromSenderToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$MalwareSender = Read-Host "Enter the email of the sender"
			If (!$MalwareSender)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No e-mail was entered, please enter a valid e-mail of the sender", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Generating mail malware report sent from $MalwareSender..."
				$textboxDetails.Text = "Get-MailDetailMalwareReport -SenderAddress $MalwareSender | Format-List"
				$TextboxResults.Text = Get-MailDetailMalwareReport -SenderAddress $MalwareSender | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get a Mail Malware report for a different Sender?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getMailMalwareReportBetweenDatesToolStripMenuItem_Click = {
	Do
	{
		#$MalwareReportStart = Read-Host "Enter the start date. EX: 06/13/2015"
		$StartDateText = "Select the beginning date for the mail malware report"
		$StartDateFormText = "Start Date"
		Show-SelectDatePicker_psf
		$startdate = $SelectDatePicker_monthcalendar1
		$MalwareReportStart = "$startdate".trimend('00:00:00')
		
		#$MalwareReportEnd = Read-Host "Enter the end date. EX: 06/15/2015 "
		$StartDateText = "Select the ending date for the mail malware report"
		$StartDateFormText = "End Date"
		Show-SelectDatePicker_psf
		$enddate = $SelectDatePicker_monthcalendar1
		$MalwareReportEnd = "$enddate".trimend('00:00:00')
		
		try
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Generating mail malware report between $MalwareReportStart and $MalwareReportEnd..."
			$textboxDetails.Text = "Get-MailDetailMalwareReport -StartDate $MalwareReportStart -EndDate $MalwareReportEnd | Format-List"
			$TextboxResults.Text = Get-MailDetailMalwareReport -StartDate $MalwareReportStart -EndDate $MalwareReportEnd | Format-List | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get another Mail Malware report for a different date?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getMailMalwareReportToARecipientToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$MalwareRecipient = Read-Host "Enter the email of the recipient"
			If (!$MalwareRecipient)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Recipient E-mail was entered, please enter a valid recipient e-mail", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Generating mail malware report sent to $MalwareRecipient..."
				$textboxDetails.Text = "Get-MailDetailMalwareReport -RecipientAddress $MalwareRecipient | Format-List"
				$TextboxResults.Text = Get-MailDetailMalwareReport -RecipientAddress $MalwareRecipient | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get another Mail Malware report for a different Recipient?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getMailMalwareReporforInboundToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Generating mail malware inbound report..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport -Direction Inbound | Format-List "
		$TextboxResults.Text = Get-MailDetailMalwareReport -Direction Inbound | Format-List | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailMalwareReportForOutboundToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Generating mail malware outbound report..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport -Direction Outbound | Format-List"
		$TextboxResults.Text = Get-MailDetailMalwareReport -Direction Outbound | Format-List | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Mail Traffic Report

$getRecentMailTrafficReportToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Generating recent mail traffic report..."
		$textboxDetails.Text = "Get-MailTrafficReport | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficReport | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getInboundMailTrafficReportToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Generating inbound traffic report..."
		$textboxDetails.Text = "Get-MailTrafficReport -Direction Inbound | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficReport -Direction Inbound | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getOutboundMailTrafficReportToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Generating outbound mail traffic report..."
		$textboxDetails.Text = "Get-MailTrafficReport -Direction Outbound | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficReport -Direction Outbound | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailTrafficReportBetweenDatesToolStripMenuItem_Click = {
	
	#$MailTrafficStart = Read-Host "Enter the start date. EX: 06/13/2015"
	$StartDateText = "Select the beginning date for the mail traffic report"
	$StartDateFormText = "Start Date"
	Show-SelectDatePicker_psf
	$startdate = $SelectDatePicker_monthcalendar1
	$MailTrafficStart = "$startdate".trimend('00:00:00')
	
	#$MailTrafficEnd = Read-Host "Enter the end date. EX: 06/15/2015 "
	$StartDateText = "Select the ending date for the mail traffic report"
	$StartDateFormText = "End Date"
	Show-SelectDatePicker_psf
	$enddate = $SelectDatePicker_monthcalendar1
	$MailTrafficEnd = "$enddate".trimend('00:00:00')
	
	
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Generating mail traffic report between $MailTrafficStart and $MailTrafficEnd..."
		$textboxDetails.Text = "Get-MailTrafficReport -StartDate $MailTrafficStart -EndDate $MailTrafficEnd | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficReport -StartDate $MailTrafficStart -EndDate $MailTrafficEnd | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#ActiveSyncDevices

$getAllUsersActiveSyncDevicesToolStripMenuItem_Click = {
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to CSV"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all ActiveSync Devices for all users..."
			$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | ForEach-Object { `$PrimarySmtpAddress = `$_.PrimarySmtpAddress; Get-MobileDeviceStatistics -Mailbox `$_.Identity | Select-Object @{ Name = 'PrimarySmtpAddress'; Expression = { `$PrimarySmtpAddress } }, DeviceType, DeviceOS, DeviceMobileOperator, LastSyncAttemptTime } | Export-CSV `$savedialog.filename -Encoding utf8 -NoTypeInformation -Delimiter ", ""
			$MailBox = Get-Mailbox -ResultSize Unlimited
			$MailBox | ForEach-Object { $PrimarySmtpAddress = $_.PrimarySmtpAddress; Get-MobileDeviceStatistics -Mailbox $_.Identity | Select-Object @{ Name = "PrimarySmtpAddress"; Expression = { $PrimarySmtpAddress } }, DeviceType, DeviceOS, DeviceMobileOperator, LastSyncAttemptTime } | Export-CSV $savedialog.filename -Encoding utf8 -NoTypeInformation -Delimiter ","
			$TextboxResults.Text = ""
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}



###SHARED MAILBOXES###

$createASharedMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewSharedMailbox = Read-Host "Enter the name of the new Shared Mailbox"
			If (!$NewSharedMailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please enter a valid name for the new Shared Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Creating new shared mailbox $NewSharedMailbox"
				$textboxDetails.Text = "New-Mailbox -Name $NewSharedMailbox –Shared"
				New-Mailbox -Name $NewSharedMailbox –Shared
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited -RecipientTypeDetails SharedMailbox | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Shared Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllSharedMailboxesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting list of shared mailboxes..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize unlimited -RecipientTypeDetails SharedMailbox | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox -ResultSize unlimited -RecipientTypeDetails SharedMailbox | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$convertRegularMailboxToSharedToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ConvertMailboxtoShared = Read-Host "Enter the name of the account you want to convert"
			$SelectUsersFormText = "Select the User you want to convert to a Shared Mailbox"
			Show-SelectCachedDisplayNames_psf
			$ConvertMailboxtoShared = $SelectCachedDisplayNames_comboboxNames
			If (!$ConvertMailboxtoShared)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User to convert to a Shared Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Converting $ConvertMailboxtoShared to a shared mailbox..."
				$textboxDetails.Text = "Set-Mailbox $ConvertMailboxtoShared –Type shared"
				Set-Mailbox $ConvertMailboxtoShared –Type shared
				$TextboxResults.Text = Get-Mailbox -Identity $ConvertMailboxtoShared | Format-List UserPrincipalName, DisplayName, RecipientTypeDetails, PrimarySmtpAddress, EmailAddresses, IsDirSynced | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to convert another User to a Shared Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$convertSharedMailboxToRegularToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$ConvertMailboxtoRegular = Read-Host "Enter the name of the account you want to convert"
			$SharedMailboxesText = "Select the Shared Mailbox you want convert to a Regular Mailbox"
			Show-SelectSharedMailbox_psf
			$ConvertMailboxtoRegular = $SelectSharedMailbox_comboboxSharedMailboxes
			If (!$ConvertMailboxtoRegular)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Shared Mailbox was selected, please select a valid Shared Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Converting $ConvertMailboxtoRegular to a Regular Mailbox..."
				$textboxDetails.Text = "Set-Mailbox $ConvertMailboxtoRegular –Type Regular"
				Set-Mailbox $ConvertMailboxtoRegular –Type Regular
				$TextboxResults.Text = Get-Mailbox -Identity $ConvertMailboxtoRegular | Format-List UserPrincipalName, DisplayName, RecipientTypeDetails, PrimarySmtpAddress, EmailAddresses, IsDirSynced | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to convert another Shared Mailbox to a Regular Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getDetailedInfoForASharedMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$SharedMailboxDetailedInfo = Read-Host "Enter the name of the shared mailbox"
			$SharedMailboxesText = "Select the Shared Mailbox you want to view detailed information for"
			Show-SelectSharedMailbox_psf
			$SharedMailboxDetailedInfo = $SelectSharedMailbox_comboboxSharedMailboxes
			If (!$SharedMailboxDetailedInfo)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Shared Mailbox was selected, please select a valid Shared Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting shared mailbox information for $SharedMailboxDetailedInfo..."
				$textboxDetails.Text = "Get-Mailbox $SharedMailboxDetailedInfo | Format-List"
				$TextboxResults.Text = Get-Mailbox $SharedMailboxDetailedInfo | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get information on another Shared Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeASharedMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SharedMailboxesText = "Please select the Shared Mailbox you want to delete "
			Show-SelectSharedMailbox_psf
			$DeleteSharedMailbox = $SelectSharedMailbox_comboboxSharedMailboxes
			If (!$DeleteSharedMailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Shared Mailbox was selected, please select a valid Shared Mailbox to delete", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxDetails.Text = "Remove-Mailbox -Identity $DeleteSharedMailbox"
				$TextboxResults.Text = "Deleting the $DeleteSharedMailbox mailbox"
				Remove-Mailbox -Identity $DeleteSharedMailbox
				$TextboxResults.Text = "Getting list of shared mailboxes..."
				$TextboxResults.Text = Get-Mailbox -ResultSize unlimited -RecipientTypeDetails SharedMailbox | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Shared Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Permissions

$exportAllUsersMailboxPermissionsToCSVToolStripMenuItem_Click = {
	
	
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$OutputFile = $savedialog.filename
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			#$OutputFile = Read-Host "Enter the location and name for the CSV. EX: C:\Scripts\UserPerms.csv"
			$textboxDetails.Text = "https://gallery.technet.microsoft.com/scriptcenter/Export-mailbox-permissions-d12a1d28"
			
			#Main
			Function Main
			{
				
				
				
				#Prepare Output file with headers
				Out-File -FilePath $OutputFile -InputObject "UserPrincipalName,ObjectWithAccess,ObjectType,AccessType,Inherited,AllowOrDeny" -Encoding UTF8
				
				
				$objUsers = get-mailbox -ResultSize Unlimited | Select-Object UserPrincipalName
				
				
				#Iterate through all users	
				Foreach ($objUser in $objUsers)
				{
					#Connect to the users mailbox
					$objUserMailbox = get-mailboxpermission -Identity $($objUser.UserPrincipalName) | Select-Object User, AccessRights, Deny, IsInherited
					
					#Prepare UserPrincipalName variable
					$strUserPrincipalName = $objUser.UserPrincipalName
					
					#Loop through each permission
					foreach ($objPermission in $objUserMailbox)
					{
						#Get the remaining permission details (We're only interested in real users, not built in system accounts/groups)
						if (($objPermission.user.tolower().contains("\domain admin")) -or ($objPermission.user.tolower().contains("\enterprise admin")) -or ($objPermission.user.tolower().contains("\organization management")) -or ($objPermission.user.tolower().contains("\administrator")) -or ($objPermission.user.tolower().contains("\exchange servers")) -or ($objPermission.user.tolower().contains("\public folder management")) -or ($objPermission.user.tolower().contains("nt authority")) -or ($objPermission.user.tolower().contains("\exchange trusted subsystem")) -or ($objPermission.user.tolower().contains("\discovery management")) -or ($objPermission.user.tolower().contains("s-1-5-21")))
						{ }
						Else
						{
							$objRecipient = (get-recipient $($objPermission.user) -EA SilentlyContinue)
							
							if ($objRecipient)
							{
								$strUserWithAccess = $($objRecipient.DisplayName) + " (" + $($objRecipient.PrimarySMTPAddress) + ")"
								$strObjectType = $objRecipient.RecipientType
							}
							else
							{
								$strUserWithAccess = $($objPermission.user)
								$strObjectType = "Other"
							}
							
							$strAccessType = $($objPermission.AccessRights) -replace ",", ";"
							
							if ($objPermission.Deny -eq $true)
							{
								$strAllowOrDeny = "Deny"
							}
							else
							{
								$strAllowOrDeny = "Allow"
							}
							
							$strInherited = $objPermission.IsInherited
							
							#Prepare the user details in CSV format for writing to file
							$strUserDetails = "$strUserPrincipalName,$strUserWithAccess,$strObjectType,$strAccessType,$strInherited,$strAllowOrDeny"
							
							$TextboxResults.Text = $strUserDetails
							
							#Append the data to file
							Out-File -FilePath $OutputFile -InputObject $strUserDetails -Encoding UTF8 -append
						}
					}
				}
				
				
			}
			
			# Start script
			. Main
			$TextboxResults.Text = ""
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$addFullAccessPermissionsToASharedMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$SharedMailboxFullAccess = Read-Host "Enter the name of the shared mailbox"
			$SharedMailboxesText = "Select the Shared Mailbox you want to modify Full Access permissions for"
			Show-SelectSharedMailbox_psf
			$SharedMailboxFullAccess = $SelectSharedMailbox_comboboxSharedMailboxes
			If (!$SharedMailboxFullAccess)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Shared Mailbox was selected, please select a valid Shared mailbox", "Error")
			}
			Else
			{
				#$GrantFullAccesstoSharedMailbox = Read-Host "Enter the UPN of the user that will have full access"
				$SelectUsersFormText = "Select the user you want to have full access to $SharedMailboxFullAccess"
				Show-SelectCachedDisplayNames_psf
				$GrantFullAccesstoSharedMailbox = $SelectCachedDisplayNames_comboboxNames
				If (!$GrantFullAccesstoSharedMailbox)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Granting Full Access permissions to $GrantFullAccesstoSharedMailbox for the $SharedMailboxFullAccess shared mailbox..."
					$textboxDetails.Text = "Add-MailboxPermission $SharedMailboxFullAccess -User $GrantFullAccesstoSharedMailbox -AccessRights FullAccess -InheritanceType All | Format-List"
					$TextboxResults.Text = Add-MailboxPermission $SharedMailboxFullAccess -User $GrantFullAccesstoSharedMailbox -AccessRights FullAccess -InheritanceType All | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions on another Shared Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getSharedMailboxPermissionsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$SharedMailboxPermissionsList = Read-Host "Enter the name of the Shared Mailbox"
			$SharedMailboxesText = "Select the Shared Mailbox you want to view permissions for"
			Show-SelectSharedMailbox_psf
			$SharedMailboxPermissionsList = $SelectSharedMailbox_comboboxSharedMailboxes
			If (!$SharedMailboxPermissionsList)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Shared Mailbox was selected, please select a valid Shared Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Send As permissions for $SharedMailboxPermissionsList..."
				$textboxDetails.Text = "Get-RecipientPermission $SharedMailboxPermissionsList | Where-Object { (`$_.Trustee -notlike 'NT AUTHORITY\SELF') } | Sort-Object Trustee | Format-Table Trustee, AccessControlType, AccessRights -AutoSize"
				#$TextboxResults.Text = Get-RecipientPermission $SharedMailboxPermissionsList | Format-List | Out-String
				$TextboxResults.Text = Get-RecipientPermission $SharedMailboxPermissionsList | Where-Object { ($_.Trustee -notlike "NT AUTHORITY\SELF") } | Sort-Object Trustee | Format-Table Trustee, AccessControlType, AccessRights -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view permissions for another Shared Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getSharedMailboxFullAccessPermissionsToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$SharedMailboxFullAccessPermissionsList = Read-Host "Enter the name of the Shared Mailbox"
			$SharedMailboxesText = "Select the Shared Mailbox you want to view Full Access permissions for"
			Show-SelectSharedMailbox_psf
			$SharedMailboxFullAccessPermissionsList = $SelectSharedMailbox_comboboxSharedMailboxes
			If (!$SharedMailboxFullAccessPermissionsList)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Shared Mailbox was selected, please select a valid Shared Mailbox", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Full Access permissions for $SharedMailboxFullAccessPermissionsList..."
				$textboxDetails.Text = "Get-MailboxPermission $SharedMailboxFullAccessPermissionsList | Where-Object { (`$_.User -notlike 'NT AUTHORITY\SELF'') } | Sort-Object Identity | Format-Table Identity, User, AccessRights -AutoSize"
				$TextboxResults.Text = Get-MailboxPermission $SharedMailboxFullAccessPermissionsList | Where-Object { ($_.User -notlike "NT AUTHORITY\SELF") } | Sort-Object Identity | Format-Table Identity, User, AccessRights -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to view permissions on another Shared Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$addSendAsAccessToASharedMailboxToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$SharedMailboxSendAsAccess = Read-Host "Enter the name of the shared mailbox"
			$SharedMailboxesText = "Select the Shared Mailbox you want to modify Send As permissions for"
			Show-SelectSharedMailbox_psf
			$SharedMailboxSendAsAccess = $SelectSharedMailbox_comboboxSharedMailboxes
			If (!$SharedMailboxSendAsAccess)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Shared Mailbox was selected, please select a valid Shared Mailbox", "Error")
			}
			Else
			{
				#$SharedMailboxSendAsUser = Read-Host "Enter the UPN of the user"
				$SelectUsersFormText = "Select the user you want grant Send As permissions for $SharedMailboxSendAsAccess shared mailbox"
				Show-SelectCachedDisplayNames_psf
				$SharedMailboxSendAsUser = $SelectCachedDisplayNames_comboboxNames
				If (!$SharedMailboxSendAsUser)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting Send As permissions for $SharedMailboxSendAsAccess..."
					$textboxDetails.Text = "Add-RecipientPermission $SharedMailboxSendAsAccess -Trustee $SharedMailboxSendAsUser -AccessRights SendAs | Format-List"
					$TextboxResults.Text = Add-RecipientPermission $SharedMailboxSendAsAccess -Trustee $SharedMailboxSendAsUser -AccessRights SendAs | Format-List | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions on another Shared Mailbox?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}



###CONTACTS###

$createANewMailContactToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$ContactFirstName = Read-Host "Enter the contacts first name"
			If (!$ContactFirstName)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No first name was entered, please enter a valid first name", "Error")
			}
			Else
			{
				$ContactsLastName = Read-Host "Enter the contacts last name"
				If (!$ContactsLastName)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No last name was entered, please enter a valid last name", "Error")
				}
				Else
				{
					$ContactName = $ContactFirstName + " " + $ContactsLastName
					$ContactExternalEmail = Read-Host "Enter external email for $ContactName"
					If (!$ContactExternalEmail)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No external email was entered, please enter a valid external email", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Creating a new contact $ContactName"
						$textboxDetails.Text = "New-MailContact -Name $ContactName -FirstName $ContactFirstName -LastName $ContactsLastName -ExternalEmailAddress $ContactExternalEmail"
						New-MailContact -Name $ContactName -FirstName $ContactFirstName -LastName $ContactsLastName -ExternalEmailAddress $ContactExternalEmail
						$TextboxResults.Text = Get-MailContact -Identity $ContactName | Format-List DisplayName, EmailAddresses, PrimarySmtpAddress, ExternalEmailAddress, RecipientType | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Contact?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllContactsToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all contacts..."
		$textboxDetails.Text = "Get-MailContact -ResultSize unlimited | Sort-Object DisplayName | Format-Table DisplayName, EmailAddresses -AutoSize"
		$TextboxResults.Text = Get-MailContact -ResultSize unlimited | Sort-Object DisplayName | Format-Table DisplayName, EmailAddresses -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getDetailedInfoForAContactToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$DetailedInfoForContact = Read-Host "Enter the contact name, displayname, alias or email address"
			$MailContactText = "Select the Contact to get detailed information for"
			Show-SelectMailContact_psf
			$DetailedInfoForContact = $SelectMailContact_comboboxSelectMailContacts
			If (!$DetailedInfoForContact)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Contact was selected, please select a Contact to view detailed information of", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed info for $DetailedInfoForContact..."
				$textboxDetails.Text = "Get-MailContact -Identity $DetailedInfoForContact | Format-List"
				$TextboxResults.Text = Get-MailContact -Identity $DetailedInfoForContact | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get information on another Contact?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeAContactToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveMailContact = Read-Host "Enter the contact name, displayname, alias or email address"
			$MailContactText = "Select the Contact you want to remove"
			Show-SelectMailContact_psf
			$RemoveMailContact = $SelectMailContact_comboboxSelectMailContacts
			If (!$RemoveMailContact)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Contact was selected, please select a valid Contact to remove", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing contact $RemoveMailContact..."
				$textboxDetails.Text = "Remove-MailContact -Identity $RemoveMailContact"
				Remove-MailContact -Identity $RemoveMailContact
				$TextboxResults.Text = "Getting list of all contacts..."
				$TextboxResults.Text = Get-MailContact -ResultSize unlimited | Sort-Object DisplayName | Format-Table DisplayName, EmailAddresses, PrimarySmtpAddress, ExternalEmailAddress, RecipientType -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Contact?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Global Address List

$hideContactFromGALToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$HideGALMailContact = Read-Host "Enter the contact name, displayname, alias or email address"
			$MailContactText = "Select the Contact you want to hide from the Global Address List"
			Show-SelectMailContact_psf
			$HideGALMailContact = $SelectMailContact_comboboxSelectMailContacts
			If (!$HideGALMailContact)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Contact was selected, please select a valid Contact to hide from the Global Address List", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Hiding $HideGALMailContact from the GAL..."
				$textboxDetails.Text = "Set-MailContact -Identity $HideGALMailContact -HiddenFromAddressListsEnabled `$True"
				Set-MailContact -Identity $HideGALMailContact -HiddenFromAddressListsEnabled $True
				$TextboxResults.Text = Get-MailContact -Identity $HideGALMailContact | Format-List DisplayName, HiddenFromAddressListsEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to hide another Contact from the Global Address List?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$unhideContactFromGALToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$unHideGALMailContact = Read-Host "Enter the contact name, displayname, alias or email address"
			$MailContactText = "Select the Contact you want to unhide from the Global Address List"
			Show-SelectMailContact_psf
			$unHideGALMailContact = $SelectMailContact_comboboxSelectMailContacts
			If (!$unHideGALMailContact)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Contact was selected, please select a valid Contact to unhide from the Global Address List", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "unhiding $unHideGALMailContact from the GAL..."
				$textboxDetails.Text = "Set-MailContact -Identity $unHideGALMailContact -HiddenFromAddressListsEnabled `$False"
				Set-MailContact -Identity $unHideGALMailContact -HiddenFromAddressListsEnabled $False
				$TextboxResults.Text = Get-MailContact -Identity $unHideGALMailContact | Format-List DisplayName, HiddenFromAddressListsEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to unhide another Contact from the Global Address List?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getGALStatusForAllUsersToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting GAL status for all users..."
		$textboxDetails.Text = "Get-MailContact -ResultSize unlimited | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize"
		$TextboxResults.Text = Get-MailContact -ResultSize unlimited | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getContactsHiddenFromGALToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users that are hidden from the GAL..."
		$textboxDetails.Text = "Get-MailContact -ResultSize unlimited | Where-Object { `$_.HiddenFromAddressListsEnabled -like 'True' } | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize"
		$TextboxResults.Text = Get-MailContact -ResultSize unlimited | Where-Object { $_.HiddenFromAddressListsEnabled -like "True" } | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getContactsNotHiddenFromGALToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users that not are hidden from the GAL"
		$textboxDetails.Text = "Get-MailContact -ResultSize unlimited | Where-Object { `$_.HiddenFromAddressListsEnabled -like 'False' } | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize"
		$TextboxResults.Text = Get-MailContact -ResultSize unlimited | Where-Object { $_.HiddenFromAddressListsEnabled -like "False" } | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}


###SKYPE###

$getAllOnlineUserToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all online users..."
		$textboxDetails.Text = "Get-CsOnlineUser -ResultSize 2147483647 | Sort-Object DisplayName | Format-Table DisplayName "
		$TextboxResults.Text = Get-CsOnlineUser -ResultSize 2147483647 | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllClientPoliciesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all client policies..."
		$textboxDetails.Text = "Get-CsClientPolicy "
		$TextboxResults.Text = Get-CsClientPolicy | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getExternalAccessPoliciesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting external access policies..."
		$textboxDetails.Text = "Get-CsExternalAccessPolicy"
		$TextboxResults.Text = Get-CsExternalAccessPolicy | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getVoicePoliciesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting voice policies..."
		$textboxDetails.Text = "Get-CsVoicePolicy"
		$TextboxResults.Text = Get-CsVoicePolicy | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getBroadcastMeetingPoliciesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting broadcast meeting policies..."
		$textboxDetails.Text = "Get-CsBroadcastMeetingPolicy"
		$TextboxResults.Text = Get-CsBroadcastMeetingPolicy | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getBroadcaseMeetingConfigurationToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting broadcast meeting configuration..."
		$textboxDetails.Text = "Get-CsBroadcastMeetingConfiguration"
		$TextboxResults.Text = Get-CsBroadcastMeetingConfiguration | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getPushNotificationConfigurationToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Push Notification configuration..."
		$textboxDetails.Text = "Get-CsPushNotificationConfiguration"
		$TextboxResults.Text = Get-CsPushNotificationConfiguration | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getHostedVoicemailPolicyToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Hosted Voicemail policy..."
		$textboxDetails.Text = "Get-CsHostedVoicemailPolicy"
		$TextboxResults.Text = Get-CsHostedVoicemailPolicy | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}



###COMPLIANCE CENTER###

$newHoldCompliancePolicyToolStripMenuItem1_Click = {
	Do
	{
		Try
		{
			$NewRetentionPolicy = Read-Host "Enter the name for the new Retention Policy"
			If (!$NewRetentionPolicy)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please enter a valid name for the new Retention Policy ", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxResults.Text = "Creating the $NewRetentionPolicy Retention Policy..."
				$textboxDetails.Text = "New-RetentionCompliancePolicy -Name $NewRetentionPolicy"
				$textboxResults.Text = New-RetentionCompliancePolicy -Name $NewRetentionPolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Retention Compliance Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getHoldCompliancePoliciesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$textboxResults.Text = "Getting all Retention Policies..."
		$textboxDetails.Text = "Get-RetentionCompliancePolicy | Format-Table -AutoSize | Out-String"
		$textboxResults.Text = Get-RetentionCompliancePolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeARetentionCompliancePolicyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			#$RemoveRetentionPolicy = Read-Host "Enter the policy name you want to remove"
			$RetentionPoliciesText = "Select the Retention Policy you want to remove"
			Show-SelectRetentionPolicy_psf
			$RemoveRetentionPolicy = $SelectRetentionPolicy_comboboxRetentionPolicies
			If (!$RemoveRetentionPolicy)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No policy was selected, please select a valid policy to delete", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxResults.Text = "Removing the $RemoveRetentionPolicy retention policy..."
				$textboxDetails.Text = "Remove-RetentionCompliancePolicy -Identity $RemoveRetentionPolicy"
				Remove-RetentionCompliancePolicy -Identity $RemoveRetentionPolicy
				$textboxResults.Text = "Getting all retention policies..."
				$textboxResults.Text = Get-RetentionCompliancePolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Retention Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllManagementRolesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$textboxResults.Text = "Getting all management roles..."
		$textboxDetails.Text = "Get-ManagementRole | Sort-Object Name | Format-Table Name, RoleType -AutoSize"
		$textboxResults.Text = Get-ManagementRole | Sort-Object Name | Format-Table Name, RoleType -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Data Loss Prevention Policies

$getDataLossPreventionPoliciesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$textboxResults.Text = "Getting Data Loss Prevention Policies..."
		$textboxDetails.Text = "Get-DlpCompliancePolicy"
		$textboxResults.Text = Get-DlpCompliancePolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$newDataLossPreventionPolicyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewDLP = Read-Host "Enter the name of the new Data Loss Prevention Policy"
			If (!$NewDLP)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please enter a valid name for the new Data Loss Prevention Policy", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxResults.Text = "Creating the new $NewDLP Data Loss Prevention policy..."
				$textboxDetails.Text = "New-DlpCompliancePolicy -Name $NewDLP"
				$textboxResults.Text = New-DlpCompliancePolicy -Name $NewDLP | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Data Loss Prevention Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeDataLossPreventionPolicyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectDLPText = "Select the Data Loss Prevention Policy you want to remove"
			Show-SelectDLP_psf
			$RemoveDLP = $SelectDLP_comboboxDLP
			If (!$RemoveDLP)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Data Loss Prevention Policy was selected, please enter a valid Data Loss Prevention Policy", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing $RemoveDLP Data Loss Prevention policy..."
				$textboxDetails.Text = "Remove-DlpCompliancePolicy -Identity $RemoveDLP"
				Remove-DlpCompliancePolicy -Identity $RemoveDLP
				$TextboxResults.Text = "Getting list of Data Loss Prevention policies..."
				$textboxResults.Text = Get-DlpCompliancePolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Data Loss Prevention Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

#Data Loss Compliance Rule

$getDataLossComplianceRulesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$textboxResults.Text = "Getting Data Loss Compliance rules..."
		$textboxDetails.Text = "Get-DlpComplianceRule"
		$textboxResults.Text = Get-DlpComplianceRule | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$newDataLossComplianceRuleToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewDLC = Read-Host "Enter the name of the new Data Loss Compliance Rule"
			If (!$NewDLC)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please enter a valid name for the new Data Loss Compliance Rule", "Error")
			}
			Else
			{
				$SelectDLPText = "Select the Data Loss Prevention Policy that will contain the DLP rule"
				Show-SelectDLP_psf
				$DLPolicy = $SelectDLP_comboboxDLP
				If (!$DLPolicy)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Data Loss Prevention Policy was selected, please select a valid Data Loss Prevention Policy for the new DLP rule", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxResults.Text = "Creating the new $NewDLC Data Loss Compliance rule..."
					$textboxDetails.Text = "New-DlpComplianceRule -Name $NewDLC -Policy $DLPolicy"
					$textboxResults.Text = New-DlpComplianceRule -Name $NewDLC -Policy $DLPolicy | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Data Loss Compliance Rule?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$removeDataLossComplianceRuleToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectDLCText = "Select the Data Loss Compliance Rule you want to remove"
			Show-SelectDataComplianceRule_psf
			$RemoveDLC = $SelectDataComplianceRule_comboboxDLC
			If (!$RemoveDLC)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Data Loss Compliance Rule was selected, please enter a valid Data Loss Compliance Rule", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxResults.Text = "Removing the $RemoveDLC Data Loss Compliance rule..."
				$textboxDetails.Text = "Remove-DlpComplianceRule -Identity $RemoveDLC"
				Remove-DlpComplianceRule -Identity $RemoveDLC
				$textboxResults.Text = "Getting Data Loss Compliance rules..."
				$textboxResults.Text = Get-DlpComplianceRule | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Data Loss Compliance Rule?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}


###eDISCOVERY###

	#Case Hold Policies

$getCaseHoldPoliciesToolStripMenuItem_Click = {
	Try
	{
		$ComplianceCaseText = "Select the eDiscovery case that is associated with the case hold policy"
		Show-SelectComplianceCase_psf
		$CCase = $SelectComplianceCase_comboboxComplianceCases
		If (!$CCase)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No eDiscovery Case was selected, please select a valid eDiscovery Case", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$textboxResults.Text = "Getting Case Hold Policies..."
			$textboxDetails.Text = "Get-CaseHoldPolicy -Case $CCase"
			$textboxResults.Text = Get-CaseHoldPolicy -Case $CCase | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$newComplianceCaseToolStripMenuItem_Click = {
	Try
	{
		$NewCC = Read-Host "Enter the name for the new Compliance Case"
		If (!$NewCC)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No Name was entered, please enter a valid name for the new Compliance Case", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$textboxResults.Text = "Creating the $NewCC Compliance Case..."
			$textboxDetails.Text = "New-ComplianceCase -Name $NewCC"
			$textboxResults.Text = New-ComplianceCase -Name $NewCC | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$newCaseHoldPolicyToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewCaseHoldPolicy = Read-Host "Enter the name of the new Case Hold Policy"
			If (!$NewCaseHoldPolicy)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Name was entered, please enter a valid Name for the new Case Hold Policy", "Error")
			}
			Else
			{
				$ComplianceCaseText = "Select the eDiscovery Case that you want to associate with the $NewCaseHoldPolicy case hold policy"
				Show-SelectComplianceCase_psf
				$CCase = $SelectComplianceCase_comboboxComplianceCases
				If (!$CCase)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No eDiscovery Case was selected, please select a valid eDiscovery Case", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxResults.Text = "Creating the new $NewCaseHoldPolicy Case Hold Policy..."
					$textboxDetails.Text = "New-CaseHoldPolicy -Name $NewCaseHoldPolicy -Case $CCase"
					$textboxResults.Text = New-CaseHoldPolicy -Name $NewCaseHoldPolicy -Case $CCase | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Case Hold Policy?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeComplianceCaseToolStripMenuItem_Click = {
	Try
	{
		$ComplianceCaseText = "Select the Compliance Case you want to remove"
		Show-SelectComplianceCase_psf
		$RemoveCCase = $SelectComplianceCase_comboboxComplianceCases
		If (!$RemoveCCase)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No Compliance Case was selected, please select a valid Compliance Case you want to remove", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$textboxResults.Text = "Removing the Compliance Case $RemoveCCase..."
			$textboxDetails.Text = "Remove-ComplianceCase -Identity $RemoveCCase"
			$textboxResults.Text = Remove-ComplianceCase -Identity $RemoveCCase | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getComplianceCasesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$textboxResults.Text = "Getting Compliance Cases..."
		$textboxDetails.Text = "Get-ComplianceCase"
		$textboxResults.Text = Get-ComplianceCase | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDetailedComplianceCaseInformationToolStripMenuItem_Click = {
	Try
	{
		$ComplianceCaseText = "Select the Compliance Case you want to view detailed information for"
		Show-SelectComplianceCase_psf
		$DetailedCCase = $SelectComplianceCase_comboboxComplianceCases
		If (!$DetailedCCase)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No Compliance Case was selected, please select a valid Compliance Case", "Error")
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$textboxResults.Text = "Getting detailed information for $DetailedCCase..."
			$textboxDetails.Text = "Get-ComplianceCase -Identity $DetailedCCase | Format-List"
			$textboxResults.Text = Get-ComplianceCase -Identity $DetailedCCase | Format-List | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

#Case Admin

$addAEDiscoveryCaseAdminToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$TextboxResults.Text = "Connecting to Exchange Online to get list of Users..."
				$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
				Import-PSSession $exchangeSession -AllowClobber
				$checkboxExchangeOnline.Checked = $true
				
				$TextboxResults.Text = "Caching Users..."
				$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
				Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
				
				$SelectUsersFormText = "Select the User you want to add as a eDiscovery Case Admin"
				Show-SelectCachedDisplayNames_psf
				$NewECaseAdmin = $SelectCachedDisplayNames_comboboxNames
				If (!$NewECaseAdmin)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxResults.Text = "Adding $NewECaseAdmin as a eDiscovery case admin..."
					$textboxDetails.Text = "Add-eDiscoveryCaseAdmin -User $NewECaseAdmin"
					Add-eDiscoveryCaseAdmin -User $NewECaseAdmin
					$TextboxResults.Text = "Getting eDiscovery Case Admins..."
					$TextboxResults.Text = Get-eDiscoveryCaseAdmin | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TextboxResults.Text = "Connecting to Exchange Online to get list of Users..."
				$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
				Import-PSSession $exchangeSession -AllowClobber
				$checkboxExchangeOnline.Checked = $true
				
				$TextboxResults.Text = "Caching Users..."
				$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
				Get-MSOLUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
				
				$SelectUsersFormText = "Select the User you want to add as a eDiscovery Case Admin"
				Show-SelectCachedDisplayNames_psf
				$NewECaseAdmin = $SelectCachedDisplayNames_comboboxNames
				If (!$NewECaseAdmin)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxResults.Text = "Adding $NewECaseAdmin as a eDiscovery case admin..."
					$textboxDetails.Text = "Add-eDiscoveryCaseAdmin -User $NewECaseAdmin"
					Add-eDiscoveryCaseAdmin -User $NewECaseAdmin
					$TextboxResults.Text = "Getting eDiscovery Case Admins..."
					$TextboxResults.Text = Get-eDiscoveryCaseAdmin | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				$TextboxResults.Text = "Connecting to Exchange Online to get list of Users..."
				$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
				Import-PSSession $exchangeSession -AllowClobber
				$checkboxExchangeOnline.Checked = $true
				
				$TextboxResults.Text = "Caching Users..."
				$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter")
				Get-MSOLUser -All | Select-Object -ExpandProperty DisplayName | Out-File "$O365AdminTempFolder\names.txt"
				
				$SelectUsersFormText = "Select the User you want to add as a eDiscovery Case Admin"
				Show-SelectCachedDisplayNames_psf
				$NewECaseAdmin = $SelectCachedDisplayNames_comboboxNames
				If (!$NewECaseAdmin)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxResults.Text = "Adding $NewECaseAdmin as a eDiscovery case admin..."
					$textboxDetails.Text = "Add-eDiscoveryCaseAdmin -User $NewECaseAdmin"
					Add-eDiscoveryCaseAdmin -User $NewECaseAdmin
					$TextboxResults.Text = "Getting eDiscovery Case Admins..."
					$TextboxResults.Text = Get-eDiscoveryCaseAdmin | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to add another eDiscovery Case Admin?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getEDiscoveryCaseAdminsToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting eDiscovery Case Admins..."
		$textboxDetails.Text = "Get-eDiscoveryCaseAdmin"
		$TextboxResults.Text = Get-eDiscoveryCaseAdmin | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}


###SHAREPOINT###

$getAllSiteCollectionsToolStripMenuItem_Click = {
	try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting list of sharepoint sites..."
		$textboxDetails.Text = "Get-SPOsite | Format-Table -Autosize"
		$TextboxResults.Text = Get-SPOSite | Format-Table -AutoSize | Out-string -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllDeletedSiteCollectionsToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all deleted SharePoint sites..."
		$textboxDetails.Text = "Get-SPODeletedSite | Format-Table -Autosize"
		$TextboxResults.Text = Get-SPODeletedSite | Format-Table -AutoSize | Out-string -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllUsersForASiteToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SPOSiteText = "Select the SharePoint Site you want to get all Users from"
			Show-SelectSPOSites_psf
			$site = $SelectSPOSites_comboboxSelectSPOSites
			If (!$site)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No SharePoint Site was selected, please select a valid SharePoint Site", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxDetails.Text = "Get-SPOUser -Site $site | Format-Table -AutoSize"
				$TextboxResults.Text = "Getting all users from site $site..."
				$TextboxResults.Text = Get-SPOUser -Site $site | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get all Users for another SharePoint Site?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$testSharePointSiteToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SPOSiteText = "Select the SharePoint Site you want to test"
			Show-SelectSPOSites_psf
			$site = $SelectSPOSites_comboboxSelectSPOSites
			If (!$site)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No SharePoint Site was selected, please select a valid SharePoint Site to test", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxDetails.Text = "Test-SPOSite -identity $site"
				$TextboxResults.Text = "Testing $site..."
				$TextboxResults.Text = Test-SPOSite -identity $site | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to test another SharePoint Site?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$repairSharePointSiteToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SPOSiteText = "Select the SharePoint Site you want to repair"
			Show-SelectSPOSites_psf
			$site = $SelectSPOSites_comboboxSelectSPOSites
			If (!$site)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No SharePoint Site was selected, please select a valid SharePoint Site to reapir", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxDetails.Text = "Repair-SPOSite -identity $site"
				$TextboxResults.Text = "Repairing $site..."
				$TextboxResults.Text = Repair-SPOSite -identity $site | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to repair another SharePoint Site?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeSharePointSiteToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SPOSiteText = "Select the SharePoint Site you want to remove"
			Show-SelectSPOSites_psf
			$site = $SelectSPOSites_comboboxSelectSPOSites
			If (!$site)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No SharePoint Site was selected, please select a valid SharePoint Site to delete", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxDetails.Text = "Remove-SPOSite -identity $site"
				$TextboxResults.Text = "Removing $site..."
				$TextboxResults.Text = Remove-SPOSite -identity $site | Out-String -Width 2147483647
				$TextboxResults.Text = "Getting all deleted SharePoint sites..."
				$TextboxResults.Text = Get-SPODeletedSite | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another SharePoint Site?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getDeletedSharePointSitesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$textboxDetails.Text = "Get-SPODeletedSite"
		$TextboxResults.Text = "Getting all deleted SharePoint sites..."
		$TextboxResults.Text = Get-SPODeletedSite | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$restoreDeletedSharePointSiteToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$DeletedSitesText = "Please select the SharePoint Site you want to restore"
			Show-SelectDeletedSPOSites_psf
			$RestoreSite = $SelectDeletedSPOSites_comboboxDeletedSites
			If (!$RestoreSite)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No SharePoint Site was selected, please select a valid SharePoint Site to recover", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$textboxDetails.Text = "Restore-SPODeletedSite -identity $RestoreSite"
				$TextboxResults.Text = "Restoring $RestoreSite..."
				$TextboxResults.Text = Restore-SPODeletedSite -identity $RestoreSite | Out-String -Width 2147483647
				$TextboxResults.Text = "Getting all SharePoint sites..."
				$TextboxResults.Text = Get-SPOSite | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to restore another SharePoint Site?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$newSharePointSiteToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewSPOSite = Read-Host "Please enter the full URL for the new SharePoint Site"
			If (!$NewSPOSite)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No URL was entered, please enter a valid SharePoint URL", "Error")
			}
			Else
			{
				$SelectUsersFormText = "Select the user you want to be the owner of the new site"
				Show-SelectUsersForm_psf
				$SPOSiteOwner = $SelectUsersForm_comboboxUsers
				If (!$SPOSiteOwner)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$textboxDetails.Text = "New-SPOSite -url $NewSPOSite -Owner $SPOSiteOwner"
					$TextboxResults.Text = "Creating a new SharePoint site $NewSPOSite..."
					$TextboxResults.Text = New-SPOSite -url $NewSPOSite -Owner $SPOSiteOwner -StorageQuota 1048576 | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another SharePoint Site?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}



###FILE###

#About

$aboutToolStripMenuItem_Click = {
	$TextboxResults.Text = "                                
O365 Admin Center 


Version: $Version
Version Release Date: $UpdateDate
Website: https://www.o365admin.center
FAQ: https://www.o365admin.center/FAQ"
	
}

#Pre-Reqs

$prerequisitesToolStripMenuItem_Click = {
	Try
	{
		Start-Process -FilePath https://o365admin.center/prerequisites/
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

#Changelog

$changelogToolStripMenuItem_Click = {
	Try
	{
		Start-Process -FilePath http://o365admin.center/changelog/
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

#Context Menu

$clearScreenToolStripMenuItem1_Click = {
	$TextboxResults.Text = ""
}

$selectAllToolStripMenuItem_Click = {
	$TextboxResults.SelectAll()
}

$copyToolStripMenuItem_Click = {
	[System.Windows.Forms.Clipboard]::SetText($TextboxResults.SelectedText.Trim())
}

$cutToolStripMenuItem_Click = {
	$TextboxResults.SelectedText = ""
}

$pasteToolStripMenuItem_Click = {
	$PastedItem = [System.Windows.Forms.Clipboard]::GetText()
	$insertText = $PastedItem;
	$selectionIndex = $TextboxResults.SelectionStart;
	$TextboxResults.Text = $TextboxResults.Text.Insert($selectionIndex, $insertText);
	$TextboxResults.SelectionStart = $selectionIndex + $insertText.Length;
	
}

$cutToolStripMenuItem1_Click = {
	$TextboxResults.SelectedText = ""	
}

$copyToolStripMenuItem1_Click = {
	[System.Windows.Forms.Clipboard]::SetText($TextboxResults.SelectedText.Trim())	
}

$pasteToolStripMenuItem1_Click = {
	$PastedItem = [System.Windows.Forms.Clipboard]::GetText()
	$insertText = $PastedItem;
	$selectionIndex = $TextboxResults.SelectionStart;
	$TextboxResults.Text = $TextboxResults.Text.Insert($selectionIndex, $insertText);
	$TextboxResults.SelectionStart = $selectionIndex + $insertText.Length;
}

$selectAllToolStripMenuItem1_Click = {
	$TextboxResults.SelectAll()	
}

$clearScreenToolStripMenuItem2_Click = {
	$TextboxResults.Text = ""
}

$printToolStripMenuItem1_Click = {
	$Printdialog = New-Object System.Windows.Forms.PrintDialog
	$Printdialog.ShowHelp = $False
	$Printdialog.AllowSelection = $true
	$Printdialog.AllowPrintToFile = $true
	$Printdialog.AllowSomePages = $false
	$Printdialog.ShowNetwork = $true
	$result = $Printdialog.ShowDialog(); $result
	If ($result -eq 'OK')
	{
		$TextboxResults.Text | Out-Printer $Printdialog.PrinterSettings.PrinterName
	}
}

$saveAsToolStripMenuItem_Click = {
	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to File"
	$savedialog.filter = ".doc|*.doc|.txt|*.txt|.xls|*.xls"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		$TextboxResults.Text | Out-File -Encoding Default $savedialog.filename
	}
	
}



###JUNK ITEMS###

$TextboxResults_TextChanged = {
	
}

$menustripExchange_ItemClicked = [System.Windows.Forms.ToolStripItemClickedEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.ToolStripItemClickedEventArgs]
}


$tabpageComplianceCenter_Click={
	#ignore
	
}

$checkboxSharepoint_CheckedChanged={
	#ignore
	
}

$checkboxExchangeOnline_CheckedChanged={
	#ignore
	
}

$checkboxComplianceCenter_CheckedChanged={
	#ignore
	
}

$checkboxSkypeForBusiness_CheckedChanged={
	#ignore
	
}

$organizationCustomizationToolStripMenuItem_Click={
	#ignore
	
}

$getMailMalwareReportToolStripMenuItem_Click={
	#ignore
	
}

$securityGroupsToolStripMenuItem_Click={
	#ignore
	
}

$aliasAddressesToolStripMenuItem_Click={
	#ignore
	
}

$checkForUpdatesToolStripMenuItem1_Click = {
	Try
	{
		#Get reg-key to see if update should prompt
		$UpdateCheck = Get-ItemProperty 'HKCU:\Software\O365 Admin Center' -Name UpdateCheck | Select-Object -ExpandProperty UpdateCheck
		
		If ($UpdateCheck -eq 0)
		{
			#Check to see if there is a new version available 
			$PublicVersion = Invoke-WebRequest -Uri https://www.o365admin.center/update.txt | Select-Object -ExpandProperty content
			#If local version is less than the public version then prompt for update
			If ($Version -lt $publicVersion)
			{
				Show-UpdateCheck_psf
			}
			#If Publicversion equals nothing then ignore, this is if the website is down or the user does not have internet
			elseif ($PublicVersion = $Null)
			{
			}
			Else
			{
				#Create the pop-up message
				Add-Type -AssemblyName System.Windows.Forms
				[System.Windows.Forms.MessageBox]::Show('You are up to date!', 'O365 Admin Center Updates', 'OK', 'Info')
			}
		}
		elseif ($UpdateCheck -eq 1)
		{
			$InformationText = "Updates are set to never be checked. Please enable updates"
			Show-Info_OK_psf
		}
		
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$neverCheckForUpdatesToolStripMenuItem_Click = {
	Try
	{
		#Sets the update check key
		Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name UpdateCheck -Value 1 -Force | Out-Null
		$InformationText = "Updates have been disabled"
		Show-Info_OK_psf
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableUpdatesToolStripMenuItem_Click = {
	Try
	{
		#Sets the update check key
		Get-Item 'HKCU:\Software\O365 Admin Center' -Force | New-ItemProperty -Name UpdateCheck -Value 0 -Force | Out-Null
		
		$InformationText = "Updates have been enabled"
		Show-Info_OK_psf
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getUsersWithInPlaceArchiveToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users with an archive..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited -Filter { ArchiveStatus -NE 'None' -AND RecipientTypeDetails -eq 'UserMailbox' }"
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.ArchiveStatus -NE 'None'} | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getUsersWithoutInPlaceArchiveToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all users without an archive..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited -Filter { ArchiveStatus -EQ 'None' -AND RecipientTypeDetails -eq 'UserMailbox' }"
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.ArchiveStatus -EQ 'None'} | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$enableInPlaceArchiveForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the User you want to enable In-Place Archive for"
			Show-SelectCachedDisplayNames_psf
			$EnableInPlaceArchiveUser = $SelectCachedDisplayNames_comboboxNames
			If (!$EnableInPlaceArchiveUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling In-Place Archive for $EnableInPlaceArchiveUser..."
				$textboxDetails.Text = "Enable-Mailbox -Identity $EnableInPlaceArchiveUser -Archive"
				Enable-Mailbox -Identity $EnableInPlaceArchiveUser -Archive | Out-String -Width 2147483647
				$TextboxResults.Text = "Getting all users with an Archive enabled..."
				$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.ArchiveStatus -NE 'None' } | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable In-Place Archiving for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$submitAIssueToolStripMenuItem_Click = {
	Try
	{
		Start-Process -FilePath mailto:issues@o365admin.center
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$submitAFeatureRequestToolStripMenuItem_Click = {
	Try
	{
		Start-Process -FilePath mailto:request@o365admin.center
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableInPlaceArchiveForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the User you want to disable In-Place Archive for"
			Show-SelectCachedDisplayNames_psf
			#$DisableInPlaceArchiveUser = $SelectCachedUserPrincipalName_comboboxUPN
			$DisableInPlaceArchiveUser = $SelectCachedDisplayNames_comboboxNames
			If (!$DisableInPlaceArchiveUser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling In-Place Archive for $DisableInPlaceArchiveUser..."
				$textboxDetails.Text = "Disable-Mailbox -Identity $DisableInPlaceArchiveUser -Archive"
				Disable-Mailbox -Identity $DisableInPlaceArchiveUser -Archive | Out-String -Width 2147483647
				$TextboxResults.Text = "Getting all users without an Archive..."
				$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.ArchiveStatus -EQ 'None' } | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable In-Place Archiving for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllPublicFoldersToolStripMenuItem_Click = {
	$CachedPF = ("$TempDir" + "\O365AdminCenter" + "\pf.txt")
	$TempDir = $env:temp
	Try
	{
		If ((Test-Path $CachedPF) -eq $false)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Caching Public Folders..."
			#$parentpath = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object -ExpandProperty ParentPath
			#$names = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object -ExpandProperty Name
			#$firstName = @($parentpath)
			#$lastName = @($names)
			#0..($firstName.Count - 1) | ForEach-Object { $fullName += @("$($firstName[$_])\$($lastName[$_])") }
			#$fullname | Out-File $CachedPF 
			(Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse).Identity | Out-File $CachedPF
			
			$TextboxResults.Text = "Getting all Public Folders..."
			$textboxDetails.Text = "Get-PublicFolder -Identity '\' -Recurse"
			$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, ParentPath |  Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
			#$parentpath = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object -ExpandProperty ParentPath
			#$names = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object -ExpandProperty Name
			#$firstName = @($parentpath)
			#$lastName = @($names)
			#0..($firstName.Count - 1) | ForEach-Object { $fullName += @("$($firstName[$_])\$($lastName[$_])") }
			#$TextboxResults.Text = $fullname | Out-String 
			
			$FormO365AdministrationCenter.Cursor = 'Default'
			
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all Public Folders..."
			$textboxDetails.Text = "Get-PublicFolder -Identity '\' -Recurse"
			$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, ParentPath | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$contextmenustrip1_Opening=[System.ComponentModel.CancelEventHandler]{
	
}

$statisticsToolStripMenuItem_Click = {
	Do
	{
		$TempDir = $env:temp
		$CachedPF = ("$TempDir" + "\O365AdminCenter" + "\pf.txt")
		Try
		{
			If ((Test-Path $CachedPF) -eq $false)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Caching Public Folders..."
				#$parentpath = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object -ExpandProperty ParentPath
				#$names = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object -ExpandProperty Name
				#$firstName = @($parentpath)
				#$lastName = @($names)
				#0..($firstName.Count - 1) | ForEach-Object { $fullName += @("$($firstName[$_])\$($lastName[$_])") }
				#$fullname | Out-File $CachedPF
				(Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse).Identity | Out-File $CachedPF
				
				$PFText = "Please select the Public Folder you want to view statistics for"
				Show-SelectCachedPublicFolders_psf
				$PFStats = $SelectCachedPublicFolders_comboboxPF
				If (!$PFStats)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Public Folder was selected, please select a valid Public Folder", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting Public Folder statistics for $PFStats.."
					$textboxDetails.Text = "Get-PublicFolderItemStatistics -Identity $PFStats"
					$TextboxResults.Text = Get-PublicFolderItemStatistics -Identity $PFStats | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				
				$PFText = "Please select the Public Folder you want to view statistics for"
				Show-SelectCachedPublicFolders_psf
				$PFStats = $SelectCachedPublicFolders_comboboxPF
				If (!$PFStats)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Public Folder was selected, please select a valid Public Folder", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting Public Folder statistics for $PFStats.."
					$textboxDetails.Text = "Get-PublicFolderItemStatistics -Identity $PFStats"
					$TextboxResults.Text = Get-PublicFolderItemStatistics -Identity $PFStats | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get information on another Public Folder?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getPublicFoldersThatAreMailEnabledToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mail Enabled Public Folders..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Where-Object { `$_.MailEnabled -eq `$True } "
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Where-Object { $_.MailEnabled -eq $True } | Select-Object Name, ParentPath, MailEnabled | Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getPublicFoldersThatAreNotMailEnabledToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mail Enabled Public Folders..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Where-Object { `$_.MailEnabled -eq `$False } "
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Where-Object { $_.MailEnabled -eq $False } | Select-Object Name, ParentPath, MailEnabled | Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$ascendingToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Public Folders Sizes..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Select-Object Name, FolderSize | Sort-Object FolderSize"
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, FolderSize | Sort-Object FolderSize | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$descendingToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Public Folders Sizes..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Select-Object Name, FolderSize | Sort-Object FolderSize -Descending"
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, FolderSize | Sort-Object FolderSize -Descending | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$alphabeticallyToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Public Folders Sizes..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Select-Object Name, FolderSize | Sort-Object Name"
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, FolderSize | Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllPublicFoldersWithSubfoldersToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Public Folders with Subfolders..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\'' -Recurse | Where-Object { `$_.HasSubFolders -eq `$True }"
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Where-Object { $_.HasSubFolders -eq $True } | Select-Object Name, ParentPath, HasSubFolders | Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllPublicFoldersWithoutSubfoldersToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Public Folders with Subfolders..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\'' -Recurse | Where-Object { `$_.HasSubFolders -eq `$False }"
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Where-Object { $_.HasSubFolders -eq $False } | Select-Object Name, ParentPath, HasSubFolders | Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllPublicFolderQuotaToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting All Public Folder Quotas..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Select-Object Name, ProhibitPostQuota, IssueWarningQuota, MaxItemSize "
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, ProhibitPostQuota, IssueWarningQuota, MaxItemSize | Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getIssueWarningQuotaToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting All Public Folder Quotas..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Select-Object Name, IssueWarningQuota "
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, IssueWarningQuota | Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getMaxItemSizeQuotaToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting All Public Folder Quotas..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Select-Object Name, MaxItemSize "
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, MaxItemSize | Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getProhibitPostQuotaToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting All Public Folder Quotas..."
		$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Select-Object Name, ProhibitPostQuota"
		$TextboxResults.Text = Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse | Select-Object Name, ProhibitPostQuota| Sort-Object Name | Format-Table -Autosize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDetailedPublicFolderReportToCSVToolStripMenuItem_Click={
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$OutputFile = $savedialog.filename
			$textboxDetails.Text = "Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse"
			$TextboxResults.Text = "Getting Detailed Public Folder Report..."
			Get-PublicFolder -ResultSize Unlimited -Identity '\' -Recurse | Export-Csv $OutputFile -NoTypeInformation
			$TextboxResults.Text = ""
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$checkForUpdatesToolStripMenuItem_Click={
	#Leave blank this is the parent button
	
}

$getMailTrafficTopReportToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mail Traffic Top Report..."
		$textboxDetails.Text = "Get-MailTrafficTopReport | Sort-Object 'Direction' | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficTopReport | Sort-Object "Direction" | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getStaleMailboxReportToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Stale Mailbox Report..."
		$textboxDetails.Text = "Get-StaleMailboxReport | Format-Table -AutoSize"
		$TextboxResults.Text = Get-StaleMailboxReport | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getStaleMailboxDetailReportToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Stale Mailbox Detail Report..."
		$textboxDetails.Text = "Get-StaleMailboxDetailReport | Format-Table -AutoSize"
		$TextboxResults.Text = Get-StaleMailboxDetailReport | Sort-Object UserName | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$exportMailDetailedSpamReportToCSVToolStripMenuItem_Click={
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$OutputFile = $savedialog.filename
			$textboxDetails.Text = "Get-MailDetailSpamReport"
			$TextboxResults.Text = "Getting Detailed Mail Spam Report..."
			Get-MailDetailSpamReport | Export-Csv $OutputFile -NoTypeInformation
			$TextboxResults.Text = ""
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDetailedMailboxUsageReportToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Detailed Mailbox Usage Report..."
		$textboxDetails.Text = "Get-MailboxUsageDetailReport | Select-Object Username, MailboxSize, CurrentMailboxSize, PercentUsed, MailboxPlan, IsInactive |  Sort-Object PercentUsed | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailboxUsageDetailReport | Select-Object Username, MailboxSize, CurrentMailboxSize, PercentUsed, MailboxPlan, IsInactive | Sort-Object PercentUsed | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$exportDetailedMailboxUsageReportToCSVToolStripMenuItem_Click={
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		if ($result -eq "OK")
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$OutputFile = $savedialog.filename
			$TextboxResults.Text = "Getting Detailed Mailbox Usage Report..."
			$textboxDetails.Text = "Get-MailboxUsageDetailReport"
			Get-MailboxUsageDetailReport | Export-Csv $OutputFile -NoTypeInformation
			$TextboxResults.Text = ""
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getMailboxUsageReportToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mailbox Usage Report..."
		$textboxDetails.Text = "Get-MailboxUsageReport | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailboxUsageReport | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getMailTrafficPolicyReportToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mail Traffic Policy Report..."
		$textboxDetails.Text = "Get-MailTrafficPolicyReport | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficPolicyReport | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$testToolStripMenuItem1_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$textboxDetails.Text = ""
		$Datacenter = @{ }
		$Datacenter["CP"] = @("LAM", "Brazil")
		$Datacenter["GR"] = @("LAM", "Brazil")
		$Datacenter["HK"] = @("APC", "Hong Kong")
		$Datacenter["SI"] = @("APC", "Singapore")
		$Datacenter["SG"] = @("APC", "Singapore")
		$Datacenter["KA"] = @("JPN", "Japan")
		$Datacenter["OS"] = @("JPN", "Japan")
		$Datacenter["TY"] = @("JPN", "Japan")
		$Datacenter["AM"] = @("EUR", "Amsterdam, Netherlands")
		$Datacenter["DB"] = @("EUR", "Dublin, Ireland")
		$Datacenter["HE"] = @("EUR", "Finland")
		$Datacenter["VI"] = @("EUR", "Austria")
		$Datacenter["BL"] = @("NAM", "Virginia, USA")
		$Datacenter["SN"] = @("NAM", "San Antonio, Texas, USA")
		$Datacenter["BN"] = @("NAM", "Virginia, USA")
		$Datacenter["DM"] = @("NAM", "Des Moines, Iowa, USA")
		$Datacenter["BY"] = @("NAM", "San Francisco, California, USA")
		$Datacenter["CY"] = @("NAM", "Cheyenne, Wyoming, USA")
		$Datacenter["CO"] = @("NAM", "Quincy, Washington, USA")
		$Datacenter["MW"] = @("NAM", "Quincy, Washington, USA")
		$Datacenter["CH"] = @("NAM", "Chicago, Illinois, USA")
		$Datacenter["ME"] = @("APC", "Melbourne, Victoria, Australia")
		$Datacenter["SY"] = @("APC", "Sydney, New South Wales, Australia")
		$Datacenter["KL"] = @("APC", "Kuala Lumpur, Malaysia")
		$Datacenter["PS"] = @("APC", "Busan, South Korea")
		$Datacenter["YQ"] = @("CAN", "Quebec City, Canada")
		$Datacenter["YT"] = @("CAN", "Toronto, Canada")
		$Datacenter["MM"] = @("GBR", "Durham, England")
		$Datacenter["LO"] = @("GBR", "London, England")
		
		
		Write-Host
		$TextboxResults.Text = "Getting Mailbox Information..."
		
		$Mailboxes = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -ne "DiscoveryMailbox" }
		
		$ServerCount = ($Mailboxes | Group-Object { $_.ServerName }).count
		
		$DatabaseCount = ($Mailboxes | Group-Object { $_.Database }).count
		
		$Mailboxes = $Mailboxes | Group-Object { $_.ServerName.SubString(0, 2) } | Select-Object @{ Name = "Datacenter"; Expression = { $_.Name } }, Count
		
		$Locations = @()
		
		# Not pretty error handling but allows counts to add properly when a datacenter location could not be identified from the table
		$E = $ErrorActionPreference
		$ErrorActionPreference = "SilentlyContinue"
		
		ForEach ($Mailbox in $Mailboxes)
		{
			$Object = New-Object -TypeName PSObject
			$Object | Add-Member -Name 'Datacenter' -MemberType NoteProperty -Value $Mailbox.Datacenter
			$Object | Add-Member -Name 'Region' -MemberType NoteProperty -Value $Datacenter[$Mailbox.Datacenter][0]
			$Object | Add-Member -Name 'Location' -MemberType NoteProperty -Value $Datacenter[$Mailbox.Datacenter][1]
			$Object | Add-Member -Name 'Count' -MemberType NoteProperty -Value $Mailbox.Count
			$Locations += $Object
		}
		
		$ErrorActionPreference = $E
		
		$TotalMailboxes = ($Locations | Measure-Object Count -Sum).sum
		
		$LocationsConsolidated = $Locations | Group-Object Location | ForEach-Object {
			New-Object PSObject -Property @{
				Location = $_.Name
				Mailboxes = ("{0,9:N0}" -f ($_.Group | Measure-Object Count -Sum).Sum)
			}
		} | Sort-Object Count -Descending
		
		$textboxresults.text = $LocationsConsolidated | Select-Object Location, Mailboxes | Sort-Object Mailboxes | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getTotalMailboxCountToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mailbox Count..."
		$textboxDetails.Text = "(Get-Mailbox -ResultSize Unlimited).Count"
		$TextboxResults.Text = (Get-Mailbox -ResultSize Unlimited).Count | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$viewAllUsersFocusedInboxStatusToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$mbxs = (Get-Mailbox).userprincipalname
		$TextboxResults.Text = "Getting Focused Inbox status for all users...(this may take some time)"
		$textboxDetails.Text = "`$mbxs = (Get-Mailbox).userprincipalname
foreach (`$mbx in `$mbxs) { Get-FocusedInbox -Identity `$mbx }"
		$results = foreach ($mbx in $mbxs) { Get-FocusedInbox -Identity $mbx }
		$TextboxResults.Text = $results | Sort-Object MailboxIdentity | Format-Table MailboxIdentity, FocusedInboxOn -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getTenantFocusedInboxStatusToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Focus Inbox status..."
		$textboxDetails.Text = "Get-OrganizationConfig | Format-Table FocusedInboxOn -AutoSize"
		$TextboxResults.Text = Get-OrganizationConfig | Format-Table FocusedInboxOn -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableFocusedInboxForCompanyToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling Focus Inbox..."
		$textboxDetails.Text = "Set-OrganizationConfig -FocusedInboxOn `$True"
		Set-OrganizationConfig -FocusedInboxOn $True
		$TextboxResults.Text = "Getting Focus Inbox status..."
		$TextboxResults.Text = Get-OrganizationConfig | Format-Table FocusedInboxOn -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableFocusedInboxForCompanyToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling Focus Inbox..."
		$textboxDetails.Text = "Set-OrganizationConfig -FocusedInboxOn `$False"
		Set-OrganizationConfig -FocusedInboxOn $False
		$TextboxResults.Text = "Getting Focus Inbox status..."
		$TextboxResults.Text = Get-OrganizationConfig | Format-Table FocusedInboxOn -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableFocusedInboxForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the User you want to disable Focused Inbox for"
			Show-SelectCachedUserPrincipalName_psf
			$FocusedInboxOff = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$FocusedInboxOff)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling Focused Inbox for $FocusedInboxOff "
				$textboxDetails.Text = "Set-FocusedInbox -Identity $FocusedInboxOff -FocusedInboxOn `$False"
				$TextboxResults.Text = Set-FocusedInbox -Identity $FocusedInboxOff -FocusedInboxOn $False | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable Focused Inbox for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableFocusedInboxForAUserToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the User you want to enable Focused Inbox for"
			Show-SelectCachedUserPrincipalName_psf
			$FocusedInboxOff = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$FocusedInboxOff)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling Focused Inbox for $FocusedInboxOff "
				$TextboxResults.Text = Set-FocusedInbox -Identity $FocusedInboxOff -FocusedInboxOn $True | Out-String -Width 2147483647
				$textboxDetails.Text = "Set-FocusedInbox -Identity $FocusedInboxOff -FocusedInboxOn `$True"
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable Focused Inbox for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableFocusedInboxForAllUsersToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling Focused Inbox for all users..."
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientTypeDetails -ne "SharedMailbox" } | Set-FocusedInbox -FocusedInboxOn $False | Out-String -Width 2147483647
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientTypeDetails -ne 'SharedMailbox' } | Set-FocusedInbox -FocusedInboxOn `$False"
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$enableFocusedInboxForAllUsersToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling Focused Inbox for all users..."
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientTypeDetails -ne "SharedMailbox" } | Set-FocusedInbox -FocusedInboxOn $True | Out-String -Width 2147483647
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientTypeDetails -ne 'SharedMailbox' } | Set-FocusedInbox -FocusedInboxOn `$True"
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAUsersFocusedInboxStatusToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$SelectUsersFormText = "Select the User you want get Focused Inbox status for"
			Show-SelectCachedUserPrincipalName_psf
			$FocusedInbox = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$FocusedInbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid User", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Focused Inbox status for $FocusedInbox"
				$TextboxResults.Text = Get-FocusedInbox -Identity $FocusedInbox | Out-String -Width 2147483647
				$textboxDetails.Text = "Get-FocusedInbox -Identity $FocusedInbox"
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get another Users Focused Inbox status?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$getUserCountToolStripMenuItem_Click={
	Try
	{
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting User Count..."
			$textboxDetails.Text = "(Get-MsolUser -All).count"
			$TextboxResults.Text = (Get-MsolUser -All).count | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting User Count..."
			$textboxDetails.Text = "(Get-MsolUser -All).count"
			$TextboxResults.Text = (Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All).count | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting User Count..."
			$textboxDetails.Text = "(Get-MsolUser -All).count"
			$TextboxResults.Text = (Get-MsolUser -All).count | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getMailboxCountToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mailbox Count..."
		$textboxDetails.Text = "(Get-Mailbox -resultsize unlimited).count"
		$TextboxResults.Text = (Get-Mailbox -resultsize unlimited).count | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getSharedMailboxCountToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Shared Mailbox Count..."
		$textboxDetails.Text = "(Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited).count"
		$TextboxResults.Text = (Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited).count | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDistributionGroupCountToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Distribution Group Count..."
		$textboxDetails.Text = "(Get-DistributionGroup -ResultSize Unlimited).count"
		$TextboxResults.Text = (Get-DistributionGroup -ResultSize Unlimited).count | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getRegularSecurityGroupCountToolStripMenuItem_Click={
	Try
	{
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Regular Security Group Count..."
			$textboxDetails.Text = "(Get-MsolGroup -All -GroupType Security).count"
			$TextboxResults.Text = (Get-MsolGroup -All -GroupType Security).count | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Regular Security Group Count..."
			$textboxDetails.Text = "(Get-MsolGroup -All -GroupType Security).count"
			$TextboxResults.Text = (Get-MsolGroup -TenantId $PartnerComboBox.SelectedItem.TenantID -All -GroupType Security).count | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Regular Security Group Count..."
			$textboxDetails.Text = "(Get-MsolGroup -All -GroupType Security).count"
			$TextboxResults.Text = (Get-MsolGroup -All -GroupType Security).count | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getMailEnabledSecurityGroupCountToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mail Enabled Security Group Count..."
		$textboxDetails.Text = "(Get-DistributionGroup -ResultSize unlimited | Where-Object { `$_.GroupType -like 'Universal, SecurityEnabled'}).count"
		$TextboxResults.Text = (Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -like "Universal, SecurityEnabled" }).count | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllDynamicDistributionGroupsToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting All Dynamic Distribution Groups..."
		$textboxDetails.Text = "Get-DynamicDistributionGroup -ResultSize Unlimited | Format-Table -AutoSize"
		$TextboxResults.Text = Get-DynamicDistributionGroup -ResultSize Unlimited | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDynamicDistributionGroupCountToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Dynamic Distribution Groups Count..."
		$textboxDetails.Text = "(Get-DynamicDistributionGroup -ResultSize Unlimited).count"
		$TextboxResults.Text = (Get-DynamicDistributionGroup -ResultSize Unlimited).Count | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$createADynamicDistributionGroupForAllUsersToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewDynDistro = Read-Host "Please enter a name for the new Dynamic Distribution Group"
			If (!$NewDynDistro)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please enter a valid name for the new Dynamic Distribution Group", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Creating a new Dynamic Distribution Group for all Users..."
				$textboxDetails.Text = "New-DynamicDistributionGroup -Name $NewDynDistro –RecipientFilter { (RecipientType -eq 'UserMailbox') }"
				$TextboxResults.Text = New-DynamicDistributionGroup -Name $NewDynDistro –RecipientFilter { (RecipientType -eq 'UserMailbox') } | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Dynamic Distribution Group for all Users?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$createADynamicDistributionGroupForAllManagersToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$NewDynDistro = Read-Host "Please enter a name for the new Dynamic Distribution Group"
			If (!$NewDynDistro)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please enter a valid name for the new Dynamic Distribution Group", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Creating a new Dynamic Distribution Group for all Managers..."
				$textboxDetails.Text = "New-DynamicDistributionGroup -Name $NewDynDistro –RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title -like 'Director*' -or Title -like 'Manager*' )}"
				$TextboxResults.Text = New-DynamicDistributionGroup -Name $NewDynDistro –RecipientFilter { (RecipientType -eq 'UserMailbox') -and (Title -like 'Director*' -or Title -like 'Manager*') } | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Dynamic Distribution Group for all Managers?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getDetailedInfoForADynamicDistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$DistroGroupsText = "Select the Dynamic Distribution Group you want detailed information on"
			Show-SelectDynamicDistributionGroups_psf
			$DetailedDyn = $SelectDynamicDistributionGroups_comboboxSelectDistroGroups
			If (!$DetailedDyn)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Dynamic Distribution Group was selected, please select a valid Dynamic Distribution Group", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed information on $DetailedDyn..."
				$textboxDetails.Text = "Get-DynamicDistributionGroup $DetailedDyn | Format-List "
				$TextboxResults.Text = Get-DynamicDistributionGroup $DetailedDyn | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get information for another Dynamic Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeADynamicDistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$DistroGroupsText = "Select the Dynamic Distribution Group you want to delete"
			Show-SelectDynamicDistributionGroups_psf
			$DetailedDyn = $SelectDynamicDistributionGroups_comboboxSelectDistroGroups
			If (!$DetailedDyn)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Dynamic Distribution Group was selected, please select a valid Dynamic Distribution Group", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing $DetailedDyn..."
				$textboxDetails.Text = "Remove-DynamicDistributionGroup $DetailedDyn "
				$TextboxResults.Text = Remove-DynamicDistributionGroup $DetailedDyn | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Dynamic Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllOnlineUsersCountToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all online users count..."
		$textboxDetails.Text = "(Get-CsOnlineUser -ResultSize 2147483647).count"
		$TextboxResults.Text = (Get-CsOnlineUser -ResultSize 2147483647).count
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$preferencesToolStripMenuItem_Click = {
}

$resetPersonalPreferencesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Remove-Item 'HKCU:\Software\O365 Admin Center' -Force
		$InformationText = "All Personal preferences have been reset"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableAllPrerequisitesChecksToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 1 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableArchPrompt -Value 1 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 1 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 1 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSkypeOnlineConnectorPrompt -Value 1 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name ExecutionPolicy -Value 1 -Force | Out-Null
		$InformationText = "All Prerequisite Checks have been Disabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$enableAllPrerequisiteChecksToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 0 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableArchPrompt -Value 0 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 0 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 0 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSkypeOnlineConnectorPrompt -Value 0 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name ExecutionPolicy -Value 0 -Force | Out-Null
		$InformationText = "All Prerequisite Checks have been Enabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$requestSupportToolStripMenuItem_Click={
	Try
	{
		Start-Process -FilePath mailto:support@o365admin.center
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$skypeForBusinessPrerequisiteToolStripMenuItem_Click={
	
}

$disableSkypeForBusinessPrerequisiteCheckToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSkypeOnlineConnectorPrompt -Value 1 -Force | Out-Null
		$InformationText = "Skype For Business prerequisite check has been disabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableSkypeForBusinessPrerequisiteCheckToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSkypeOnlineConnectorPrompt -Value 0 -Force | Out-Null
		$InformationText = "Skype For Business prerequisite check has been enabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableExchangeOnlinePrerequisiteCheckToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 1 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 1 -Force | Out-Null
		$InformationText = "Exchange Online prerequisite check has been disabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableExchangeOnlinePrerequisiteCheckToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableAzurePrompt -Value 0 -Force | Out-Null
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableMSOnlinePrompt -Value 0 -Force | Out-Null
		$InformationText = "Exchange Online prerequisite check has been enabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableSharePointPrerequisiteCheckToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 1 -Force | Out-Null
		$InformationText = "SharePoint prerequisite check has been Disabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableSharePointPrerequisiteCheckToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableSharePointOnlinePrompt -Value 0 -Force | Out-Null
		$InformationText = "SharePoint prerequisite check has been Enabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableArchitecturePrerequisiteToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableArchPrompt -Value 1 -Force | Out-Null
		$InformationText = "Architecture prerequisite check has been disabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableArchitecturePrerequisiteToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name DisableArchPrompt -Value 0 -Force | Out-Null
		$InformationText = "Architecture prerequisite check has been enabled"
		Show-Info_OK_psf
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllTransportRulesToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all Transport Rules..."
		$textboxDetails.Text = "Get-TransportRule"
		$TextboxResults.Text = Get-TransportRule | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllDisabledTransportRulesToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all disabled Transport Rules..."
		$textboxDetails.Text = "Get-TransportRule | Where-Object {`$_.State -ne 'Enabled'}"
		$TextboxResults.Text = Get-TransportRule | Where-Object {$_.State -ne 'Enabled'} | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllEnabledTransportRulesToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all enabled Transport Rules..."
		$textboxDetails.Text = "Get-TransportRule | Where-Object {`$_.State -eq 'Enabled'}"
		$TextboxResults.Text = Get-TransportRule | Where-Object { $_.State -eq 'Enabled' } | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getSpoofedMailReportToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Spoof Mail Report..."
		$textboxDetails.Text = "Get-SpoofMailReport"
		$TextboxResults.Text = Get-SpoofMailReport | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getTransportRulePredicateToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Transport Rule Predicate..."
		$textboxDetails.Text = "Get-TransportRulePredicate"
		$TextboxResults.Text = Get-TransportRulePredicate | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDetailedInfoForATransportRuleToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TransportRulesText = "Select the Transport Rule you want to view detailed information on"
			Show-SelectTransportRules_psf
			$DetailedTransportRule = $SelectTransportRules_comboboxTPs
			If (!$DetailedTransportRule)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Transport Rule was selected, please select a valid Transport Rule", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Detailed information on the Transport Rule, '$DetailedTransportRule'..."
				$textboxDetails.Text = "Get-TransportRule -Identity $DetailedTransportRule | Format-List "
				$TextboxResults.Text = Get-TransportRule -Identity $DetailedTransportRule | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get information on another Transport Rule?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getTransportRuleActionToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Transport Rule Action..."
		$textboxDetails.Text = "Get-TransportRuleAction"
		$TextboxResults.Text = Get-TransportRuleAction | Format-Table -AutoSize | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableATransportRuleToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TransportRulesText = "Select the Transport Rule you want to enable"
			Show-SelectDisabledTransportRules_psf
			$TransportRule = $SelectDisabledTransportRules_comboboxTPs
			If (! $TransportRule)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Transport Rule was selected, please select a valid Transport Rule", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling the Transport Rule, '$TransportRule''..."
				$textboxDetails.Text = "Enable-TransportRule -Identity $TransportRule"
				$TextboxResults.Text = Enable-TransportRule -Identity $TransportRule | Out-String -Width 2147483647
				$TextboxResults.Text = Get-TransportRule | Where-Object { $_.State -eq 'Enabled' } | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to menable another Transport Rule?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableATransportRuleToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TransportRulesText = "Select the Transport Rule you want to disable"
			Show-SelectEnabledTransportRules_psf
			$TransportRule = $SelectEnabledTransportRules_comboboxTPs
			If (!$TransportRule)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Transport Rule was selected, please select a valid Transport Rule", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling the Transport Rule, '$TransportRule''..."
				$textboxDetails.Text = "Disable-TransportRule -Identity $TransportRule"
				$TextboxResults.Text = Disable-TransportRule -Identity $TransportRule | Out-String -Width 2147483647
				$TextboxResults.Text = Get-TransportRule | Where-Object { $_.State -ne 'Enabled' } | Format-Table -AutoSize | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable another Transport Rule?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeATransportRuleToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TransportRulesText = "Select the Transport Rule you want to remove"
			Show-SelectTransportRules_psf
			$DetailedTransportRule = $SelectTransportRules_comboboxTPs
			If (!$DetailedTransportRule)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Transport Rule was selected, please select a valid Transport Rule", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing the Transport Rule, '$DetailedTransportRule''..."
				$textboxDetails.Text = "Remove-TransportRule -Identity $DetailedTransportRule "
				$TextboxResults.Text = Remove-TransportRule -Identity $DetailedTransportRule | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove another Transport Rule?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$newTransportRuleForSenderDomainToBypassClutterToolStripMenuItem_Click = {
	Try
	{
		$NewTransportRule = Read-Host "Please enter a name for the Transport Rule"
		If (!$NewTransportRule)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No name was entered, please select a valid name for the new Transport Rule", "Error")
		}
		Else
		{
			$SenderDomain = Read-Host "Please enter the sender domain that will bypass Clutter"
			If (!$SenderDomain)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Domain was entered, please enter a valid domain name what will bypass Clutter", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Creating a new Transport Rule where $SenderDomain can bypass Clutter..."
				$textboxDetails.Text = "New-TransportRule -Name '$NewTransportRule' -SenderDomainIs $SenderDomain -SetHeaderName 'X-MS-Exchange-Organization-BypassClutter' -SetHeaderValue 'true' "
				$TextboxResults.Text = New-TransportRule -Name $NewTransportRule -SenderDomainIs $SenderDomain -SetHeaderName "X-MS-Exchange-Organization-BypassClutter" -SetHeaderValue "true" | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$blockEMailMessagesBetweenTwoDistributionGroupsToolStripMenuItem_Click = {
	Try
	{
		$TempDir = $env:temp
		$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\distros.txt")
		If ((Test-Path $O365AdminTempFolder) -eq $false)
		{
			$Textboxresults.text = "Caching Distribution Groups…"
			(Get-DistributionGroup -ResultSize unlimited | Where-Object { $_.GroupType -notlike 'Universal, SecurityEnabled' }).DisplayName | Out-File "$O365AdminTempFolder"
			$Textboxresults.text = ""
			
			$NewTransportRule = Read-Host "Please enter a name for the Transport Rule"
			If (!$NewTransportRule)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please select a valid name for the new Transport Rule", "Error")
			}
			Else
			{
				$DistroGroupsText = "Select the first Distribution Group"
				Show-SelectCachedDistroGroups_psf
				$Distro1 = $SelectCachedDistroGroups_comboboxNames
				If (!$Distro1)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$DistroGroupsText = "Select the second Distribution Group. Memers of $Distro1 will not be able to send to this group and this group will not be able to send to $Distro1 "
					Show-SelectCachedDistroGroups_psf
					$Distro2 = $SelectCachedDistroGroups_comboboxNames
					If (!$Distro2)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Creating a new Transport Rule where members of $Distro1 and $Distro2 cannot e-mail each other..."
						$textboxDetails.Text = "New-TransportRule $NewTransportRule -BetweenMemberOf1 $Distro1 -BetweenMemberOf2 $Distro2  -RejectMessageEnhancedStatusCode '5.7.1' -RejectMessageReasonText 'Email messages sent between $Distro1 and $Distro2 are prohibited.'"
						$TextboxResults.Text = New-TransportRule $NewTransportRule -BetweenMemberOf1 $Distro1 -BetweenMemberOf2 $Distro2 -RejectMessageEnhancedStatusCode "5.7.1" -RejectMessageReasonText "Email messages sent between $Distro1 and $Distro2 are prohibited." | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Else
		{
			$NewTransportRule = Read-Host "Please enter a name for the Transport Rule"
			If (!$NewTransportRule)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No name was entered, please select a valid name for the new Transport Rule", "Error")
			}
			Else
			{
				$DistroGroupsText = "Select the first Distribution Group"
				Show-SelectCachedDistroGroups_psf
				$Distro1 = $SelectCachedDistroGroups_comboboxNames
				If (!$Distro1)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
				}
				Else
				{
					$DistroGroupsText = "Select the second Distribution Group. Memers of $Distro1 will not be able to send to this group and this group will not be able to send to $Distro1 "
					Show-SelectCachedDistroGroups_psf
					$Distro2 = $SelectCachedDistroGroups_comboboxNames
					If (!$Distro2)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No Distribution Group was selected, please select a valid Distribution Group", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Creating a new Transport Rule where members of $Distro1 and $Distro2 cannot e-mail each other..."
						$textboxDetails.Text = "New-TransportRule $NewTransportRule -BetweenMemberOf1 $Distro1 -BetweenMemberOf2 $Distro2  -RejectMessageEnhancedStatusCode '5.7.1' -RejectMessageReasonText 'Email messages sent between $Distro1 and $Distro2 are prohibited.'"
						$TextboxResults.Text = New-TransportRule $NewTransportRule -BetweenMemberOf1 $Distro1 -BetweenMemberOf2 $Distro2 -RejectMessageEnhancedStatusCode "5.7.1" -RejectMessageReasonText "Email messages sent between $Distro1 and $Distro2 are prohibited." | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$specificSenderBypassClutterToolStripMenuItem_Click={
	Try
	{
		$NewTransportRule = Read-Host "Please enter a name for the Transport Rule"
		If (!$NewTransportRule)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No name was entered, please select a valid name for the new Transport Rule", "Error")
		}
		Else
		{
			$SenderDomain = Read-Host "Please enter the sender's e-mail that will bypass Clutter"
			If (!$SenderDomain)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Domain was entered, please enter a valid domain name what will bypass Clutter", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Creating a new Transport Rule where $SenderDomain can bypass Clutter..."
				$textboxDetails.Text = "New-TransportRule -Name '$NewTransportRule' -From $SenderDomain -SetHeaderName 'X-MS-Exchange-Organization-BypassClutter' -SetHeaderValue 'true' "
				$TextboxResults.Text = New-TransportRule -Name $NewTransportRule -From $SenderDomain -SetHeaderName "X-MS-Exchange-Organization-BypassClutter" -SetHeaderValue "true" | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$changeATransportRulePriorityToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$TransportRulesText = "Select the Transport Rule you want to modify priority for"
			Show-SelectTransportRules_psf
			$DetailedTransportRule = $SelectTransportRules_comboboxTPs
			If (!$DetailedTransportRule)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Transport Rule was selected, please select a valid Transport Rule", "Error")
			}
			Else
			{
				$NewPriority = Read-Host "Please enter a new priority number. Ex: 1"
				If (!$NewPriority)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No priority was set, please enter a valid priority number ", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Setting the priority level for $DetailedTransportRule to $NewPriority..."
					$textboxDetails.Text = "Set-TransportRule -Identity $DetailedTransportRule -Priority $NewPriority"
					$TextboxResults.Text = Set-TransportRule -Identity $DetailedTransportRule -Priority $NewPriority | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify another Transport Rules priority?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$blockPasswordProtectedAttachmentsToolStripMenuItem_Click={
	Try
	{
		$NewTransportRule = Read-Host "Please enter a name for the Transport Rule"
		If (!$NewTransportRule)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No name was entered, please select a valid name for the new Transport Rule", "Error")
		}
		Else
		{
			
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Creating a new Transport Rule where password protected attachments are blocked..."
			$textboxDetails.Text = "New-TransportRule -Name '$NewTransportRule' -AttachmentIsPasswordProtected $True -Quarantine $True "
			$TextboxResults.Text = New-TransportRule -Name $NewTransportRule -AttachmentIsPasswordProtected $True -Quarantine $True | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$quarantineMessagesWithExecutableAttachmentsToolStripMenuItem_Click= {
	$NewTransportRule = Read-Host "Please enter a name for the Transport Rule"
	If (!$NewTransportRule)
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("No name was entered, please select a valid name for the new Transport Rule", "Error")
	}
	Else
	{
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Creating a new Transport Rule where messages with executable content is quarantined..."
		$textboxDetails.Text = "New-TransportRule -Name '$NewTransportRule' -AttachmentHasExecutableContent $True -Quarantine $True "
		$TextboxResults.Text = New-TransportRule -Name $NewTransportRule -AttachmentHasExecutableContent $True -Quarantine $True | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$addAPublicFolderPermissionToolStripMenuItem_Click = {
	Do
	{
		$TempDir = $env:temp
		$CachedPF = ("$TempDir" + "\O365AdminCenter" + "\pf.txt")
		Try
		{
			If ((Test-Path $CachedPF) -eq $false)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Caching Public Folders..."
				(Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse).Identity | Out-File $CachedPF
				
				$PFText = "Please select the Public Folder you want to modify permissions for"
				Show-SelectCachedPublicFolders_psf
				$PFStats = $SelectCachedPublicFolders_comboboxPF
				If (!$PFStats)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Public Folder was selected, please select a valid Public Folder", "Error")
				}
				Else
				{
					$SelectUsersFormText = "Select the user you want to add permission to $PFStats"
					#Call-SelectUsersForm_psf
					Show-SelectCachedDisplayNames_psf
					#$GlobalUPNooouser = $SelectUsersForm_comboboxUsers
					$GlobalUPNooouser = $SelectCachedDisplayNames_comboboxNames
					If (!$GlobalUPNooouser)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
					}
					Else
					{
						$PermissionsText = "Select the level of access you want $GlobalUPNooouser to have"
						Show-SelectPFPermissions_psf
						$Permissions = $SelectPFPermissions_comboboxTPs
						If (!$Permissions)
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							[System.Windows.Forms.MessageBox]::Show("No level of access was selected, please select a valid level of access", "Error")
						}
						Else
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							$TextboxResults.Text = "Modifying permissions for the public folder '$PFStats' for $GlobalUPNooouser with $Permissions access.."
							$textboxDetails.Text = "Add-PublicFolderClientPermission -identity $PFStats -user $GlobalUPNooouser -accessrights $Permissions"
							$TextboxResults.Text = Add-PublicFolderClientPermission -identity $PFStats -user $GlobalUPNooouser -accessrights $Permissions | Out-String -Width 2147483647
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
					}
				}
			}
			Else
			{
				
				$PFText = "Please select the Public Folder you want to modify permissions for"
				Show-SelectCachedPublicFolders_psf
				$PFStats = $SelectCachedPublicFolders_comboboxPF
				If (!$PFStats)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Public Folder was selected, please select a valid Public Folder", "Error")
				}
				Else
				{
					$SelectUsersFormText = "Select the user you want to add permission to $PFStats"
					#Call-SelectUsersForm_psf
					Show-SelectCachedDisplayNames_psf
					#$GlobalUPNooouser = $SelectUsersForm_comboboxUsers
					$GlobalUPNooouser = $SelectCachedDisplayNames_comboboxNames
					If (!$GlobalUPNooouser)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a valid user", "Error")
					}
					Else
					{
						$PermissionsText = "Select the level of access you want $GlobalUPNooouser to have"
						Show-SelectPFPermissions_psf
						$Permissions = $SelectPFPermissions_comboboxTPs
						If (!$Permissions)
						{
							$TextboxResults.Text = ""
							$textboxDetails.Text = ""
							[System.Windows.Forms.MessageBox]::Show("No level of access was selected, please select a valid level of access", "Error")
						}
						Else
						{
							$FormO365AdministrationCenter.Cursor = 'WaitCursor'
							$TextboxResults.Text = "Modifying permissions for the public folder '$PFStats' for $GlobalUPNooouser with $Permissions access.."
							$textboxDetails.Text = "Add-PublicFolderClientPermission -identity $PFStats -user $GlobalUPNooouser -accessrights $Permissions"
							$TextboxResults.Text = Add-PublicFolderClientPermission -identity $PFStats -user $GlobalUPNooouser -accessrights $Permissions | Out-String -Width 2147483647
							$FormO365AdministrationCenter.Cursor = 'Default'
						}
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions on another Public Folder?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAPublicFolderPermissionToolStripMenuItem_Click = {
	Do
	{
		$TempDir = $env:temp
		$CachedPF = ("$TempDir" + "\O365AdminCenter" + "\pf.txt")
		Try
		{
			If ((Test-Path $CachedPF) -eq $false)
			{
				$TextboxResults.Text = "Caching Public Folders..."
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Caching Public Folders..."
				(Get-PublicFolder -ResultSize Unlimited -Identity "\" -Recurse).Identity | Out-File $CachedPF
				$TextboxResults.Text = ""
				$PFText = "Please select the Public Folder you want to view permissions for"
				Show-SelectCachedPublicFolders_psf
				$PFStats = $SelectCachedPublicFolders_comboboxPF
				If (!$PFStats)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Public Folder was selected, please select a valid Public Folder", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting Public Folder permissions for $PFStats.."
					$textboxDetails.Text = "Get-PublicFolderClientPermission -Identity $PFStats"
					$TextboxResults.Text = Get-PublicFolderClientPermission -Identity $PFStats | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			Else
			{
				
				$PFText = "Please select the Public Folder you want to view permissions for"
				Show-SelectCachedPublicFolders_psf
				$PFStats = $SelectCachedPublicFolders_comboboxPF
				If (!$PFStats)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No Public Folder was selected, please select a valid Public Folder", "Error")
				}
				Else
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Getting Public Folder permissions for $PFStats.."
					$textboxDetails.Text = "Get-PublicFolderClientPermission -Identity $PFStats"
					$TextboxResults.Text = Get-PublicFolderClientPermission -Identity $PFStats | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
			}
			
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to modify permissions on another Public Folder?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableExecutionPolicyCheckToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name ExecutionPolicy -Value 1 -Force | Out-Null
		$InformationText = "Execution Policy check has been disabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableExecutionPolicyCheckToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name ExecutionPolicy -Value 0 -Force | Out-Null
		$InformationText = "Execution Policy check has been enabled"
		$FormO365AdministrationCenter.Cursor = 'Default'
		Show-Info_OK_psf
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$TextboxResults_TextChanged={
	
	
}

$deleteAllMailboxContentForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to delete Mailbox Content for"
		Show-SelectCachedDisplayNames_psf
		$DeleteMailboxContent = $SelectCachedDisplayNames_comboboxNames
		If (!$DeleteMailboxContent)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
		}
		Else
		{
			Try
			{
				$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete all Mailbox Content for $DeleteMailboxContent?.", "Warning!", 4)
				If ($OUTPUT -eq "YES")
				{
					$FormO365AdministrationCenter.Cursor = 'WaitCursor'
					$TextboxResults.Text = "Removing mailbox conetent for $DeleteMailboxContent..."
					$textboxDetails.Text = "Search-Mailbox -Identity $DeleteMailboxContent -DeleteContent"
					$TextboxResults.Text = Search-Mailbox -Identity $DeleteMailboxContent -DeleteContent | Out-String -Width 2147483647
					$FormO365AdministrationCenter.Cursor = 'Default'
				}
				Else
				{
					[System.Windows.Forms.MessageBox]::Show("Mailbox Content for $DeleteMailboxContent has not been deleted", "Info")
				}
			}
			Catch
			{
				$FormO365AdministrationCenter.Cursor = 'Default'
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("$_", "Error")
			}
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to delete all Mailbox Content for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getMailboxContentForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to get all Mailbox Content for"
		Show-SelectCachedDisplayNames_psf
		$MailboxContent = $SelectCachedDisplayNames_comboboxNames
		If (!$MailboxContent)
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
		}
		Else
		{
			Try
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting mailbox content for $MailboxContent..."
				$textboxDetails.Text = "Get-MailboxFolderStatistics $MailboxContent | Select-Object Identity, ItemsInFolder"
				$TextboxResults.Text = Get-MailboxFolderStatistics $MailboxContent | Select-Object Identity, ItemsInFolder | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Catch
			{
				$FormO365AdministrationCenter.Cursor = 'Default'
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("$_", "Error")
			}
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Mailbox Content for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$createAnAutoReplyForAMailboxToolStripMenuItem_Click = {
	Do
	{
		#$OOOautoreplyUser = Read-Host "What user is the Out Of Office auto reply for?"
		$SelectUsersFormText = "Select the user you want to create an Auto Reply for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$GlobalUPNooouser = $SelectUsersForm_comboboxUsers
		$GlobalUPNooouser = $SelectCachedDisplayNames_comboboxNames
		
		Try
		{
			If (!$GlobalUPNooouser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("Please select a user you want to create an Auto Reply for", "Error")
			}
			Else
			{
				$OOOInternal = Read-Host "What is the Internal Message"
				If (!$OOOInternal)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("Please enter an internal Auto Reply message", "Error")
				}
				Else
				{
					$OOOExternal = Read-Host "What is the External Message"
					If (!$OOOExternal)
					{
						$TextboxResults.Text = ""
						$textboxDetails.Text = ""
						[System.Windows.Forms.MessageBox]::Show("Please enter an Auto Reply message", "Error")
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Creating an Auto Reply for $GlobalUPNooouser..."
						$textboxDetails.Text = "Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Enabled -ExternalMessage $OOOExternal -InternalMessage $OOOInternal"
						Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Enabled -ExternalMessage $OOOExternal -InternalMessage $OOOInternal
						$TextboxResults.Text = Get-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser | Format-List | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create an Auto-Reply for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableAutoReplyForAMailboxToolStripMenuItem_Click = {
	Do
	{
		#$OOOautoreplyUser = Read-Host "What user is the Out Of Office auto reply for?"
		$SelectUsersFormText = "Select the user you want to disable an Auto Reply for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$GlobalUPNooouser = $SelectUsersForm_comboboxUsers
		$GlobalUPNooouser = $SelectCachedDisplayNames_comboboxNames
		
		Try
		{
			If (!$GlobalUPNooouser)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user selected, please select a user.", "Error")
				
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling an Auto Reply for $GlobalUPNooouser..."
				$textboxDetails.Text = "Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Disabled"
				Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Disabled
				$TextboxResults.Text = Get-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Disable Auto-Reply for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableMailboxAuditingOnAllMailboxesToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling Auditing on all user mailboxes..."
		$textboxDetails.text = "Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' } | Set-Mailbox -AuditEnabled `$true" | Out-String -Width 2147483647
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq "UserMailbox" } | Set-Mailbox -AuditEnabled $true | Out-String -Width 2147483647
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' } | Format-List Name, Audit* | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableMailboxAuditingOnAllUsersToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling Auditing on all user mailboxes..."
		$textboxDetails.text = "Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' } | Set-Mailbox -AuditEnabled `$false" | Out-String -Width 2147483647
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq "UserMailbox" } | Set-Mailbox -AuditEnabled $false | Out-String -Width 2147483647
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' } | Format-List Name, Audit* | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getMailboxAuditingForAllUsersToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Mailbox Auditing for all user mailboxes..."
		$textboxDetails.text = "Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' } | Format-List Name, Audit*" | Out-String -Width 2147483647
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' } | Format-List Name, Audit* | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailboxAuditingForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to get Mailbox Auditing information for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Mailbox Auditing information for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Get-Mailbox $GlobalUPNdetailedmailbox | Format-List Audit*"
				$TextboxResults.Text = Get-Mailbox $GlobalUPNdetailedmailbox | Format-List Audit* | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the Mailbox Auditing status for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$enableMailboxAuditingForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to enable Mailbox Auditing for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling Mailbox Auditing information for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Set-Mailbox -Identity $GlobalUPNdetailedmailbox -AuditEnabled `$true"
				$TextboxResults.Text = Set-Mailbox -Identity $GlobalUPNdetailedmailbox -AuditEnabled $true | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable Mailbox Auditing for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableMailboxAuditingForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to disable Mailbox Auditing for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling Mailbox Auditing information for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Set-Mailbox -Identity $GlobalUPNdetailedmailbox -AuditEnabled `$false"
				$TextboxResults.Text = Set-Mailbox -Identity $GlobalUPNdetailedmailbox -AuditEnabled $false | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable Mailbox Auditing for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeCachedCredentialsToolStripMenuItem_Click={
	Try
	{
		$TempDir = $env:temp
		$O365AdminTempFolderCreds = ("$TempDir" + "\O365AdminCenter_Creds")
		$CachedMem = "$O365AdminTempFolderCreds\Creds.xml"
		Remove-Item $CachedMem -Force
		
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name CredMem -Value 0 -Force | Out-Null
		
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Saved credentials have been removed", "Error")
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableCachedCredentialsToolStripMenuItem_Click = {
	Try
	{
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name CredMem -Value 2 -Force | Out-Null
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Cached Credentials have been disabled", "Info")
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enable2FAToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name TFA -Value 1 -Force | Out-Null
		$InformationText = "Second-Factor Authentication has been enabled"
		Show-Info_OK_psf
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disable2FAToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name TFA -Value 0 -Force | Out-Null
		$InformationText = "Second-Factor Authentication has been Disabled"
		Show-Info_OK_psf
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$clear2FAModulePathToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Get-Item 'HKCU:\Software\O365 Admin Center' | Remove-ItemProperty -Name TFAPath -Force | Out-Null
		$InformationText = "Second-Factor Module has been cleared"
		Show-Info_OK_psf
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$set2FAModulePathToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TFAModule = Read-Host "Please enter the full path to the 2FA Module"
		If (!$TFAModule)
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("No Path was entered!", "Error")
		}
		Else
		{
			$InformationText = "Second-Factor Module has been set to $TFAModule"
			Show-Info_OK_psf
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$download2FAModuleToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Start-Process -FilePath https://technet.microsoft.com/en-us/library/mt775114
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableDirectReportsGroupAutoCreationToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling Direct Reports Group Auto Creation..."
		$textboxDetails.Text = "Set-OrganizationConfig -DirectReportsGroupAutoCreationEnabled `$True"
		$TextboxResults = Set-OrganizationConfig -DirectReportsGroupAutoCreationEnabled $true | Out-String -Width 2147483647
		$TextboxResults.Text = "Success"
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableDirectReportsGroupAutoCreationToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling Direct Reports Group Auto Creation..."
		$textboxDetails.Text = "Set-OrganizationConfig -DirectReportsGroupAutoCreationEnabled `$False"
		$TextboxResults.Text = Set-OrganizationConfig -DirectReportsGroupAutoCreationEnabled $false | Out-String -Width 2147483647
		$TextboxResults.Text = "Success"
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDirectReportsGroupAutoCreationStatusToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Direct Reports Group Auto Creation Status..."
		$textboxDetails.Text = "Get-OrganizationConfig | Format-List *group*"
		$TextboxResults.Text = Get-OrganizationConfig | Format-List *group* | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllGroupsCreatedByDirectReportsGroupAutoCreationToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting All Groups Created by Direct Reports Group Auto Creation..."
		$textboxDetails.Text = "Get-UnifiedGroup -ResultSize Unlimited | Where-Object { $_.GroupPersonification -eq 'Groupsona:AutoDirectReports' }"
		$TextboxResults.Text = Get-UnifiedGroup -ResultSize Unlimited | Where-Object { $_.GroupPersonification -eq 'Groupsona:AutoDirectReports' } | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}

}

$exportFullSMTPLogToCSVToolStripMenuItem_Click={
	Try
	{
		$savedialog = New-Object windows.forms.savefiledialog
		$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
		$savedialog.title = "Export to File"
		$savedialog.filter = ".csv|*.csv"
		$savedialog.ShowHelp = $True
		$result = $savedialog.ShowDialog(); $result
		$OutputFile = $savedialog.filename
		if ($result -eq "OK")
		{
			$TextboxResults.Text = "Exporting Full SMTP Log to csv..."
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			#Collect all recipients from Office 365 
			$Recipients = Get-Recipient -ResultSize Unlimited | Select-Object PrimarySMTPAddress
			$MailTraffic = @{ }
			foreach ($Recipient in $Recipients)
			{
				$MailTraffic[$Recipient.PrimarySMTPAddress.ToLower()] = @{ }
			}
			$Recipients = $null
			
			#Collect Message Tracking Logs (These are broken into "pages" in Office 365 so we need to collect them all with a loop) 
			$Messages = $null
			$Page = 1
			do
			{
				
				Write-Host "Collecting Message Tracking - Page $Page..."
				$CurrMessages = Get-MessageTrace -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -PageSize 5000 -Page $Page | Select-Object Received, *Address, *IP, Subject, Status, Size
				
				if ($CurrMessages -ne $null)
				{
					$CurrMessages | Export-Csv $OutputFile -NoTypeInformation
				}
				$Page++
				$Messages += $CurrMessages
				
				
			}
			until ($CurrMessages -eq $null)
		}
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$downloadMSOnlineModuleFor2FAToolStripMenuItem_Click = {
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		Start-Process -FilePath http://connect.microsoft.com/site1164/Downloads/DownloadDetails.aspx?DownloadID=59185
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}

	
}

$getMigrationStatisticsToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Migration Statistics..."
		$textboxDetails.Text = "Get-MigrationStatistics"
		$TextboxResults.Text = Get-MigrationStatistics | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getMigrationUserStatisticsToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the user you want to get Migration User Statistics for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Migration User Statistics for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Get-MailboxUserStatistics -Identity $GlobalUPNdetailedmailbox"
				$TextboxResults.Text = Get-MailboxUserStatistics -Identity $GlobalUPNdetailedmailbox | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Migration User Statistics for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getMoveRequestForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the user you want to get the Move Request status for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting the Move Request status for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Get-MoveRequest -Identity $GlobalUPNdetailedmailbox"
				$TextboxResults.Text = Get-MoveRequest -Identity $GlobalUPNdetailedmailbox | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the Move Request status for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getMigrationUserStatusToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the user you want to get the Migration User status for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Migration User status for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Get-MailboxUser -Identity $GlobalUPNdetailedmailbox"
				$TextboxResults.Text = Get-MailboxUser -Identity $GlobalUPNdetailedmailbox | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the Migration Status for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$resumeMoveRequestForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the user you want to resume the Move Request for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Resuming the Move Request for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Resume-MoveRequest -Identity $GlobalUPNdetailedmailbox"
				$TextboxResults.Text = Resume-MoveRequest -Identity $GlobalUPNdetailedmailbox | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to resume the Move Request for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$removeMoveRequestForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the user you want to remove the Move Request for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Removing the Move Request for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Remove-MoveRequest -Identity $GlobalUPNdetailedmailbox"
				$TextboxResults.Text = Remove-MoveRequest -Identity $GlobalUPNdetailedmailbox | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to remove a Move Request for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$suspendMoveRequestForAUserToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the user you want to suspend the Move Request for"
		Show-SelectCachedDisplayNames_psf
		$GlobalUPNdetailedmailbox = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNdetailedmailbox)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No user selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Suspending the Move Request for $GlobalUPNdetailedmailbox..."
				$textboxDetails.Text = "Suspend-MoveRequest -Identity $GlobalUPNdetailedmailbox"
				$TextboxResults.Text = Suspend-MoveRequest -Identity $GlobalUPNdetailedmailbox | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to suspend the Move REquest for another user?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getMembersOfADynamicDistributionGroupToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$DistroGroupsText = "Select the Dynamic Distribution Group you want to view the members of"
			Show-SelectDynamicDistributionGroups_psf
			$DetailedDyn = $SelectDynamicDistributionGroups_comboboxSelectDistroGroups
			If (!$DetailedDyn)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No Dynamic Distribution Group was selected, please select a valid Dynamic Distribution Group", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting membership for $DetailedDyn..."
				$DDG = Get-DynamicDistributionGroup $DetailedDyn
				$textboxDetails.Text = "Get-Recipient -RecipientPreviewFilter $DDG.RecipientFilter"
				$TextboxResults.Text = Get-Recipient -RecipientPreviewFilter $DDG.RecipientFilter | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Members of another Dynamic Distribution Group?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllUsersImmutableIDToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users ImmutableID..."
			$textboxDetails.Text = "Get-MsolUser -All | Select-Object DisplayName, ImmutableID"
			$TextboxResults.text = Get-MsolUser -All | Select-Object DisplayName, ImmutableID | Sort-Object DisplayName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users ImmutableID..."
			$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -All | Select-Object DisplayName, ImmutableID | Sort-Object DisplayName"
			$TextboxResults.text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Select-Object DisplayName, ImmutableID | Sort-Object DisplayName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users ImmutableID..."
			$textboxDetails.Text = "Get-MsolUser -All | Select-Object DisplayName, ImmutableID"
			$TextboxResults.text = Get-MsolUser -All | Select-Object DisplayName, ImmutableID | Sort-Object DisplayName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAUsersImmutableIDToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to get the ImmutableID of"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPN = $SelectUsersForm_comboboxUsers
		$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
		Try
		{
			If (!$GlobalUPN)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			ElseIf (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting ImmutableID for $GlobalUPN..."
				$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $GlobalUPN | Select-Object DisplayName, ImmutableID"
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN | Select-Object DisplayName, ImmutableID | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed ImmutableID for $GlobalUPN..."
				$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $GlobalUPN -TenantId $TenantText | Select-Object DisplayName, ImmutableID"
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN -TenantId $PartnerComboBox.SelectedItem.TenantID | Select-Object DisplayName, ImmutableID | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting ImmutableID for $GlobalUPN..."
				$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $GlobalUPN | Select-Object DisplayName, ImmutableID"
				$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN | Select-Object DisplayName, ImmutableID | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the ImmutableID for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$setAUsersImmutableIDToolStripMenuItem_Click = {
	Do
	{
		$SelectUsersFormText = "Select the User you want to set the ImmutableID for"
		#Call-SelectUsersForm_psf
		Show-SelectCachedUserPrincipalName_psf
		#$GlobalUPN = $SelectUsersForm_comboboxUsers
		$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
		Try
		{
			If (!$GlobalUPN)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a User.", "Error")
			}
			Else
			{
				$ImmutableIDVar = Read-Host "Please enter the ImmutableID you want to set for $GlobalUPN..."
				If (!$ImmutableIDVar)
				{
					$TextboxResults.Text = ""
					$textboxDetails.Text = ""
					[System.Windows.Forms.MessageBox]::Show("No ImmutableID value was entered for $GlobalUPN! Please enter a valid ImmutableID.", "Error")
				}
				Else
				{
					If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Setting the ImmutableID for $GlobalUPN..."
						$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPN -ImmutableID $ImmutableIDVar"
						Set-MsolUser -UserPrincipalName $GlobalUPN -ImmutableID $ImmutableIDVar
						$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN | Select-Object DisplayName, ImmutableID | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
					ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
					{
						$TenantText = $PartnerComboBox.text
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Setting the ImmutableID for $GlobalUPN..."
						$textboxDetails.Text = "Set-MsolUser -TenantId $TenantText  -UserPrincipalName $GlobalUPN -ImmutableID $ImmutableIDVar"
						Set-MsolUser TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPN -ImmutableID $ImmutableIDVar
						$TextboxResults.text = Get-MsolUser TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPN | Select-Object DisplayName, ImmutableID | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
						
					}
					Else
					{
						$FormO365AdministrationCenter.Cursor = 'WaitCursor'
						$TextboxResults.Text = "Setting the ImmutableID for $GlobalUPN..."
						$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPN -ImmutableID $ImmutableIDVar"
						Set-MsolUser -UserPrincipalName $GlobalUPN -ImmutableID $ImmutableIDVar
						$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN | Select-Object DisplayName, ImmutableID | Out-String -Width 2147483647
						$FormO365AdministrationCenter.Cursor = 'Default'
					}
				}
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to set the ImmutableID for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$getAllGroupsToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.text = "Getting all Groups..."
		$textboxDetails.Text = "Get-Groups | Format-Table"
		$TextboxResults.text = Get-Groups | Format-Table | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllRecipientsToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.text = "Getting all Recipients..."
		$textboxDetails.Text = "Get-Recipient -ResultSize unlimited"
		$TextboxResults.text = Get-Recipient -ResultSize unlimited | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllSiteTemplatesToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.text = "Getting all Site Templates..."
		$textboxDetails.Text = "Get-SPOWebTemplate"
		$TextboxResults.text = Get-SPOWebTemplate | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getSharePointOnlinePropertiesToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.text = "Getting all SharePoint Site Online Organization Properties..."
		$textboxDetails.Text = "Get-SPOTenant"
		$TextboxResults.text = Get-SPOTenant | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}



$getSharePointOnlineLogsToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.text = "Getting all SharePoint Organization logs..."
		$textboxDetails.Text = "Get-SPOTenantLogEntry"
		$TextboxResults.text = Get-SPOTenantLogEntry | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllActivityAlertsToolStripMenuItem_Click={
	Try
	{
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.text = "Getting all Activity Alerts..."
		$textboxDetails.Text = "Get-ActivityAlert"
		$TextboxResults.text = Get-ActivityAlert | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$newActivityAlertToolStripMenuItem_Click = {
	Do
	{
		Try
		{
			$ActivityReport = Read-Host "Enter a name for the new Activity Report"
			If (!$ActivityReport)
			{
				[System.Windows.Forms.MessageBox]::Show("No name was entered for the Activity Report, please enter a valid name", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.text = "Getting all Activity Alerts..."
				$textboxDetails.Text = "New-ActivityAlert -Identity $ActivityReport"
				$TextboxResults.text = New-ActivityAlert -Identity $ActivityReport | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to create another Activity Report?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
}

$disableOutlookAnyWhereForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to disable Outlook AnyWhere for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling Outlook AnyWhere for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -MAPIEnabled `$False"
				Set-CASMailbox $GlobalUPNrpp -MAPIEnabled $False 
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable Outlook AnyWhere for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$enableOutlookAnyWhereForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to enable Outlook AnyWhere for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling Outlook AnyWhere for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -MAPIEnabled `$True"
				Set-CASMailbox $GlobalUPNrpp -MAPIEnabled $True
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable Outlook AnyWhere for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}



$disableOutlookAnyWhereForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling Outlook AnyWhere for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -MAPIEnabled `$False"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -MAPIEnabled $False
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	

}

$getClientAccessSettingsForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting Client Access Settings for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Get-CASMailbox"
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getClientAccessSettingsForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to get Client Access Settings for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting Client Access Settings for $GlobalUPNrpp..."
				$textboxDetails.Text = "Get-CASMailbox $GlobalUPNrpp"
				$TextboxResults.Text =  Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get Client Access Settings for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
	
}

$enableOutlookAnyWhereForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling Outlook AnyWhere for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -MAPIEnabled `$True"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -MAPIEnabled $True
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableAllClientAccessSettingsForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to disable all Client Access Settings for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling all Client Access Settings for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -ActiveSyncEnabled `$False -OWAEnabled `$False -PopEnabled `$False -ImapEnabled `$False -MapiEnabled `$False"
				Set-CASMailbox $GlobalUPNrpp -ActiveSyncEnabled $False -OWAEnabled $False -PopEnabled $False -ImapEnabled $False -MapiEnabled $False
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable all Client Access Settings for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
	
}

$enableAllClientAccessSettingsForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to enable all Client Access Settings for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling all Client Access Settings for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -ActiveSyncEnabled `$True -OWAEnabled `$True -PopEnabled `$True -ImapEnabled `$True -MapiEnabled `$True"
				Set-CASMailbox $GlobalUPNrpp -ActiveSyncEnabled $True -OWAEnabled $True -PopEnabled $True -ImapEnabled $True -MapiEnabled $True
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable all Client Access Settings for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$getDetailedClientAccessInformationForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to get detailed Client Access Settings for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting detailed Client Access Settings for $GlobalUPNrpp..."
				$textboxDetails.Text = "Get-CASMailbox $GlobalUPNrpp | Format-List "
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Format-List | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get detailed Client Access Settings for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
	
}

$disableAllClientAccessSettingsForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling all Client Access Settings for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox  -ActiveSyncEnabled `$False -OWAEnabled `$False -PopEnabled `$False -ImapEnabled `$False -MapiEnabled `$False"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ActiveSyncEnabled $False -OWAEnabled $False -PopEnabled $False -ImapEnabled $False -MapiEnabled $False
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableAllClientAccessSettingsForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling all Client Access Settings for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox  -ActiveSyncEnabled `$True -OWAEnabled `$True -PopEnabled `$True -ImapEnabled `$True -MapiEnabled `$True"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ActiveSyncEnabled $FTrue -OWAEnabled $True -PopEnabled $True -ImapEnabled $True -MapiEnabled $True
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getOutlookAnyWhereStatusForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to get the Outlook AnyWhere status for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting the Outlook AnyWhere status for $GlobalUPNrpp..."
				$textboxDetails.Text = "Get-CASMailbox $GlobalUPNrpp | Select-Object Name, MAPIEnabled "
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Select-Object Name, MAPIEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the Outlook AnyWhere status for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$getActiveSyncStatusForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to get the ActiveSync status for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting the ActiveSync status for $GlobalUPNrpp..."
				$textboxDetails.Text = "Get-CASMailbox $GlobalUPNrpp | Select-Object Name, ActiveSyncEnabled "
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Select-Object Name, MAPIEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the ActiveSync status for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
	
}

$disableActiveSyncForAUserToolStripMenuItem1_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to disable ActiveSync for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling ActiveSync for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -ActiveSyncEnabled `$False"
				Set-CASMailbox $GlobalUPNrpp -ActiveSyncEnabled $False
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable ActiveSync for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$enableActiveSyncForAUserToolStripMenuItem1_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to enable ActiveSync for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling ActiveSync for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -ActiveSyncEnabled `$True"
				Set-CASMailbox $GlobalUPNrpp -ActiveSyncEnabled $True
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to Enable ActiveSync for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$disableActiveSyncForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling ActiveSync for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ActiveSyncEnabled `$False"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ActiveSyncEnabled $False
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableActiveSyncForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling ActiveSync for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ActiveSyncEnabled `$True"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ActiveSyncEnabled $True
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getIMAPStatusForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to get the IMAP status for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting the IMAP status for $GlobalUPNrpp..."
				$textboxDetails.Text = "Get-CASMailbox $GlobalUPNrpp | Select-Object Name, ImapEnabled"
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Select-Object Name, ImapEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the IMAP status for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$disableIMAPForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to disable IMAP for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling IMAP for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -ImapEnabled `$False"
				Set-CASMailbox $GlobalUPNrpp -ImapEnabled $False
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable IMAP for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
	
}

$enableIMAPForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to enable IMAP for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling IMAP for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -ImapEnabled `$True"
				Set-CASMailbox $GlobalUPNrpp -ImapEnabled $True
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to enable IMAP for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$disableIMAPForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling IMAP for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ImapEnabled `$False"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ImapEnabled $False
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableIMAPForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling IMAP for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ImapEnabled `$True"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -ImapEnabled $True
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getOutlookWebAccessStatusForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to get the Outlook Web Access status for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting the Outlook Web Access status for $GlobalUPNrpp..."
				$textboxDetails.Text = "Get-CASMailbox $GlobalUPNrpp | Select-Object Name, OWAEnabled "
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Select-Object Name, OWAEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the Outlook Web Access status for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$disableOutlookWebAccessForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to disable Outlook Web Access for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling Outlook Web Access for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -OWAEnabled `$False"
				Set-CASMailbox $GlobalUPNrpp -OWAEnabled $False
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable Outlook Web Acccess for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$enableOutlookWebAccessForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to enable Outlook Web Access for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Enabling Outlook Web Access for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -OWAEnabled `$True"
				Set-CASMailbox $GlobalUPNrpp -OWAEnabled $True
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to True Outlook Web Acccess for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$disableOutlookWebAccessForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling Outlook Web Access for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -OWAEnabled `$False"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -OWAEnabled $False
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableOutlookWebAccessForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling Outlook Web Access for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -OWAEnabled `$True"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -OWAEnabled $True
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getPOPStatusForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to get the POP status for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Getting the POP status for $GlobalUPNrpp..."
				$textboxDetails.Text = "Get-CASMailbox $GlobalUPNrpp | Select-Object Name, PopEnabled "
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Select-Object Name, PopEnabled | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to get the POP status for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
	
}

$disablePOPForAUserToolStripMenuItem_Click={
	Do
	{
		Try
		{
			#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
			$SelectUsersFormText = "Select the User you want to disable POP for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
			$GlobalUPNrpp = $SelectCachedUserPrincipalName_comboboxUPN
			If (!$GlobalUPNrpp)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User was selected, please select a User", "Error")
			}
			
			Else
			{
				
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Disabling POP for $GlobalUPNrpp..."
				$textboxDetails.Text = "Set-CASMailbox $GlobalUPNrpp -PopEnabled `$False"
				Set-CASMailbox $GlobalUPNrpp -PopEnabled $False
				$TextboxResults.Text = Get-CASMailbox $GlobalUPNrpp | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
				
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$textboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to disable POP for another User?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
	
}

$enablePOPForAUserToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Enabling POP for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -PopEnabled `$True"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -PopEnabled $True
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disablePOPForAllUsersToolStripMenuItem_Click={
	Try
	{
		
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Disabling POP for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -PopEnabled `$False"
		Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -PopEnabled $False
		$TextboxResults.Text = Get-Mailbox -ResultSize Unlimited | Get-CASMailbox | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$clearAllUsersImmutableIDToolStripMenuItem_Click={
	Try
	{
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to clear all users ImmutableID?.", "Warning!", 4)
		If ($OUTPUT -eq "YES")
		{
			
			#What to do if connected to main o365 account
			If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Clearing all users ImmutableID..."
				$textboxDetails.Text = "Get-MSOLUser -All | Set-MSOLUser -ImmutableID '`$Null'"
				Get-MSOLUser -All | Set-MSOLUser -ImmutableID "$Null"
				$TextboxResults.Text = Get-MsolUser -All | Select-Object DisplayName, ImmutableID | Sort-Object DisplayName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			#What to do if connected to partner account
			ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
			{
				$TenantText = $PartnerComboBox.text
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Clearing all users ImmutableID..."
				$textboxDetails.Text = "Get-MSOLUser -TenantId $TenantText -All | Set-MSOLUser -TenantId $TenantText -ImmutableID '`$Null'"
				Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Set-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -ImmutableID "$Null"
				$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Select-Object DisplayName, ImmutableID | Sort-Object DisplayName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Clearing all users ImmutableID..."
				$textboxDetails.Text = "Get-MSOLUser -All | Set-MSOLUser -ImmutableID '`$Null'"
				Get-MSOLUser -All | Set-MSOLUser -ImmutableID "$Null"
				$TextboxResults.Text = Get-MsolUser -All | Select-Object DisplayName, ImmutableID | Sort-Object DisplayName | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Else
		{
			[System.Windows.Forms.MessageBox]::Show("All users ImmutableID has not been changed", "Info")
		}
	}
	
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getAllUsersWith2FAEnabledToolStripMenuItem_Click = {
	Try
	{
		
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users with 2FA enabled..."
			$textboxDetails.Text = "Get-MsolUser | Where-Object { `$_.StrongAuthenticationRequirements -like ' * ' } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements "
			#Find all MFA enabled users
			$TextboxResults.Text = Get-MsolUser -All | Where-Object { $_.StrongAuthenticationRequirements -like "*" } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object UserPrincipalName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users with 2FA enabled..."
			$textboxDetails.Text = "Get-MsolUser | Where-Object { `$_.StrongAuthenticationRequirements -like ' * ' } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements "
			#Find all MFA enabled users
			$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.StrongAuthenticationRequirements -like "*" } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object UserPrincipalName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users with 2FA enabled..."
			$textboxDetails.Text = "Get-MsolUser | Where-Object { `$_.StrongAuthenticationRequirements -like ' * ' } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements "
			#Find all MFA enabled users
			$TextboxResults.Text = Get-MsolUser -All | Where-Object { $_.StrongAuthenticationRequirements -like "*" } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object UserPrincipalName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		
		
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getAllUsersWith2FADisabledToolStripMenuItem_Click={
	Try
	{
		
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users with 2FA disabled..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.StrongAuthenticationMethods -like ' * ' } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements "
			#Find all MFA enabled users
			$TextboxResults.Text = Get-MsolUser -All | Where-Object { $_.StrongAuthenticationMethods -like "*" } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object UserPrincipalName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users with 2FA disabled..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.StrongAuthenticationMethods -like ' * ' } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements "
			#Find all MFA enabled users
			$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.StrongAuthenticationMethods -like "*" } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object UserPrincipalName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users with 2FA disabled..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.StrongAuthenticationMethods -like ' * ' } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements "
			#Find all MFA enabled users
			$TextboxResults.Text = Get-MsolUser -All | Where-Object { $_.StrongAuthenticationMethods -like "*" } | Select-Object UserPrincipalName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object UserPrincipalName | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		
		
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableCachedCredentialsToolStripMenuItem_Click={
	Try
	{
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name CredMem -Value 1 -Force | Out-Null
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Cached Credentials have been enabled", "Info")
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getLastDirSyncTimeToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last DirSync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastDirSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastDirSyncTime | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last DirSync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List LastDirSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List LastDirSyncTime | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last DirSync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastDirSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastDirSyncTime | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDirSyncServiceAccountToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting DirSync service account..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List DirSyncServiceAccount"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List DirSyncServiceAccount | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting DirSync service account..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List DirSyncServiceAccount"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List DirSyncServiceAccount | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting DirSync service account..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List DirSyncServiceAccount"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List DirSyncServiceAccount | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableDirSyncTenantWideToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Enabling DirSync..."
			$textboxDetails.Text = "Set-MsolDirSyncEnabled -EnableDirSync `$True"
			$TextboxResults.Text = Set-MsolDirSyncEnabled -EnableDirSync $True | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Enabling DirSync..."
			$textboxDetails.Text = "Set-MsolDirSyncEnabled -TenantId $TenantText -EnableDirSync `$True"
			$TextboxResults.Text = Set-MsolDirSyncEnabled -TenantId $PartnerComboBox.SelectedItem.TenantID -EnableDirSync $True | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling DirSync..."
			$textboxDetails.Text = "Set-MsolDirSyncEnabled -EnableDirSync `$True"
			$TextboxResults.Text = Set-MsolDirSyncEnabled -EnableDirSync $True | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableDirSyncTenantWideToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling DirSync..."
			$textboxDetails.Text = "Set-MsolDirSyncEnabled -EnableDirSync `$False"
			$TextboxResults.Text = Set-MsolDirSyncEnabled -EnableDirSync $False | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling DirSync..."
			$textboxDetails.Text = "Set-MsolDirSyncEnabled -TenantId $TenantText -EnableDirSync `$False"
			$TextboxResults.Text = Set-MsolDirSyncEnabled -TenantId $PartnerComboBox.SelectedItem.TenantID -EnableDirSync $False  | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Disabling DirSync..."
			$textboxDetails.Text = "Set-MsolDirSyncEnabled -EnableDirSync `$False"
			$TextboxResults.Text = Set-MsolDirSyncEnabled -EnableDirSync $False | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getLastPasswordSyncTimeToolStripMenuItem1_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last Password Sync time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastPasswordSyncTime "
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastPasswordSyncTime  | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last Password time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List LastPasswordSyncTime"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List LastPasswordSyncTime  | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting last Password time..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastPasswordSyncTime "
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastPasswordSyncTime  | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getDirSyncStatusToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Password Sync Status..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List PasswordSynchronizationEnabled "
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List PasswordSynchronizationEnabled | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Password Sync Status..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List PasswordSynchronizationEnabled"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List PasswordSynchronizationEnabled | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Password Sync Status..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List PasswordSynchronizationEnabled "
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List PasswordSynchronizationEnabled| Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getPasswordSyncStatusToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting DirSync Status..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List DirectorySynchronizationEnabled"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List DirectorySynchronizationEnabled | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Password Sync Status..."
			$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List DirectorySynchronizationEnabled"
			$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List DirectorySynchronizationEnabled | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Password Sync Status..."
			$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List DirectorySynchronizationEnabled"
			$TextboxResults.Text = Get-MsolCompanyInformation | Format-List DirectorySynchronizationEnabled | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDirSyncErrorsToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting DirSync Errors..."
			$textboxDetails.Text = "Get-MsolDirSyncProvisioningError"
			$TextboxResults.Text = Get-MsolDirSyncProvisioningError | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting DirSync Errors..."
			$textboxDetails.Text = "Get-MsolDirSyncProvisioningError -TenantId $TenantText"
			$TextboxResults.Text = Get-MsolDirSyncProvisioningError -TenantId $PartnerComboBox.SelectedItem.TenantID | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting DirSync Errors..."
			$textboxDetails.Text = "Get-MsolDirSyncProvisioningError"
			$TextboxResults.Text = Get-MsolDirSyncProvisioningError | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getPartnerInformationToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Partner Information..."
			$textboxDetails.Text = "Get-MsolPartnerInformation"
			$TextboxResults.Text = Get-MsolPartnerInformation | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Partner Information..."
			$textboxDetails.Text = "Get-MsolPartnerInformation -TenantId $TenantText"
			$TextboxResults.Text = Get-MsolPartnerInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting Partner Information..."
			$textboxDetails.Text = "Get-MsolPartnerInformation"
			$TextboxResults.Text = Get-MsolPartnerInformation | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}



$setNewCachedCredentialsToolStripMenuItem_Click = {
	Try
	{
		$global:o365credentials = (Get-Credential -Message "Please enter your Office 365 credentials")
		$TempDir = $env:temp
		$O365AdminTempFolderCreds = ("$TempDir" + "\O365AdminCenter_Creds")
		#Create temporary directory
		#[system.io.directory]::CreateDirectory("$O365AdminTempFolderCreds")
		$global:o365credentials | Export-Clixml -path $O365AdminTempFolderCreds\Creds.xml -Force
		Get-Item 'HKCU:\Software\O365 Admin Center' | New-ItemProperty -Name CredMem -Value 1 -Force | Out-Null
		[System.Windows.Forms.MessageBox]::Show("The new credentials have been saved!", "Info", "OK", "Info")
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllGlobalAdminsToolStripMenuItem_Click = {
	$Role = "Company Administrators"
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Company Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Company Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -TenantId $PartnerComboBox.SelectedItem.TenantID -RoleName "Company Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Company Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -TenantId $PartnerComboBox.SelectedItem.TenantID -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Company Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Company Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getAllComplianceAdministratorsToolStripMenuItem_Click={
	$Role = "Compliance Administrators"
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Compliance Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Compliance Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -TenantId $PartnerComboBox.SelectedItem.TenantID -RoleName "Compliance Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Compliance Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -TenantId $PartnerComboBox.SelectedItem.TenantID -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Compliance Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Compliance Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllExchangeServiceAdministratorsToolStripMenuItem_Click={
	$Role = "Exchange Service Administrators"
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Exchange Service Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Exchange Service Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -TenantId $PartnerComboBox.SelectedItem.TenantID -RoleName "Exchange Service Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Exchange Service Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -TenantId $PartnerComboBox.SelectedItem.TenantID -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Exchange Service Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Exchange Service Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllHelpdeskAdministratorsToolStripMenuItem_Click={
	$Role = "Helpdesk Administrators"
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Helpdesk Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Helpdesk Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -TenantId $PartnerComboBox.SelectedItem.TenantID -RoleName "Helpdesk Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Helpdesk Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -TenantId $PartnerComboBox.SelectedItem.TenantID -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Helpdesk Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Helpdesk Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllDeviceUsersToolStripMenuItem_Click={
	$Role = "Device Users"
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Device Users"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Device Users'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -TenantId $PartnerComboBox.SelectedItem.TenantID -RoleName "Device Users"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Device Users'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -TenantId $PartnerComboBox.SelectedItem.TenantID -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "Device Users"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'Device Users'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllSharePointServiceAdministratorsToolStripMenuItem_Click={
	$Role = "SharePoint Service Administrators"
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "SharePoint Service Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'SharePoint Service Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -TenantId $PartnerComboBox.SelectedItem.TenantID -RoleName "SharePoint Service Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'SharePoint Service Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -TenantId $PartnerComboBox.SelectedItem.TenantID -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "SharePoint Service Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'SharePoint Service Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllUserAccountAdministratorsToolStripMenuItem_Click={
	$Role = "User Account Administrators"
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "User Account Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'User Account Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -TenantId $PartnerComboBox.SelectedItem.TenantID -RoleName "User Account Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'User Account Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -TenantId $PartnerComboBox.SelectedItem.TenantID -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$O365ROLE = Get-MsolRole -RoleName "User Account Administrator"
			$TextboxResults.Text = "Getting All $Role..."
			$textboxDetails.Text = "`$O365ROLE = Get-MsolRole -RoleName 'User Account Administrator'
Get-MsolRoleMember -All -RoleObjectId `$O365ROLE.ObjectId"
			$TextboxResults.Text = Get-MsolRoleMember -All -RoleObjectId $O365ROLE.ObjectId | Out-String -Width 2147483647
			
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disable2FAForAUserToolStripMenuItem_Click = {

	
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$SelectUsersFormText = "Select the User you want to disable Second-Factor Authentication for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPN = $SelectUsersForm_comboboxUsers
			$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
			
			$mfa = @()
			
			$TextboxResults.Text = "Disabling 2FA for $GlobalUPN..."
			$textboxDetails.Text = "`$mfa = @()
Set-MsolUser -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements `$mfa "
			$TextboxResults.Text = Set-MsolUser -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements $mfa | Out-String -Width 2147483647
			$TextboxResults.Text = Get-MsolUser -All | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$SelectUsersFormText = "Select the User you want to disable Second-Factor Authentication for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPN = $SelectUsersForm_comboboxUsers
			$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
			
			$mfa = @()
			
			$TextboxResults.Text = "Disabling 2FA for $GlobalUPN..."
			$textboxDetails.Text = "`$mfa = @()
Set-MsolUser -TenantId $TenantText -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements `$mfa "
			$TextboxResults.Text = Set-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements $mfa | Out-String -Width 2147483647
			$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID| Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
			
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$SelectUsersFormText = "Select the User you want to disable Second-Factor Authentication for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPN = $SelectUsersForm_comboboxUsers
			$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
			
			$mfa = @()
			
			$TextboxResults.Text = "Disabling 2FA for $GlobalUPN..."
			$textboxDetails.Text = "`$mfa = @()
Set-MsolUser -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements `$mfa "
			$TextboxResults.Text = Set-MsolUser -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements $mfa | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllUsers2FAStatusToolStripMenuItem_Click={
	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users 2FA status..."
			$textboxDetails.Text = "Get-MsolUser -All | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize"
			$TextboxResults.Text = Get-MsolUser -All | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users 2FA status..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize"
			$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
			
		}
		Else
		{
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			$TextboxResults.Text = "Getting all users 2FA status..."
			$textboxDetails.Text = "Get-MsolUser -All | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize"
			$TextboxResults.Text = Get-MsolUser -All | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enable2FAForAUserToolStripMenuItem_Click={

	Try
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			#Create the StrongAuthenticationRequirement object and insert required settings
			$auth = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
			$auth.RelyingParty = "*"
			$auth.State = "Enabled"
			$auth.RememberDevicesNotIssuedBefore = (Get-Date)
			
			
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$SelectUsersFormText = "Select the User you want to enable Second-Factor Authentication for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPN = $SelectUsersForm_comboboxUsers
			$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
			
			$mfa = @()
			
			$TextboxResults.Text = "Enabling 2FA for $GlobalUPN..."
			$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements  $auth "
			$TextboxResults.Text = Set-MsolUser -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements $auth | Out-String -Width 2147483647
			$TextboxResults.Text = Get-MsolUser -All | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
		
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			#Create the StrongAuthenticationRequirement object and insert required settings
			$auth = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
			$auth.RelyingParty = "*"
			$auth.State = "Enabled"
			$auth.RememberDevicesNotIssuedBefore = (Get-Date)
			
			
			$TenantText = $PartnerComboBox.text
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$SelectUsersFormText = "Select the User you want to enable Second-Factor Authentication for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPN = $SelectUsersForm_comboboxUsers
			$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
			
			$mfa = @()
			
			$TextboxResults.Text = "Enabling 2FA for $GlobalUPN..."
			$textboxDetails.Text = "Set-MsolUser -TenantId $TenantText -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements $auth "
			$TextboxResults.Text = Set-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements $auth | Out-String -Width 2147483647
			$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
			
		}
		Else
		{
			#Create the StrongAuthenticationRequirement object and insert required settings
			$auth = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
			$auth.RelyingParty = "*"
			$auth.State = "Enabled"
			$auth.RememberDevicesNotIssuedBefore = (Get-Date)
			
			
			$FormO365AdministrationCenter.Cursor = 'WaitCursor'
			
			$SelectUsersFormText = "Select the User you want to enable Second-Factor Authentication for"
			#Call-SelectUsersForm_psf
			Show-SelectCachedUserPrincipalName_psf
			#$GlobalUPN = $SelectUsersForm_comboboxUsers
			$GlobalUPN = $SelectCachedUserPrincipalName_comboboxUPN
			
			$mfa = @()
			
			$TextboxResults.Text = "Enabling 2FA for $GlobalUPN..."
			$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements  $auth "
			$TextboxResults.Text = Set-MsolUser -UserPrincipalName $GlobalUPN -StrongAuthenticationRequirements $auth | Out-String -Width 2147483647
			$TextboxResults.Text = Get-MsolUser -All | Select-Object DisplayName, StrongAuthenticationMethods, StrongAuthenticationRequirements | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
			$FormO365AdministrationCenter.Cursor = 'Default'
		}
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$placeAUserOnLitigationHoldToolStripMenuItem_Click={
	Do
	{
		#$HidefromGALUser = Read-Host "Enter the UPN of the user you want to hide from the GAL"
		$SelectUsersFormText = "Select the User you want to place on Litigation Hold"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$GlobalUPNhideGAL = $SelectUsersForm_comboboxUsers
		$GlobalUPNhideGAL = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNhideGAL)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Placing $GlobalUPNhideGAL on Litigation Hold..."
				$textboxDetails.Text = "set-Mailbox -Identity $GlobalUPNhideGAL -LitigationHoldEnabled `$True"
				set-Mailbox -Identity $GlobalUPNhideGAL -LitigationHoldEnabled $True
				$TextboxResults.Text = get-mailbox | where-object { $_.litigationholdenabled -eq $true } | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to place another user on Litigation Hold?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

$getAllUsersOnLitigationHoldToolStripMenuItem_Click={
	Try
	{
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all Users on Litigation Hold..."
		$textboxDetails.Text = "get-mailbox | where-object { `$_.litigationholdenabled -eq `$true } | Sort-Object"
		$TextboxResults.Text = get-mailbox | where-object { $_.litigationholdenabled -eq $true } | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$placeAllUsersOnLitigationHoldToolStripMenuItem_Click = {
	Try
	{
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Placing all users on Litigation Hold..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' } | Set-Mailbox -LitigationHoldEnabled `$True"
		Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq "UserMailbox" } | Set-Mailbox -LitigationHoldEnabled $true
		$TextboxResults.Text = get-mailbox | where-object { $_.litigationholdenabled -eq $true } | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$takeAllUsersOffLitigationHoldToolStripMenuItem_Click={
	Try
	{
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Placing all users off Litigation Hold..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq 'UserMailbox' } | Set-Mailbox -LitigationHoldEnabled `$False"
		Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq "UserMailbox" } | Set-Mailbox -LitigationHoldEnabled $False
		$TextboxResults.Text = get-mailbox | where-object { $_.litigationholdenabled -eq $False } | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllUsersOffLitigationHoldToolStripMenuItem_Click={
	Try
	{
		
		$FormO365AdministrationCenter.Cursor = 'WaitCursor'
		$TextboxResults.Text = "Getting all Users off Litigation Hold..."
		$textboxDetails.Text = "get-mailbox | where-object { `$_.litigationholdenabled -eq `$False } | Sort-Object"
		$TextboxResults.Text = get-mailbox | where-object { $_.litigationholdenabled -eq $False } | Out-String -Width 2147483647
		$FormO365AdministrationCenter.Cursor = 'Default'
	}
	Catch
	{
		$FormO365AdministrationCenter.Cursor = 'Default'
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$placeAUserOffLitigationHoldToolStripMenuItem_Click={
	Do
	{
		#$HidefromGALUser = Read-Host "Enter the UPN of the user you want to hide from the GAL"
		$SelectUsersFormText = "Select the User you want to place off Litigation Hold"
		#Call-SelectUsersForm_psf
		Show-SelectCachedDisplayNames_psf
		#$GlobalUPNhideGAL = $SelectUsersForm_comboboxUsers
		$GlobalUPNhideGAL = $SelectCachedDisplayNames_comboboxNames
		Try
		{
			If (!$GlobalUPNhideGAL)
			{
				$TextboxResults.Text = ""
				$textboxDetails.Text = ""
				[System.Windows.Forms.MessageBox]::Show("No User selected, please select a user.", "Error")
			}
			Else
			{
				$FormO365AdministrationCenter.Cursor = 'WaitCursor'
				$TextboxResults.Text = "Placing $GlobalUPNhideGAL off Litigation Hold..."
				$textboxDetails.Text = "set-Mailbox -Identity $GlobalUPNhideGAL -LitigationHoldEnabled `$False"
				set-Mailbox -Identity $GlobalUPNhideGAL -LitigationHoldEnabled $False
				$TextboxResults.Text = get-mailbox | where-object { $_.litigationholdenabled -eq $False } | Out-String -Width 2147483647
				$FormO365AdministrationCenter.Cursor = 'Default'
			}
		}
		Catch
		{
			$FormO365AdministrationCenter.Cursor = 'Default'
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
		#Create the pop-up message
		Add-Type -AssemblyName System.Windows.Forms
		$Result = [System.Windows.Forms.MessageBox]::Show('Do you want to place another user off Litigation Hold?', 'Info', 'YesNo', 'Info')
	}
	While ($Result -eq 'Yes')
	
}

. (Join-Path $PSScriptRoot 'Main.psf.designer.ps1')
$FormO365AdministrationCenter.ShowDialog()
