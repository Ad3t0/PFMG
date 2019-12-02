$ver = "v1.1.9"
$Computer = $env:COMPUTERNAME
$Users = query user /server:$Computer 2>&1
$Users = $Users | ForEach-Object {
	(($_.trim() -replace ">" -replace "(?m)^([A-Za-z0-9]{3,})\s+(\d{1,2}\s+\w+)", '$1  none  $2' -replace "\s{2,}", "," -replace "none", $null))
} | ConvertFrom-Csv
foreach ($User in $Users) {
	if ($User.STATE -eq "Active") {
		$currentUser = $User.USERNAME
	}
}
$userSID = (New-Object System.Security.Principal.NTAccount($currentUser)).Translate([System.Security.Principal.SecurityIdentifier]).value
$currentUserProfile = "C:\Users\$($currentUser)"
$pcStats = Get-CimInstance -ClassName Win32_ComputerSystem

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Show-Console {
	$consolePtr = [Console.Window]::GetConsoleWindow()
	[Console.Window]::ShowWindow($consolePtr, 4)
}
function Hide-Console {
	$consolePtr = [Console.Window]::GetConsoleWindow()
	[Console.Window]::ShowWindow($consolePtr, 0)
}
function Invoke-ScriptMultithreaded {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $false)]
		[string]$Script,
		[Parameter(Mandatory = $false, ValueFromPipeline = $false)]
		[String[]]$Arguments,
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[Object[]]$Array
	)
	begin {
		if ($NULL -eq $Arguments) { $Arguments = @() }
		$a = $Arguments
	}
	process {
		foreach ($Element in $Array) {
			try {
				Start-Job -Name $Element -FilePath $Script -ArgumentList $Element, $a[0], $a[1], $a[2], $a[3], $a[4], $a[5], $a[6], $a[7], $a[8], $a[9], $a[10], $a[11], $a[12], $a[13], $a[14], $a[15], $a[16], $a[17], $a[18], $a[19], $a[20]
			}
			catch {
				$Exception = $error[0]
				$FunctionError = "`r`n" + "Function:" + "`t" + "Invoke-ScriptMultithreaded " +
				"`r`n" + "Script:" + "`t`t" + $Script +
				"`r`n" + "Element:" + "`t`t" + $Element +
				"`r`n" + "Arguments:" + "`t" + $Arguments +
				"`r`n" + "Error:" + "`t`t" + $Exception
				Write-EventLog -LogName "Windows PowerShell" -Source "PowerShell" -EventId 100 -Message $FunctionError -EntryType Error
			}
		}
	}
	end {
	}
}
if (!(Test-Path -Path "C:\ProgramData\PFMG-Data")) {
	New-Item -Path "C:\ProgramData\PFMG-Data" -ItemType "directory"
}
$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
if (!(Test-Path -Path $pathToJson)) {
	$defaultSettings = @"
{
  "exclude": "*.pst",
  "path": null,
  "exportSizeDesktop": null,
  "exportSizeDownloads": null,
  "exportSizeDocuments": null,
  "exportSizePictures": null,
  "importSizeDesktop": null,
  "importSizeDownloads": null,
  "importSizeDocuments": null,
  "importSizePictures": null
  }
"@
	New-Item $pathToJson
	Set-Content $pathToJson $defaultSettings
}
$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
$exportSize = @'
$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
$Computer = $env:COMPUTERNAME
$Users = query user /server:$Computer 2>&1
$Users = $Users | ForEach-Object {
	(($_.trim() -replace ">" -replace "(?m)^([A-Za-z0-9]{3,})\s+(\d{1,2}\s+\w+)", '$1  none  $2' -replace "\s{2,}", "," -replace "none", $null))
} | ConvertFrom-Csv
foreach ($User in $Users) {
	if ($User.STATE -eq "Active") {
		$currentUser = $User.USERNAME
	}
}
$currentUserProfile = "C:\Users\$($currentUser)"
$toExclude = $jsonSettings.exclude.Split(" ")
$exportSizeDesktop = "{0:N2}" -f ((Get-ChildItem "$($currentUserProfile)\Desktop" -Recurse -Exclude $toExclude | Measure-Object -Property Length -Sum).Sum / 1GB)
$exportSizeDownloads = "{0:N2}" -f ((Get-ChildItem "$($currentUserProfile)\Downloads" -Recurse -Exclude $toExclude | Measure-Object -Property Length -Sum).Sum / 1GB)
$exportSizeDocuments = "{0:N2}" -f ((Get-ChildItem "$($currentUserProfile)\Documents" -Recurse -Exclude $toExclude | Measure-Object -Property Length -Sum).Sum / 1GB)
$exportSizePictures = "{0:N2}" -f ((Get-ChildItem "$($currentUserProfile)\Pictures" -Recurse -Exclude $toExclude | Measure-Object -Property Length -Sum).Sum / 1GB)
$jsonSettings.exportSizeDesktop = [math]::Round($exportSizeDesktop,3)
$jsonSettings.exportSizeDownloads = [math]::Round($exportSizeDownloads,3)
$jsonSettings.exportSizeDocuments = [math]::Round($exportSizeDocuments,3)
$jsonSettings.exportSizePictures = [math]::Round($exportSizePictures,3)
$jsonSettings | ConvertTo-Json | Set-Content $pathToJson
'@
$pathToexportSize = "C:\ProgramData\PFMG-Data\PFMG-exportSize.ps1"
Set-Content $pathToexportSize $exportSize
#
$importSize = @'
$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
$importSizeDesktop = "{0:N2}" -f ((Get-ChildItem "$($jsonSettings.path)\Desktop" -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB)
$importSizeDownloads = "{0:N2}" -f ((Get-ChildItem "$($jsonSettings.path)\Downloads" -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB)
$importSizeDocuments = "{0:N2}" -f ((Get-ChildItem "$($jsonSettings.path)\Documents" -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB)
$importSizePictures = "{0:N2}" -f ((Get-ChildItem "$($jsonSettings.path)\Pictures" -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB)
$jsonSettings.importSizeDesktop = [math]::Round($importSizeDesktop,3)
$jsonSettings.importSizeDownloads = [math]::Round($importSizeDownloads,3)
$jsonSettings.importSizeDocuments = [math]::Round($importSizeDocuments,3)
$jsonSettings.importSizePictures = [math]::Round($importSizePictures,3)
$jsonSettings | ConvertTo-Json | Set-Content $pathToJson
'@
$pathToimportSize = "C:\ProgramData\PFMG-Data\PFMG-importSize.ps1"
Set-Content $pathToimportSize $importSize
#
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration') | Out-Null
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\system32\cleanmgr.exe")
# CustomDialog
$FORM_PFMGMain = New-Object System.Windows.Forms.Form
Add-Type -AssemblyName System.Windows.Forms
$FORM_PFMGMain.Icon = $icon
$FORM_PFMGMain.FormBorderStyle = 'Fixed3D'
$FORM_PFMGMain.MaximizeBox = $false
$FORM_PFMGMain.MinimizeBox = $false
#
[System.Windows.Forms.Application]::EnableVisualStyles()
$FORM_PFMGMain.ClientSize = '500,420'
$FORM_PFMGMain.text = "PFMG"
$FORM_PFMGMain.TopMost = $false
$GROUPBOX_MigrationPath = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_MigrationPath.height = 55
$GROUPBOX_MigrationPath.width = 480
$GROUPBOX_MigrationPath.text = "Migration Path"
$GROUPBOX_MigrationPath.location = New-Object System.Drawing.Point(10, 15)
$TEXTBOX_BackupPath = New-Object system.Windows.Forms.TextBox
$TEXTBOX_BackupPath.multiline = $false
$TEXTBOX_BackupPath.width = 405
$TEXTBOX_BackupPath.height = 20
$TEXTBOX_BackupPath.location = New-Object System.Drawing.Point(15, 20)
$TEXTBOX_BackupPath.Font = 'Microsoft Sans Serif,10'
$BUTTON_PathSelection = New-Object system.Windows.Forms.Button
$BUTTON_PathSelection.text = "..."
$BUTTON_PathSelection.width = 30
$BUTTON_PathSelection.height = 30
$BUTTON_PathSelection.location = New-Object System.Drawing.Point(435, 15)
$BUTTON_PathSelection.Font = 'Microsoft Sans Serif,10'
$GROUPBOX_Folders = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Folders.height = 90
$GROUPBOX_Folders.width = 225
$GROUPBOX_Folders.text = "Folders"
$GROUPBOX_Folders.location = New-Object System.Drawing.Point(10, 75)
$CHECKBOX_Desktop = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Desktop.text = "Desktop"
$CHECKBOX_Desktop.AutoSize = $false
$CHECKBOX_Desktop.width = 80
$CHECKBOX_Desktop.height = 20
$CHECKBOX_Desktop.location = New-Object System.Drawing.Point(20, 20)
$CHECKBOX_Desktop.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Documents = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Documents.text = "Documents"
$CHECKBOX_Documents.AutoSize = $false
$CHECKBOX_Documents.width = 100
$CHECKBOX_Documents.height = 20
$CHECKBOX_Documents.location = New-Object System.Drawing.Point(20, 55)
$CHECKBOX_Documents.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Pictures = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Pictures.text = "Pictures"
$CHECKBOX_Pictures.AutoSize = $false
$CHECKBOX_Pictures.width = 90
$CHECKBOX_Pictures.height = 20
$CHECKBOX_Pictures.location = New-Object System.Drawing.Point(130, 55)
$CHECKBOX_Pictures.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Downloads = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Downloads.text = "Downloads"
$CHECKBOX_Downloads.AutoSize = $false
$CHECKBOX_Downloads.width = 90
$CHECKBOX_Downloads.height = 20
$CHECKBOX_Downloads.location = New-Object System.Drawing.Point(130, 20)
$CHECKBOX_Downloads.Font = 'Microsoft Sans Serif,10'
$GROUPBOX_Bookmarks = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Bookmarks.height = 90
$GROUPBOX_Bookmarks.width = 225
$GROUPBOX_Bookmarks.text = "Bookmarks"
$GROUPBOX_Bookmarks.location = New-Object System.Drawing.Point(10, 175)
$CHECKBOX_InternetExplorer = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_InternetExplorer.text = "Internet Explorer"
$CHECKBOX_InternetExplorer.AutoSize = $false
$CHECKBOX_InternetExplorer.width = 125
$CHECKBOX_InternetExplorer.height = 20
$CHECKBOX_InternetExplorer.location = New-Object System.Drawing.Point(20, 20)
$CHECKBOX_InternetExplorer.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Firefox = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Firefox.text = "Firefox"
$CHECKBOX_Firefox.AutoSize = $false
$CHECKBOX_Firefox.width = 70
$CHECKBOX_Firefox.height = 20
$CHECKBOX_Firefox.location = New-Object System.Drawing.Point(20, 55)
$CHECKBOX_Firefox.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_GoogleChrome = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_GoogleChrome.text = "Google Chrome"
$CHECKBOX_GoogleChrome.AutoSize = $false
$CHECKBOX_GoogleChrome.width = 125
$CHECKBOX_GoogleChrome.height = 20
$CHECKBOX_GoogleChrome.location = New-Object System.Drawing.Point(95, 55)
$CHECKBOX_GoogleChrome.Font = 'Microsoft Sans Serif,10'
$BUTTON_Exit = New-Object system.Windows.Forms.Button
$BUTTON_Exit.text = "Exit"
$BUTTON_Exit.width = 90
$BUTTON_Exit.height = 30
$BUTTON_Exit.location = New-Object System.Drawing.Point(400, 380)
$BUTTON_Exit.Font = 'Microsoft Sans Serif,10'
$BUTTON_Migrate = New-Object system.Windows.Forms.Button
$BUTTON_Migrate.text = "Migrate"
$BUTTON_Migrate.width = 90
$BUTTON_Migrate.height = 30
$BUTTON_Migrate.location = New-Object System.Drawing.Point(285, 380)
$BUTTON_Migrate.Font = 'Microsoft Sans Serif,10'
$LABEL_Version = New-Object system.Windows.Forms.Label
$LABEL_Version.text = $ver
$LABEL_Version.AutoSize = $true
$LABEL_Version.width = 25
$LABEL_Version.height = 10
$LABEL_Version.location = New-Object System.Drawing.Point(9, 399)
$LABEL_Version.Font = 'Microsoft Sans Serif,10'
$GROUPBOX_Excluded = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Excluded.height = 50
$GROUPBOX_Excluded.width = 225
$GROUPBOX_Excluded.text = "Excluded"
$GROUPBOX_Excluded.location = New-Object System.Drawing.Point(10, 335)
$LISTBOX_MigrateInfo = New-Object system.Windows.Forms.ListBox
$LISTBOX_MigrateInfo.text = "listBox"
$LISTBOX_MigrateInfo.width = 245
$LISTBOX_MigrateInfo.height = 289
$LISTBOX_MigrateInfo.location = New-Object System.Drawing.Point(245, 86)
$TEXTBOX_Excluded = New-Object system.Windows.Forms.TextBox
$TEXTBOX_Excluded.multiline = $false
$TEXTBOX_Excluded.width = 205
$TEXTBOX_Excluded.height = 20
$TEXTBOX_Excluded.location = New-Object System.Drawing.Point(10, 20)
$TEXTBOX_Excluded.Font = 'Microsoft Sans Serif,10'
$LABEL_ProfileFound = New-Object system.Windows.Forms.Label
$LABEL_ProfileFound.text = "Profile Found"
$LABEL_ProfileFound.AutoSize = $true
$LABEL_ProfileFound.width = 40
$LABEL_ProfileFound.height = 10
$LABEL_ProfileFound.location = New-Object System.Drawing.Point(120, 395)
$LABEL_ProfileFound.Font = 'Microsoft Sans Serif,10,style=Bold'
$GROUPBOX_Outlook = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Outlook.height = 50
$GROUPBOX_Outlook.width = 225
$GROUPBOX_Outlook.text = "Outlook"
$GROUPBOX_Outlook.location = New-Object System.Drawing.Point(10, 275)
$CHECKBOX_Outlook = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Outlook.text = "Outlook Configuration"
$CHECKBOX_Outlook.AutoSize = $false
$CHECKBOX_Outlook.width = 164
$CHECKBOX_Outlook.height = 20
$CHECKBOX_Outlook.location = New-Object System.Drawing.Point(25, 20)
$CHECKBOX_Outlook.Font = 'Microsoft Sans Serif,10'
$FORM_PFMGMain.controls.AddRange(@($GROUPBOX_MigrationPath, $GROUPBOX_Folders, $GROUPBOX_Bookmarks, $BUTTON_Exit, $BUTTON_Migrate, $LABEL_Version, $GROUPBOX_Excluded, $LISTBOX_MigrateInfo, $LABEL_ProfileFound, $GROUPBOX_Outlook))
$GROUPBOX_MigrationPath.controls.AddRange(@($TEXTBOX_BackupPath, $BUTTON_PathSelection))
$GROUPBOX_Folders.controls.AddRange(@($CHECKBOX_Desktop, $CHECKBOX_Documents, $CHECKBOX_Pictures, $CHECKBOX_Downloads))
$GROUPBOX_Bookmarks.controls.AddRange(@($CHECKBOX_InternetExplorer, $CHECKBOX_Firefox, $CHECKBOX_GoogleChrome))
$GROUPBOX_Excluded.controls.AddRange(@($TEXTBOX_Excluded))
$GROUPBOX_Outlook.controls.AddRange(@($CHECKBOX_Outlook))
#
$FORM_PFMGMain.Add_Shown( {
		$FORM_PFMGMain.Activate()
		Hide-Console
	})
$LISTBOX_MigrateInfo.Items.Add("Loading...")
$LABEL_ProfileFound.ForeColor = 'Green'
$BUTTON_Migrate.Enabled = $False
$BUTTON_Migrate.text = 'Export'
$LISTBOX_MigrateInfo.SelectionMode = 'None'
Invoke-ScriptMultithreaded -Script "C:\ProgramData\PFMG-Data\PFMG-exportSize.ps1" -Array 1
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 2000
$timer.add_tick( { UpdateUi })
function UpdateUi () {
	$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
	$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
	$LISTBOX_MigrateInfo.Items.Clear()
	$LISTBOX_MigrateInfo.Items.Add("System Information:")
	$LISTBOX_MigrateInfo.Items.Add("-------------------------------")
	$LISTBOX_MigrateInfo.Items.Add("Username: $($currentUser)")
	if ($env:USERDNSDOMAIN) {
		$LISTBOX_MigrateInfo.Items.Add("Domain: $($env:USERDNSDOMAIN)")	
	}
	$LISTBOX_MigrateInfo.Items.Add("Computer: $($env:COMPUTERNAME)")
	$LISTBOX_MigrateInfo.Items.Add("Model: $($pcStats.Model)")
	$LISTBOX_MigrateInfo.Items.Add("Manufacturer: $($pcStats.Manufacturer)")
	$LISTBOX_MigrateInfo.Items.Add("")
	$LISTBOX_MigrateInfo.Items.Add("User Profile Data:")
	$LISTBOX_MigrateInfo.Items.Add("-------------------------------")
	if ($CHECKBOX_Desktop.Checked) {
		$LISTBOX_MigrateInfo.Items.Add("Desktop = $($jsonSettings.exportSizeDesktop) GB")
		$exportSizeTotal += [double]$jsonSettings.exportSizeDesktop
	}
	if ($CHECKBOX_Downloads.Checked) {
		$LISTBOX_MigrateInfo.Items.Add("Downloads = $($jsonSettings.exportSizeDownloads) GB")
		$exportSizeTotal += [double]$jsonSettings.exportSizeDownloads
	}
	if ($CHECKBOX_Documents.Checked) {
		$LISTBOX_MigrateInfo.Items.Add("Documents = $($jsonSettings.exportSizeDocuments) GB")
		$exportSizeTotal += [double]$jsonSettings.exportSizeDocuments
	}
	if ($CHECKBOX_Pictures.Checked) {
		$LISTBOX_MigrateInfo.Items.Add("Pictures = $($jsonSettings.exportSizePictures) GB")
		$exportSizeTotal += [double]$jsonSettings.exportSizePictures
	}
	$exportSizeTotal = [math]::Round($exportSizeTotal, 3)
	$LISTBOX_MigrateInfo.Items.Add("")
	$LISTBOX_MigrateInfo.Items.Add("Export Total = $($exportSizeTotal) GB")
}
$timer.start()
$timerImport = New-Object System.Windows.Forms.Timer
$timerImport.Interval = 2000
$timerImport.add_tick( { UpdateUitimerImport })
function UpdateUitimerImport () {
	$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"	
	$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
	$pathToJsonProfile = "$($TEXTBOX_BackupPath.text)\jsonProfile.json"
	$jsonProfile = Get-Content -Path $pathToJsonProfile -Raw | ConvertFrom-Json
	$LISTBOX_MigrateInfo.Items.Clear()
	$LISTBOX_MigrateInfo.Items.Add("System Information:")
	$LISTBOX_MigrateInfo.Items.Add("-------------------------------")
	$LISTBOX_MigrateInfo.Items.Add("Username: $($jsonProfile.UsernameValue)")
	if ($env:USERDNSDOMAIN) {
		$LISTBOX_MigrateInfo.Items.Add("Domain: $($jsonProfile.DomainValue)")	
	}
	$LISTBOX_MigrateInfo.Items.Add("Computer: $($env:COMPUTERNAME)")
	$LISTBOX_MigrateInfo.Items.Add("Model: $($pcStats.Model)")
	$LISTBOX_MigrateInfo.Items.Add("Manufacturer: $($pcStats.Manufacturer)")
	$LISTBOX_MigrateInfo.Items.Add("Export Timestamp: $($jsonProfile.dateTime)")
	$LISTBOX_MigrateInfo.Items.Add("")
	$LISTBOX_MigrateInfo.Items.Add("User Profile Data:")
	$LISTBOX_MigrateInfo.Items.Add("-------------------------------")
	$LISTBOX_MigrateInfo.Items.Add("Desktop = $($jsonSettings.importSizeDesktop) GB")
	$importSizeTotal += [double]$jsonSettings.importSizeDesktop
	$LISTBOX_MigrateInfo.Items.Add("Downloads = $($jsonSettings.importSizeDownloads) GB")
	$importSizeTotal += [double]$jsonSettings.importSizeDownloads
	$LISTBOX_MigrateInfo.Items.Add("Documents = $($jsonSettings.importSizeDocuments) GB")
	$importSizeTotal += [double]$jsonSettings.importSizeDocuments
	$LISTBOX_MigrateInfo.Items.Add("Pictures = $($jsonSettings.importSizePictures) GB")
	$importSizeTotal += [double]$jsonSettings.importSizePictures
	$importSizeTotal = [math]::Round($importSizeTotal, 3)
	$LISTBOX_MigrateInfo.Items.Add("")
	$LISTBOX_MigrateInfo.Items.Add("Import Total = $($importSizeTotal) GB")
}
$CHECKBOX_Desktop.Checked = $True
$CHECKBOX_Documents.Checked = $True
$CHECKBOX_Pictures.Checked = $True
$CHECKBOX_InternetExplorer.Checked = $True
if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook*") {
	$CHECKBOX_Outlook.Checked = $True
}
else {
	$CHECKBOX_Outlook.Enabled = $False
}



if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk") {
	$CHECKBOX_Firefox.Checked = $True
}
else {
	$CHECKBOX_Firefox.Enabled = $False
}
if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk") {
	$CHECKBOX_GoogleChrome.Checked = $True
}
else {
	$CHECKBOX_GoogleChrome.Enabled = $False
}
$TEXTBOX_Excluded.text = $jsonSettings.exclude
$timerExclude = New-Object System.Windows.Forms.Timer
$timerExclude.Interval = 1000
$timerExclude.add_tick( { textExcludeChanged })
function textExcludeChanged () {
	Invoke-ScriptMultithreaded -Script "C:\ProgramData\PFMG-Data\PFMG-exportSize.ps1" -Array 1
	$timerExclude.stop()
}
$TEXTBOX_BackupPath.Add_TextChanged( {
		if (!([bool]([uri]$TEXTBOX_BackupPath.text).IsUnc -and $TEXTBOX_BackupPath.text -match '^\\\\\w+$')) {
			if (Test-Path -Path $TEXTBOX_BackupPath.text) {
				$BUTTON_Migrate.Enabled = $True
			}
			else {
				$BUTTON_Migrate.Enabled = $False
			}
			if (Test-Path -Path "$($TEXTBOX_BackupPath.text)\jsonProfile.json") {
				Invoke-ScriptMultithreaded -Script "C:\ProgramData\PFMG-Data\PFMG-importSize.ps1" -Array 1
				$LISTBOX_MigrateInfo.Items.Clear()
				$LISTBOX_MigrateInfo.Items.Add("Loading...")
				$timer.stop()
				$timerImport.start()
				$BUTTON_Migrate.text = 'Import'
				$LABEL_ProfileFound.text = "Profile Found"
				$CHECKBOX_Desktop.Enabled = $False
				$CHECKBOX_Downloads.Enabled = $False
				$CHECKBOX_Documents.Enabled = $False
				$CHECKBOX_Pictures.Enabled = $False
				$CHECKBOX_InternetExplorer.Enabled = $False


		
					
				
				
				$CHECKBOX_Outlook.Enabled = $False
		
				$CHECKBOX_Firefox.Enabled = $False
				$CHECKBOX_GoogleChrome.Enabled = $False
				$TEXTBOX_Excluded.Enabled = $False
			}
			else {
				$timerImport.stop()
				$timer.start()
				$LISTBOX_MigrateInfo.Items.Clear()
				$LISTBOX_MigrateInfo.Items.Add("Loading...")
				$BUTTON_Migrate.text = 'Export'
				$LABEL_ProfileFound.text = ""
				$CHECKBOX_Desktop.Enabled = $True
				$CHECKBOX_Downloads.Enabled = $True
				$CHECKBOX_Documents.Enabled = $True
				$CHECKBOX_Pictures.Enabled = $True
				$CHECKBOX_InternetExplorer.Enabled = $True
				if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook*") {
					$CHECKBOX_Outlook.Enabled = $True
				}

				if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk") {
					$CHECKBOX_Firefox.Enabled = $True
				}
				if (Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk") {
					$CHECKBOX_GoogleChrome.Enabled = $True
				}
				$TEXTBOX_Excluded.Enabled = $True
			}
		}
	})
