
$formSelectUser_Load={
	$TempDir = $env:temp
	$O365AdminTempFolder = ("$TempDir" + "\O365AdminCenter\names.txt")
	$LabelInstructions.Text = "$SelectUsersFormText"
	$UserListcombo = Get-Content $O365AdminTempFolder
	
	#What to do if connected to main o365 account
	If (Get-PSSession -name mainaccount -ErrorAction SilentlyContinue)
	{
		Load-ComboBox $comboboxNames $UserListcombo
	}
	#What to do if connected to partner account
	ElseIf (Get-PSSession -name partneraccount -ErrorAction SilentlyContinue)
	{
		Load-ComboBox $comboboxNames $UserListcombo
	}
	Else
	{
		Load-ComboBox $comboboxNames $UserListcombo
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
	elseif ($Items -is [System.Collections.IEnumerable])
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

. (Join-Path $PSScriptRoot 'SelectCachedDisplayNames.psf.designer.ps1')
$formSelectUser.ShowDialog()
