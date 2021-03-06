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

###GLOBAL VARIABLES###

#Version information
$Version = "3.0.0.0"



###FORM ITEMS###

	#Form

$FormO365AdministrationCenter_Load = {
	
	#Check to see if there is a new version available 
	$PublicVersion = Invoke-WebRequest -Uri http://o365admin.center/update.txt | Select-Object -ExpandProperty content
	#If local version is less than the public version then prompt for update
	If ($Version -lt $publicVersion)
	{
		$Output = [System.Windows.Forms.MessageBox]::Show("Update Available!
Version $PublicVersion is now available, would you like to download it?", "O365 Admin Center", 4)
		#If you select "Yes" to downloading a new version
		If ($OUTPUT -eq "YES")
		{
			#Start downloading the new version
			Start-Process -FilePath http://o365admin.center/O365-Admin-Center.exe
			#Close the form
			$FormO365AdministrationCenter.Close()
		}
	}
	#If Publicversion equals nothing then ignore, this is if the website is down or the user does not have internet
	elseif ($PublicVersion = $Null)
	{
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
	
}

$checkForUpdatesToolStripMenuItem_Click = {
	#Check to see if there is a new version available 
	$PublicVersion = Invoke-WebRequest -Uri http://o365admin.center/update.txt | Select-Object -ExpandProperty content
	#If version info is not equal to public version info
	If ($Version -lt $publicVersion)
	{
		$Output = [System.Windows.Forms.MessageBox]::Show("Update Available!
Version $PublicVersion is now available, would you like to download it?", "O365 Admin Center", 4)
		#If you select "Yes" to downloading a new version
		If ($OUTPUT -eq "YES")
		{
			#Start downloading the new version
			Start-Process -FilePath http://o365admin.center/O365-Admin-Center.exe
			#Close the form
			$FormO365AdministrationCenter.Close()
		}
	}
	elseif ($PublicVersion = $Null)
	{
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("You are up to date!", "Check for Updates")
	}
	
}

$exitToolStripMenuItem_Click = {
	#Close the form
	Get-PSSession | Remove-PSSession
	$FormO365AdministrationCenter.Close()
}

	#Buttons

$ButtonDisconnect_Click = {
	#Clears the combobox
	$PartnerComboBox.Text = ""
	
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
	
	#Enables the partner combobox
	$PartnerComboBox.Enabled = $True
	
	#Disable the connect to tenant button
	$TenantConnectButton.Enabled = $true
	
	#Enables the connect to o365 button
	$ButtonConnectTo365.Enabled = $True
	$ButtonConnectTo365.Text = "Connect to O365"
	
	
	
	#Enables tenant combobox
	$PartnerComboBox.Enabled = $True
	
	$checkboxComplianceCenter.Checked = $false
	$checkboxExchangeOnline.Checked = $false
	$checkboxSharepoint.Checked = $false
	$checkboxSkypeForBusiness.Checked = $false
	$checkboxComplianceCenter.Enabled = $true
	$checkboxExchangeOnline.Enabled = $true
	$checkboxSharepoint.Enabled = $true
	$checkboxSkypeForBusiness.Enabled = $true
	$TenantConnectButton.Enabled = $True
	$progressbar1.Value = 100
	
	#Hide the progress bar
	$progressbar1.Visible = $false
	
}

<#
$buttonDisconnectFromPartner_Click = {
	$TextboxResults.Text = "Disconnecting from partner account..."
	Get-PSSession | Remove-PSSession
	Connect-MsolService -Credential $global:o365credentials
	$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
	Import-PSSession $exchangeSession
	#Disable Button
	$PartnerConnectButton.Enabled = $True
	$ButtonDisconnectFromPartner.Enabled = $False
	#Sets custom button text
	$PartnerConnectButton.Text = "Connect to Partner"
	$FormO365AdministrationCenter.Text = "O365 Administration Center"
	$PartnerComboBox.Enabled = $True
	$TextboxResults.Text = ""
	$textboxDetails.Text = ""

}
#>

$ButtonConnectTo365_Click = {
	
	try
	{
		If ($checkboxComplianceCenter.Checked -eq $False -and $checkboxExchangeOnline.Checked -eq $False -and $checkboxSharepoint.Checked -eq $False -and $checkboxSkypeForBusiness.Checked -eq $False)
		{
			[System.Windows.Forms.MessageBox]::Show("Please select a service to connect to", "Error")
		}
		Else
		{
			$global:o365credentials = (Get-Credential -Message "O365 Credentials")
			
			#Show progress bar
			$progressbar1.Visible = $true
			$TextboxResults.Text = "Connecting to O365..."
			$progressbar1.Value = 10
			Connect-MsolService -Credential $global:o365credentials
			$progressbar1.Value = 60
			
			$partnerTIDs = Get-MsolPartnerContract -All | Select-Object TenantID
			$progressbar1.Value = 70
			
			#If tenant domains are available then load combobox with all tenants
			If ($partnerTIDs -ne $Null)
			{
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
				$progressbar1.Value = 75
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
			
			$progressbar1.Value = 80
			
			#If compliance center checkbox is checked
			If ($checkboxComplianceCenter.Checked)
			{
				$TextboxResults.Text = "Connecting to Compliance Center..."
				$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
				Import-PSSession $ccSession
				$TextboxResults.Text = ""
			}
			$progressbar1.Value = 85
			
			#If exchange online checkbox is checked
			If ($checkboxExchangeOnline.Checked)
			{
				$TextboxResults.Text = "Connecting to Exchange Online..."
				$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
				Import-PSSession $exchangeSession -AllowClobber
				$TextboxResults.Text = ""
			}
			$progressbar1.Value = 90
			
			If ($checkboxSharepoint.Checked -and $checkboxExchangeOnline.Checked)
			{
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
			#If sharepoint checkbox is checked
			ElseIf ($checkboxSharepoint.Checked)
			{
				#$Sharepointdomain = Read-Host "Enter the domain name. EX: contoso, yahoo"
				#Connect to Exchange online so we can grab the Sharepoint URL attribute 
				$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
				Import-PSSession $exchangeSession -AllowClobber
				$progressbar1.Value = 93
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
			$progressbar1.Value = 95
			#If skype for business checkbox is checked
			If ($checkboxSkypeForBusiness.Checked)
			{
				$TextboxResults.Text = "Connecting to Skype for Business.."
				Import-Module SkypeOnlineConnector
				#Skype for business session
				$sfboSession = New-CsOnlineSession -Credential $global:o365credentials
				#Import Skype For Business Session
				Import-PSSession $sfboSession
				$TextboxResults.Text = ""
			}
			
			$progressbar1.Value = 99
			
			#Clear the textbox
			$TextboxResults.Text = ""
			
			#Disable the connect to o365 button
			$ButtonConnectTo365.Enabled = $False
			
			#Enable the disconnect button
			$ButtonDisconnect.Enabled = $True
			
			#Disable the checkboxes
			$checkboxExchangeOnline.Enabled = $false
			$checkboxSkypeForBusiness.Enabled = $false
			$checkboxSharepoint.Enabled = $false
			$checkboxComplianceCenter.Enabled = $False
			
			#Change button text
			$ButtonConnectTo365.Text = "Connected to O365"
			
			$progressbar1.Value = 100
			
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
		}
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		$PartnerComboBox.Enabled = $True
		$ButtonConnectTo365.Enabled = $True
		$TenantConnectButton.Enabled = $True
		$checkboxComplianceCenter.Enabled = $true
		$checkboxExchangeOnline.Enabled = $true
		$checkboxSharepoint.Enabled = $true
		$checkboxSkypeForBusiness.Enabled = $true
		[System.Windows.Forms.MessageBox]::Show('You are not connected to O365, Please verify the correct username, and password. Check Help>Prerequisites for more info', "Error")
	}
	#Hide the progress bar
	$progressbar1.Visible = $false
}

$TenantConnectButton_Click = {
	try
	{
		#Show the proress bar
		$progressbar1.Visible = $true
		
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
		$progressbar1.Value = 90
		
		#Disable the connect to tenant button
		$TenantConnectButton.Enabled = $false
		
		#Sets custom form text
		$FormO365AdministrationCenter.Text = "-Connected to" + $PartnerComboBox.SelectedItem.Name + "-"
		
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
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Unable to connect to partner", "Error")
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
		#Takes the user input to a variable and passes it to the shell
		$TextboxResults.text = Invoke-Expression $userinput | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}



###USERS###

	#User General Items

$createOutOfOfficeAutoReplyForAUserToolStripMenuItem_Click = {
	#$OOOautoreplyUser = Read-Host "What user is the Out Of Office auto reply for?"
	$SelectUsersFormText = "Select the user you want to create an out of office reply for"
	Call-SelectUsersForm_psf
	$GlobalUPNooouser = $SelectUsersForm_comboboxUsers
	
	$OOOInternal = Read-Host "What is the Internal Message"

	$OOOExternal = Read-Host "What is the External Message"
	
	Try
	{
		$TextboxResults.Text = "Creating an out of office reply for $GlobalUPNooouser..."
		$textboxDetails.Text = "Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Enabled -ExternalMessage $OOOExternal -InternalMessage $OOOInternal"
		Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Enabled -ExternalMessage $OOOExternal -InternalMessage $OOOInternal
		$TextboxResults.Text = Get-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser | Format-List | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableOutOfOfficeReplyForAUserToolStripMenuItem_Click = {
	#$OOOautoreplyUser = Read-Host "What user is the Out Of Office auto reply for?"
	$SelectUsersFormText = "Select the user you want to disable an out of office reply for"
	Call-SelectUsersForm_psf
	$GlobalUPNooouser = $SelectUsersForm_comboboxUsers
	
	Try
	{
		$TextboxResults.Text = "Disabling an out of office reply for $GlobalUPNooouser..."
		$textboxDetails.Text = "Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Disabled"
		Set-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser -AutoReplyState Disabled
		$TextboxResults.Text = Get-MailboxAutoReplyConfiguration -Identity $GlobalUPNooouser | Format-List | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getListOfUsersToolStripMenuItem_Click = {
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting list of users..."
		$textboxDetails.Text = "Get-MSOLUser -All | Sort-Object DisplayName |  Format-Table DisplayName, UserPrincipalName -AutoSize"
		$TextboxResults.text = Get-MSOLUser -All | Sort-Object DisplayName | Format-Table DisplayName, UserPrincipalName -AutoSize | Out-String -Width 2147483647
	}
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting list of users..."
		$textboxDetails.Text = "Get-MSOLUser -TenantId $TenantText -All | Sort-Object DisplayName |  Format-Table DisplayName, UserPrincipalName -AutoSize "
		$TextboxResults.text = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Sort-Object DisplayName | Format-Table DisplayName, UserPrincipalName -AutoSize | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not get a list of users", "Error")
	}
}

$getDetailedInfoForAUserToolStripMenuItem_Click = {
	$SelectUsersFormText = "Select the user you want to view detailed information for"
	Call-SelectUsersForm_psf
	$GlobalUPN = $SelectUsersForm_comboboxUsers
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting detailed info for $GlobalUPN..."
		$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $GlobalUPN | Format-List"
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN | Format-List | Out-String -Width 2147483647
	}
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting detailed info for $GlobalUPN..."
		$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $GlobalUPN -TenantId $TenantText | Format-List"
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPN -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not get detailed info for $DetailedInfoUser", "Error")
	}
}

$changeUsersLoginNameToolStripMenuItem_Click = {
	$SelectUsersFormText = "Select the user you want to change the User Principal Name for"
	Call-SelectUsersForm_psf
	$GlobalUPN = $SelectUsersForm_comboboxUsers
	$NewUserUPN = Read-Host "What would you like the new username to be?"
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Changing $GlobalUPN UPN to $NewUserUPN..."
		$textboxDetails.Text = "Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -NewUserPrincipalName $NewUserUPN"
		Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -NewUserPrincipalName $NewUserUPN
		$TextboxResults.text = Get-MSOLUser -UserPrincipalName $NewUserUPN | Format-List UserPrincipalName | Out-String -Width 2147483647
	}
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Changing $GlobalUPN UPN to $NewUserUPN..."
		$textboxDetails.Text = "Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -TenantId $TenantText -NewUserPrincipalName $NewUserUPN"
		Set-MsolUserPrincipalname -UserPrincipalName $GlobalUPN -TenantId $PartnerComboBox.SelectedItem.TenantID -NewUserPrincipalName $NewUserUPN
		$TextboxResults.text = Get-MSOLUser -UserPrincipalName $NewUserUPN -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List UserPrincipalName | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not change the login name for $GlobalUPN", "Error")
	}
}

$deleteAUserToolStripMenuItem_Click = {
	#$DeleteUser = Read-Host "Enter the UPN of the user you want to delete"
	$SelectUsersFormText = "Select the user you want to delete"
	Call-SelectUsersForm_psf
	$GlobalUPNdelete = $SelectUsersForm_comboboxUsers
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $GlobalUPNdelete ?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$TextboxResults.Text = "Deleting $GlobalUPNdelete..."
			$textboxDetails.Text = "Remove-MsolUser –UserPrincipalName $GlobalUPNdelete"
			$TextboxResults.text = Remove-MsolUser –UserPrincipalName $GlobalUPNdelete | Format-List UserPrincipalName | Out-String -Width 2147483647
			$TextboxResults.Text = "$GlobalUPNdelete was deleted"
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Deleting $GlobalUPNdelete..."
			$textboxDetails.Text = "Remove-MsolUser –UserPrincipalName $GlobalUPNdelete -TenantId $TenantText"
			$TextboxResults.text = Remove-MsolUser –UserPrincipalName $GlobalUPNdelete -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List UserPrincipalName | Out-String -Width 2147483647
			$TextboxResults.Text = "$GlobalUPNdelete was deleted"
		}
		Else
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$GlobalUPNdelete was not deleted", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$GlobalUPNdelete was not deleted", "Info")
	}
	
}

$createANewUserToolStripMenuItem_Click = {
	$Firstname = Read-Host "Enter the First Name for the new user"
	$LastName = Read-Host "Enter the Last Name for the new user"
	$DisplayName = Read-Host "Enter the Display Name for the new user"
	$NewUser = Read-Host "Enter the UPN for the new user"
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Creating user $NewUser..."
		$textboxDetails.Text = "New-MsolUser -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName"
		$TextboxResults.text = New-MsolUser -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName | Format-List | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Creating user $NewUser..."
		$textboxDetails.Text = "New-MsolUser -TenantId $TenantText -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName"
		$TextboxResults.text = New-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $NewUser -FirstName $Firstname -LastName $LastName -DisplayName $DisplayName | Format-List | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not create the new user $newuser", "Error")
	}
}

$disableUserAccountToolStripMenuItem_Click = {
	#$BlockUser = Read-Host "Enter the UPN of the user you want to disable"
	$SelectUsersFormText = "Select the user you want to disable"
	Call-SelectUsersForm_psf
	$GlobalUPNdisable = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Disabling $GlobalUPNdisable..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential `$True"
		Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential $True
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdisable | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Disabling $GlobalUPNdisable..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential `$True -TenantId $TenantText"
		Set-MsolUser -UserPrincipalName $GlobalUPNdisable -blockcredential $True -TenantId $PartnerComboBox.SelectedItem.TenantID
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdisable -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not disable $GlobalUPNdisable", "Error")
	}
}

$enableAccountToolStripMenuItem_Click = {
	#$EnableUser = Read-Host "Enter the UPN of the user you want to enable"
	$SelectUsersFormText = "Select the user you want to enable"
	Call-SelectUsersForm_psf
	$GlobalUPNenable = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Enabling $GlobalUPNenable..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential `$False"
		Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential $False
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNenable | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Enabling $GlobalUPNenable..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential `$False -TenantId $TenantText"
		Set-MsolUser -UserPrincipalName $GlobalUPNenable -blockcredential $False -TenantId $PartnerComboBox.SelectedItem.TenantID
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNenable -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List DisplayName, BlockCredential | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could enable $EnableUser", "Error")
	}
}