$TEXTBOX_Excluded.Add_TextChanged( {
		$timerExclude.stop()
		$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
		$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
		$jsonSettings.exclude = $TEXTBOX_Excluded.text
		$jsonSettings | ConvertTo-Json | Set-Content $pathToJson
		$timerExclude.start()
	})
$CHECKBOX_Desktop.Add_CheckStateChanged( {
		UpdateUi
	})
$CHECKBOX_Downloads.Add_CheckStateChanged( {
		UpdateUi
	})
$CHECKBOX_Documents.Add_CheckStateChanged( {
		UpdateUi
	})
$CHECKBOX_Pictures.Add_CheckStateChanged( {
		UpdateUi
	})
function Get-Folder {
	[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
	$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
	$FolderBrowserDialog.Description = "Select a folder for the data migration"
	$FolderBrowserDialog.RootFolder = 'MyComputer'
	[void]$FolderBrowserDialog.ShowDialog()
	return $FolderBrowserDialog.SelectedPath
}
$BUTTON_PathSelection.Add_Click( {
		$TEXTBOX_BackupPath.text = Get-Folder
	})
$BUTTON_Migrate.Add_Click( {
		if (Test-Path -Path "$($TEXTBOX_BackupPath.text)\jsonProfile.json") {
			$importConfirm = [System.Windows.MessageBox]::Show('All open web browsers will be force closed before the import. Are you sure?', 'Profile Import', 'YesNo', 'Warning')
			switch ($importConfirm) {
				'Yes' {
			
					Stop-Process -Name Firefox -Force -ErrorAction SilentlyContinue
					Stop-Process -Name Chrome -Force -ErrorAction SilentlyContinue
					$pathToJsonProfile = "$($TEXTBOX_BackupPath.text)\jsonProfile.json"
					$jsonProfile = Get-Content -Path $pathToJsonProfile -Raw | ConvertFrom-Json
					Show-Console
					$FORM_PFMGMain.Hide()
					robocopy "$($TEXTBOX_BackupPath.text)\Desktop" "$($currentUserProfile)\Desktop" /s /np /eta /mov /xf $toExclude desktop.ini | Write-Host
					robocopy "$($TEXTBOX_BackupPath.text)\Downloads" "$($currentUserProfile)\Downloads" /s /np /eta /mov /xf $toExclude desktop.ini | Write-Host
					robocopy "$($TEXTBOX_BackupPath.text)\Documents" "$($currentUserProfile)\Documents" /s /np /eta /mov /xf $toExclude desktop.ini | Write-Host
					robocopy "$($TEXTBOX_BackupPath.text)\Pictures" "$($currentUserProfile)\Pictures" /s /np /eta /mov /xf $toExclude desktop.ini | Write-Host
					robocopy "$($TEXTBOX_BackupPath.text)\Bookmarks\Favorites" "$($currentUserProfile)\Favorites" /s /np /eta /mov /xf $toExclude desktop.ini | Write-Host
					REGEDIT /S "$($TEXTBOX_BackupPath.text)\Outlook\Outlook.reg"
					New-Item -Path "$($currentUserProfile)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" -ItemType "directory" -Force -ErrorAction SilentlyContinue
					Copy-Item -Path "$($TEXTBOX_BackupPath.text)\Bookmarks\GoogleChrome\Bookmarks" -Destination "$($currentUserProfile)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" -Force -ErrorAction SilentlyContinue
					Start-Process "Firefox" -ArgumentList "-headless"
					Start-Sleep 1
					Stop-Process -Name Firefox -Force -ErrorAction SilentlyContinue
					Start-Sleep 1
					$firefoxProfile = Get-ChildItem -Path "$($currentUserProfile)\AppData\Roaming\Mozilla\Firefox\Profiles\" | Where-Object { $_.PSIsContainer } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
					Copy-Item -Path "$($TEXTBOX_BackupPath.text)\Bookmarks\Firefox\places.sqlite" -Destination "$($currentUserProfile)\AppData\Roaming\Mozilla\Firefox\Profiles\$($firefoxProfile.Name)\places.sqlite" -Force -ErrorAction SilentlyContinue
					Hide-Console
					$FORM_PFMGMain.Show()
				}
			}
		}
		else {
			if ($exportSizeTotal -gt 5) {
				$importConfirm = [System.Windows.MessageBox]::Show('This is a large profile at $($exportSizeTotal) GB. All open web browsers will be force closed before the export. Are you sure?', 'Profile Export', 'YesNo', 'Warning')
			}
			else {
				$importConfirm = [System.Windows.MessageBox]::Show('All open web browsers will be force closed before the export. Are you sure?', 'Profile Export', 'YesNo', 'Warning')
			}
			switch ($importConfirm) {
				'Yes' {
					
					Stop-Process -Name Firefox -Force -ErrorAction SilentlyContinue
					Stop-Process -Name Chrome -Force -ErrorAction SilentlyContinue
					$dateTime = Get-Date -UFormat '+%Y-%m-%d'
					$dateTimeLong = Get-Date -UFormat '+%Y-%m-%d T%H-%M-%S'
					$mFileName = "$($currentUser)_$($env:COMPUTERNAME)_$($dateTime)PFMG"
					$toExclude = $TEXTBOX_Excluded.text.Split(" ")
					Show-Console
					$FORM_PFMGMain.Hide()
					if ($CHECKBOX_Desktop.Checked) {
						robocopy "$($currentUserProfile)\Desktop" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Desktop" /s /np /eta /xf $toExclude desktop.ini | Write-Host
					}
					if ($CHECKBOX_Downloads.Checked) {
						robocopy "$($currentUserProfile)\Downloads" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Downloads" /s /np /eta /xf $toExclude desktop.ini | Write-Host
					}
					if ($CHECKBOX_Documents.Checked) {
						robocopy "$($currentUserProfile)\Documents" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Documents" /s /np /eta /xf $toExclude desktop.ini | Write-Host
					}
					if ($CHECKBOX_Pictures.Checked) {
						robocopy "$($currentUserProfile)\Pictures" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Pictures" /s /np /eta /xf $toExclude desktop.ini | Write-Host
					}
					if ($CHECKBOX_InternetExplorer.Checked) {
						robocopy "$($currentUserProfile)\Favorites" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Favorites" /s /np /eta /xf $toExclude desktop.ini Bing.lnk | Write-Host
					}




					if ($CHECKBOX_Outlook.Checked) {
						reg export "HKU\$($userSID)\Software\Microsoft\Office\16.0\Outlook\Profiles" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Outlook\Outlook.reg"
					}





					if ($CHECKBOX_GoogleChrome.Checked) {
						New-Item -Path "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\GoogleChrome" -ItemType "directory" -ErrorAction SilentlyContinue
						Copy-Item -Path "$($currentUserProfile)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" -Destination "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\GoogleChrome\Bookmarks" -Force -ErrorAction SilentlyContinue
					}
					if ($CHECKBOX_Firefox.Checked) {
						Start-Process "Firefox" -ArgumentList "-headless"
						Start-Sleep 1
						Stop-Process -Name Firefox -Force -ErrorAction SilentlyContinue
						$firefoxProfile = Get-ChildItem -Path "$($currentUserProfile)\AppData\Roaming\Mozilla\Firefox\Profiles\" -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
						New-Item -Path "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Firefox" -ItemType "directory" -ErrorAction SilentlyContinue
						Copy-Item -Path "$($currentUserProfile)\AppData\Roaming\Mozilla\Firefox\Profiles\$($firefoxProfile.Name)\places.sqlite" -Destination "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Firefox\" -Force -ErrorAction SilentlyContinue
					}
					$pathToJsonProfile = "$($TEXTBOX_BackupPath.text)\$($mFileName)\jsonProfile.json"
					$jsonProfile = @"
{
  "UsernameValue": "*.pst",
  "DomainValue": null,
  "HostnameValue": null,
  "ModelValue": null,
  "ManufacturerValue": null,
  "dateTime": null
  }
"@
					New-Item $pathToJsonProfile -ErrorAction SilentlyContinue
					Set-Content $pathToJsonProfile $jsonProfile
					$jsonProfile = Get-Content -Path $pathToJsonProfile -Raw | ConvertFrom-Json
					$jsonProfile.UsernameValue = $currentUser
					$jsonProfile.DomainValue = $env:USERDNSDOMAIN
					$jsonProfile.HostnameValue = $env:COMPUTERNAME
					$jsonProfile.ModelValue = $pcStats.Model
					$jsonProfile.ManufacturerValue = $pcStats.Manufacturer
					$jsonProfile.dateTime = $dateTimeLong
					$jsonProfile | ConvertTo-Json | Set-Content $pathToJsonProfile
					$LABEL_ProfileFound.text = "Complete!"
					$LABEL_ProfileFound.ForeColor = 'Green'
					$FORM_PFMGMain.Show()
				}
			}
		}
	})
#
$BUTTON_Exit.Add_Click( {
		$window.Close()
		Stop-Process $pid
	})
$FORM_PFMGMain.ShowDialog()
[System.GC]::Collect()
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)
