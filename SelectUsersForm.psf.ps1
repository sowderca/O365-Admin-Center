
$formSelectUser_Load = {
	$LabelInstructions.Text = "$SelectUsersFormText"
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		$UserListcombo = Get-MSOLUser -All | Select-Object  UserPrincipalName
		Load-ComboBox $comboboxUsers $UserListcombo -DisplayMember UserPrincipalName
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		$UserListcombo = Get-MSOLUser -TenantId $PartnerComboBox.SelectedItem.TenantID -All  | Select-Object  UserPrincipalName
		Load-ComboBox $comboboxUsers $UserListcombo -DisplayMember UserPrincipalName
	}
	Else
	{
		$UserListcombo = Get-MSOLUser -All | Select-Object  UserPrincipalName
		Load-ComboBox $comboboxUsers $UserListcombo -DisplayMember UserPrincipalName
	}
	
}

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
		[Parameter(Mandatory=$true)]
		[System.Windows.Forms.ComboBox]$ComboBox,
		[ValidateNotNull()]
		[Parameter(Mandatory=$true)]
		$Items,
	    [Parameter(Mandatory=$false)]
		[string]$DisplayMember,
		[switch]$Append
	)
	
	if(-not $Append)
	{
		$ComboBox.Items.Clear()	
	}
	
	if($Items -is [Object[]])
	{
		$ComboBox.Items.AddRange($Items)
	}
	elseif ($Items -is [Array])
	{
		$ComboBox.BeginUpdate()
		foreach($obj in $Items)
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

$buttonOK_Click={
	$formSelectUser.Close()
}




. (Join-Path $PSScriptRoot 'SelectUsersForm.psf.designer.ps1')
$formSelectUser.ShowDialog()