$getDetailedMailboxInfoToolStripMenuItem_Click = {
	#$GetDetailedMailboxInfoUser = Read-Host "Enter the UPN of the user you want to view detailed info for"
	$SelectUsersFormText = "Select the user you want to get detailed mailbox information for"
	Call-SelectUsersForm_psf
	$GlobalUPNdetailedmailbox = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Getting detailed mailbox info for $GlobalUPNdetailedmailbox..."
		$textboxDetails.Text = "Get-mailbox -identity $GlobalUPNdetailedmailbox | Format-List"
		$TextboxResults.Text = Get-mailbox -identity $GlobalUPNdetailedmailbox | Format-List | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Last Logon

$getAllUsersLastLogonToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all users last logon timestamp..."
		$textboxDetails.Text = "Get-Mailbox | ForEach-Object { Get-MailboxStatistics `$_.Identity | Select-Object DisplayName, LastLogonTime } | Format-Table -AutoSize "
		$TextboxResults.Text = Get-Mailbox | ForEach-Object { Get-MailboxStatistics $_.Identity | Select-Object DisplayName, LastLogonTime } | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAUsersLastLogonToolStripMenuItem_Click = {
	$SelectUsersFormText = "Select the user you want to get get last logon timestamp for"
	Call-SelectUsersForm_psf
	$LastLogonUser = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Getting last logon timestamp for $LastLogonUser..."
		$textboxDetails.Text = "Get-MailboxStatistics $LastLogonUser | Select-Object DisplayName, LastLogonTime | Format-Table -AutoSize "
		$TextboxResults.Text = Get-MailboxStatistics $LastLogonUser | Select-Object DisplayName, LastLogonTime  | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#GAL

$hideAUserFromTheGALToolStripMenuItem_Click = {
	#$HidefromGALUser = Read-Host "Enter the UPN of the user you want to hide from the GAL"
	$SelectUsersFormText = "Select the user you want to hide from the Global Address List"
	Call-SelectUsersForm_psf
	$GlobalUPNhideGAL = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Hiding $GlobalUPNhideGAL from the GAL..."
		$textboxDetails.Text = "set-Mailbox -Identity $GlobalUPNhideGAL -HiddenFromAddressListsEnabled `$True"
		set-Mailbox -Identity $GlobalUPNhideGAL -HiddenFromAddressListsEnabled $True
		$TextboxResults.Text = Get-Mailbox -Identity $GlobalUPNhideGAL | Format-List HiddenFromAddressListsEnabled | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getUsersThatAreHiddenFromTheGALToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all mailboxes hidden from the GAL..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.HiddenFromAddressListsEnabled -eq `$True } | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.HiddenFromAddressListsEnabled -eq $True } | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getUsersThatAreNotHiddenFromTheGALToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all mailboxes not hidden from the GAL..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.HiddenFromAddressListsEnabled -eq `$False } | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.HiddenFromAddressListsEnabled -eq $False } | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$unhideAUserFromTheGALToolStripMenuItem_Click = {
	#$unHidefromGALUser = Read-Host "Enter the UPN of the user you want to unhide from the GAL"
	$SelectUsersFormText = "Select the user you want to unhide from the GAL"
	Call-SelectUsersForm_psf
	$GlobalUPNunhideGAL = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Unhiding $GlobalUPNunhideGAL from the GAL..."
		$textboxDetails.Text = "set-Mailbox -Identity $GlobalUPNunhideGAL -HiddenFromAddressListsEnabled `$False"
		set-Mailbox -Identity $GlobalUPNunhideGAL -HiddenFromAddressListsEnabled $False
		$TextboxResults.Text = Get-Mailbox -Identity $GlobalUPNunhideGAL | Format-List HiddenFromAddressListsEnabled | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Quota

$getUserQuotaToolStripMenuItem_Click = {
	#$QuotaUser = Read-Host "Enter the Email of the user you want to view Quota information for"
	$SelectUsersFormText = "Select the user you want to view Quota information for"
	Call-SelectUsersForm_psf
	$GlobalUPNviewQuota = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting user quota for $GlobalUPNviewQuota..."
		$textboxDetails.Text = "Get-Mailbox $GlobalUPNviewQuota | Format-List DisplayName, UserPrincipalName, *Quota"
		$TextboxResults.text = Get-Mailbox $GlobalUPNviewQuota | Format-List DisplayName, UserPrincipalName, *Quota | Format-List | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllUsersQuotaToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting quota for all users..."
		$textboxDetails.Text = "Get-Mailbox | Format-List DisplayName, UserPrincipalName, *Quota -AutoSize"
		$TextboxResults.text = Get-Mailbox | Sort-Object DisplayName | Format-Table DisplayName, UserPrincipalName, *Quota -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$setUserMailboxQuotaToolStripMenuItem_Click = {
	#$MailboxSetQuota = Read-Host "Enter the UPN of the user you want to edit quota for"
	$SelectUsersFormText = "Select the user you want to edit quota for"
	Call-SelectUsersForm_psf
	$GlobalUPNeditQuota = $SelectUsersForm_comboboxUsers
	$ProhibitSendReceiveQuota = Read-Host "Enter (GB) the ProhibitSendReceiveQuota value (EX: 50GB) Max:50GB"
	$ProhibitSendQuota = Read-Host "Enter (GB) the ProhibitSendQuota value (EX: 48GB) Max:50GB"
	$IssueWarningQuota = Read-Host "Enter (GB) theIssueWarningQuota value (EX: 45GB) Max:50GB"
	Try
	{
		$TextboxResults.Text = "Setting quota for $GlobalUPNeditQuota... "
		$textboxDetails.Text = "Set-Mailbox $GlobalUPNeditQuota -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota -ProhibitSendQuota $ProhibitSendQuota -IssueWarningQuota $IssueWarningQuota"
		Set-Mailbox $GlobalUPNeditQuota -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota -ProhibitSendQuota $ProhibitSendQuota -IssueWarningQuota $IssueWarningQuota
		$TextboxResults.text = Get-Mailbox $GlobalUPNeditQuota | Format-List DisplayName, UserPrincipalName, *Quota | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$setMailboxQuotaForAllToolStripMenuItem_Click = {
	$ProhibitSendReceiveQuota2 = Read-Host "Enter (GB) the ProhibitSendReceiveQuota value (EX: 50GB) Max:50GB"
	$ProhibitSendQuota2 = Read-Host "Enter (GB) the ProhibitSendQuota value (EX: 48GB) Max:50GB"
	$IssueWarningQuota2 = Read-Host "Enter (GB) theIssueWarningQuota value (EX: 45GB) Max:50GB"
	Try
	{
		$TextboxResults.Text = "Setting quota for all... "
		$textboxDetails.Text = "Get-Mailbox | Set-Mailbox -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota2 -ProhibitSendQuota $ProhibitSendQuota2 -IssueWarningQuota $IssueWarningQuota2"
		Get-Mailbox | Set-Mailbox -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota2 -ProhibitSendQuota $ProhibitSendQuota2 -IssueWarningQuota $IssueWarningQuota2
		$TextboxResults.text = Get-Mailbox | Format-List DisplayName, UserPrincipalName, *Quota | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Licenses

$getLicensedUsersToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting all users with a license..."
		$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -eq `$TRUE } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize"
		$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -eq $True } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting all users with a license..."
		$textboxDetails.Text = "Get-MsolUser -All -TenantID $TenantText | Where-Object { `$_.isLicensed -eq `$TRUE } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize"
		$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.isLicensed -eq $True } | Sort-Object DisplayName | Format-Table DisplayName, Licenses -AutoSize | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not get license information", "Error")
	}
}

$displayAllUsersWithoutALicenseToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting all users without a license..."
		$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -like `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize"
		$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -like "False" } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting all users without a license..."
		$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -All | Where-Object { `$_.isLicensed -like `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize"
		$TextboxResults.text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Where-Object { $_.isLicensed -like $False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName -AutoSize | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not display users without a license", "Error")
	}
	
}

$removeAllUnlicensedUsersToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove all unlicensed users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$TextboxResults.Text = "Removing all users without a license..."
			$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.isLicensed -ne `$True } | Remove-MsolUser -Force"
			Get-MsolUser -All | Where-Object { $_.isLicensed -ne $True } | Remove-MsolUser -Force
			$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.isLicensed -like $True } | Format-List UserPrincipalName | Out-String -Width 2147483647
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Removing all users without a license..."
			$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -All | Where-Object { `$_.isLicensed -ne `$True } | Remove-MsolUser -Force"
			Get-MsolUser -all -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Where-Object { $_.isLicensed -ne $True } | Remove-MsolUser -Force -TenantId $PartnerComboBox.SelectedItem.TenantID
			$TextboxResults.text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Where-Object { $_.isLicensed -like $True } | Format-List UserPrincipalName | Out-String -Width 2147483647
		}
		Else
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("Could not remove all unlicensed users", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("No users were removed", "Info")
	}
	
}

$displayAllLicenseInfoToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting all license information..."
		$textboxDetails.Text = "Get-MsolAccountSku | Format-Table"
		$TextboxResults.text = Get-MsolAccountSku | Select-Object -Property AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, @{
			Name = 'Unused'
			Expression = {
				$_.ActiveUnits - $_.ConsumedUnits
			}
		} | Sort-Object Unused | Format-Table AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, Unused -AutoSize | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting all license information..."
		$textboxDetails.Text = "Get-MsolAccountSku -TenantId $TenantText | Format-Table"
		$TextboxResults.text = Get-MsolAccountSku -TenantId $PartnerComboBox.SelectedItem.TenantID | Select-Object -Property AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, @{
			Name = 'Unused'
			Expression = {
				$_.ActiveUnits - $_.ConsumedUnits
			}
		} | Sort-Object Unused | Format-Table AccountSkuId, ActiveUnits, WarningUnits, ConsumedUnits, Unused -AutoSize | Out-String -Width 2147483647
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		$TextboxResults.Text = ""
	}
}

$addALicenseToAUserToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		#$LicenseUserAdd = Read-Host "Enter the User Principal Name of the User you want to license"
		$SelectUsersFormText = "Select the user you want to add a license to"
		Call-SelectUnlicensedUsers_psf
		$LicenseUserAdd = $SelectUnlicensedUsers_comboboxSelectUnlicensedUsers
		
		#$LicenseUserAddLocation = Read-Host "Enter the 2 digit location code for the user. Example: US"
		$locationCodeText = "Select the 2 digit location code"
		Call-SelectLocationCode_psf
		$LicenseUserAddLocation = $SelectLocationCode_comboboxSelectLocationCode_SelectedItem
		
		#$TextboxResults.text = Get-MsolAccountSku | Format-Table | Out-String
		#$LicenseType = Read-Host "Enter the AccountSku of the License you want to assign to this user"
		$LicensesText = "Select a license for $LicenseUserAdd"
		Call-SelectLicenses_psf
		$LicenseType = $SelectLicenses_comboboxSelectAvailableLicenses
		
		$TextboxResults.Text = "Adding $LicenseType license to $LicenseUserAdd..."
		
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
Set-MsolUserLicense -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType"
		Set-MsolUser -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
		Set-MsolUserLicense -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType
		$TextboxResults.Text = Get-MsolUser -UserPrincipalName $LicenseUserAdd | Format-List DisplayName, Licenses | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		
		#$LicenseUserAdd = Read-Host "Enter the User Principal Name of the User you want to license"
		$SelectUsersFormText = "Select the user you want to add a license to"
		Call-SelectUnlicensedUsers_psf
		$LicenseUserAdd = $SelectUnlicensedUsers_comboboxSelectUnlicensedUsers
		
		#$LicenseUserAddLocation = Read-Host "Enter the 2 digit location code for the user. Example: US"
		$locationCodeText = "Select the 2 digit location code"
		Call-SelectLocationCode_psf
		$LicenseUserAddLocation = $SelectLocationCode_comboboxSelectLocationCode_SelectedItem
		
		#$TextboxResults.text = Get-MsolAccountSku -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-Table | Out-String
		#$LicenseType = Read-Host "Enter the AccountSku of the License you want to assign to this user"
		$LicensesText = "Select a license for $LicenseUserAdd"
		Call-SelectLicenses_psf
		$LicenseType = $SelectLicenses_comboboxSelectAvailableLicenses
		
		$TextboxResults.Text = "Adding $LicenseType license to $LicenseUserAdd..."
		$textboxDetails.Text = "Set-MsolUser -TenantId $TenantText -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
Set-MsolUserLicense -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType"
		Set-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $LicenseUserAdd –UsageLocation $LicenseUserAddLocation
		Set-MsolUserLicense -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $LicenseUserAdd -AddLicenses $LicenseType
		$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $LicenseUserAdd | Format-List DisplayName, Licenses | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeLicenseFromAUserToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		#$RemoveLicenseFromUser = Read-Host "Enter the User Principal Name of the user you want to remove a license from"
		$SelectUsersFormText = "Select the user you want to remove a license from"
		Call-SelectUsersForm_psf
		$RemoveLicenseFromUser = $SelectUsersForm_comboboxUsers

		#$TextboxResults.Text = Get-MsolUser -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String
		#$RemoveLicenseType = Read-Host "Enter the AccountSku of the license you want to remove"
		$UserLicenseText = "Select a license to remove from $RemoveLicenseFromUser"
		Call-SelectUserLicenses_psf
		$RemoveLicenseType = $SelectUserLicenses_comboboxSelectCurrentLicense
		$TextboxResults.Text = "Removing the $RemoveLicenseType license from $RemoveLicenseFromUser..."
	
		$textboxDetails.Text = "Set-MsolUserLicense -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType"
		Set-MsolUserLicense -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType
		$TextboxResults.Text = Get-MsolUser -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		
		#$RemoveLicenseFromUser = Read-Host "Enter the User Principal Name of the user you want to remove a license from"
		$SelectUsersFormText = "Select the user you want to remove a license from"
		Call-SelectUsersForm_psf
		$RemoveLicenseFromUser = $SelectUsersForm_comboboxUsers
		#$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String
		
		
		#$RemoveLicenseType = Read-Host "Enter the AccountSku of the license you want to remove"
		$UserLicenseText = "Select a license to remove from $RemoveLicenseFromUser"
		Call-SelectUserLicenses_psf
		$RemoveLicenseType = $SelectUserLicenses_comboboxSelectCurrentLicense
		$TextboxResults.Text = "Removing the $RemoveLicenseType license from $RemoveLicenseFromUser..."

		$textboxDetails.Text = "Set-MsolUserLicense -TenantId $TenantText -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType"
		Set-MsolUserLicense -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $RemoveLicenseFromUser -RemoveLicenses $RemoveLicenseType
		$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $RemoveLicenseFromUser | Format-List DisplayName, Licenses | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAUsersLicenseToolStripMenuItem_Click = {
	$licensedUsersText = "Select the user you want to view licenses for"
	Call-SelectLicensedUsers_psf
	$UserLicInfo = $SelectLicensedUsers_comboboxSelectlicensedUsers
	
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $UserLicInfo | Select-Object Licenses"
		$TextboxResults.Text = Get-MsolUser -UserPrincipalName $UserLicInfo | Select-Object Licenses | Format-Table -AutoSize | Out-String -Width 2147483647
		
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$textboxDetails.Text = "Get-MsolUser -UserPrincipalName $UserLicInfo -TenantId $TenantText | Select-Object Licenses"
		$TextboxResults.Text = Get-MsolUser -UserPrincipalName $UserLicInfo -TenantId $PartnerComboBox.SelectedItem.TenantID | Select-Object Licenses | Format-Table -AutoSize | Out-String -Width 2147483647
	}
}

	#Calendar Items

$AddCalendarPermissionsForAUserToolStripMenuItem_Click = {
	#$Calendaruser = Read-Host "Enter the UPN of the user whose Calendar you want to give access to"
	$SelectUsersFormText = "Select the user you want to modify calendar permissions for"
	Call-SelectUsersForm_psf
	$Calendaruserchangepermission = $SelectUsersForm_comboboxUsers
	
	#$Calendaruser2 = Read-Host "Enter the UPN of the user who you want to give access to"
	$SelectUsersFormText = "Select the user you want to give permission to $Calendaruserchangepermission calendar"
	Call-SelectUsersForm_psf
	$Calendarusergrantpermission = $SelectUsersForm_comboboxUsers
	
	#$TextboxResults.text = "Calendar Permissions: 
#Owner
#PublishingEditor
#Editor
#PublishingAuthor
#Author
#NonEditingAuthor
#Reviewer
#Contributor
#AvailabilityOnly
#LimitedDetails"
	#$level = Read-Host "Access Level?"
	
	$LabelPermissionsText = "Select the level of access you want $Calendaruserchangepermission to have on $Calendarusergrantpermission calendar"
	Call-AccessPermissions_psf
	$level = $AccessPermissions_comboboxPermissions_SelectedItem
	
	try
	{
		$TextboxResults.Text = "Adding $Calendarusergrantpermission to $Calendaruserchangepermission calender with $level permissions..."
		$textboxDetails.Text = "Add-MailboxFolderPermission -Identity ${Calendaruserchangepermission}:\calendar -user $Calendarusergrantpermission -AccessRights $level"
		Remove-MailboxFolderPermission -identity ${Calendaruserchangepermission}:\calendar -user $Calendarusergrantpermission -Confirm:$False
		Add-MailboxFolderPermission -Identity ${Calendaruserchangepermission}:\calendar -user $Calendarusergrantpermission -AccessRights $level
		$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${Calendaruserchangepermission}:\calendar | Sort-Object User, AccessRights | Format-Table User, AccessRights, Identity, FolderName, IsValid -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$GetUsersCalendarPermissionsToolStripMenuItem_Click = {
	#$CalUserPermissions = Read-Host "What user would you like calendar permissions for?"
	$SelectUsersFormText = "Select the user you want to view calendar permissions for"
	Call-SelectUsersForm_psf
	$CalUserPermissions = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Getting $CalUserPermissions calendar permissions..."
		$textboxDetails.Text = "Get-MailboxFolderPermission -Identity ${CalUserPermissions}:\calendar | Sort-Object User, AccessRights | Format-Table User, AccessRights, Identity, FolderName, IsValid -AutoSize"
		$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${CalUserPermissions}:\calendar | Sort-Object User, AccessRights | Format-Table User, AccessRights, Identity, FolderName, IsValid -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$AddASingleUserPermissionsOnAllCalendarsToolStripMenuItem_Click = {
	#$MasterUser = Read-Host "Enter the UPN of the user you want permission on all users calendars"
	$SelectUsersFormText = "Select the user you want permission on all users calendars"
	Call-SelectUsersForm_psf
	$MasterUser = $SelectUsersForm_comboboxUsers
	
	#$TextboxResults.text = "Calendar Permissions: 
#Owner
#PublishingEditor
#Editor
#PublishingAuthor
#Author
#NonEditingAuthor
#Reviewer
#Contributor
#AvailabilityOnly
#LimitedDetails"
	#$level2 = Read-Host "Access Level?"
	$LabelPermissionsText = "Select the level of access you want $MasterUser to have on all calendars"
	Call-AccessPermissions_psf
	$level2 = $AccessPermissions_comboboxPermissions_SelectedItem

	
	try
	{
		$TextboxResults.Text = "Adding $MasterUser to everyones calendars with $level2 permissions..."
		$textboxDetails.Text = "Get-Mailbox | Select-Object -ExpandProperty Alias
Foreach (`$user in `$users) { Add-MailboxFolderPermission `${user}:\Calendar -user $MasterUser -accessrights $level2 }﻿"
		$users = Get-Mailbox | Select-Object -ExpandProperty Alias
		Foreach ($user in $users) { Add-MailboxFolderPermission ${user}:\Calendar -user $MasterUser -accessrights $level2 }﻿
	}
	catch
	{
		#[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	$TextboxResults.Text = ""
	
}

$removeAUserFromAllCalendarsToolStripMenuItem_Click = {
	#$RemoveUserFromAll = Read-Host "Enter the UPN of the user you want to remove from all calendars"
	$SelectUsersFormText = "Select the user you want to remove from all calendars"
	Call-SelectUsersForm_psf
	$RemoveUserFromAll = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Removing $RemoveUserFromAll from all users calendar..."
		$textboxDetails.Text = "`$users = Get-Mailbox | Select-Object -ExpandProperty Alias
Foreach (`$user in `$users) { Remove-MailboxFolderPermission `${user}:\Calendar -user $RemoveUserFromAll -Confirm:`$false}﻿"
		$users = Get-Mailbox | Select-Object -ExpandProperty Alias
		Foreach ($user in $users) { Remove-MailboxFolderPermission ${user}:\Calendar -user $RemoveUserFromAll -Confirm:$false }﻿
	}
	catch
	{
		#[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	$TextboxResults.Text = ""
}

$removeAUserFromSomeonesCalendarToolStripMenuItem_Click = {
	#$Calendaruserremove = Read-Host "Enter the UPN of the user whose calendar you want to remove access to"
	$SelectUsersFormText = "Select the user you want to modify calendar permissions for"
	Call-SelectUsersForm_psf
	$GlobalCalUser = $SelectUsersForm_comboboxUsers
	
	#$Calendaruser2remove = Read-Host "Enter the UPN of the user who you want to remove access"
	$CalendarPermissionsText = "Select the user you want to remove from $GlobalCalUser calendar"
	Call-SelectUserCalendarPermissions_psf
	$Calendaruser2remove = $SelectUserCalendarPermissions_comboboxSelectCalendarPermissions
	try
	{
		$TextboxResults.Text = "Removing $Calendaruser2remove from $GlobalCalUser calendar..."
		$textboxDetails.Text = "Remove-MailboxFolderPermission -Identity ${GlobalCalUser}:\calendar -user $Calendaruser2remove"
		Remove-MailboxFolderPermission -Identity ${GlobalCalUser}:\calendar -user $Calendaruser2remove
		$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${GlobalCalUser}:\calendar | Sort-Object User, AccessRights | Format-Table User, AccessRights, Identity, FolderName, IsValid -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Calendar Repair

$disableCalendarRepairForAllUsersToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to disable Calendar Repair for all users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		Try
		{
			$TextboxResults.Text = "Disabling Calendar Repair for all mailboxes..."
			$TextboxDetails.Text = "Get-mailbox | Set-Mailbox -CalendarRepairDisabled `$true"
			Get-mailbox | Set-Mailbox -CalendarRepairDisabled $true
			$TextboxResults.Text = Get-Mailbox | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
		}
		Catch
		{
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
			$TextboxResults.Text = "Enabling Calendar Repair for all mailboxes..."
			$TextboxDetails.Text = "Get-mailbox | Set-Mailbox -CalendarRepairDisabled `$false"
			Get-mailbox | Set-Mailbox -CalendarRepairDisabled $false
			$TextboxResults.Text = Get-Mailbox | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
		}
		Catch
		{
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
	$SelectUsersFormText = "Select the user you want disable Calendar Repair for"
	Call-SelectUsersForm_psf
	$DisableCalRepairUser = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Disabling Calendar Repair for $DisableCalRepairUser..."
		$TextboxDetails.Text = "Set-Mailbox -identity $DisableCalRepairUser -CalendarRepairDisabled `$true"
		Set-Mailbox -identity $DisableCalRepairUser -CalendarRepairDisabled $true
		$TextboxResults.Text = Get-Mailbox -identity $DisableCalRepairUser | Select-Object DisplayName, CalendarRepairDisabled | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$TextboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableCalendarRepairForAUserToolStripMenuItem_Click = {
	$SelectUsersFormText = "Select the user you want disable Calendar Repair for"
	Call-SelectUsersForm_psf
	$EnableCalRepairUser = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Disabling Calendar Repair for $EnableCalRepairUser..."
		$TextboxDetails.Text = "Set-Mailbox -identity $EnableCalRepairUser -CalendarRepairDisabled `$false"
		Set-Mailbox -identity $EnableCalRepairUser -CalendarRepairDisabled $false
		$TextboxResults.Text = Get-Mailbox -identity $EnableCalRepairUser | Select-Object DisplayName, CalendarRepairDisabled | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$TextboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$getAllUsersWithCalendarRepairEnabledToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all users that have Calendar Repair enabled..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.CalendarRepairDisabled -eq `$false | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.CalendarRepairDisabled -eq $false } | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$TextboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllUsersWithCalendarRepairDisabledToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all users that have Calendar Repair enabled..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.CalendarRepairDisabled -eq `$true | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.CalendarRepairDisabled -eq $true } | Select-Object DisplayName, CalendarRepairDisabled | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$TextboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getCalendarRepairInfoForAUserToolStripMenuItem_Click = {
	$SelectUsersFormText = "Select the user you want get Calendar Repair info for"
	Call-SelectUsersForm_psf
	$CalRepairUserinfo = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Getting Calendar Repair info for $CalRepairUserinfo..."
		$TextboxDetails.Text = "Get-Mailbox -identity $CalRepairUserinfo | Select-Object DisplayName, CalendarRepairDisabled"
		$TextboxResults.Text = Get-Mailbox -identity $CalRepairUserinfo | Select-Object DisplayName, CalendarRepairDisabled | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$TextboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Clutter

$disableClutterForAllToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Disabling Clutter for all users..."
		$textboxDetails.Text = "Get-Mailbox | Set-Clutter -Enable `$false | Format-Table MailboxIdentity, IsEnabled -AutoSize"
		$TextboxResults.text = Get-Mailbox | Set-Clutter -Enable $false | Format-Table MailboxIdentity, IsEnabled -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$enableClutterForAllToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Enabling Clutter for all users..."
		$textboxDetails.Text = "Get-Mailbox | Set-Clutter -Enable `$True | Format-List MailboxIdentity, IsEnabled -AutoSize"
		$TextboxResults.text = Get-Mailbox | Set-Clutter -Enable $True | Format-Table MailboxIdentity, IsEnabled -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$enableClutterForAUserToolStripMenuItem_Click = {
	#$UserEnableClutter = Read-Host "Which user would you like to enable Clutter for?"
	$SelectUsersFormText = "Select the user you want to enable clutter for"
	Call-SelectUsersForm_psf
	$GlobalUPNenableClutter = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Enabling Clutter for $GlobalUPNenableClutter..."
		$textboxDetails.Text = "Get-Mailbox $GlobalUPNenableClutter | Set-Clutter -Enable `$True"
		$TextboxResults.text = Get-Mailbox $GlobalUPNenableClutter | Set-Clutter -Enable $True | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableClutterForAUserToolStripMenuItem_Click = {
	#$UserDisableClutter = Read-Host "Which user would you like to disable Clutter for?"
	$SelectUsersFormText = "Select the user you want to disable clutter for"
	Call-SelectUsersForm_psf
	$GlobalUPNdisableClutter = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Disabling Clutter for $GlobalUPNdisableClutter..."
		$textboxDetails.Text = "Get-Mailbox $GlobalUPNdisableClutter | Set-Clutter -Enable `$False"
		$TextboxResults.text = Get-Mailbox $GlobalUPNdisableClutter | Set-Clutter -Enable $False | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getClutterInfoForAUserToolStripMenuItem_Click = {
	#$GetCluterInfoUser = Read-Host "What user would you like to view Clutter information about?"
	$SelectUsersFormText = "Select the user you want to get clutter information for"
	Call-SelectUsersForm_psf
	$GlobalUPNinfoClutter = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Getting Clutter information for $GlobalUPNinfoClutter..."
		$textboxDetails.Text = "Get-Clutter -Identity $GlobalUPNinfoClutter"
		$TextboxResults.Text = Get-Clutter -Identity $GlobalUPNinfoClutter | Format-Table MailboxIdentity, IsEnabled -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Recycle Bin

$displayAllDeletedUsersToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting all deleted users..."
		$textboxDetails.Text = "Get-MsolUser -All -ReturnDeletedUsers |  Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize "
		$TextboxResults.Text = Get-MsolUser -All -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String -Width 2147483647
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting all deleted users..."
		$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText -ReturnDeletedUsers |  Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize "
		$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID -ReturnDeletedUsers | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, ObjectID -AutoSize | Out-String -Width 2147483647
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("Could not display users without a license", "Error")
	}
}

$deleteAllUsersInRecycleBinToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete all users in the recycle bin?.", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$TextboxResults.Text = "Deleting all users in the recycle bin..."
			$textboxDetails.Text = "Get-MsolUser -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin –Force"
			$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin –Force | Format-List | Out-String
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Deleting all users in the recycle bin..."
			$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin –Force"
			$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin –Force | Format-List | Out-String
		}
		Else
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("Could not display users without a license", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("All users in the recycle bin have not been deleted", "Info")
	}
	
}

$deleteSpecificUsersInRecycleBinToolStripMenuItem_Click = {
	#$DeletedUserRecycleBin = Read-Host "Please enter the User Principal Name of the user you want to permanently delete"
	$AliasRecycleBinText = "Select the user you want to delete from the recycle bin"
	Call-SelectUserRecycleBin_psf
	$GlobalUPNdeleteRecycle = $SelectUserRecycleBin_comboboxSelectRecycleBin
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $GlobalUPNdeleteRecycle ?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$TextboxResults.Text = "Deleting  $GlobalUPNdeleteRecycle from the recycle bin..."
			$textboxDetails.Text = "Remove-MsolUser -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force"
			Remove-MsolUser -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force
			$TextboxResults.Text = "Getting users in the recycle bin..."
			$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Deleting  $GlobalUPNdeleteRecycle from the recycle bin..."
			$textboxDetails.Text = "Remove-MsolUser -TenantId $TenantText -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force"
			Remove-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPNdeleteRecycle -RemoveFromRecycleBin -Force
			$TextboxResults.Text = "Getting users in the recycle bin..."
			$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String
		}
		Else
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$GlobalUPNdeleteRecycle was not deleted", "Info")
	}
}

$restoreDeletedUserToolStripMenuItem_Click = {
	#$RestoredUserFromRecycleBin = Read-Host "Enter the User Principal Name of the user you want to restore"
	$SelectUsersFormText = "Select the user you want to restore from the recycle bin"
	Call-SelectUsersForm_psf
	$GlobalUPNrestoreuser = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Restoring $GlobalUPNrestoreuser from the recycle bin..."
		$textboxDetails.Text = "Restore-MsolUser –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts"
		Restore-MsolUser –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts
		$TextboxResults.Text = "Getting list of deleted users"
		$TextboxResults.Text = Get-MsolUser -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Restoring $GlobalUPNrestoreuser from the recycle bin..."
		$textboxDetails.Text = "Restore-MsolUser -TenantId $TenantText –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts"
		Restore-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID –UserPrincipalName $GlobalUPNrestoreuser -AutoReconcileProxyConflicts
		$TextboxResults.Text = "Getting list of deleted users"
		$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -ReturnDeletedUsers | Sort-Object UserprincipalName | Format-Table UserPrincipalName, ObjectID -Autosize | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$restoreAllDeletedUsersToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Restoring all deleted users..."
		$textboxDetails.Text = "Get-MsolUser -All -ReturnDeletedUsers | Restore-MsolUser"
		Get-MsolUser -ReturnDeletedUsers -All | Restore-MsolUser
		$TextboxResults.Text = "Users that were deleted have now been restored"
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Restoring all deleted users..."
		$textboxDetails.Text = "Get-MsolUser -ReturnDeletedUsers -TenantID $TenantText -All | Restore-MsolUser"
		Get-MsolUser -ReturnDeletedUsers -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Restore-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID
		$TextboxResults.Text = "Users that were deleted have now been restored"
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Quarentine

$getQuarantineBetweenDatesToolStripMenuItem_Click = {
	#$StartDateQuarentine = Read-Host "Enter the beginning date. (Format MM/DD/YYYY)"
	$StartDateText = "Select the beginning date to view quarantine"
	$StartDateFormText = "Start Date"
	Call-SelectDatePicker_psf
	$startdate = $SelectDatePicker_monthcalendar1
	$StartDateQuarentine = "$startdate".trimend('00:00:00')
	
	#$EndDateQuarentine = Read-Host "Enter the end date. (Format MM/DD/YYYY)"
	$StartDateText = "Select the ending date to view quarantine"
	$StartDateFormText = "End Date"
	Call-SelectDatePicker_psf
	$enddate = $SelectDatePicker_monthcalendar1
	$EndDateQuarentine = "$enddate".trimend('00:00:00')
	try
	{
		$TextboxResults.Text = "Getting quarantine between $StartDateQuarentine and $EndDateQuarentine..."
		$textboxDetails.Text = "Get-QuarantineMessage -StartReceivedDate $StartDateQuarentine -EndReceivedDate $EndDateQuarentine | Format-List ReceivedTime, SenderAddress, RecipientAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction "
		$TextboxResults.Text = Get-QuarantineMessage -StartReceivedDate $StartDateQuarentine -EndReceivedDate $EndDateQuarentine | Format-List ReceivedTime, SenderAddress, RecipientAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getQuarantineFromASpecificUserToolStripMenuItem_Click = {
	$QuarentineFromUser = Read-Host "Enter the email address you want to see quarentine from"
	try
	{
		$TextboxResults.Text = "Getting quarantine sent from $QuarentineFromUser ..."
		$textboxDetails.Text = "Get-QuarantineMessage -SenderAddress $QuarentineFromUser | Format-List ReceivedTime, SenderAddress, RecipientAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction"
		$TextboxResults.Text = Get-QuarantineMessage -SenderAddress $QuarentineFromUser | Format-List ReceivedTime, SenderAddress, RecipientAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getQuarantineToASpecificUserToolStripMenuItem_Click = {
	#$QuarentineInfoForUser = Read-Host "Enter the email of the user you want to view quarantine for"
	$AllUsersEmailsText = "Select the email address or enter in one you want to view quarantine for"
	Call-SelectAllEmailPrimaryAddresses_psf
	$QuarentineInfoForUser = $SelectAllEmailPrimaryAddresses_comboboxSelectAllEmailAddresses
	try
	{
		$TextboxResults.Text = "Getting quarantine sent to $QuarentineInfoForUser..."
		$textboxDetails.Text = " Get-QuarantineMessage -RecipientAddress $QuarentineInfoForUser | Format-List ReceivedTime, SenderAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction"
		$TextboxResults.Text = Get-QuarantineMessage -RecipientAddress $QuarentineInfoForUser | Format-List ReceivedTime, SenderAddress, Subject, Size, Type, Expires, QuarantinedUser, ReleasedUser, Direction | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Passwords

$enableStrongPasswordForAUserToolStripMenuItem_Click = {
	#$UserEnableStrongPasswords = Read-Host "Enter the User Principal Name of the user you want to enable strong password policy for"
	$SelectUsersFormText = "Select the user you want to enable strong password policy for"
	Call-SelectUsersForm_psf
	$GlobalUPNespp = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Enabling strong password policy for $GlobalUPNespp..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired `$True"
		Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired $True
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNespp | Format-List UserPrincipalName, StrongPasswordRequired | Out-String
		
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Enabling strong password policy for $GlobalUPNespp..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired `$True -TenantId $TenantText"
		Set-MsolUser -UserPrincipalName $GlobalUPNespp -StrongPasswordRequired $True -TenantId $PartnerComboBox.SelectedItem.TenantID
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNespp -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List UserPrincipalName, StrongPasswordRequired | Out-String
		
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllUsersStrongPasswordPolicyInfoToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting strong password policy for all users..."
		$textboxDetails.Text = "Get-MsolUser -All | Sort-Object DisplayName | Format-Table DisplayName, strongpasswordrequired -AutoSize"
		$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting strong password policy for all users..."
		$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize"
		$TextboxResults.text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Sort-Object DisplayName | Format-Table DisplayName, strongpasswordrequired -AutoSize | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableStrongPasswordsForAUserToolStripMenuItem_Click = {
	#$UserdisableStrongPasswords = Read-Host "Enter the User Principal Name of the user you want to disable strong password policy for"
	$SelectUsersFormText = "Select the user you want to disable strong password policy for"
	Call-SelectUsersForm_psf
	$GlobalUPNdspp = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Disabling strong password policy for $GlobalUPNdspp..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired `$False"
		Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired $False
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdspp | Format-List UserPrincipalName, StrongPasswordRequired | Out-String
		
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Disabling strong password policy for $GlobalUPNdspp..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired `$False -TenantID $TenantText"
		Set-MsolUser -UserPrincipalName $GlobalUPNdspp -StrongPasswordRequired $False -TenantId $PartnerComboBox.SelectedItem.TenantID
		$TextboxResults.text = Get-MsolUser -UserPrincipalName $GlobalUPNdspp -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List UserPrincipalName, StrongPasswordRequired | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$enableStrongPasswordsForAllToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Enabling strong password policy for all users..."
		$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired `$True"
		Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired $True
		$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Enabling strong password policy for all users..."
		$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Set-MsolUser -StrongPasswordRequired -TenantId $TenantText `$True"
		Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Set-MsolUser -StrongPasswordRequired $True -TenantId $PartnerComboBox.SelectedItem.TenantID
		$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableStrongPasswordsForAllToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Disabling strong password policy for all users..."
		$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired `$False"
		Get-MsolUser -All | Set-MsolUser -StrongPasswordRequired $False
		$TextboxResults.text = Get-MsolUser -All | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Disabling strong password policy for all users..."
		$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Set-MsolUser -StrongPasswordRequired `$False -TenantId $TenantText"
		Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Set-MsolUser -StrongPasswordRequired $False -TenantId $PartnerComboBox.SelectedItem.TenantID
		$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object DisplayName | Format-Table  DisplayName, strongpasswordrequired -AutoSize | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$resetPasswordForAUserToolStripMenuItem1_Click = {
	#$ResetPasswordUser = Read-Host "Enter the UPN of the user you want to reset the password for"
	$SelectUsersFormText = "Select the user you want to reset the password for"
	Call-SelectUsersForm_psf
	$GlobalUPNrpp = $SelectUsersForm_comboboxUsers
	$NewPassword = Read-Host "What would you like the new password to be?"
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Resetting $GlobalUPNrpp password to $NewPassword..."
		$textboxDetails.Text = "Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword `$False"
		Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword $False
		$TextboxResults.Text = "The password for $GlobalUPNrpp has been set to $NewPassword"
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Resetting $GlobalUPNrpp password to $NewPassword..."
		$textboxDetails.Text = "Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword `$False -TenantId $TenantText"
		Set-MsolUserPassword –UserPrincipalName $GlobalUPNrpp –NewPassword $NewPassword -ForceChangePassword $False -TenantId $PartnerComboBox.SelectedItem.TenantID
		$TextboxResults.Text = "The password for $GlobalUPNrpp has been set to $NewPassword"
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$setPasswordToNeverExpireForAllToolStripMenuItem1_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to set everyones password to never expire?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$TextboxResults.Text = "Setting password to never expire for all..."
			$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires `$True"
			Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires $True
			$TextboxResults.text = Get-MSOLUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Setting password to never expire for all..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Set-MsolUser –PasswordNeverExpires `$True -TenantId $TenantText"
			Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Set-MsolUser –PasswordNeverExpires $True -TenantId $PartnerComboBox.SelectedItem.TenantID
			$TextboxResults.text = Get-MSOLUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String
		}
		Else
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("No changes have been made", "Info")
	}
}

$setPasswordToExpireForAllToolStripMenuItem1_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to set everyones password to expire?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$TextboxResults.Text = "Setting password to expire for all..."
			$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires `$False"
			Get-MsolUser -All | Set-MsolUser –PasswordNeverExpires $False
			$TextboxResults.text = Get-MSOLUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Setting password to expire for all..."
			$textboxDetails.Text = "Get-MsolUser -All -Tenant $TenantText | Set-MsolUser –PasswordNeverExpires `$False -TenantId $TenantText"
			Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Set-MsolUser –PasswordNeverExpires $False -TenantId $PartnerComboBox.SelectedItem.TenantID
			$TextboxResults.text = Get-MSOLUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires -AutoSize | Out-String
		}
		Else
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("No changes have been made", "Info")
	}
}

$resetPasswordForAllToolStripMenuItem_Click = {
	$SetPasswordforAll = Read-Host "What password would you like to set for all users?"
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to change all users password to $SetPasswordforAll", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$TextboxResults.Text = "Resetting all users passwords to $SetPasswordforAll..."
			$textboxDetails.Text = "Get-MsolUser -All | ForEach-Object{ 
Set-MsolUserPassword -userPrincipalName `$_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword `$False }"
			Get-MsolUser -All | ForEach-Object{ Set-MsolUserPassword -UserPrincipalName $_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword $False }
			$TextboxResults.Text = "Password for all users has been set to $SetPasswordforAll"
			
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Resetting all users passwords to $SetPasswordforAll..."
			$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | ForEach-Object{ 
Set-MsolUserPassword -TenantId $TenantText -userPrincipalName `$_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword `$False }"
			Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | ForEach-Object { Set-MsolUserPassword -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $_.UserPrincipalName –NewPassword $SetPasswordforAll -ForceChangePassword $False }
			$TextboxResults.Text = "Password for all users has been set to $SetPasswordforAll"
		}
		Else
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("No user passwords have not been changed", "Info")
	}
}

$setATemporaryPasswordForAllToolStripMenuItem_Click = {
	$SetTempPasswordforAll = Read-Host "What password would you like to set for all users?"
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want change all users passwords to $SetTempPasswordforAll", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		#What to do if connected to main o365 account
		If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
		{
			$TextboxResults.Text = "Setting $SetTempPasswordforAll as the temporary password for all users..."
			$textboxDetails.Text = "Get-MsolUser -All | Set-MsolUserPassword –NewPassword $SetTempPasswordforAll -ForceChangePassword `$True"
			Get-MsolUser -All | Set-MsolUserPassword –NewPassword $SetTempPasswordforAll -ForceChangePassword $True
			$TextboxResults.Text = "Temporary password has been set to $SetTempPasswordforAll Please note that users will be prompted to change it upon logon"
		}
		#What to do if connected to partner account
		ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
		{
			$TenantText = $PartnerComboBox.text
			$TextboxResults.Text = "Setting $SetTempPasswordforAll as the temporary password for all users..."
			$textboxDetails.Text = "Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Set-MsolUserPassword -TenantId $TenantText –NewPassword $SetTempPasswordforAll -ForceChangePassword `$True"
			Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All | Set-MsolUserPassword -TenantId $PartnerComboBox.SelectedItem.TenantID –NewPassword $SetTempPasswordforAll -ForceChangePassword $True
			$TextboxResults.Text = "Temporary password has been set to $SetTempPasswordforAll Please note that users will be prompted to change it upon logon"
		}
		Else
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("No user passwords have not been changed", "Info")
	}
}

$TemporaryPasswordForAUserToolStripMenuItem_Click = {
	#$ResetPasswordUser2 = Read-Host "Enter the UPN of the user you want to reset the password for"
	$SelectUsersFormText = "Select the user you want to reset the password for"
	Call-SelectUsersForm_psf
	$GlobalUPNrtp = $SelectUsersForm_comboboxUsers
	$NewPassword2 = Read-Host "What would you like the new password to be?"
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Setting $NewPassword2 as the temporary password for $GlobalUPNrtp..."
		$textboxDetails.Text = "Set-MsolUserPassword –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword `$True"
		Set-MsolUserPassword –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword $True
		$TextboxResults.Text = "Temporary password has been set to $NewPassword2 Please note that $GlobalUPNrtp will be prompted to change it upon logon"
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Setting $NewPassword2 as the temporary password for $GlobalUPNrtp..."
		$textboxDetails.Text = "Set-MsolUserPassword -TenantId $TenantText –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword `$True"
		Set-MsolUserPassword -TenantId $PartnerComboBox.SelectedItem.TenantID –UserPrincipalName $GlobalUPNrtp –NewPassword $NewPassword2 -ForceChangePassword $True
		$TextboxResults.Text = "Temporary password has been set to $NewPassword2 Please note that $GlobalUPNrtp will be prompted to change it upon logon"
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getPasswordResetDateForAUserToolStripMenuItem_Click = {
	#$GetPasswordInfoUser = Read-Host "Enter the UPN of the user you want to view the password last changed date for"
	$SelectUsersFormText = "Select the user you want to view last password changed date for"
	Call-SelectUsersForm_psf
	$GlobalUPNgpifu = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting last password reset date for $GlobalUPNgpifu..."
		$textboxDetails.Text = "Get-MsolUser -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp"
		$TextboxResults.Text = Get-MsolUser -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting last password reset date for $GlobalUPNgpifu..."
		$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp"
		$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -userprincipalname $GlobalUPNgpifu | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getPasswordLastResetDateForAllToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting last password reset date for all users..."
		$textboxDetails.Text = "Get-MsolUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize "
		$TextboxResults.Text = Get-MsolUser -All | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting last password reset date for all users..."
		$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize "
		$TextboxResults.Text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, lastpasswordchangetimestamp -AutoSize | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$setPasswordToExpireForAUserToolStripMenuItem_Click = {
	#$PasswordtoExpireforUser = Read-Host "Enter the UPN of the user you want the password to expire for"
	$SelectUsersFormText = "Select the user you want to set password to expire for"
	Call-SelectUsersForm_psf
	$GlobalUPNspte = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Setting password to expire for $GlobalUPNspte..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires `$False"
		Set-MsolUser -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires $False
		$TextboxResults.text = Get-MSOLUser -UserPrincipalName $GlobalUPNspte | Format-List UserPrincipalName, PasswordNeverExpires | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Setting password to expire for $GlobalUPNspte..."
		$textboxDetails.Text = "Set-MsolUser -TenantId $TenantText -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires `$False"
		Set-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPNspte –PasswordNeverExpires $False
		$TextboxResults.text = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $GlobalUPNspte | Format-List UserPrincipalName, PasswordNeverExpires | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$setPasswordToNeverExpireForAUserToolStripMenuItem_Click = {
	#$PasswordtoNeverExpireforUser = Read-Host "Enter the UPN of the user you want the password to never expire for"
	$SelectUsersFormText = "Select the user you want to set the password to never expire"
	Call-SelectUsersForm_psf
	$PasswordtoNeverExpireforUser = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Setting password to never expire for $PasswordtoNeverExpireforUser..."
		$textboxDetails.Text = "Set-MsolUser -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires `$True"
		Set-MsolUser -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires $True
		$TextboxResults.text = Get-MSOLUser -UserPrincipalName $PasswordtoNeverExpireforUser | Format-List UserPrincipalName, PasswordNeverExpires | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Setting password to never expire for $PasswordtoNeverExpireforUser..."
		$textboxDetails.Text = "Set-MsolUser -TenantId $TenantText -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires `$True"
		Set-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $PasswordtoNeverExpireforUser –PasswordNeverExpires $True
		$TextboxResults.text = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -UserPrincipalName $PasswordtoNeverExpireforUser | Format-List UserPrincipalName, PasswordNeverExpires | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getUsersWhosPasswordNeverExpiresToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting users where the password is set to never expire..."
		$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.PasswordNeverExpires -eq `$True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
		$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.PasswordNeverExpires -eq $True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting users where the password is set to never expire..."
		$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Where-Object { `$_.PasswordNeverExpires -eq `$True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
		$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.PasswordNeverExpires -eq $True } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getUsersWhosPasswordWillExpireToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting users where the password is set to expire..."
		$textboxDetails.Text = "Get-MsolUser -All | Where-Object { `$_.PasswordNeverExpires -eq `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
		$TextboxResults.text = Get-MsolUser -All | Where-Object { $_.PasswordNeverExpires -eq $False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting users where the password is set to expire..."
		$textboxDetails.Text = "Get-MsolUser -All -TenantId $TenantText | Where-Object { `$_.PasswordNeverExpires -eq `$False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires"
		$TextboxResults.text = Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID | Where-Object { $_.PasswordNeverExpires -eq $False } | Sort-Object UserPrincipalName | Format-Table UserPrincipalName, PasswordNeverExpires | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getPasswordLastResetDateForAUserToolStripMenuItem_Click = {
	#$GetPasswordInfoUser = Read-Host "Enter the UPN of the user you want to view the password last changed date for"
	$SelectUsersFormText = "Select the user you want to view password last changed date for"
	Call-SelectUsersForm_psf
	$GetPasswordInfoUser = $SelectUsersForm_comboboxUsers
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting last password reset date for $GetPasswordInfoUser..."
		$textboxDetails.Text = "Get-MsolUser -userprincipalname $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp"
		$TextboxResults.Text = Get-MsolUser -userprincipalname $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting last password reset date for $GetPasswordInfoUser..."
		$textboxDetails.Text = "Get-MsolUser -TenantId $TenantText -UserPrincipalName $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp"
		$TextboxResults.Text = Get-MsolUser -TenantId $PartnerComboBox.SelectedItem.TenantID -userprincipalname $GetPasswordInfoUser | Format-List UserPrincipalName, lastpasswordchangetimestamp | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getUsersNextPasswordResetDateToolStripMenuItem_Click = {
	#$NextUserResetDateUser = Read-Host "Enter the UPN of the user"
	$SelectUsersFormText = "Select the user you want to view next password reset date for"
	Call-SelectUsersForm_psf
	$NextUserResetDateUser = $SelectUsersForm_comboboxUsers
	$VarDate = Read-Host "Enter days before passwords expires. EX: 90"
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting $NextUserResetDateUser next password reset date..."
		$textboxDetails.Text = "(Get-MSOLUser -All -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime"
		$TextboxResults.Text = (Get-MSOLUser -All -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting $NextUserResetDateUser next password reset date..."
		$textboxDetails.Text = "(Get-MSOLUser -All -TenantId $TenantText -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime"
		$TextboxResults.Text = (Get-MsolUser -All -TenantId $PartnerComboBox.SelectedItem.TenantID -userprincipalname $NextUserResetDateUser).lastpasswordchangetimestamp.adddays($VarDate) | Format-List DateTime | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Mailbox Permissions

$addFullPermissionsToAMailboxToolStripMenuItem_Click = {
	$SelectUsersFormText = "Select the user you want to give full access to"
	Call-SelectUsersForm_psf
	$mailboxAccess = $SelectUsersForm_comboboxUsers
	#$mailboxAccess = read-host "Mailbox you want to give full-access to"
	
	$SelectUsersFormText = "Select the user you want to give full access to $mailboxAccess"
	Call-SelectUsersForm_psf
	$mailboxUser = $SelectUsersForm_comboboxUsers
	#$mailboxUser = read-host "Enter the UPN of the user that will have full access"
	try
	{
		$TextboxResults.Text = "Assigning full access permissions to $mailboxUser for the account $mailboxAccess..."
		$textboxDetails.Text = "Add-MailboxPermission $mailboxAccess -User $mailboxUser -AccessRights FullAccess -InheritanceType All"
		$TextboxResults.text = Add-MailboxPermission $mailboxAccess -User $mailboxUser -AccessRights FullAccess -InheritanceType All | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$addSendAsPermissionToAMailboxToolStripMenuItem_Click = {
	#$SendAsAccess = read-host "Mailbox you want to give Send As access to"
	$SelectUsersFormText = "Select the user you want to modify Send As access permissions for"
	Call-SelectUsersForm_psf
	$SendAsAccess = $SelectUsersForm_comboboxUsers
	
	#$mailboxUserAccess = read-host "Enter the UPN of the user that will have Send As access"
	$SelectUsersFormText = "Select the user you want to give Send As access to $SendAsAccess"
	Call-SelectUsersForm_psf
	$mailboxUserAccess = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Assigning Send-As access to $mailboxUserAccess for the account $SendAsAccess..."
		$textboxDetails.Text = "Add-RecipientPermission $SendAsAccess -Trustee $mailboxUserAccess -AccessRights SendAs"
		$TextboxResults.text = Add-RecipientPermission $SendAsAccess -Trustee $mailboxUserAccess -AccessRights SendAs | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$assignSendOnBehalfPermissionsForAMailboxToolStripMenuItem_Click = {
	#$SendonBehalfof = read-host "Mailbox you want to give Send on Behalf access to"
	$SelectUsersFormText = "Select the user you want to modify Send on Behalf permissions for"
	Call-SelectUsersForm_psf
	$SendonBehalfof = $SelectUsersForm_comboboxUsers
	
	#$mailboxUserSendonBehalfAccess = read-host "Enter the UPN of the user that will have Send As access"
	$SelectUsersFormText = "Select the user you want to give Send on Behalf permissions for $SendonBehalfof"
	Call-SelectUsersForm_psf
	$mailboxUserSendonBehalfAccess = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Assigning Send On Behalf of permissions to $mailboxUserSendonBehalfAccess for the account $SendonBehalfof..."
		$textboxDetails.Text = "Set-Mailbox -Identity $SendonBehalfof -GrantSendOnBehalfTo $mailboxUserSendonBehalfAccess"
		Set-Mailbox -Identity $SendonBehalfof -GrantSendOnBehalfTo $mailboxUserSendonBehalfAccess
		$TextboxResults.text = Get-Mailbox -Identity $SendonBehalfof | Format-List Identity, GrantSendOnBehalfTo | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$displayMailboxPermissionsForAUserToolStripMenuItem_Click = {
	#$MailboxUserFullAccessPermission = Read-Host "Enter the UPN of the user want to view Full Access permissions for"
	$SelectUsersFormText = "Select the user you want to view Full Access permissions for"
	Call-SelectUsersForm_psf
	$MailboxUserFullAccessPermission = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting Full Access permissions for $MailboxUserFullAccessPermission..."
		$textboxDetails.Text = "Get-MailboxPermission $MailboxUserFullAccessPermission | Where-Object { (`$_.IsInherited -eq `$False) -and (`$_.User -notcontains 'NT AUTHORITY\SELF') } | Sort-Object User | Format-Table -AutoSize"
		$TextboxResults.text = Get-MailboxPermission $MailboxUserFullAccessPermission | Where-Object { ($_.IsInherited -eq $False) -and ($_.User -notcontains 'NT AUTHORITY\SELF') } | Sort-Object User | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
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
	#$UserRemoveFullAccessRights = Read-Host "What user mailbox would you like modify Full Access rights to"
	$SelectUsersFormText = "Select the user you want to modify Full Access rights for"
	Call-SelectUsersForm_psf
	$UserRemoveFullAccessRights = $SelectUsersForm_comboboxUsers
	
	#$RemoveFullAccessRightsUser = Read-Host "Enter the UPN of the user you want to remove"
	$FullPermissionsText = "Select the user you want to remove"
	Call-SelectUserFullPermissions_psf
	$RemoveFullAccessRightsUser = $SelectUserFullPermissions_comboboxSelectFullAccessUsers

	try
	{
		$TextboxResults.Text = "Removing Full Access Permissions for $RemoveFullAccessRightsUser on account $UserRemoveFullAccessRights..."
		$textboxDetails.Text = "Remove-MailboxPermission  $UserRemoveFullAccessRights -User $RemoveFullAccessRightsUser -AccessRights FullAccess -Confirm:`$False -ea 1"
		Remove-MailboxPermission  $UserRemoveFullAccessRights -User $RemoveFullAccessRightsUser -AccessRights FullAccess -Confirm:$False -ea 1
		$TextboxResults.text = Get-MailboxPermission $UserRemoveFullAccessRights | Where-Object { ($_.IsInherited -eq $False) -and -not ($_.User -like "NT AUTHORITY\SELF") } | Sort-Object User | Format-Table | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$revokeSendAsPermissionsForAMailboxToolStripMenuItem_Click = {
	#$UserDeleteSendAsAccessOn = Read-Host "What user mailbox would you like to modify Send As permission for?"
	$SelectUsersFormText = "Select the user you want to modify Send As permissions for"
	Call-SelectUsersForm_psf
	$GlobalUserCurrentPermissions = $SelectUsersForm_comboboxUsers
	
	#$UserDeleteSendAsAccess = Read-Host "Enter the UPN of the user you want to remove Send As access to?"
	$CurrentMailboxPermissionsText = "Select the user you want to remove Send As access to"
	Call-SelectExistingMailboxPermissions_psf
	$UserDeleteSendAsAccess = $SelectExistingMailboxPermissions_comboboxSelectCurrentPermissions
	try
	{
		$TextboxResults.Text = "Removing Send As permission for $UserDeleteSendAsAccess on account $GlobalUserCurrentPermissions..."
		$textboxDetails.Text = "Remove-RecipientPermission $GlobalUserCurrentPermissions -AccessRights SendAs -Trustee $UserDeleteSendAsAccess"
		$TextboxResults.Text = Remove-RecipientPermission $GlobalUserCurrentPermissions -AccessRights SendAs -Trustee $UserDeleteSendAsAccess | Sort-Object User | Format-Table | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$viewAllMailboxesAUserHasFullAccessToToolStripMenuItem_Click = {
	#$ViewAllFullAccess = Read-Host "Enter the UPN of the account you want to view"
	$SelectUsersFormText = "Select the user you want to view"
	Call-SelectUsersForm_psf
	$ViewAllFullAccess = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting all mailboxes $ViewAllFullAccess has Full Access permissions to..."
		$textboxDetails.Text = "Get-Mailbox | Get-MailboxPermission -User $ViewAllFullAccess |  Sort-Object Identity | Format-Table"
		$TextboxResults.Text = Get-Mailbox | Get-MailboxPermission -User $ViewAllFullAccess | Sort-Object Identity | Format-Table | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$viewAllMailboxesAUserHasSendAsPermissionsToToolStripMenuItem_Click = {
	#$ViewSendAsAccess = Read-Host "Enter the UPN of the account you want to view"
	$SelectUsersFormText = "Select the user you want to view all accounts they have Send As permissions for"
	Call-SelectUsersForm_psf
	$ViewSendAsAccess = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting all mailboxes $ViewSendAsAccess has Send As permissions to..."
		$textboxDetails.Text = "Get-Mailbox | Get-RecipientPermission -Trustee $ViewSendAsAccess | Sort-Object Identity | Format-Table"
		$TextboxResults.Text = Get-Mailbox | Get-RecipientPermission -Trustee $ViewSendAsAccess | Sort-Object Identity | Format-Table | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$viewAllMailboxesAUserHasSendOnBehaldPermissionsToToolStripMenuItem_Click = {
	#$ViewSendonBehalf = Read-Host "Enter the Name of the account you want to view"
	$SelectUsersFormText = "Select the user you want to view all accounts they have Send On Behalf Of permissiosn for"
	Call-SelectUsersForm_psf
	$ViewSendonBehalf = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting all mailboxes $ViewSendonBehalf has Send On Behalf permissions to..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.GrantSendOnBehalfTo -match $ViewSendonBehalf } | Sort-Object DisplayName | Format-Table DisplayName, GrantSendOnBehalfTo, PrimarySmtpAddress, RecipientType"
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.GrantSendOnBehalfTo -match $ViewSendonBehalf } | Sort-Object DisplayName | Format-Table DisplayName, GrantSendOnBehalfTo, PrimarySmtpAddress, RecipientType | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeAllPermissionsToAMailboxToolStripMenuItem_Click = {
	#$UserDeleteAllAccessOn = Read-Host "What user mailbox would you like to modify permissions for?"
	$SelectUsersFormText = "Select the user you want to modify permissions for"
	Call-SelectUsersForm_psf
	$GlobalUserCurrentPermissions = $SelectUsersForm_comboboxUsers
	
	#$UserDeleteAllAccess = Read-Host "Enter the UPN of the user you want to remove access to?"
	$CurrentMailboxPermissionsText = "Select the user you want to remove access to"
	Call-SelectExistingMailboxPermissions_psf
	$UserDeleteAllAccess = $SelectExistingMailboxPermissions_comboboxSelectCurrentPermissions
	try
	{
		$TextboxResults.Text = "Removing all permissions for $UserDeleteAllAccess on account $GlobalUserCurrentPermissions..."
		$textboxDetails.Text = "Remove-MailboxPermission -Identity $GlobalUserCurrentPermissions -User $UserDeleteAllAccess -AccessRights FullAccess -InheritanceType All"
		$TextboxResults.Text = Remove-MailboxPermission -Identity $GlobalUserCurrentPermissions -User $UserDeleteAllAccess -AccessRights FullAccess -InheritanceType All
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Forwarding

$getAllUsersForwardinToInternalRecipientToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all users forwarding to internal users..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.ForwardingAddress -ne `$Null -and `$_.RecipientType -eq 'UserMailbox' } | Sort-Object Name | Format-Table Name, ForwardingAddress, DeliverToMailboxAndForward -AutoSize"
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.ForwardingAddress -ne $Null -and $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, ForwardingAddress, DeliverToMailboxAndForward -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardToInternalRecipientAndDontSaveLocalCopyToolStripMenuItem_Click = {
	#$UsertoFWD2 = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
	$SelectUsersFormText = "Select the user you want to modify fowarding for"
	Call-SelectUsersForm_psf
	$UsertoFWD2 = $SelectUsersForm_comboboxUsers
	
	#$Fwd2me2 = Read-Host "Enter the Name, Display Name, Alias, or Email Address of the user to forward to"
	$SelectUsersFormText = "Select the user you want $UsertoFWD2 to forward to"
	Call-SelectUsersForm_psf
	$Fwd2me2 = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Setting up forwarding from $UsertoFWD2 to $Fwd2me2..."
		$textboxDetails.Text = "Set-Mailbox  $UsertoFWD2 -ForwardingAddress $Fwd2me2 -DeliverToMailboxAndForward `$False"
		Set-Mailbox  $UsertoFWD2 -ForwardingAddress $Fwd2me2 -DeliverToMailboxAndForward $False
		$TextboxResults.Text = Get-Mailbox $UsertoFWD2 | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardToExternalAddressAndSaveLocalCopyToolStripMenuItem_Click = {
	#$UsertoFWD3 = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
	$SelectUsersFormText = "Select the user you want to modify fowarding for"
	Call-SelectUsersForm_psf
	$UsertoFWD3 = $SelectUsersForm_comboboxUsers
	
	$Fwd2me2External = Read-Host "Enter the external email address to forward to"
	Try
	{
		$TextboxResults.Text = "Setting up forwarding from $UsertoFWD3 to $Fwd2me2External..."
		$textboxDetails.Text = "Set-Mailbox $UsertoFWD3 -ForwardingsmtpAddress $Fwd2me2External -DeliverToMailboxAndForward `$true"
		Set-Mailbox $UsertoFWD3 -ForwardingsmtpAddress $Fwd2me2External -DeliverToMailboxAndForward $true
		$TextboxResults.Text = Get-Mailbox $UsertoFWD3 | Format-List Name, DeliverToMailboxAndForward, ForwardingSmtpAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardToExternalAddressAndDontSaveLocalCopyToolStripMenuItem_Click = {
	#$UsertoFWD4 = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
	$SelectUsersFormText = "Select the user you want to modify fowarding for"
	Call-SelectUsersForm_psf
	$UsertoFWD4  = $SelectUsersForm_comboboxUsers
	
	$Fwd2me2External2 = Read-Host "Enter the external email address to forward to"
	Try
	{
		$TextboxResults.Text = "Setting up forwarding from $UsertoFWD4 to $Fwd2me2External2..."
		$textboxDetails.Text = "Set-Mailbox $UsertoFWD4 -ForwardingsmtpAddress $Fwd2me2External2 -DeliverToMailboxAndForward `$False"
		Set-Mailbox $UsertoFWD4 -ForwardingsmtpAddress $Fwd2me2External2 -DeliverToMailboxAndForward $False
		$TextboxResults.Text = Get-Mailbox $UsertoFWD4 | Format-List Name, DeliverToMailboxAndForward, ForwardingSmtpAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getForwardingInfoForAUserToolStripMenuItem_Click = {
	#$UserFwdInfo = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user"
	$SelectUsersFormText = "Select the user you want view Forwarding information for"
	Call-SelectUsersForm_psf
	$UserFwdInfo = $SelectUsersForm_comboboxUsers
	
	Try
	{
		$TextboxResults.Text = "Getting forwarding info for $UserFwdInfo..."
		$textboxDetails.Text = "Get-Mailbox $UserFwdInfo | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress, ForwardingSmtpAddress"
		$TextboxResults.Text = Get-Mailbox $UserFwdInfo | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress, ForwardingSmtpAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeExternalForwadingForAUserToolStripMenuItem_Click = {
	#$RemoveFWDfromUserExternal = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address"
	$SelectUsersWithForwardingFormText = "Select the user you want remove forwarding for"
	Call-SelectExternalUsersWithForwarding_psf
	$RemoveFWDfromUserExternal = $SelectExternalUsersWithForwarding_comboboxUsersWithForwarding
	
	Try
	{
		$TextboxResults.Text = "Removing all external forwarding from $RemoveFWDfromUserExternal..."
		$textboxDetails.Text = "Set-Mailbox $RemoveFWDfromUserExternal -ForwardingSmtpAddress `$Null"
		Set-Mailbox $RemoveFWDfromUserExternal -ForwardingSmtpAddress $Null
		$TextboxResults.Text = Get-Mailbox $RemoveFWDfromUserExternal | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeAllForwardingForAUserToolStripMenuItem_Click = {
	#$RemoveAllFWDforUser = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address"
	$SelectUsersAllForwaringFormText = "Select the user you want to remove forwarding for"
	Call-SelectUsersAnyForwarding_psf
	$RemoveAllFWDforUser = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Removing all forwarding from $RemoveAllFWDforUser..."
		$textboxDetails.Text = "Set-Mailbox $RemoveAllFWDforUser -ForwardingAddress `$Null -ForwardingSmtpAddress `$Null"
		Set-Mailbox $RemoveAllFWDforUser -ForwardingAddress $Null -ForwardingSmtpAddress $Null
		$TextboxResults.Text = Get-Mailbox $RemoveAllFWDforUser | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress, ForwardingSmtpAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeInternalForwardingForUserToolStripMenuItem_Click = {
	#$RemoveFWDfromUser = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address"
	$SelectUsersInternalForwaringFormText = "Select the user to remove forwarding for"
	Call-SelectUsersInternalForwarding_psf
	$RemoveFWDfromUser = $SelectUsersInternalForwarding_comboboxUsersInternalForwarding
	Try
	{
		$TextboxResults.Text = "Removing all internal forwarding from $RemoveFWDfromUser..."
		$textboxDetails.Text = "Set-Mailbox $RemoveFWDfromUser -ForwardingAddress `$Null"
		Set-Mailbox $RemoveFWDfromUser -ForwardingAddress $Null
		$TextboxResults.Text = Get-Mailbox $RemoveFWDfromUser | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$forwardToInternalRecipientAndSaveLocalCopyToolStripMenuItem_Click = {
	#$UsertoFWD = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
	$SelectUsersFormText = "Select the user you want to modify fowarding for"
	Call-SelectUsersForm_psf
	$UsertoFWD = $SelectUsersForm_comboboxUsers
	
	#$Fwd2me = Read-Host "Enter the Name, Display Name, Alias, or Email Address of the user to forward to"
	$SelectUsersFormText = "Select the user you want to $UsertoFWD to forward to"
	Call-SelectUsersForm_psf
	$Fwd2me = $SelectUsersForm_comboboxUsers
	
	Try
	{
		$TextboxResults.Text = "Setting up forwarding from $UsertoFWD to $Fwd2me..."
		$textboxDetails.Text = "Set-Mailbox  $UsertoFWD -ForwardingAddress $Fwd2me -DeliverToMailboxAndForward `$True"
		Set-Mailbox  $UsertoFWD -ForwardingAddress $Fwd2me -DeliverToMailboxAndForward $True
		$TextboxResults.Text = Get-Mailbox $UsertoFWD | Format-List Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllUsersForwardingToExternalRecipientToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all users forwarding to external users..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.ForwardingSmtpAddress -ne `$Null -and `$_.RecipientType -eq 'UserMailbox' } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize"
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.ForwardingSmtpAddress -ne $Null -and $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
	
}

$removeAllForwardingForAllUsersToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove all forwarding from all users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		Try
		{
			$TextboxResults.Text = "Removing all forwarding from all users..."
			$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingAddress `$Null -ForwardingSmtpAddress `$Null"
			$AllMailboxes = Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingAddress $Null -ForwardingSmtpAddress $Null
			$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingAddress, ForwardingSmtpAddress -AutoSize | Out-String
		}
		Catch
		{
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

$removeExternalForwardingForAllUsersToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove external forwarding for all users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		Try
		{
			$TextboxResults.Text = "Removing all external forwarding from all users..."
			$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingSmtpAddress `$Null"
			Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingSmtpAddress $Null
			$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String
		}
		Catch
		{
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

$removeInternalForwardingForAllUsersToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove internal forwarding for all users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		Try
		{
			$TextboxResults.Text = "Removing all internal forwarding from all users..."
			$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingAddress `$Null"
			Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingAddress $Null
			$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingAddress -AutoSize | Out-String
		}
		Catch
		{
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

$forwardAllUsersEmailToExternalRecipientAndSaveALocalCopyToolStripMenuItem_Click = {
	$ForwardAllToExternal = Read-Host "Enter the email to forward all email to"
	Try
	{
		$TextboxResults.Text = "Setting up forwarding for all users to $ForwardAllToExternal..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingsmtpAddress $ForwardAllToExternal -DeliverToMailboxAndForward `$True"
		Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingsmtpAddress $ForwardAllToExternal -DeliverToMailboxAndForward $True
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardAllUsersEmailToExternalRecipientAndDontSaveALocalCopyToolStripMenuItem_Click = {
	$ForwardAllToExternal2 = Read-Host "Enter the email to forward all email to"
	Try
	{
		$TextboxResults.Text = "Setting up forwarding for all users to $ForwardAllToExternal2..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingsmtpAddress $ForwardAllToExternal2 -DeliverToMailboxAndForward `$False"
		Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingsmtpAddress $ForwardAllToExternal2 -DeliverToMailboxAndForward $False
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingSmtpAddress -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardAllUsersEmailToInternalRecipientAndSaveLocalCopyToolStripMenuItem_Click = {
	#$ForwardAllToInternal = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
	$SelectUsersFormText = "Select the user you want to forward all email to"
	Call-SelectUsersForm_psf
	$ForwardAllToInternal = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Setting up forwarding for all users to $ForwardAllToInternal..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingAddress $ForwardAllToInternal -DeliverToMailboxAndForward `$True"
		Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingAddress $ForwardAllToInternal -DeliverToMailboxAndForward $True
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$forwardAllUsersEmailToInternalRecipientAndDontSaveLocalCopyToolStripMenuItem_Click = {
	#$ForwardAllToInternal2 = Read-Host "Enter the users UPN, Display Name, Alias, or Email Address of the user to forward"
	$SelectUsersFormText = "Select the user you want to forward all email to"
	Call-SelectUsersForm_psf
	$ForwardAllToInternal2 = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Setting up forwarding for all users to $ForwardAllToInternal2..."
		$textboxDetails.Text = "Get-Mailbox | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-Mailbox -ForwardingAddress $ForwardAllToInternal2 -DeliverToMailboxAndForward `$True"
		Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Set-Mailbox -ForwardingAddress $ForwardAllToInternal2 -DeliverToMailboxAndForward $True
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientType -eq "UserMailbox" } | Sort-Object Name | Format-Table Name, DeliverToMailboxAndForward, ForwardingAddress | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Aliases

$addEmailAddressForAUserToolStripMenuItem_Click = {
	#$AddAliasforUser = Read-Host "Enter the UPN of the user you want to add an alias for"
	$SelectUsersFormText = "Select the user you want to add an alias for"
	Call-SelectUsersForm_psf
	$AddAliasforUser = $SelectUsersForm_comboboxUsers
	
	$AddAlias = Read-Host "Enter the alias address"
	Try
	{
		$TextboxResults.Text = "Adding $AddAlias as an alias for $AddAliasforUser..."
		$textboxDetails.Text = "Set-Mailbox $AddAliasforUser -EmailAddresses @{ add = '$AddAlias' }"
		Set-Mailbox $AddAliasforUser -EmailAddresses @{ add = $AddAlias }
		$TextboxResults.Text = "Getting all aliases for $AddAliasforUser..."
		$TextboxResults.Text = Get-Mailbox $AddAliasforUser | Format-List EmailAddresses | Out-String
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeAnEmailAddressForAUserToolStripMenuItem_Click = {
	#$RemoveAliasforUser = Read-Host "Enter the UPN of the user you want to remove an alias for"
	$SelectUsersFormText = "Select the user you want to remove an alias for"
	Call-SelectUsersForm_psf
	$EmailAddressUser = $SelectUsersForm_comboboxUsers
	
	$EmailAddressText = "Select the users alias you want to remove"
	Call-SelectEmailAddresses_psf
	$removeAlias = $SelectEmailAddresses_comboboxSelectEmailAddresses
	#$removeAlias = Read-Host "Enter the alias address"
	
	Try
	{
		$TextboxResults.Text = "Removing $removeAlias as an alias for $EmailAddressUser..."
		$textboxDetails.Text = "Set-Mailbox $EmailAddressUser -EmailAddresses @{ remove = '$removeAlias' }"
		Set-Mailbox $EmailAddressUser -EmailAddresses @{ remove = $removeAlias }
		$TextboxResults.Text = "Getting all aliases for $EmailAddressUser..."
		$TextboxResults.Text = Get-Mailbox $EmailAddressUser | Format-List EmailAddresses | Out-String
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAUsersEmailAddressesToolStripMenuItem_Click = {
	#$ViewAliasforaUser = Read-Host "Enter the UPN of the user you want to view email addresses for"
	$SelectUsersFormText = "Select the user you want to view all email addresses for"
	Call-SelectUsersForm_psf
	$ViewAliasforaUser = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Getting all email addresses for $ViewAliasforaUser..."
		$textboxDetails.Text = "Get-Mailbox -identity $ViewAliasforaUser | Format-List EmailAddresses"
		$TextboxResults.Text = Get-Mailbox -identity $ViewAliasforaUser | Format-List EmailAddresses | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}



###GROUPS###

	#Distribution Groups

$displayDistributionGroupsToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting all Distribution Groups..."
		$textboxDetails.Text = "Get-DistributionGroup | Where-Object { `$_.GroupType -notlike 'Universal, SecurityEnabled'} | Sort-Object DisplayName | Format-Table DisplayName -AutoSize"
		$TextboxResults.text = Get-DistributionGroup | Where-Object { $_.GroupType -notlike "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$createADistributionGroupToolStripMenuItem_Click = {
	$NewDistroGroup = Read-Host "What is the name of the new Distribution Group?"
	try
	{
		$TextboxResults.Text = "Creating the $NewDistroGroup Distribution Group..."
		$textboxDetails.Text = "New-DistributionGroup -Name $NewDistroGroup | Format-List"
		$TextboxResults.Text = New-DistributionGroup -Name $NewDistroGroup | Format-List | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$deleteADistributionGroupToolStripMenuItem_Click = {
	#$DeleteDistroGroup = Read-Host "Enter the name of the Distribtuion group you want deleted."
	$DistroGroupsText = "Select the Distribution Group you want to delete"
	Call-SelectDistroGroup_psf
	$DeleteDistroGroup = $SelectDistroGroup_comboboxSelectDistroGroups
	
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $DeleteDistroGroup ?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		try
		{
			$TextboxResults.Text = "Deleting the $DeleteDistroGroup Distribution Group..."
			$textboxDetails.Text = "Remove-DistributionGroup $DeleteDistroGroup"
			Remove-DistributionGroup $DeleteDistroGroup
			$TextboxResults.Text = "Getting list of distribution groups"
			$TextboxResults.text = Get-DistributionGroup | Where-Object { $_.GroupType -notlike "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName | Out-String
		}
		catch
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$DeleteDistroGroup was not deleted", "Info")
	}
}

$allowDistributionGroupToReceiveExternalEmailToolStripMenuItem_Click = {
	#$AllowExternalEmail = Read-Host "Enter the name of the Distribtuion Group you want to allow external email to"
	$DistroGroupsText = "Select the Distribution Group you want to allow External Email to"
	Call-SelectDistroGroup_psf
	$AllowExternalEmail = $SelectDistroGroup_comboboxSelectDistroGroups
	
	try
	{
		$TextboxResults.Text = "Allowing extneral senders for the $AllowExternalEmail Distribution Group..."
		$textboxDetails.Text = "Set-DistributionGroup $AllowExternalEmail -RequireSenderAuthenticationEnabled `$False"
		Set-DistributionGroup $AllowExternalEmail -RequireSenderAuthenticationEnabled $False
		$TextboxResults.text = Get-DistributionGroup $AllowExternalEmail | Format-List Name, RequireSenderAuthenticationEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$hideDistributionGroupFromGALToolStripMenuItem_Click = {
	#$GroupHideGAL = Read-Host "Enter the name of the Distribtuion Group you want to hide from the GAL"
	$DistroGroupsText = "Select the Distribution Group you want to hide from the Global Address List"
	Call-SelectDistroGroup_psf
	$GroupHideGAL = $SelectDistroGroup_comboboxSelectDistroGroups
	
	try
	{
		$TextboxResults.Text = "Hiding the $GroupHideGAL from the Global Address List..."
		$textboxDetails.Text = "Set-DistributionGroup $GroupHideGAL -HiddenFromAddressListsEnabled `$True"
		Set-DistributionGroup $GroupHideGAL -HiddenFromAddressListsEnabled $True
		$TextboxResults.text = Get-DistributionGroup $GroupHideGAL | Format-List Name, HiddenFromAddressListsEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$displayDistributionGroupMembersToolStripMenuItem_Click = {
	#$ListDistributionGroupMembers = Read-Host "Enter the name of the Distribution Group you want to list members of"
	$DistroGroupsText = "Select the Distribution Group you want to view the members of"
	Call-SelectDistroGroup_psf
	$ListDistributionGroupMembers = $SelectDistroGroup_comboboxSelectDistroGroups
	try
	{
		$TextboxResults.Text = "Getting all members of the $ListDistributionGroupMembers Distrubution Group..."
		$textboxDetails.Text = "Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize"
		$TextboxResults.Text = Get-DistributionGroupMember $ListDistributionGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$addAUserToADistributionGroupToolStripMenuItem_Click = {
	#$DistroGroupAdd = Read-Host "Enter the name of the Distribution Group"
	$DistroGroupsText = "Select the Distribution Group you want to add a user to"
	Call-SelectDistroGroup_psf
	$DistroGroupAdd = $SelectDistroGroup_comboboxSelectDistroGroups
	
	#$DistroGroupAddUser = Read-Host "Enter the UPN of the user you wish to add to $DistroGroupAdd"
	$SelectUsersFormText = "Select the user you want to add to $DistroGroupAdd"
	Call-SelectUsersForm_psf
	$DistroGroupAddUser = $SelectUsersForm_comboboxUsers
	
	try
	{
		$TextboxResults.Text = "Adding $DistroGroupAddUser to the $DistroGroupAdd Distribution Group..."
		$textboxDetails.Text = "Add-DistributionGroupMember -Identity $DistroGroupAdd -Member $DistroGroupAddUser"
		Add-DistributionGroupMember -Identity $DistroGroupAdd -Member $DistroGroupAddUser
		$TextboxResults.Text = "Getting members of $DistroGroupAdd..."
		$TextboxResults.Text = Get-DistributionGroupMember $DistroGroupAdd | Sort-Object DisplayName | Format-Table -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeAUserADistributionGroupToolStripMenuItem_Click = {
	#$DistroGroupRemove = Read-Host "Enter the name of the Distribution Group"
	$DistroGroupsText = "Select the Distribution Group you want to remove a user from"
	Call-SelectDistroGroup_psf
	$GlobalDistroGroupMembers = $SelectDistroGroup_comboboxSelectDistroGroups
	
	#$DistroGroupRemoveUser = Read-Host "Enter the UPN of the user you wish to remove from $GlobalDistroGroupMembers"
	$DistroGroupMembersText = "Select the User you want to remove from $GlobalDistroGroupMembers"
	Call-SelectDistroGroupMembers_psf
	$DistroGroupRemoveUser = $SelectDistroGroupMembers_comboboxSelectDistroGroupMembers
	
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove $DistroGroupRemoveUser from $GlobalDistroGroupMembers ?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		try
		{
			$TextboxResults.Text = "Removing $DistroGroupRemoveUser from the $GlobalDistroGroupMembers Distribution Group..."
			$textboxDetails.Text = "Remove-DistributionGroupMember -Identity $GlobalDistroGroupMembers -Member $DistroGroupRemoveUser"
			Remove-DistributionGroupMember -Identity $GlobalDistroGroupMembers -Member $DistroGroupRemoveUser
			$TextboxResults.Text = "Getting members of $GlobalDistroGroupMembers"
			$TextboxResults.Text = Get-DistributionGroupMember $GlobalDistroGroupMembers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String
		}
		catch
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$DistroGroupRemoveUser was not removed from $DistroGroupRemove ?", "Info")
	}
	
}

$addAllUsersToADistributionGroupToolStripMenuItem_Click = {
	$users = Get-Mailbox | Select-Object -ExpandProperty Alias
	#$AddAllUsersToSingleDistro = Read-Host "Enter the name of the Distribution Group you want to add all users to"
	$DistroGroupsText = "Select the Distribution Group you want to add all users to"
	Call-SelectDistroGroup_psf
	$AddAllUsersToSingleDistro = $SelectDistroGroup_comboboxSelectDistroGroups
	try
	{
		$TextboxResults.Text = "Adding all users to the $AddAllUsersToSingleDistro distribution group..."
		$textboxDetails.Text = "Foreach (`$user in `$users) { Add-DistributionGroupMember -Identity $AddAllUsersToSingleDistro -Member `$user }"
		Foreach ($user in $users) { Add-DistributionGroupMember -Identity $AddAllUsersToSingleDistro -Member $user }
		$TextboxResults.Text = "Getting members of $AddAllUsersToSingleDistro"
		$TextboxResults.Text = Get-DistributionGroupMember $AddAllUsersToSingleDistro | Sort-Object DisplayName | Format-Table -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getDetailedInfoForDistributionGroupToolStripMenuItem_Click = {
	#$DetailedInfoMailDistroGroup = Read-Host "Enter the group name"
	$DistroGroupsText = "Select the Distribution Group you want to view more information on"
	Call-SelectDistroGroup_psf
	$DetailedInfoMailDistroGroup = $SelectDistroGroup_comboboxSelectDistroGroups
	Try
	{
		$TextboxResults.Text = "Getting detailed info about the $DetailedInfoMailDistroGroup group..."
		$textboxDetails.Text = "Get-DistributionGroup $DetailedInfoMailDistroGroup | Format-List"
		$TextboxResults.text = Get-DistributionGroup $DetailedInfoMailDistroGroup | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$allowAllDistributionGroupsToReceiveExternalEmailToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Allowing extneral senders for all Distribution Groups..."
		$textboxDetails.Text = "Get-DistributionGroup | Set-DistributionGroup -RequireSenderAuthenticationEnabled `$False"
		Get-DistributionGroup | Set-DistributionGroup -RequireSenderAuthenticationEnabled $False
		$TextboxResults.text = Get-DistributionGroup | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$denyDistributionGroupFromReceivingExternalEmailToolStripMenuItem_Click = {
	#$DenyExternalEmail = Read-Host "Enter the name of the Distribtuion Group you want to deny external email to"
	$DistroGroupsText = "Select the Distribution Group you want to deny external email to"
	Call-SelectDistroGroup_psf
	$DenyExternalEmail = $SelectDistroGroup_comboboxSelectDistroGroups
	
	try
	{
		$TextboxResults.Text = "Denying extneral senders for the $DenyExternalEmail Distribution Group..."
		$textboxDetails.Text = "Set-DistributionGroup $DenyExternalEmail -RequireSenderAuthenticationEnabled `$True"
		Set-DistributionGroup $DenyExternalEmail -RequireSenderAuthenticationEnabled $True
		$TextboxResults.text = Get-DistributionGroup $DenyExternalEmail | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$denyAllDistributionGroupsFromReceivingExternalEmailToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Denying extneral senders for all Distribution Groups..."
		$textboxDetails.Text = "Get-DistributionGroup | Set-DistributionGroup -RequireSenderAuthenticationEnabled `$True"
		Get-DistributionGroup | Set-DistributionGroup -RequireSenderAuthenticationEnabled $True
		$TextboxResults.text = Get-DistributionGroup | Sort-Objects Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getExternalEmailStatusForADistributionGroupToolStripMenuItem_Click = {
	#$ExternalEmailStatus = Read-Host "Enter the Distribution Group"
	$DistroGroupsText = "Select the Distribution Group you want to view external email status for"
	Call-SelectDistroGroup_psf
	$ExternalEmailStatus = $SelectDistroGroup_comboboxSelectDistroGroups
	
	try
	{
		$TextboxResults.Text = "Getting external email status for $ExternalEmailStatus..."
		$textboxDetails.Text = "Get-DistributionGroup $ExternalEmailStatus | Format-List Name, RequireSenderAuthenticationEnabled"
		$TextboxResults.text = Get-DistributionGroup $ExternalEmailStatus | Format-List Name, RequireSenderAuthenticationEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getExternalEmailStatusForAllDistributionGroupsToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting external email status for all distribution groups..."
		$textboxDetails.Text = "Get-DistributionGroup | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize"
		$TextboxResults.text = Get-DistributionGroup | Sort-Object Name | Format-Table Name, RequireSenderAuthenticationEnabled -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Unified Groups

$getListOfUnifiedGroupsToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting list of all unified groups..."
		$textboxDetails.Text = "Get-UnifiedGroup | Sort-Object Name | Format-Table -AutoSize"
		$TextboxResults.Text = Get-UnifiedGroup | Sort-Object Name | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$listMembersOfAGroupToolStripMenuItem_Click = {
	#$GetUnifiedGroupMembers = Read-Host "Enter the name of the group you want to view members for."
	$SelectUnifiedGroupsText = "Select the Unified Group you want to view members for"
	Call-SelectUnifiedGroups_psf
	$GetUnifiedGroupMembers = $SelectUnifiedGroups_comboboxUnifiedGroups
	try
	{
		$TextboxResults.Text = "Getting all members of the $GetUnifiedGroupMembers group..."
		$textboxDetails.Text = "Get-UnifiedGroupLinks –Identity $GetUnifiedGroupMembers –LinkType Members | Sort-Object DisplayName | Format-Table DisplayName -AutoSize"
		$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $GetUnifiedGroupMembers –LinkType Members | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeAGroupToolStripMenuItem_Click = {
	#$RemoveUnifiedGroup = Read-Host "Enter the name of the group you want to remove"
	$SelectUnifiedGroupsText = "Select the Unified Group you want to remove"
	Call-SelectUnifiedGroups_psf
	$RemoveUnifiedGroup = $SelectUnifiedGroups_comboboxUnifiedGroups
	
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $RemoveUnifiedGroup ?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		try
		{
			$TextboxResults.Text = "Removing the $RemoveUnifiedGroup group..."
			$textboxDetails.Text = "Remove-UnifiedGroup $RemoveUnifiedGroup"
			Remove-UnifiedGroup $RemoveUnifiedGroup
			$TextboxResults.Text = "Getting list of unified groups..."
			$TextboxResults.Text = Get-UnifiedGroup | Sort-Object Name | Format-Table -AutoSize | Out-String
		}
		Catch
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$RemoveUnifiedGroup was not deleted", "Info")
	}
}

$addAUserToAGroupToolStripMenuItem_Click = {
	#$UnifiedGroupAddUser = Read-Host "Enter the name of the group you want to add a user to"
	$SelectUnifiedGroupsText = "Select the Unified Group you want to add a user to"
	Call-SelectUnifiedGroups_psf
	$UnifiedGroupAddUser = $SelectUnifiedGroups_comboboxUnifiedGroups
	
	#$UnifiedGroupUserAdd = Read-Host "Enter the UPN of the user you want to add to the $UnifiedGroupAddUser group."
	$SelectUsersFormText = "Select the user you want add to $UnifiedGroupAddUser"
	Call-SelectUsersForm_psf
	$UnifiedGroupUserAdd = $SelectUsersForm_comboboxUsers
	
	try
	{
		$TextboxResults.Text = "Adding $UnifiedGroupUserAdd as a member of the $UnifiedGroupAddUser group..."
		$textboxDetails.Text = "Add-UnifiedGroupLinks $UnifiedGroupAddUser –Links $UnifiedGroupUserAdd –LinkType Members"
		Add-UnifiedGroupLinks $UnifiedGroupAddUser –Links $UnifiedGroupUserAdd –LinkType Members
		$TextboxResults.Text = "Getting members for $UnifiedGroupAddUser..."
		$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $UnifiedGroupAddUser –LinkType Members | Sort-Object DisplayName | Format-Table DisplayName -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$createANewGroupToolStripMenuItem_Click = {
	$NewUnifiedGroupName = Read-Host "Enter the Display Name of the new group"
	
	#$NewUnifiedGroupAccessType = Read-Host "Enter the Access Type for the group $NewUnifiedGroupName (Public or Private)"
	$UnifiedGroupAccessTypeText = "Select the Access Type for the group $NewUnifiedGroupName"
	Call-SelectUnifiedGroupAccessType_psf
	$NewUnifiedGroupAccessType = $SelectUnifiedGroupAccessType_comboboxAccessType_SelectedItem
	
	try
	{
		$TextboxResults.Text = "Creating a the $NewUnifiedGroupName group..."
		$textboxDetails.Text = "New-UnifiedGroup –DisplayName $NewUnifiedGroupName -AccessType $NewUnifiedGroupAccessType"
		New-UnifiedGroup –DisplayName $NewUnifiedGroupName -AccessType $NewUnifiedGroupAccessType
		$TextboxResults.Text = Get-UnifiedGroup $NewUnifiedGroupName | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$listOwnersOfAGroupToolStripMenuItem_Click = {
	#$GetUnifiedGroupOwners = Read-Host "Enter the name of the group you want to view members for."
	$SelectUnifiedGroupsText = "Select the Unified Group you want to view owners for"
	Call-SelectUnifiedGroups_psf
	$GetUnifiedGroupOwners = $SelectUnifiedGroups_comboboxUnifiedGroups
	try
	{
		$TextboxResults.Text = "Getting all owners of the $GetUnifiedGroupOwners group..."
		$textboxDetails.Text = "Get-UnifiedGroupLinks –Identity $GetUnifiedGroupOwners –LinkType Owners | Format-List DisplayName | Format-Table -AutoSize"
		$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $GetUnifiedGroupOwners –LinkType Owners | Sort-Object DisplayName | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$listSubscribersOfAGroupToolStripMenuItem_Click = {
	#$GetUnifiedGroupSubscribers = Read-Host "Enter the name of the group you want to view members for."
	$SelectUnifiedGroupsText = "Select the Unified Group you want to view members for"
	Call-SelectUnifiedGroups_psf
	$GetUnifiedGroupSubscribers = $SelectUnifiedGroups_comboboxUnifiedGroups
	try
	{
		$TextboxResults.Text = "Getting all subscribers of the $GetUnifiedGroupSubscribers group..."
		$textboxDetails.Text = "Get-UnifiedGroupLinks –Identity $GetUnifiedGroupSubscribers –LinkType Subscribers | Sort-Object DisplayName | Format-Table -AutoSize"
		$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $GetUnifiedGroupSubscribers –LinkType Subscribers | Sort-Object DisplayName | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$addAnOwnerToAGroupToolStripMenuItem_Click = {
	#$TextboxResults.Text = "Important! The user must be a member of the group prior to becoming an owner"
	#$UnifiedGroupAddOwner = Read-Host "Enter the name of the group you want to modify ownership for"
	$SelectUnifiedGroupsText = "Select the Unified Group you want to modify ownership for"
	Call-SelectUnifiedGroups_psf
	$UnifiedGroupModify = $SelectUnifiedGroups_comboboxUnifiedGroups
	
	#$AddUnifiedGroupOwner = Read-Host "Enter the UPN of the user you want to become an owner"
	$UnifiedGroupMembersText = "Select the user you want to add as a owner to $UnifiedGroupModify"
	Call-SelectUnifiedGroupMembers_psf
	$AddUnifiedGroupOwner = $SelectUnifiedGroupMembers_comboboxUnifiedGroupMembers
	
	try
	{
		$TextboxResults.Text = "Adding $AddUnifiedGroupOwner as an owner of the $UnifiedGroupModify group..."
		$textboxDetails.Text = "Add-UnifiedGroupLinks -Identity $UnifiedGroupModify -LinkType Owners -Links $AddUnifiedGroupOwner"
		Add-UnifiedGroupLinks -Identity $UnifiedGroupModify -LinkType Owners -Links $AddUnifiedGroupOwner
		$TextboxResults.Text = "Getting list of owners for $UnifiedGroupModify..."
		$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $UnifiedGroupModify –LinkType Owners | Sort-Object DisplayName | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}

}

$addASubscriberToAGroupToolStripMenuItem_Click = {
	#$UnifiedGroupAddSubscriber = Read-Host "Enter the name of the group you want to add a subscriber for"
	$SelectUnifiedGroupsText = "Select the Unified Group you want to add a subscriber to"
	Call-SelectUnifiedGroups_psf
	$UnifiedGroupAddSubscriber = $SelectUnifiedGroups_comboboxUnifiedGroups
	
	#$AddUnifiedGroupSubscriber = Read-Host "Enter the UPN of the user you want to add as a subscriber"
	$SelectUsersFormText = "Select the user you want to add as a subscriber to $UnifiedGroupAddSubscriber"
	Call-SelectUsersForm_psf
	$AddUnifiedGroupSubscriber = $SelectUsersForm_comboboxUsers
	
	try
	{
		$TextboxResults.Text = "Adding $AddUnifiedGroupSubscriber as a subscriber to the $UnifiedGroupAddSubscriber group..."
		$textboxDetails.Text = "Add-UnifiedGroupLinks -Identity $UnifiedGroupAddSubscriber -LinkType Owners -Links $AddUnifiedGroupSubscriber"
		Add-UnifiedGroupLinks -Identity $UnifiedGroupAddSubscriber -LinkType Owners -Links $AddUnifiedGroupSubscriber
		$TextboxResults.Text = "Getting list of subscribers for $UnifiedGroupAddSubscriber..."
		$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $UnifiedGroupAddSubscriber –LinkType Subscribers | Sort-Object DisplayName | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeAMemberFromAGroupToolStripMenuItem_Click = {
	$SelectUnifiedGroupsText = "Select the Unified Group you want to remove a member from"
	Call-SelectUnifiedGroups_psf
	$UnifiedGroupModify = $SelectUnifiedGroups_comboboxUnifiedGroups
	
	$UnifiedGroupMembersText = "Select the user you want to remove from $UnifiedGroupModify"
	Call-SelectUnifiedGroupMembers_psf
	$RemoveUserFromUnifiedGroup = $SelectUnifiedGroupMembers_comboboxUnifiedGroupMembers
	
	Try
	{
		$TextboxResults.Text = "Removing $RemoveUserFromUnifiedGroup from the $UnifiedGroupModify group..."
		$textboxDetails.Text = "Remove-UnifiedGroupLinks -Identity $UnifiedGroupModify -LinkType Members -Links $RemoveUserFromUnifiedGroup"
		Remove-UnifiedGroupLinks -Identity $UnifiedGroupModify -LinkType Members -Links $RemoveUserFromUnifiedGroup
		$TextboxResults.Text = "Getting members of $UnifiedGroupModify..."
		$TextboxResults.Text = Get-UnifiedGroupLinks –Identity $UnifiedGroupModify –LinkType Members | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Security Groups

$createARegularSecurityGroupToolStripMenuItem_Click = {
	$SecurityGroupName = Read-Host "Enter a name for the new Security Group"
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Creating the $SecurityGroupName security group..."
		$textboxDetails.Text = "New-MsolGroup -DisplayName $SecurityGroupName | Format-List | Out-String"
		$TextboxResults.Text = New-MsolGroup -DisplayName $SecurityGroupName | Format-List | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Creating the $SecurityGroupName security group..."
		$textboxDetails.Text = "New-MsolGroup -DisplayName $SecurityGroupName -TenantId $TenantText"
		$TextboxResults.Text = New-MsolGroup -DisplayName $SecurityGroupName -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllRegularSecurityGroupsToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting list of all Security groups..."
		$textboxDetails.Text = "Get-MsolGroup -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize"
		$TextboxResults.Text = Get-MsolGroup -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting list of all Security groups..."
		$textboxDetails.Text = "Get-MsolGroup -TenantId $TenantText -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize"
		$TextboxResults.Text = Get-MsolGroup -TenantId $PartnerComboBox.SelectedItem.TenantID -GroupType Security | Sort-Object DisplayName | Format-Table DisplayName, GroupType -AutoSize | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllMailEnabledSecurityGroupsToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all Mail Enabled Security Groups..."
		$textboxDetails.Text = "Get-DistributionGroup | Where-Object { `$_.GroupType -like 'Universal, SecurityEnabled' } | Sort-Object DisplayName | Format-Table DisplayName, SamAccountName, GroupType, IsDirSynced, EmailAddresses -AutoSize "
		$TextboxResults.text = Get-DistributionGroup | Where-Object { $_.GroupType -like "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName, SamAccountName, GroupType, IsDirSynced, EmailAddresses -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$createAMailEnabledSecurityGroupToolStripMenuItem_Click = {
	$MailEnabledSecurityGroup = Read-Host "Enter the name of the security group"
	$MailEnabledSMTPAddress = Read-Host "Enter the primary SMTP address for $MailEnabledSecurityGroup"
	Try
	{
		$TextboxResults.Text = "Creating the $MailEnabledSecurityGroup security group..."
		$textboxDetails.Text = "New-DistributionGroup -Name $MailEnabledSecurityGroup -Type Security -PrimarySmtpAddress $MailEnabledSMTPAddress"
		$TextboxResults.Text = New-DistributionGroup -Name $MailEnabledSecurityGroup -Type Security -PrimarySmtpAddress $MailEnabledSMTPAddress | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$addAUserToAMailEnabledSecurityGroupToolStripMenuItem_Click = {
	#$MailEnabledGroupAdd = Read-Host "Enter the name of the Group"
	$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to add a user to"
	Call-SelectMailEnabledSecurityGroups_psf
	$MailEnabledGroupAdd = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
	
	#$MailEnabledGroupAddUser = Read-Host "Enter the UPN of the user you wish to add to $MailEnabledGroupAdd"
	$SelectUsersFormText = "Select the user you want to add to $MailEnabledGroupAdd"
	Call-SelectUsersForm_psf
	$MailEnabledGroupAddUser = $SelectUsersForm_comboboxUsers
	
	try
	{
		$TextboxResults.Text = "Adding $MailEnabledGroupAddUser to the $MailEnabledGroupAdd Group..."
		$textboxDetails.Text = "Add-DistributionGroupMember -Identity $MailEnabledGroupAdd -Member $MailEnabledGroupAddUser"
		Add-DistributionGroupMember -Identity $MailEnabledGroupAdd -Member $MailEnabledGroupAddUser
		$TextboxResults.Text = "Getting members of $MailEnabledGroupAdd..."
		$TextboxResults.Text = Get-DistributionGroupMember $MailEnabledGroupAdd | Sort-Object DisplayName | Format-Table Displayname -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$allowSecurityGroupToRecieveExternalMailToolStripMenuItem_Click = {
	#$AllowExternalEmailSecurity = Read-Host "Enter the name of the Group you want to allow external email to"
	$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to allow external email to"
	Call-SelectMailEnabledSecurityGroups_psf
	$AllowExternalEmailSecurity = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
	
	try
	{
		$TextboxResults.Text = "Allowing extneral senders for the $AllowExternalEmailSecurity Group..."
		$textboxDetails.Text = "Set-DistributionGroup $AllowExternalEmailSecurity -RequireSenderAuthenticationEnabled `$False"
		Set-DistributionGroup $AllowExternalEmailSecurity -RequireSenderAuthenticationEnabled $False
		$TextboxResults.text = Get-DistributionGroup $AllowExternalEmailSecurity | Format-List Name, RequireSenderAuthenticationEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getDetailedInfoForMailEnabledSecurityGroupToolStripMenuItem_Click = {
	#$DetailedInfoMailEnabledSecurityGroup = Read-Host "Enter the group name"
	$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to get detailed information for"
	Call-SelectMailEnabledSecurityGroups_psf
	$DetailedInfoMailEnabledSecurityGroup = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
	
	Try
	{
		$TextboxResults.Text = "Getting detailed info about the $DetailedInfoMailEnabledSecurityGroup group..."
		$textboxDetails.Text = "Get-DistributionGroup $DetailedInfoMailEnabledSecurityGroup | Format-List"
		$TextboxResults.text = Get-DistributionGroup $DetailedInfoMailEnabledSecurityGroup | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeMailENabledSecurityGroupToolStripMenuItem_Click = {
	#$DeleteMailEnabledSecurityGroup = Read-Host "Enter the name of the group you want deleted."
	$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to remove"
	Call-SelectMailEnabledSecurityGroups_psf
	$DeleteMailEnabledSecurityGroup = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
	
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $DeleteMailEnabledSecurityGroup ?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		try
		{
			$TextboxResults.Text = "Deleting the $DeleteMailEnabledSecurityGroup Group..."
			$textboxDetails.Text = "Remove-DistributionGroup $DeleteMailEnabledSecurityGroup"
			Remove-DistributionGroup $DeleteMailEnabledSecurityGroup
			$TextboxResults.Text = "Getting list of mail enabled security groups..."
			$TextboxResults.text = Get-DistributionGroup | Where-Object { $_.GroupType -like "Universal, SecurityEnabled" } | Sort-Object DisplayName | Format-Table DisplayName | Out-String
		}
		catch
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$DeleteMailEnabledSecurityGroup was not deleted", "Info")
	}
	
}

$denySecurityGroupFromRecievingExternalEmailToolStripMenuItem_Click = {
	#$DenyExternalEmailSecurity = Read-Host "Enter the name of the Group you want to deny external email to"
	$MailEnabledSecurityGroupText = "Select the Mail Enabled Security Group you want to deny external email to"
	Call-SelectMailEnabledSecurityGroups_psf
	$DenyExternalEmailSecurity = $SelectMailEnabledSecurityGroups_comboboxSelectMailEnabledSecurityGroups
	
	try
	{
		$TextboxResults.Text = "Denying extneral senders for the $DenyExternalEmailSecurity Group..."
		$textboxDetails.Text = "Set-DistributionGroup $DenyExternalEmailSecurity -RequireSenderAuthenticationEnabled `$True"
		Set-DistributionGroup $DenyExternalEmailSecurity -RequireSenderAuthenticationEnabled $True
		$TextboxResults.text = Get-DistributionGroup $DenyExternalEmailSecurity | Format-List Name, RequireSenderAuthenticationEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}



###RESOURCE MAILBOX###

	#Booking Options

$allowConflictMeetingsToolStripMenuItem_Click = {
	#$ConflictMeetingAllow = Read-Host "Enter the Room Name of the Resource Calendar you want to allow conflicts"
	$RoomMailboxText = "Select a room mailbox to allow conflict meetings for"
	Call-SelectRoomMailbox_psf
	$ConflictMeetingAllow = $SelectRoomMailbox_comboboxSelectRoomMailbox
	try
	{
		$TextboxResults.Text = "Allowing conflict meetings $ConflictMeetingAllow..."
		$textboxDetails.Text = "Set-CalendarProcessing $ConflictMeetingAllow -AllowConflicts `$True"
		Set-CalendarProcessing $ConflictMeetingAllow -AllowConflicts $True
		$TextboxResults.Text = Get-CalendarProcessing -identity $ConflictMeetingAllow | Format-List Identity, AllowConflicts | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$denyConflictMeetingsForAllResourceMailboxesToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Denying conflict meeting for all room calendars..."
		$textboxDetails.Text = "Get-MailBox | Where-Object { `$_.ResourceType -eq 'Room' } | Set-CalendarProcessing -AllowConflicts `$False"
		Get-MailBox | Where-Object { $_.ResourceType -eq "Room" } | Set-CalendarProcessing -AllowConflicts $False
		$TextboxResults.Text = Get-MailBox | Where-Object { $_.ResourceType -eq "Room" } | Get-CalendarProcessing | Sort-Object Identity | Format-Table Identity, AllowConflicts -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$allowConflicMeetingsForAllResourceMailboxesToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Allowing conflict meeting for all room calendars..."
		$textboxDetails.Text = "Get-MailBox | Where-Object { `$_.ResourceType -eq 'Room' } | Set-CalendarProcessing -AllowConflicts `$True"
		Get-MailBox | Where-Object { $_.ResourceType -eq "Room" } | Set-CalendarProcessing -AllowConflicts $True
		$TextboxResults.Text = Get-MailBox | Where-Object { $_.ResourceType -eq "Room" } | Get-CalendarProcessing | Sort-Object Identity | Format-Table Identity, AllowConflicts -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disallowconflictmeetingsToolStripMenuItem_Click = {
	#$ConflictMeetingDeny = Read-Host "Enter the Room Name of the Resource Calendar you want to disallow conflicts"
	$RoomMailboxText = "Select a room mailbox to disallow conflict meetings for"
	Call-SelectRoomMailbox_psf
	$ConflictMeetingDeny = $SelectRoomMailbox_comboboxSelectRoomMailbox
	try
	{
		$TextboxResults.Text = "Denying conflict meetings for $ConflictMeetingDeny..."
		$textboxDetails.Text = "Set-CalendarProcessing $ConflictMeetingDeny -AllowConflicts `$False"
		Set-CalendarProcessing $ConflictMeetingDeny -AllowConflicts $False
		$TextboxResults.Text = Get-CalendarProcessing -identity $ConflictMeetingDeny | Format-List Identity, AllowConflicts | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$enableAutomaticBookingForAllResourceMailboxToolStripMenuItem1_Click = {
	Try
	{
		$TextboxResults.Text = "Enabling automatic booking on all room calendars..."
		$textboxDetails.Text = "Get-MailBox | Where-Object { `$_.ResourceType -eq 'Room' } | Set-CalendarProcessing -AutomateProcessing:AutoAccept"
		Get-MailBox | Where-Object { $_.ResourceType -eq "Room" } | Set-CalendarProcessing -AutomateProcessing:AutoAccept
		$TextboxResults.Text = Get-MailBox | Where-Object { $_.ResourceType -eq "Room" } | Get-CalendarProcessing | Sort-Object Identity | Format-Table Identity, AutomateProcessing -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$GetRoomMailBoxCalendarProcessingToolStripMenuItem_Click = {
	#$RoomMailboxCalProcessing = Read-Host "Enter the Calendar Name you want to view calendar processing information for"
	$RoomMailboxText = "Select a room mailbox to view calendar processing for"
	Call-SelectRoomMailbox_psf
	$RoomMailboxCalProcessing = $SelectRoomMailbox_comboboxSelectRoomMailbox
	try
	{
		$TextboxResults.Text = "Getting calendar processing information for $RoomMailboxCalProcessing..."
		$textboxDetails.Text = "Get-Mailbox $RoomMailboxCalProcessing | Get-CalendarProcessing | Format-List"
		$TextboxResults.Text = Get-Mailbox $RoomMailboxCalProcessing | Get-CalendarProcessing | Format-List | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Room Mailbox

$convertAMailboxToARoomMailboxToolStripMenuItem_Click = {
	#$MailboxtoRoom = Read-Host "What user would you like to convert to a Room Mailbox? Please enter the full email address"
	$MailboxText = "Select a mailbox to convert to a room mailbox"
	Call-SelectMailboxes_psf
	$MailboxtoRoom = $SelectMailboxes_comboboxSelectMailbox
	Try
	{
		$TextboxResults.Text = "Converting $MailboxtoRoom to a Room Mailbox..."
		$textboxDetails.Text = "Set-Mailbox $MailboxtoRoom -Type Room"
		Set-Mailbox $MailboxtoRoom -Type Room
		$TextboxResults.Text = Get-MailBox $MailboxtoRoom | Format-List Name, ResourceType, PrimarySmtpAddress, EmailAddresses, UserPrincipalName, IsMailboxEnabled | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$createANewRoomMailboxToolStripMenuItem_Click = {
	$NewRoomMailbox = Read-Host "Enter the name of the new room mailbox"
	Try
	{
		$TextboxResults.Text = "Creating the $NewRoomMailbox Room Mailbox..."
		$textboxDetails.Text = "New-Mailbox -Name $NewRoomMailbox -Room "
		$TextboxResults.Text = New-Mailbox -Name $NewRoomMailbox -Room | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getListOfRoomMailboxesToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting list of all Room Mailboxes..."
		$textboxDetails.Text = "Get-MailBox | Where-Object { `$_.ResourceType -eq 'Room' } | Sort-Object Name | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailBox | Where-Object { $_.ResourceType -eq "Room" } | Sort-Object Name | Format-Table -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeARoomMailboxToolStripMenuItem_Click = {
	#$RemoveRoomMailbox = Read-Host "Enter the name of the room mailbox"
	$RoomMailboxText = "Select a room mailbox to remove"
	Call-SelectRoomMailbox_psf
	$RemoveRoomMailbox = $SelectRoomMailbox_comboboxSelectRoomMailbox
	
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove $RemoveRoomMailbox ?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		Try
		{
			$TextboxResults.Text = "Removing the $RemoveRoomMailbox Room Mailbox..."
			$textboxDetails.Text = "Remove-Mailbox $RemoveRoomMailbox"
			Remove-Mailbox $RemoveRoomMailbox
			$TextboxResults.Text = "Getting list of Room Mailboxes..."
			$TextboxResults.Text = Get-MailBox | Where-Object { $_.ResourceType -eq "Room" } | Sort-Object Name | Format-Table -AutoSize | Out-String
			
		}
		Catch
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$RemoveRoomMailbox was not removed", "Info")
	}
}




###JUNK EMAIL CONFIGURATION###

	#Blacklist

$blacklistDomainForAllToolStripMenuItem_Click = {
	$BlacklistDomain = Read-Host "Enter the domain you want to blacklist for all users. EX: google.com"
	try
	{
		$TextboxResults.Text = "Blacklisting $BlacklistDomain for all users..."
		$textboxDetails.Text = "Get-Mailbox | Set-MailboxJunkEmailConfiguration -BlockedSendersAndDomains `@{ Add = $BlacklistDomain }"
		Get-Mailbox | Set-MailboxJunkEmailConfiguration -BlockedSendersAndDomains @{ Add = $BlacklistDomain }
		$TextboxResults.Text = Get-Mailbox | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-Table Identity, BlockedSendersAndDomains, Enabled -AutoSize | Out-String
		
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$blacklistDomainForASingleUserToolStripMenuItem_Click = {
	#$Blockeddomainuser = Read-Host "Enter the UPN of the user you want to modify junk email for"
	$SelectUsersFormText = "Select the user you want to modify the blacklist for"
	Call-SelectUsersForm_psf
	$Blockeddomainuser = $SelectUsersForm_comboboxUsers
	
	$BlockedDomain2 = Read-Host "Enter the domain you want to blacklist"
	try
	{
		$TextboxResults.Text = "Blacklisting $BlockedDomain2 for $Blockeddomainuser..."
		$textboxDetails.Text = "Set-MailboxJunkEmailConfiguration -Identity $Blockeddomainuser -BlockedSendersAndDomains `@{ Add = $BlockedDomain2 } "
		Set-MailboxJunkEmailConfiguration -Identity $Blockeddomainuser -BlockedSendersAndDomains @{ Add = $BlockedDomain2 }
		$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $Blockeddomainuser | Format-List Identity, BlockedSendersAndDomains | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$blacklistASpecificEmailAddressForAllToolStripMenuItem_Click = {
	$BlockSpecificEmailForAll = Read-Host "Enter the email address you want to blacklist for all"
	try
	{
		$TextboxResults.Text = "Blacklisting $BlockSpecificEmailForAll for all users..."
		$textboxDetails.Text = "Get-Mailbox | Set-MailboxJunkEmailConfiguration -BlockedSendersAndDomains `@{ Add = $BlockSpecificEmailForAll }"
		Get-Mailbox | Set-MailboxJunkEmailConfiguration -BlockedSendersAndDomains @{ Add = $BlockSpecificEmailForAll }
		$TextboxResults.Text = Get-Mailbox | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-Table Identity, BlockedSendersAndDomains, Enabled -Autosize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$blacklistASpecificEmailAddressForASingleUserToolStripMenuItem_Click = {
	#$ModifyblacklistforaUser = Read-Host "Enter the user you want to modify the blacklist for"
	$SelectUsersFormText = "Select the user you want to modify the blacklist for"
	Call-SelectUsersForm_psf
	$ModifyblacklistforaUser = $SelectUsersForm_comboboxUsers
	
	$DenySpecificEmailForOne = Read-Host "Enter the email address you want to whitelist for a single user"
	try
	{
		$TextboxResults.Text = "Blacklisting $DenySpecificEmailForOne for $ModifyblacklistforaUser..."
		$textboxDetails.Text = "Set-MailboxJunkEmailConfiguration -Identity $ModifyblacklistforaUser -BlockedSendersAndDomains `@{ Add = $DenySpecificEmailForOne }"
		Set-MailboxJunkEmailConfiguration -Identity $ModifyblacklistforaUser -BlockedSendersAndDomains @{ Add = $DenySpecificEmailForOne }
		$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $ModifyblacklistforaUser | Format-List Identity, BlockedSendersAndDomains, Enabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Junk Email General Items

$checkSafeAndBlockedSendersForAUserToolStripMenuItem_Click = {
	#$CheckSpamUser = Read-Host "Enter the UPN of the user you want to check blocked and allowed senders for"
	$SelectUsersFormText = "Select the user you want to check safe and blocked senders for"
	Call-SelectUsersForm_psf
	$GlobalUPN = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting safe and blocked senders for $GlobalUPN..."
		$textboxDetails.Text = "Get-MailboxJunkEmailConfiguration -Identity $GlobalUPN | Format-List Identity, TrustedListsOnly, ContactsTrusted, TrustedSendersAndDomains, BlockedSendersAndDomains, TrustedRecipientsAndDomains, IsValid "
		$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $GlobalUPN | Format-List Identity, TrustedListsOnly, ContactsTrusted, TrustedSendersAndDomains, BlockedSendersAndDomains, TrustedRecipientsAndDomains, IsValid | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$checkSafeAndBlockedSendersForAllToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting safe and blocked senders for all users..."
		$textboxDetails.Text = "Get-Mailbox | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-List Identity, TrustedListsOnly, ContactsTrusted, TrustedSendersAndDomains, BlockedSendersAndDomains, TrustedRecipientsAndDomains, IsValid"
		$TextboxResults.Text = Get-Mailbox | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-List Identity, TrustedListsOnly, ContactsTrusted, TrustedSendersAndDomains, BlockedSendersAndDomains, TrustedRecipientsAndDomains, IsValid | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Whitelist

$whitelistDomainForAllToolStripMenuItem_Click = {
	$AllowedDomain = Read-Host "Enter the domain you want to whitelist for all users. EX: google.com"
	try
	{
		$TextboxResults.Text = "Whitelisting $AllowedDomain for all..."
		$textboxDetails.Text = "Get-Mailbox | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains `@{ Add = $AllowedDomain }"
		Get-Mailbox | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains @{ Add = $AllowedDomain }
		$TextboxResults.Text = Get-Mailbox | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-Table Identity, TrustedSendersAndDomains, TrustedRecipientsAndDomains -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$whitelistDomainForASingleUserToolStripMenuItem_Click = {
	#$Alloweddomainuser = Read-Host "Enter the UPN of the user you want to modify junk email for"
	$SelectUsersFormText = "Select the user you want to modify the whitelist for"
	Call-SelectUsersForm_psf
	$Alloweddomainuser = $SelectUsersForm_comboboxUsers
	
	$AllowedDomain2 = Read-Host "Enter the domain you want to whitelist"
	try
	{
		$TextboxResults.Text = "Whitelisting $AllowedDomain2 for $Alloweddomainuser..."
		$textboxDetails.Text = "Set-MailboxJunkEmailConfiguration -Identity $Alloweddomainuser -TrustedSendersAndDomains `@{ Add = $AllowedDomain2 }"
		Set-MailboxJunkEmailConfiguration -Identity $Alloweddomainuser -TrustedSendersAndDomains @{ Add = $AllowedDomain2 }
		$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $Alloweddomainuser | Format-List Identity, TrustedSendersAndDomains, TrustedRecipientsAndDomains | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$whitelistASpecificEmailAddressForAllToolStripMenuItem_Click = {
	$AllowSpecificEmailForAll = Read-Host "Enter the email address you want to whitelist for all"
	try
	{
		$TextboxResults.Text = "Whitelisting $AllowSpecificEmailForAll for all..."
		$textboxDetails.Text = "Get-Mailbox | | Where-Object { `$_.RecipientType -eq 'UserMailbox' } | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains @{ Add = $AllowSpecificEmailForAll }"
		Get-Mailbox | Where-Object { $_.RecipientType -eq 'UserMailbox' } | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains @{ Add = $AllowSpecificEmailForAll }
		$TextboxResults.Text = Get-Mailbox | Where-Object { $_.RecipientType -eq 'UserMailbox' } | Get-MailboxJunkEmailConfiguration | Sort-Object Identity | Format-Table Identity, TrustedSendersAndDomains, TrustedRecipientsAndDomains -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$whitelistASpecificEmailAddressForASingleUserToolStripMenuItem_Click = {
	#$ModifyWhitelistforaUser = Read-Host "Enter the user you want to modify the whitelist for"
	$SelectUsersFormText = "Select the user you want to modify the whitelist for"
	Call-SelectUsersForm_psf
	$ModifyWhitelistforaUser = $SelectUsersForm_comboboxUsers
	
	$AllowSpecificEmailForOne = Read-Host "Enter the email address you want to whitelist for a single user"
	try
	{
		$TextboxResults.Text = "Whitelisting $AllowSpecificEmailForOne for $ModifyWhitelistforaUser..."
		$textboxDetails.Text = "Set-MailboxJunkEmailConfiguration -Identity $ModifyWhitelistforaUser -TrustedSendersAndDomains `@{ Add = $AllowSpecificEmailForOne }"
		Set-MailboxJunkEmailConfiguration -Identity $ModifyWhitelistforaUser -TrustedSendersAndDomains @{ Add = $AllowSpecificEmailForOne }
		$TextboxResults.Text = Get-MailboxJunkEmailConfiguration -Identity $ModifyWhitelistforaUser | Format-List Identity, TrustedSendersAndDomains, TrustedRecipientsAndDomains, Enabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}


###CONTACTS FOLDER PERMISSIONS

$addContactsPermissionsForAUserToolStripMenuItem_Click = {
	#$ContacsUser = Read-Host "Enter the UPN of the user whose contacts folder you want to give access to"
	#$Contactsuser2 = Read-Host "Enter the UPN of the user who you want to give access to"
	#$TextboxResults.text = "Contacts Permissions: 
#Owner
#PublishingEditor
#Editor
#PublishingAuthor
#Author
#NonEditingAuthor
#Reviewer
#Contributor
#AvailabilityOnly
#LimitedDetails"
	#$level = Read-Host "Access Level?"
	$SelectUsersFormText = "Select the user you want to modify contacts permissions for"
	Call-SelectUsersForm_psf
	$GlobalUPNmodifycontacts = $SelectUsersForm_comboboxUsers
	
	$SelectUsersFormText = "Select the user you want to add to $GlobalUPNmodifycontacts contacts"
	Call-SelectUsersForm_psf
	$GlobalUPNadd2contacts = $SelectUsersForm_comboboxUsers
	
	$LabelPermissionsText = "Select the level of access"
	Call-AccessPermissions_psf
	$GlobalContactsPermissions = $AccessPermissions_comboboxPermissions_SelectedItem
	
	try
	{
		$TextboxResults.Text = "Adding $GlobalUPNadd2contacts to $GlobalUPNmodifycontacts contacts folder with $GlobalContactsPermissions permissions..."
		$textboxDetails.Text = "Add-MailboxFolderPermission -Identity ${GlobalUPNmodifycontacts}:\contacts -user $GlobalUPNadd2contacts -AccessRights $GlobalContactsPermissions"
		Remove-MailboxFolderPermission -identity ${$GlobalUPNmodifycontacts}:\contacts -user $GlobalUPNadd2contacts -Confirm:$False
		Add-MailboxFolderPermission -Identity ${GlobalUPNmodifycontacts}:\contacts -user $GlobalUPNadd2contacts -AccessRights $GlobalContactsPermissions
		$TextboxResults.Text = "Getting contact folder permissions for $GlobalUPNmodifycontacts..."
		$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${GlobalUPNmodifycontacts}:\contacts | Sort-Object User, AccessRights | Format-Table User, AccessRights, FolderName -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getUsersContactsPermissionsToolStripMenuItem_Click = {
	#$ContactsUserPermissions = Read-Host "What user would you like contacts folder permissions for?"
	$SelectUsersFormText = "Select the user you want to view contacts permissions for"
	Call-SelectUsersForm_psf
	$GlobalUPNremovecontacts = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Getting $GlobalUPNremovecontacts contacts permissions..."
		$textboxDetails.Text = "Get-MailboxFolderPermission -Identity ${GlobalUPNremovecontacts}:\contacts | Sort-Object User, AccessRights | Format-Table User, AccessRights, FolderName "
		$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${GlobalUPNremovecontacts}:\contacts | Sort-Object User, AccessRights | Format-Table User, AccessRights, FolderName -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeAUserFromSomeonesContactsPermissionsToolStripMenuItem_Click = {
	#$Contactsuserremove = Read-Host "Enter the UPN of the user whose contacts you want to remove access to"
	#$Contactsuser2remove = Read-Host "Enter the UPN of the user who you want to remove access"
	$SelectUsersFormText = "Select the user whose contacts you want to remove access to"
	Call-SelectUsersForm_psf
	$GlobalUPNremove = $SelectUsersForm_comboboxUsers
	
	$SelectUsersFormText = "Select the user you want to remove access"
	Call-SelectUsersForm_psf
	$GlobalUPN2remove = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Removing $GlobalUPN2remove from $GlobalUPNremove contacts folder..."
		$textboxDetails.Text = "Remove-MailboxFolderPermission -Identity ${GlobalUPNremove}:\contacts -user $GlobalUPN2remove"
		Remove-MailboxFolderPermission -Identity ${GlobalUPNremove}:\contacts -user $GlobalUPN2remove
		$TextboxResults.Text = "Getting contact folder permissions for $GlobalUPNremove..."
		$TextboxResults.Text = Get-MailboxFolderPermission -Identity ${GlobalUPNremove}:\contacts | Sort-Object User, AccessRights | Format-Table User, AccessRights, FolderName -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeAUserFromAllContactsFoldersToolStripMenuItem_Click = {
	#$RemoveUserFromAllContacts = Read-Host "Enter the UPN of the user you want to remove from all contacts folders"
	$SelectUsersFormText = "Select the user you want to remove from all users contacts folder"
	Call-SelectUsersForm_psf
	$GlobalUPNremovefromallcontacts = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Removing $GlobalUPNremovefromallcontacts from all users contacts folders..."
		$textboxDetails.Text = "`$users = Get-Mailbox | Select-Object -ExpandProperty Alias
Foreach (`$user in `$users) { Remove-MailboxFolderPermission `${user}:\Contacts -user $GlobalUPNremovefromallcontacts -Confirm:`$false}﻿"
		$users = Get-Mailbox | Select-Object -ExpandProperty Alias
		Foreach ($user in $users) { Remove-MailboxFolderPermission ${user}:\Contacts -user $GlobalUPNremovefromallcontacts -Confirm:$false }﻿
	}
	catch
	{
		#[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	$TextboxResults.Text = ""
	
}

$addASingleUserPermissionsOnAllContactsFoldersToolStripMenuItem_Click = {
	#$MasterUserContacts = Read-Host "Enter the UPN of the user you want permission on all users contacts folders"
	#$TextboxResults.text = "Contacts Permissions: 
#Owner
#PublishingEditor
#Editor
#PublishingAuthor
#Author
#NonEditingAuthor
#Reviewer
#Contributor
#AvailabilityOnly
#LimitedDetails"
	#$level2 = Read-Host "Access Level?"
	$SelectUsersFormText = "Select the user you want to add to everyones contacts folder"
	Call-SelectUsersForm_psf
	$GlobalUPNremoveaddtoallcontacts = $SelectUsersForm_comboboxUsers
	
	$LabelPermissionsText = "Select the level of access"
	Call-AccessPermissions_psf
	$GlobalContactsPermissions2 = $AccessPermissions_comboboxPermissions_SelectedItem
	try
	{
		$TextboxResults.Text = "Adding $GlobalUPNremoveaddtoallcontacts to everyones contacts folder with $GlobalContactsPermissions2 permissions..."
		$textboxDetails.Text = "Get-Mailbox | Select-Object -ExpandProperty Alias
Foreach (`$user in `$users) { Add-MailboxFolderPermission `${user}:\Contacts -user $GlobalUPNremoveaddtoallcontacts -accessrights $GlobalContactsPermissions2 }﻿"
		$users = Get-Mailbox | Select-Object -ExpandProperty Alias
		Foreach ($user in $users) { Add-MailboxFolderPermission ${user}:\Contacts -user $GlobalUPNremoveaddtoallcontacts -accessrights $GlobalContactsPermissions2 }﻿
	}
	catch
	{
		#[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	$TextboxResults.Text = ""
	
}



###ADMIN###

	#OWA

$disableAccessToOWAForASingleUserToolStripMenuItem_Click = {
	#$DisableOWAforUser = Read-Host "Enter the UPN of the user you want to disable OWA access for"
	$SelectUsersFormText = "Select the user you want to disable OWA access for"
	Call-SelectUsersForm_psf
	$DisableOWAforUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Disabling OWA access for $DisableOWAforUser..."
		$textboxDetails.Text = "Set-CASMailbox $DisableOWAforUser -OWAEnabled `$False"
		Set-CASMailbox $DisableOWAforUser -OWAEnabled $False
		$TextboxResults.Text = Get-CASMailbox $DisableOWAforUser | Format-List DisplayName, OWAEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$enableOWAAccessForASingleUserToolStripMenuItem_Click = {
	#$EnableOWAforUser = Read-Host "Enter the UPN of the user you want to enable OWA access for"
	$SelectUsersFormText = "Select the user you want to enable OWA access for"
	Call-SelectUsersForm_psf
	$EnableOWAforUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Enabling OWA access for $EnableOWAforUser..."
		$textboxDetails.Text = "Set-CASMailbox $EnableOWAforUser -OWAEnabled `$True"
		Set-CASMailbox $EnableOWAforUser -OWAEnabled $True
		$TextboxResults.Text = Get-CASMailbox $EnableOWAforUser | Format-List DisplayName, OWAEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$disableOWAAccessForAllToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to disable OWA for all users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		try
		{
			$TextboxResults.Text = "Disabling OWA access for all..."
			$textboxDetails.Text = "Get-Mailbox | Set-CASMailbox -OWAEnabled `$False"
			Get-Mailbox | Set-CASMailbox -OWAEnabled $False
			$TextboxResults.Text = Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, OWAEnabled -AutoSize | Out-String
		}
		catch
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("ActiveSync has not been disabled for all users", "Info")
	}
	
}

$enableOWAAccessForAllToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Enabling OWA access for all..."
		$textboxDetails.Text = "Get-Mailbox | Set-CASMailbox -OWAEnabled `$True"
		Get-Mailbox | Set-CASMailbox -OWAEnabled $True
		$TextboxResults.Text = Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, OWAEnabled -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getOWAAccessForAllToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting OWA info for all users..."
		$textboxDetails.Text = "Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, OWAEnabled, OwaMailboxPolicy, OWAforDevicesEnabled -Autosize"
		$TextboxResults.Text = Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, OWAEnabled, OwaMailboxPolicy, OWAforDevicesEnabled -Autosize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getOWAInfoForASingleUserToolStripMenuItem_Click = {
	#$OWAAccessUser = Read-Host "Enter the UPN for the User you want to view OWA info for"
	$SelectUsersFormText = "Select the user you want to view OWA information for"
	Call-SelectUsersForm_psf
	$OWAAccessUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting OWA Access for $OWAAccessUser..."
		$textboxDetails.Text = "Get-CASMailbox -identity $OWAAccessUser | Format-List DisplayName, OWAEnabled, OwaMailboxPolicy, OWAforDevicesEnabled"
		$TextboxResults.Text = Get-CASMailbox -identity $OWAAccessUser | Format-List DisplayName, OWAEnabled, OwaMailboxPolicy, OWAforDevicesEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#ActiveSync

$getActiveSyncDevicesForAUserToolStripMenuItem_Click = {
	#$ActiveSyncDevicesUser = Read-Host "Enter the UPN of the user you wish to see ActiveSync Devices for"
	$SelectUsersFormText = "Select the user you want to view ActiveSync devices for"
	Call-SelectUsersForm_psf
	$ActiveSyncDevicesUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting ActiveSync device info for $ActiveSyncDevicesUser..."
		$textboxDetails.Text = "Get-MobileDeviceStatistics -Mailbox $ActiveSyncDevicesUser | Format-List DeviceFriendlyName, DeviceModel, DeviceOS, DeviceMobileOperator, DeviceType, Status, FirstSyncTime, LastPolicyUpdateTime, LastSyncAttemptTime, LastSuccessSync, LastPingHeartbeat, DeviceAccessState, IsValid "
		$TextboxResults.Text = Get-MobileDeviceStatistics -Mailbox $ActiveSyncDevicesUser | Format-List DeviceFriendlyName, DeviceModel, DeviceOS, DeviceMobileOperator, DeviceType, Status, FirstSyncTime, LastPolicyUpdateTime, LastSyncAttemptTime, LastSuccessSync, LastPingHeartbeat, DeviceAccessState, IsValid | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableActiveSyncForAUserToolStripMenuItem_Click = {
	#$DisableActiveSyncForUser = Read-Host "Enter the UPN of the user you wish to disable ActiveSync for"
	$SelectUsersFormText = "Select the user you want to disable ActiveSync for"
	Call-SelectUsersForm_psf
	$DisableActiveSyncForUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Disabling ActiveSync for $DisableActiveSyncForUser..."
		$textboxDetails.Text = "Set-CASMailbox $DisableActiveSyncForUser -ActiveSyncEnabled `$False"
		Set-CASMailbox $DisableActiveSyncForUser -ActiveSyncEnabled $False
		$TextboxResults.Text = Get-CASMailbox -Identity $DisableActiveSyncForUser | Format-List DisplayName, ActiveSyncEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$enableActiveSyncForAUserToolStripMenuItem_Click = {
	#$EnableActiveSyncForUser = Read-Host "Enter the UPN of the user you wish to enable ActiveSync for"
	$SelectUsersFormText = "Select the user you want to enable ActiveSync for"
	Call-SelectUsersForm_psf
	$EnableActiveSyncForUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Enabling ActiveSync for $EnableActiveSyncForUser... "
		$textboxDetails.Text = "Set-CASMailbox $EnableActiveSyncForUser -ActiveSyncEnabled `$True"
		Set-CASMailbox $EnableActiveSyncForUser -ActiveSyncEnabled $True
		$TextboxResults.Text = Get-CASMailbox -Identity $EnableActiveSyncForUser | Format-List DisplayName, ActiveSyncEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$viewActiveSyncInfoForAUserToolStripMenuItem_Click = {
	#$ActiveSyncInfoForUser = Read-Host "Enter the UPN for the user you want to view ActiveSync info for"
	$SelectUsersFormText = "Select the user you want to view ActiveSync information for"
	Call-SelectUsersForm_psf
	$ActiveSyncInfoForUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting ActiveSync info for $ActiveSyncInfoForUser..."
		$textboxDetails.Text = "Get-CASMailbox -Identity $ActiveSyncInfoForUser | Format-List DisplayName, ActiveSyncEnabled, ActiveSyncAllowedDeviceIDs, ActiveSyncBlockedDeviceIDs, ActiveSyncMailboxPolicy, ActiveSyncMailboxPolicyIsDefaulted, ActiveSyncDebugLogging, HasActiveSyncDevicePartnership"
		$TextboxResults.Text = Get-CASMailbox -Identity $ActiveSyncInfoForUser | Format-List DisplayName, ActiveSyncEnabled, ActiveSyncAllowedDeviceIDs, ActiveSyncBlockedDeviceIDs, ActiveSyncMailboxPolicy, ActiveSyncMailboxPolicyIsDefaulted, ActiveSyncDebugLogging, HasActiveSyncDevicePartnership | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableActiveSyncForAllToolStripMenuItem_Click = {
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to disable ActiveSync for all users?", "Warning!", 4)
	If ($OUTPUT -eq "YES")
	{
		try
		{
			$TextboxResults.Text = "Disabling ActiveSync for all..."
			$textboxDetails.Text = "Get-Mailbox | Set-CASMailbox -ActiveSyncEnabled `$False"
			Get-Mailbox | Set-CASMailbox -ActiveSyncEnabled $False
			$TextboxResults.Text = Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, ActiveSyncEnabled -AutoSize | Out-String
		}
		catch
		{
			$TextboxResults.Text = ""
			$textboxDetails.Text = ""
			[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		}
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("ActiveSync has not been disabled for all users", "Info")
	}
}

$getActiveSyncInfoForAllToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting ActiveSync info for all..."
		$textboxDetails.Text = "Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, ActiveSyncEnabled -AutoSize"
		$TextboxResults.Text = Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, ActiveSyncEnabled -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
		
	}
}

$enableActiveSyncForAllToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Enabling ActiveSync for all.."
		$textboxDetails.Text = "Get-Mailbox | Set-CASMailbox -ActiveSyncEnabled `$True"
		Get-Mailbox | Set-CASMailbox -ActiveSyncEnabled $True
		$TextboxResults.Text = Get-Mailbox | Get-CASMailbox | Sort-Object DisplayName | Format-Table DisplayName, ActiveSyncEnabled -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#PowerShell

$disableAccessToPowerShellForAUserToolStripMenuItem_Click = {
	#$DisablePowerShellforUser = Read-Host "Enter the UPN of the user you want to disable PowerShell access for"
	$SelectUsersFormText = "Select the user you want to disable PowerShell access for"
	Call-SelectUsersForm_psf
	$DisablePowerShellforUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Disabling PowerShell access for $DisablePowerShellforUser..."
		$textboxDetails.Text = "Set-User $DisablePowerShellforUser -RemotePowerShellEnabled `$False"
		Set-User $DisablePowerShellforUser -RemotePowerShellEnabled $False
		$TextboxResults.Text = Get-User $DisablePowerShellforUser | Format-List DisplayName, RemotePowerShellEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$displayPowerShellRemotingStatusForAUserToolStripMenuItem_Click = {
	#$PowerShellRemotingStatusUser = Read-Host "Enter the UPN of the user you want to view PowerShell Remoting for"
	$SelectUsersFormText = "Select the user you want to view PowerShell remoting for"
	Call-SelectUsersForm_psf
	$PowerShellRemotingStatusUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Getting PowerShell info for $PowerShellRemotingStatusUser..."
		$textboxDetails.Text = "Get-User $PowerShellRemotingStatusUser | Format-List DisplayName, RemotePowerShellEnabled"
		$TextboxResults.Text = Get-User $PowerShellRemotingStatusUser | Format-List DisplayName, RemotePowerShellEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$enableAccessToPowerShellForAUserToolStripMenuItem_Click = {
	#$EnablePowerShellforUser = Read-Host "Enter the UPN of the user you want to enable PowerShell access for"
	$SelectUsersFormText = "Select the user you want to enable PowerShell access for"
	Call-SelectUsersForm_psf
	$EnablePowerShellforUser = $SelectUsersForm_comboboxUsers
	try
	{
		$TextboxResults.Text = "Enabling PowerShell access for $EnablePowerShellforUser..."
		$textboxDetails.Text = "Set-User $EnablePowerShellforUser -RemotePowerShellEnabled `$True"
		Set-User $EnablePowerShellforUser -RemotePowerShellEnabled $True
		$TextboxResults.Text = Get-User $EnablePowerShellforUser | Format-List DisplayName, RemotePowerShellEnabled | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getPowerShellRemotingStatusForAllToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting PowerShell info for all users..."
		$textboxDetails.Text = "Get-User | Sort-Object DisplayName | Format-Table DisplayName, RemotePowerShellEnabled -AutoSize"
		$TextboxResults.Text = Get-User | Sort-Object DisplayName | Format-Table DisplayName, RemotePowerShellEnabled -AutoSize | Out-String
	}
	catch
	{
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
		$TextboxResults.Text = "Getting recent messages..."
		$textboxDetails.Text = "Get-MessageTrace | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
		$TextboxResults.Text = Get-MessageTrace | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$fromACertainSenderToolStripMenuItem1_Click = {
	$MessageTraceSender = Read-Host "Enter the senders email address"
	try
	{
		$TextboxResults.Text = "Getting messages from $MessageTraceSender..."
		$textboxDetails.Text = "Get-MessageTrace -SenderAddress $MessageTraceSender | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
		$TextboxResults.Text = Get-MessageTrace -SenderAddress $MessageTraceSender | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$toACertainRecipientToolStripMenuItem_Click = {
	$MessageTraceRecipient = Read-Host "Enter the recipients email address"
	try
	{
		$TextboxResults.Text = "Getting messages sent to $MessageTraceRecipient..."
		$textboxDetails.Text = "Get-MessageTrace -RecipientAddress $MessageTraceRecipient | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
		$TextboxResults.Text = Get-MessageTrace -RecipientAddress $MessageTraceRecipient | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getFailedMessagesToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting failed messages..."
		$textboxDetails.Text = "Get-MessageTrace -Status 'Failed' | Format-Table Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
		$TextboxResults.Text = Get-MessageTrace -Status "Failed" | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$GetMessagesBetweenDatesToolStripMenuItem_Click = {
	#$MessageTraceStartDate = Read-Host "Enter the start date. EX: 06/13/2015 or 09/01/2015 5:00 PM"
	$StartDateText = "Select the beginning date for the message trace"
	$StartDateFormText = "Start Date"
	Call-SelectDatePicker_psf
	$startdate = $SelectDatePicker_monthcalendar1
	$MessageTraceStartDate = "$startdate".trimend('00:00:00')
	
	#$MessageTraceEndDate = Read-Host "Enter the end date. EX: 06/15/2015 or 09/01/2015 5:00 PM"
	$StartDateText = "Select the ending date for the message trace"
	$StartDateFormText = "End Date"
	Call-SelectDatePicker_psf
	$enddate = $SelectDatePicker_monthcalendar1
	$MessageTraceEndDate = "$enddate".trimend('00:00:00')
	
	try
	{
		$TextboxResults.Text = "Getting messages between $MessageTraceStartDate and $MessageTraceEndDate..."
		$textboxDetails.Text = "Get-MessageTrace -StartDate $MessageTraceStartDate -EndDate $MessageTraceEndDate | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status"
		$TextboxResults.Text = Get-MessageTrace -StartDate $MessageTraceStartDate -EndDate $MessageTraceEndDate | Format-List Received, SenderAddress, RecipientAddress, FromIP, ToIP, Subject, Size, Status | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Company Info

$getTechnicalNotificationEmailToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting technical account info..."
		$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List TechnicalNotificationEmails"
		$TextboxResults.Text = Get-MsolCompanyInformation | Format-List TechnicalNotificationEmails | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting technical account info..."
		$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List TechnicalNotificationEmails"
		$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List TechnicalNotificationEmails | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$lastDirSyncTimeToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting last DirSync time..."
		$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastDirSyncTime"
		$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastDirSyncTime | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting last DirSync time..."
		$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List LastDirSyncTime"
		$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List LastDirSyncTime | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getLastPasswordSyncTimeToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting last password sync time..."
		$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List LastPasswordSyncTime"
		$TextboxResults.Text = Get-MsolCompanyInformation | Format-List LastPasswordSyncTime | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting last password sync time..."
		$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText  | Format-List LastPasswordSyncTime"
		$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List LastPasswordSyncTime | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllCompanyInfoToolStripMenuItem_Click = {
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$TextboxResults.Text = "Getting all company info..."
		$textboxDetails.Text = "Get-MsolCompanyInformation | Format-List "
		$TextboxResults.Text = Get-MsolCompanyInformation | Format-List | Out-String
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$TenantText = $PartnerComboBox.text
		$TextboxResults.Text = "Getting all company info..."
		$textboxDetails.Text = "Get-MsolCompanyInformation -TenantId $TenantText | Format-List"
		$TextboxResults.Text = Get-MsolCompanyInformation -TenantId $PartnerComboBox.SelectedItem.TenantID | Format-List | Out-String
	}
	Else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Sharing Policy

$getSharingPolicyToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting all sharing policies..."
		$textboxDetails.Text = "Get-SharingPolicy | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState"
		$TextboxResults.Text = Get-SharingPolicy | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$disableASharingPolicyToolStripMenuItem_Click = {
	#$DisableSharingPolicy = Read-Host "Enter the name of the policy you want to disable"
	$SharingPolicyText = "Select the sharing policy you want to disable"
	Call-SelectSharingPolicy_psf
	$DisableSharingPolicy = $SelectSharingPolicy_comboboxSharingPolicies
	
	try
	{
		$TextboxResults.Text = "Disabling the sharing policy $DisableSharingPolicy..."
		$textboxDetails.Text = "Set-SharingPolicy -Identity $DisableSharingPolicy -Enabled `$False"
		Set-SharingPolicy -Identity $DisableSharingPolicy -Enabled $False
		$TextboxResults.Text = Get-SharingPolicy -Identity $DisableSharingPolicy | Format-List Name, Enabled, ObjectState | Out-String -Width 2147483647
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$enableASharingPolicyToolStripMenuItem_Click = {
	#$EnableSharingPolicy = Read-Host "Enter the name of the policy you want to Enable"
	$SharingPolicyText = "Select the sharing policy you want to enable"
	Call-SelectSharingPolicy_psf
	$EnableSharingPolicy = $SelectSharingPolicy_comboboxSharingPolicies
	
	try
	{
		$TextboxResults.Text = "Enabling the sharing policy $EnableSharingPolicy..."
		$textboxDetails.Text = "Set-SharingPolicy -Identity $EnableSharingPolicy -Enabled `$True"
		Set-SharingPolicy -Identity $EnableSharingPolicy -Enabled $True
		$TextboxResults.Text = Get-SharingPolicy -Identity $EnableSharingPolicy | Format-List Name, Enabled, ObjectState | Out-String -Width 2147483647
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$createANewSharingPolicyToolStripMenuItem_Click = {
	$TextboxResults.Text = "You may need to enable organization customization if customization status is dehydrated."
	$TextboxResults.Text = Get-OrganizationConfig | Format-List  Identity, IsDehydrated | Out-String
	$NewSharingPolicyName = Read-Host "Enter the name for the sharing policy"
	$TextboxResults.Text = "The following sharing policy action values can be used:
CalendarSharingFreeBusySimple: Share free/busy hours only
CalendarSharingFreeBusyDetail: Share free/busy hours, subject, and location
CalendarSharingFreeBusyReviewer: Share free/busy hours, subject, location, and the body of the message or calendar item
ContactsSharing: Share contacts only

EXAMPLE: mail.contoso.com: CalendarSharingFreeBusyDetail, ContactsSharing "
	$SharingPolicy = Read-Host "Enter the domain this policy will apply to and the value"
	try
	{
		$TextboxResults.Text = "Creating a new sharing policy $NewSharingPolicyName..."
		$textboxDetails.Text = "New-SharingPolicy -Name $NewSharingPolicyName -Domains $SharingPolicy"
		New-SharingPolicy -Name $NewSharingPolicyName -Domains $SharingPolicy
		$TextboxResults.Text = Get-SharingPolicy -Identity $NewSharingPolicyName | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getInfoForASingleSharingPolicyToolStripMenuItem_Click = {
	#$DetailedInfoForSharingPolicy = Read-Host "Enter the name of the policy you want info for"
	$SharingPolicyText = "Select the sharing policy you want to view detailed information for"
	Call-SelectSharingPolicy_psf
	$DetailedInfoForSharingPolicy = $SelectSharingPolicy_comboboxSharingPolicies
	
	try
	{
		$TextboxResults.Text = "Getting info for the sharing policy $DetailedInfoForSharingPolicy..."
		$textboxDetails.Text = "Get-SharingPolicy -Identity $DetailedInfoForSharingPolicy | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState"
		$TextboxResults.Text = Get-SharingPolicy -Identity $DetailedInfoForSharingPolicy | Format-List Name, Domains, Enabled, Default, Identity, WhenChanged, WhenCreated, IsValid, ObjectState | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Configuration 

$enableCustomizationToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Enabling customization..."
		$textboxDetails.Text = "Enable-OrganizationCustomization"
		Enable-OrganizationCustomization
		$TextboxResults.Text = "Success"
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getCustomizationStatusToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting customization status..."
		$textboxDetails.Text = "Get-OrganizationConfig | Format-Table  Identity, IsDehydrated -AutoSize "
		$TextboxResults.Text = Get-OrganizationConfig | Format-Table  Identity, IsDehydrated -AutoSize | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getOrganizationCustomizationToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting customization information..."
		$textboxDetails.Text = "Get-OrganizationConfig | Format-List"
		$TextboxResults.Text = Get-OrganizationConfig | Format-List | Out-String
	}
	catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getSharepointSiteToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting sharepoint URL..."
		$textboxDetails.Text = "Get-OrganizationConfig | Format-List SharePointUrl"
		$TextboxResults.Text = Get-OrganizationConfig | Format-List SharePointUrl | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}



###REPORTING###

$getAllMailboxSizesToolStripMenuItem_Click = {
	try
	{
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
		
		ItemCount | Sort-Object "TotalItemSize (MB)" -Descending | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getLicenceReconciliationReportToolStripMenuItem_Click = {
	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to File"
	$savedialog.filter = ".csv|*.csv"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		$LogFile = $savedialog.filename
		
		
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
		
		# The Output will be written to this file in the current working directory 
		#$LogFile = "Office_365_Licenses.csv"
		
		
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
			
			#write-host ("Gathering users with the following subscription: " + $license.accountskuid)
			
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
		
		#write-host ("Script Completed.  Results available in " + $LogFile)
	}
}

$getAllGroupsAndAllMembersToCSVToolStripMenuItem_Click = {
	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to File"
	$savedialog.filter = ".csv|*.csv"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		#Constant Variables 
		$OutputFile = $savedialog.filename
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
		$TextboxResults.Text = "Getting all users last logon timestamp..."
		$textboxDetails.Text = "(Get-Mailbox) | ForEach-Object { Get-MailboxStatistics $_.Identity | Select-Object DisplayName, LastLogonTime } "
		(Get-Mailbox) | ForEach-Object { Get-MailboxStatistics $_.Identity | Select-Object DisplayName, LastLogonTime } | Export-CSV $savedialog.filename -Encoding utf8 -NoTypeInformation -Delimiter ","
		$TextboxResults.Text = ""
	}
	else
	{
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
			$OutputFile = $savedialog.filename
			
			
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
		}
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllDIsabledUsersThatAreStillMembersOfDistroGroupsToolStripMenuItem_Click = {
	Try
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
		}
	}
	Catch
	{ }
}

$UsersGetLicensesRecoReportToolStripMenuItem1_Click = {
	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to File"
	$savedialog.filter = ".csv|*.csv"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		$LogFile = $savedialog.filename
		
		
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
		
		# The Output will be written to this file in the current working directory 
		#$LogFile = "Office_365_Licenses.csv"
		
		
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
			
			#write-host ("Gathering users with the following subscription: " + $license.accountskuid)
			
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
		
		#write-host ("Script Completed.  Results available in " + $LogFile)
	}
}

$getAllGroupsAndAllMembersToolStripMenuItem_Click = {
	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to File"
	$savedialog.filter = ".csv|*.csv"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		#Constant Variables 
		$OutputFile = $savedialog.filename
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
	}
	
}

	#Mail Malware Report

$getMailMalwareReportToolStripMenuItem1_Click = {
	$TextboxResults.Text = "Generating recent mail malware report..."
	Try
	{
		$TextboxResults.Text = "Getting mail malware report..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport | Format-List"
		$TextboxResults.Text = Get-MailDetailMalwareReport | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailMalwareReportFromSenderToolStripMenuItem_Click = {
	$MalwareSender = Read-Host "Enter the email of the sender"
	try
	{
		$TextboxResults.Text = "Generating mail malware report sent from $MalwareSender..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport -SenderAddress $MalwareSender | Format-List"
		$TextboxResults.Text = Get-MailDetailMalwareReport -SenderAddress $MalwareSender | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailMalwareReportBetweenDatesToolStripMenuItem_Click = {
	#$MalwareReportStart = Read-Host "Enter the start date. EX: 06/13/2015"
	$StartDateText = "Select the beginning date for the mail malware report"
	$StartDateFormText = "Start Date"
	Call-SelectDatePicker_psf
	$startdate = $SelectDatePicker_monthcalendar1
	$MalwareReportStart = "$startdate".trimend('00:00:00')
	
	#$MalwareReportEnd = Read-Host "Enter the end date. EX: 06/15/2015 "
	$StartDateText = "Select the ending date for the mail malware report"
	$StartDateFormText = "End Date"
	Call-SelectDatePicker_psf
	$enddate = $SelectDatePicker_monthcalendar1
	$MalwareReportEnd = "$enddate".trimend('00:00:00')
	
	try
	{
		$TextboxResults.Text = "Generating mail malware report between $MalwareReportStart and $MalwareReportEnd..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport -StartDate $MalwareReportStart -EndDate $MalwareReportEnd | Format-List"
		$TextboxResults.Text = Get-MailDetailMalwareReport -StartDate $MalwareReportStart -EndDate $MalwareReportEnd | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailMalwareReportToARecipientToolStripMenuItem_Click = {
	$MalwareRecipient = Read-Host "Enter the email of the recipient"
	try
	{
		$TextboxResults.Text = "Generating mail malware report sent to $MalwareRecipient..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport -RecipientAddress $MalwareRecipient | Format-List"
		$TextboxResults.Text = Get-MailDetailMalwareReport -RecipientAddress $MalwareRecipient | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailMalwareReporforInboundToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Generating mail malware inbound report..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport -Direction Inbound | Format-List "
		$TextboxResults.Text = Get-MailDetailMalwareReport -Direction Inbound | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailMalwareReportForOutboundToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Generating mail malware outbound report..."
		$textboxDetails.Text = "Get-MailDetailMalwareReport -Direction Outbound | Format-List"
		$TextboxResults.Text = Get-MailDetailMalwareReport -Direction Outbound | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Mail Traffic Report

$getRecentMailTrafficReportToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Generating recent mail traffic report..."
		$textboxDetails.Text = "Get-MailTrafficReport | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficReport | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getInboundMailTrafficReportToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Generating inbound traffic report..."
		$textboxDetails.Text = "Get-MailTrafficReport -Direction Inbound | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficReport -Direction Inbound | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getOutboundMailTrafficReportToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Generating outbound mail traffic report..."
		$textboxDetails.Text = "Get-MailTrafficReport -Direction Outbound | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficReport -Direction Outbound | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getMailTrafficReportBetweenDatesToolStripMenuItem_Click = {
	
	#$MailTrafficStart = Read-Host "Enter the start date. EX: 06/13/2015"
	$StartDateText = "Select the beginning date for the mail traffic report"
	$StartDateFormText = "Start Date"
	Call-SelectDatePicker_psf
	$startdate = $SelectDatePicker_monthcalendar1
	$MailTrafficStart = "$startdate".trimend('00:00:00')
	
	#$MailTrafficEnd = Read-Host "Enter the end date. EX: 06/15/2015 "
	$StartDateText = "Select the ending date for the mail traffic report"
	$StartDateFormText = "End Date"
	Call-SelectDatePicker_psf
	$enddate = $SelectDatePicker_monthcalendar1
	$MailTrafficEnd = "$enddate".trimend('00:00:00')
	
	
	Try
	{
		$TextboxResults.Text = "Generating mail traffic report between $MailTrafficStart and $MailTrafficEnd..."
		$textboxDetails.Text = "Get-MailTrafficReport -StartDate $MailTrafficStart -EndDate $MailTrafficEnd | Format-Table -AutoSize"
		$TextboxResults.Text = Get-MailTrafficReport -StartDate $MailTrafficStart -EndDate $MailTrafficEnd | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#ActiveSyncDevices

$getAllUsersActiveSyncDevicesToolStripMenuItem_Click = {
	$savedialog = New-Object windows.forms.savefiledialog
	$savedialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()
	$savedialog.title = "Export to CSV"
	$savedialog.filter = ".csv|*.csv"
	$savedialog.ShowHelp = $True
	$result = $savedialog.ShowDialog(); $result
	if ($result -eq "OK")
	{
		$TextboxResults.Text = "Getting all ActiveSync Devices for all users..."
		$textboxDetails.Text = "Get-Mailbox -ResultSize Unlimited | ForEach-Object { `$PrimarySmtpAddress = `$_.PrimarySmtpAddress; Get-MobileDeviceStatistics -Mailbox `$_.Identity | Select-Object @{ Name = 'PrimarySmtpAddress'; Expression = { `$PrimarySmtpAddress } }, DeviceType, DeviceOS, DeviceMobileOperator, LastSyncAttemptTime } | Export-CSV `$savedialog.filename -Encoding utf8 -NoTypeInformation -Delimiter ", ""
		$MailBox = Get-Mailbox -ResultSize Unlimited
		$MailBox | ForEach-Object { $PrimarySmtpAddress = $_.PrimarySmtpAddress; Get-MobileDeviceStatistics -Mailbox $_.Identity | Select-Object @{ Name = "PrimarySmtpAddress"; Expression = { $PrimarySmtpAddress } }, DeviceType, DeviceOS, DeviceMobileOperator, LastSyncAttemptTime } | Export-CSV $savedialog.filename -Encoding utf8 -NoTypeInformation -Delimiter ","
		$TextboxResults.Text = ""
	}
	else
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}



###SHARED MAILBOXES###

$createASharedMailboxToolStripMenuItem_Click = {
	$NewSharedMailbox = Read-Host "Enter the name of the new Shared Mailbox"
	Try
	{
		$TextboxResults.Text = "Creating new shared mailbox $NewSharedMailbox"
		$textboxDetails.Text = "New-Mailbox -Name $NewSharedMailbox –Shared"
		New-Mailbox -Name $NewSharedMailbox –Shared
		$TextboxResults.Text = Get-Mailbox -RecipientTypeDetails SharedMailbox | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllSharedMailboxesToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting list of shared mailboxes..."
		$textboxDetails.Text = "Get-Mailbox -RecipientTypeDetails SharedMailbox | Format-Table -AutoSize"
		$TextboxResults.Text = Get-Mailbox -RecipientTypeDetails SharedMailbox | Format-Table -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$convertRegularMailboxToSharedToolStripMenuItem_Click = {
	#$ConvertMailboxtoShared = Read-Host "Enter the name of the account you want to convert"
	$SelectUsersFormText = "Select the user you want to convert to a shared mailbox"
	Call-SelectUsersForm_psf
	$ConvertMailboxtoShared = $SelectUsersForm_comboboxUsers
	
	Try
	{
		$TextboxResults.Text = "Converting $ConvertMailboxtoShared to a shared mailbox..."
		$textboxDetails.Text = "Set-Mailbox $ConvertMailboxtoShared –Type shared"
		Set-Mailbox $ConvertMailboxtoShared –Type shared
		$TextboxResults.Text = Get-Mailbox -Identity $ConvertMailboxtoShared | Format-List UserPrincipalName, DisplayName, RecipientTypeDetails, PrimarySmtpAddress, EmailAddresses, IsDirSynced | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$convertSharedMailboxToRegularToolStripMenuItem_Click = {
	#$ConvertMailboxtoRegular = Read-Host "Enter the name of the account you want to convert"
	$SharedMailboxesText = "Select the shared mailbox you want convert to a regular mailbox"
	Call-SelectSharedMailbox_psf
	$ConvertMailboxtoRegular = $SelectSharedMailbox_comboboxSharedMailboxes
	
	Try
	{
		$TextboxResults.Text = "Converting $ConvertMailboxtoRegular to a regular mailbox..."
		$textboxDetails.Text = "Set-Mailbox $ConvertMailboxtoRegular –Type Regular"
		Set-Mailbox $ConvertMailboxtoRegular –Type Regular
		$TextboxResults.Text = Get-Mailbox -Identity $ConvertMailboxtoRegular | Format-List UserPrincipalName, DisplayName, RecipientTypeDetails, PrimarySmtpAddress, EmailAddresses, IsDirSynced | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getDetailedInfoForASharedMailboxToolStripMenuItem_Click = {
	#$SharedMailboxDetailedInfo = Read-Host "Enter the name of the shared mailbox"
	$SharedMailboxesText = "Select the shared mailbox you want to view detailed information for"
	Call-SelectSharedMailbox_psf
	$SharedMailboxDetailedInfo = $SelectSharedMailbox_comboboxSharedMailboxes
	Try
	{
		$TextboxResults.Text = "Getting shared mailbox information for $SharedMailboxDetailedInfo..."
		$textboxDetails.Text = "Get-Mailbox $SharedMailboxDetailedInfo | Format-List"
		$TextboxResults.Text = Get-Mailbox $SharedMailboxDetailedInfo | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
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
		}
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$addFullAccessPermissionsToASharedMailboxToolStripMenuItem_Click = {
	#$SharedMailboxFullAccess = Read-Host "Enter the name of the shared mailbox"
	$SharedMailboxesText = "Select the shared mailbox you want to modify Full Access permissions for"
	Call-SelectSharedMailbox_psf
	$SharedMailboxFullAccess = $SelectSharedMailbox_comboboxSharedMailboxes
	
	#$GrantFullAccesstoSharedMailbox = Read-Host "Enter the UPN of the user that will have full access"
	$SelectUsersFormText = "Select the user you want to have full access to $SharedMailboxFullAccess"
	Call-SelectUsersForm_psf
	$GrantFullAccesstoSharedMailbox = $SelectUsersForm_comboboxUsers
	Try
	{
		$TextboxResults.Text = "Granting Full Access permissions to $GrantFullAccesstoSharedMailbox for the $SharedMailboxFullAccess shared mailbox..."
		$textboxDetails.Text = "Add-MailboxPermission $SharedMailboxFullAccess -User $GrantFullAccesstoSharedMailbox -AccessRights FullAccess -InheritanceType All | Format-List"
		$TextboxResults.Text = Add-MailboxPermission $SharedMailboxFullAccess -User $GrantFullAccesstoSharedMailbox -AccessRights FullAccess -InheritanceType All | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getSharedMailboxPermissionsToolStripMenuItem_Click = {
	#$SharedMailboxPermissionsList = Read-Host "Enter the name of the Shared Mailbox"
	$SharedMailboxesText = "Select the shared mailbox you want to view permissions for"
	Call-SelectSharedMailbox_psf
	$SharedMailboxPermissionsList = $SelectSharedMailbox_comboboxSharedMailboxes
	
	Try
	{
		$TextboxResults.Text = "Getting Send As permissions for $SharedMailboxPermissionsList..."
		$textboxDetails.Text = "Get-RecipientPermission $SharedMailboxPermissionsList | Where-Object { (`$_.Trustee -notlike 'NT AUTHORITY\SELF') } | Sort-Object Trustee | Format-Table Trustee, AccessControlType, AccessRights -AutoSize"
		#$TextboxResults.Text = Get-RecipientPermission $SharedMailboxPermissionsList | Format-List | Out-String
		$TextboxResults.Text = Get-RecipientPermission $SharedMailboxPermissionsList | Where-Object { ($_.Trustee -notlike "NT AUTHORITY\SELF") } | Sort-Object Trustee | Format-Table Trustee, AccessControlType, AccessRights -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getSharedMailboxFullAccessPermissionsToolStripMenuItem_Click = {
	#$SharedMailboxFullAccessPermissionsList = Read-Host "Enter the name of the Shared Mailbox"
	$SharedMailboxesText = "Select the shared mailbox you want to view Full Access permissions for"
	Call-SelectSharedMailbox_psf
	$SharedMailboxFullAccessPermissionsList = $SelectSharedMailbox_comboboxSharedMailboxes
	
	Try
	{
		$TextboxResults.Text = "Getting Full Access permissions for $SharedMailboxFullAccessPermissionsList..."
		$textboxDetails.Text = "Get-MailboxPermission $SharedMailboxFullAccessPermissionsList | Where-Object { (`$_.User -notlike 'NT AUTHORITY\SELF'') } | Sort-Object Identity | Format-Table Identity, User, AccessRights -AutoSize"
		$TextboxResults.Text = Get-MailboxPermission $SharedMailboxFullAccessPermissionsList | Where-Object { ($_.User -notlike "NT AUTHORITY\SELF") } | Sort-Object Identity | Format-Table Identity, User, AccessRights -AutoSize | Out-String
		
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$addSendAsAccessToASharedMailboxToolStripMenuItem_Click = {
	#$SharedMailboxSendAsAccess = Read-Host "Enter the name of the shared mailbox"
	$SharedMailboxesText = "Select the shared mailbox you want to modify Send As permissions for"
	Call-SelectSharedMailbox_psf
	$SharedMailboxSendAsAccess = $SelectSharedMailbox_comboboxSharedMailboxes
	
	#$SharedMailboxSendAsUser = Read-Host "Enter the UPN of the user"
	$SelectUsersFormText = "Select the user you want grant Send As permissions for $SharedMailboxSendAsAccess shared mailbox"
	Call-SelectUsersForm_psf
	$SharedMailboxSendAsUser = $SelectUsersForm_comboboxUsers
	
	Try
	{
		$TextboxResults.Text = "Getting Send As permissions for $SharedMailboxSendAsAccess..."
		$textboxDetails.Text = "Add-RecipientPermission $SharedMailboxSendAsAccess -Trustee $SharedMailboxSendAsUser -AccessRights SendAs | Format-List"
		$TextboxResults.Text = Add-RecipientPermission $SharedMailboxSendAsAccess -Trustee $SharedMailboxSendAsUser -AccessRights SendAs | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}



###CONTACTS###

$createANewMailContactToolStripMenuItem_Click = {
	$ContactFirstName = Read-Host "Enter the contacts first name"
	$ContactsLastName = Read-Host "Enter the contacts last name"
	$ContactName = $ContactFirstName + " " + $ContactsLastName
	$ContactExternalEmail = Read-Host "Enter external email for $ContactName"
	Try
	{
		$TextboxResults.Text = "Creating a new contact $ContactName"
		$textboxDetails.Text = "New-MailContact -Name $ContactName -FirstName $ContactFirstName -LastName $ContactsLastName -ExternalEmailAddress $ContactExternalEmail"
		New-MailContact -Name $ContactName -FirstName $ContactFirstName -LastName $ContactsLastName -ExternalEmailAddress $ContactExternalEmail
		$TextboxResults.Text = Get-MailContact -Identity $ContactName | Format-List DisplayName, EmailAddresses, PrimarySmtpAddress, ExternalEmailAddress, RecipientType | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getAllContactsToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all contacts..."
		$textboxDetails.Text = "Get-MailContact | Sort-Object DisplayName | Format-Table DisplayName, EmailAddresses -AutoSize"
		$TextboxResults.Text = Get-MailContact | Sort-Object DisplayName | Format-Table DisplayName, EmailAddresses -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getDetailedInfoForAContactToolStripMenuItem_Click = {
	#$DetailedInfoForContact = Read-Host "Enter the contact name, displayname, alias or email address"
	$MailContactText = "Select the contact to get detailed information for"
	Call-SelectMailContact_psf
	$DetailedInfoForContact = $SelectMailContact_comboboxSelectMailContacts
	Try
	{
		$TextboxResults.Text = "Getting detailed info for $DetailedInfoForContact..."
		$textboxDetails.Text = "Get-MailContact -Identity $DetailedInfoForContact | Format-List"
		$TextboxResults.Text = Get-MailContact -Identity $DetailedInfoForContact | Format-List | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$removeAContactToolStripMenuItem_Click = {
	#$RemoveMailContact = Read-Host "Enter the contact name, displayname, alias or email address"
	$MailContactText = "Select the contact you want to remove"
	Call-SelectMailContact_psf
	$RemoveMailContact = $SelectMailContact_comboboxSelectMailContacts
	Try
	{
		$TextboxResults.Text = "Removing contact $RemoveMailContact..."
		$textboxDetails.Text = "Remove-MailContact -Identity $RemoveMailContact"
		Remove-MailContact -Identity $RemoveMailContact
		$TextboxResults.Text = "Getting list of all contacts..."
		$TextboxResults.Text = Get-MailContact | Sort-Object DisplayName | Format-Table DisplayName, EmailAddresses, PrimarySmtpAddress, ExternalEmailAddress, RecipientType -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Global Address List

$hideContactFromGALToolStripMenuItem_Click = {
	#$HideGALMailContact = Read-Host "Enter the contact name, displayname, alias or email address"
	$MailContactText = "Select the contact you want to hide from the Global Address List"
	Call-SelectMailContact_psf
	$HideGALMailContact = $SelectMailContact_comboboxSelectMailContacts
	Try
	{
		$TextboxResults.Text = "Hiding $HideGALMailContact from the GAL..."
		$textboxDetails.Text = "Set-MailContact -Identity $HideGALMailContact -HiddenFromAddressListsEnabled `$True"
		Set-MailContact -Identity $HideGALMailContact -HiddenFromAddressListsEnabled $True
		$TextboxResults.Text = Get-MailContact -Identity $HideGALMailContact | Format-List DisplayName, HiddenFromAddressListsEnabled | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$unhideContactFromGALToolStripMenuItem_Click = {
	#$unHideGALMailContact = Read-Host "Enter the contact name, displayname, alias or email address"
	$MailContactText = "Select the contact you want to unhide from the Global Address List"
	Call-SelectMailContact_psf
	$unHideGALMailContact = $SelectMailContact_comboboxSelectMailContacts
	Try
	{
		$TextboxResults.Text = "unhiding $unHideGALMailContact from the GAL..."
		$textboxDetails.Text = "Set-MailContact -Identity $unHideGALMailContact -HiddenFromAddressListsEnabled `$False"
		Set-MailContact -Identity $unHideGALMailContact -HiddenFromAddressListsEnabled $False
		$TextboxResults.Text = Get-MailContact -Identity $unHideGALMailContact | Format-List DisplayName, HiddenFromAddressListsEnabled | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getGALStatusForAllUsersToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting GAL status for all users..."
		$textboxDetails.Text = "Get-MailContact | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize"
		$TextboxResults.Text = Get-MailContact | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getContactsHiddenFromGALToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all users that are hidden from the GAL..."
		$textboxDetails.Text = "Get-MailContact | Where-Object { `$_.HiddenFromAddressListsEnabled -like 'True' } | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize"
		$TextboxResults.Text = Get-MailContact | Where-Object { $_.HiddenFromAddressListsEnabled -like "True" } | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getContactsNotHiddenFromGALToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all users that not are hidden from the GAL"
		$textboxDetails.Text = "Get-MailContact | Where-Object { `$_.HiddenFromAddressListsEnabled -like 'False' } | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize"
		$TextboxResults.Text = Get-MailContact | Where-Object { $_.HiddenFromAddressListsEnabled -like "False" } | Sort-Object DisplayName | Format-Table DisplayName, HiddenFromAddressListsEnabled -AutoSize | Out-String
	}
	Catch
	{
		$TextboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}


###SKYPE###

$getAllOnlineUserToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all online users..."
		$textboxDetails.Text = "Get-CsOnlineUser | Sort-Object DisplayName | Format-Table DisplayName "
		$TextboxResults.Text = Get-CsOnlineUser | Sort-Object DisplayName | Format-Table DisplayName | Out-String
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllClientPoliciesToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all client policies..."
		$textboxDetails.Text = "Get-CsClientPolicy "
		$TextboxResults.Text = Get-CsClientPolicy | Out-String
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getExternalAccessPoliciesToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting external access policies..."
		$textboxDetails.Text = "Get-CsExternalAccessPolicy"
		$TextboxResults.Text = Get-CsExternalAccessPolicy | Out-String
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getVoicePoliciesToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting voice policies..."
		$textboxDetails.Text = "Get-CsVoicePolicy"
		$TextboxResults.Text = Get-CsVoicePolicy | Out-String
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getBroadcastMeetingPoliciesToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting broadcast meeting policies..."
		$textboxDetails.Text = "Get-CsBroadcastMeetingPolicy"
		$TextboxResults.Text = Get-CsBroadcastMeetingPolicy | Out-String
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getBroadcaseMeetingConfigurationToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting broadcast meeting configuration..."
		$textboxDetails.Text = "Get-CsBroadcastMeetingConfiguration"
		$TextboxResults.Text = Get-CsBroadcastMeetingConfiguration | Out-String
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}



###COMPLIANCE CENTER###

$newHoldCompliancePolicyToolStripMenuItem1_Click = {
	$NewRetentionPolicy = Read-Host "Enter the name for the new retention Policy"
	Try
	{
		$textboxResults.Text = "Creating the $NewRetentionPolicy retention policy..."
		$textboxDetails.Text = "New-RetentionCompliancePolicy -Name $NewRetentionPolicy"
		$textboxResults.Text = New-RetentionCompliancePolicy -Name $NewRetentionPolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getHoldCompliancePoliciesToolStripMenuItem_Click = {
	Try
	{
		$textboxResults.Text = "Getting all retention policies..."
		$textboxDetails.Text = "Get-RetentionCompliancePolicy | Format-Table -AutoSize | Out-String"
		$textboxResults.Text = Get-RetentionCompliancePolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeARetentionCompliancePolicyToolStripMenuItem_Click = {
	#$RemoveRetentionPolicy = Read-Host "Enter the policy name you want to remove"
	$RetentionPoliciesText = "Select the policy you want to remove"
	Call-SelectRetentionPolicy_psf
	$RemoveRetentionPolicy = $SelectRetentionPolicy_comboboxRetentionPolicies
	
	Try
	{
		$textboxResults.Text = "Removing the $RemoveRetentionPolicy retention policy..."
		$textboxDetails.Text = "Remove-RetentionCompliancePolicy -Identity $RemoveRetentionPolicy"
		Remove-RetentionCompliancePolicy -Identity $RemoveRetentionPolicy
		$textboxResults.Text = "Getting all retention policies..."
		$textboxResults.Text = Get-RetentionCompliancePolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Data Loss Prevention Policies

$getDataLossPreventionPoliciesToolStripMenuItem_Click = {
	Try
	{
		$textboxResults.Text = "Getting Data Loss Prevention Policies..."
		$textboxDetails.Text = "Get-DlpCompliancePolicy"
		$textboxResults.Text = Get-DlpCompliancePolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$newDataLossPreventionPolicyToolStripMenuItem_Click = {
	$NewDLP = Read-Host "Enter the name of the new Data Loss Prevention Policy"
	Try
	{
		$textboxResults.Text = "Creating the new $NewDLP Data Loss Prevention policy..."
		$textboxDetails.Text = "New-DlpCompliancePolicy -Name $NewDLP"
		$textboxResults.Text = New-DlpCompliancePolicy -Name $NewDLP | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeDataLossPreventionPolicyToolStripMenuItem_Click = {
	$SelectDLPText = "Select the Data Loss Prevention Policy you want to remove"
	Call-SelectDLP_psf
	$RemoveDLP = $SelectDLP_comboboxDLP
	
	Try
	{
		$TextboxResults.Text = "Removing $RemoveDLP Data Loss Prevention policy..."
		$textboxDetails.Text = "Remove-DlpCompliancePolicy -Identity $RemoveDLP"
		Remove-DlpCompliancePolicy -Identity $RemoveDLP
		$TextboxResults.Text = "Getting list of Data Loss Prevention policies..."
		$textboxResults.Text = Get-DlpCompliancePolicy | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

	#Data Loss Compliance Rule

$getDataLossComplianceRulesToolStripMenuItem_Click = {
	Try
	{
		$textboxResults.Text = "Getting Data Loss Compliance rules..."
		$textboxDetails.Text = "Get-DlpComplianceRule"
		$textboxResults.Text = Get-DlpComplianceRule | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$newDataLossComplianceRuleToolStripMenuItem_Click = {
	$NewDLC = Read-Host "Enter the name of the new Data Loss Compliance Rule"
	
	$SelectDLPText = "Select the Data Loss Prevention Policy that will contain the DLP rule"
	Call-SelectDLP_psf
	$DLPolicy = $SelectDLP_comboboxDLP
	Try
	{
		$textboxResults.Text = "Creating the new $NewDLC Data Loss Compliance rule..."
		$textboxDetails.Text = "New-DlpComplianceRule -Name $NewDLC -Policy $DLPolicy"
		$textboxResults.Text = New-DlpComplianceRule -Name $NewDLC -Policy $DLPolicy | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeDataLossComplianceRuleToolStripMenuItem_Click = {
	$SelectDLCText = "Select the Data Loss Compliance Rule you want to remove"
	Call-SelectDataComplianceRule_psf
	$RemoveDLC = $SelectDataComplianceRule_comboboxDLC
	Try
	{
		$textboxResults.Text = "Removing the $RemoveDLC Data Loss Compliance rule..."
		$textboxDetails.Text = "Remove-DlpComplianceRule -Identity $RemoveDLC"
		Remove-DlpComplianceRule -Identity $RemoveDLC
		$textboxResults.Text = "Getting Data Loss Compliance rules..."
		$textboxResults.Text = Get-DlpComplianceRule | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}



###eDISCOVERY###

	#Case Hold Policies

$getCaseHoldPoliciesToolStripMenuItem_Click = {
	$ComplianceCaseText = "Select the eDiscovery case that is associated with the case hold policy"
	Call-SelectComplianceCase_psf
	$CCase = $SelectComplianceCase_comboboxComplianceCases
	Try
	{
		$textboxResults.Text = "Getting Case Hold Policies..."
		$textboxDetails.Text = "Get-CaseHoldPolicy -Case $CCase"
		$textboxResults.Text = Get-CaseHoldPolicy -Case $CCase | Sort-Object Name | Format-Table -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$newComplianceCaseToolStripMenuItem_Click = {
	$NewCC = Read-Host "Enter the name for the new Compliance Case"
	Try
	{
		$textboxResults.Text = "Creating the $NewCC Compliance Case..."
		$textboxDetails.Text = "New-ComplianceCase -Name $NewCC"
		$textboxResults.Text = New-ComplianceCase -Name $NewCC | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$newCaseHoldPolicyToolStripMenuItem_Click = {
	$NewCaseHoldPolicy = Read-Host "Enter the name of the new Case Hold Policy"
	
	$ComplianceCaseText = "Select the eDiscovery case that you want to associate with the $NewCaseHoldPolicy case hold policy"
	Call-SelectComplianceCase_psf
	$CCase = $SelectComplianceCase_comboboxComplianceCases
	
	Try
	{
		$textboxResults.Text = "Creating the new $NewCaseHoldPolicy Case Hold Policy..."
		$textboxDetails.Text = "New-CaseHoldPolicy -Name $NewCaseHoldPolicy -Case $CCase"
		$textboxResults.Text = New-CaseHoldPolicy -Name $NewCaseHoldPolicy -Case $CCase | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$removeComplianceCaseToolStripMenuItem_Click = {
	$ComplianceCaseText = "Select the Compliance Case you want to remove"
	Call-SelectComplianceCase_psf
	$RemoveCCase = $SelectComplianceCase_comboboxComplianceCases
	
	Try
	{
		$textboxResults.Text = "Removing the Compliance Case $RemoveCCase..."
		$textboxDetails.Text = "Remove-ComplianceCase -Identity $RemoveCCase"
		$textboxResults.Text = Remove-ComplianceCase -Identity $RemoveCCase | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}

$getComplianceCasesToolStripMenuItem_Click = {
	Try
	{
		$textboxResults.Text = "Getting Compliance Cases..."
		$textboxDetails.Text = "Get-ComplianceCase"
		$textboxResults.Text = Get-ComplianceCase | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getDetailedComplianceCaseInformationToolStripMenuItem_Click = {
	$ComplianceCaseText = "Select the Compliance Case you want to view detailed information for"
	Call-SelectComplianceCase_psf
	$DetailedCCase = $SelectComplianceCase_comboboxComplianceCases
	
	Try
	{
		$textboxResults.Text = "Getting detailed information for $DetailedCCase..."
		$textboxDetails.Text = "Get-ComplianceCase -Identity $DetailedCCase | Format-List"
		$textboxResults.Text = Get-ComplianceCase -Identity $DetailedCCase | Format-List | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

	#Case Admin

$addAEDiscoveryCaseAdminToolStripMenuItem_Click = {
	$TextboxResults.Text = "Connecting to Exchange Online to get list of users..."
	$exchangeSession = New-PSSession -Name MainAccount -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $global:o365credentials -Authentication Basic -AllowRedirection
	Import-PSSession $exchangeSession -AllowClobber
	$checkboxExchangeOnline.Checked = $true
	
	$SelectUsersFormText = "Select the user you want to add as a eDiscovery Case Admin"
	Call-SelectUsersForm_psf
	$NewECaseAdmin = $SelectUsersForm_comboboxUsers
	
	Try
	{
		$textboxResults.Text = "Adding $NewECaseAdmin as a eDiscovery case admin..."
		$textboxDetails.Text = "Add-eDiscoveryCaseAdmin -User $NewECaseAdmin"
		Add-eDiscoveryCaseAdmin -User $NewECaseAdmin
		$TextboxResults.Text = "Getting eDiscovery Case Admins..."
		$TextboxResults.Text = Get-eDiscoveryCaseAdmin | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getEDiscoveryCaseAdminsToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting eDiscovery Case Admins..."
		$textboxDetails.Text = "Get-eDiscoveryCaseAdmin"
		$TextboxResults.Text = Get-eDiscoveryCaseAdmin | Sort-Object Name | Format-Table Name -AutoSize | Out-String -Width 2147483647
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}


###SHAREPOINT###

$getAllSiteCollectionsToolStripMenuItem_Click = {
	try
	{
		$TextboxResults.Text = "Getting list of sharepoint sites..."
		$textboxDetails.Text = "Get-SPOsite | Format-Table -Autosize"
		$TextboxResults.Text = Get-SPOSite | Format-Table -AutoSize | Out-string
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
	
}

$getAllDeletedSiteCollectionsToolStripMenuItem_Click = {
	Try
	{
		$TextboxResults.Text = "Getting all deleted SharePoint sites..."
		$textboxDetails.Text = "Get-SPODeletedSite | Format-Table -Autosize"
		$TextboxResults.Text = Get-SPODeletedSite | Format-Table -AutoSize | Out-string
	}
	Catch
	{
		$textboxResults.Text = ""
		$textboxDetails.Text = ""
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}



###FILE###

#About

$aboutToolStripMenuItem_Click = {
	$TextboxResults.Text = "                 o365 Admin Center $Version
	
HOW TO USE

To start, click the Connect to Office 365 button. This will connect you to Exchange Online using Remote PowerShell. 
Once you are connected the button will grey out and the form title will change to -CONNECTED TO O365-

The TextBox will display all output for each command. 
If nothing appears and there was no error then the result was null. 
The Textbox also serves as input, passing your own commands to PowerShell with the result populating in the same Textbox. 
To run your own command simply clear the Textbox and enter in your command and press the Run Command button or press Enter on your keyboard.

You can also export the results to a file using the Export to File button. 
The Textbox also allows copy and paste. 
Closing the form properly removes all PSSessions"
	
}

#Pre-Reqs

$prerequisitesToolStripMenuItem_Click = {
	Start-Process -FilePath http://o365admin.center/prerequisites/
}

#Buy Me A Beer
$buyMeABeerToolStripMenuItem_Click = {
	$textboxDetails.Text = ""
	$TextboxResults.Text = ""
	Start-Process -FilePath https://www.paypal.me/bwya77
	#$TextboxResults.Text = "https://www.paypal.me/bwya77
	
	
	#Thank You!"
}

#Changelog

$changelogToolStripMenuItem_Click = {
	Start-Process -FilePath http://o365admin.center/changelog/	
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

$WhitelistToolStripMenuItem_Click = {
	
}

$aliasAddressesToolStripMenuItem_Click = {
	
}

$organizationCustomizationToolStripMenuItem_Click = {
	
}

$getMailMalwareReportToolStripMenuItem_Click = {
	
}

$securityGroupsToolStripMenuItem_Click = {
	
}

$checkboxExchangeOnline_CheckedChanged = {
		
}

$checkboxSkypeForBusiness_CheckedChanged = {
		
}

$checkboxComplianceCenter_CheckedChanged = {
	
}

$checkboxSharepoint_CheckedChanged = {
		
}

$tabpageComplianceCenter_Click = {
		
}


. (Join-Path $PSScriptRoot 'O365 Admin Center.psf.designer.ps1')
$FormO365AdministrationCenter.ShowDialog()
