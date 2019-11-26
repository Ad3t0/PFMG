$p = Get-Process -Name explorer
$procId = $p.Id[0]
$currentUser = (Get-WmiObject -Class Win32_Process -Filter "ProcessId=$($procId)").GetOwner().User
$currentUserProfile = "C:\Users\$($currentUser)"
function Invoke-ScriptMultithreaded {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true,ValueFromPipeline = $false)]
		[string]$Script,
		[Parameter(Mandatory = $false,ValueFromPipeline = $false)]
		[String[]]$Arguments,
		[Parameter(Mandatory = $true,ValueFromPipeline = $true)]
		[Object[]]$Array
	)
	begin {
		if ($Arguments -eq $NULL) { $Arguments = @() }
		$a = $Arguments
	}
	process {
		foreach ($Element in $Array) {
			try {
				Start-Job -Name $Element -FilePath $Script -ArgumentList $Element,$a[0],$a[1],$a[2],$a[3],$a[4],$a[5],$a[6],$a[7],$a[8],$a[9],$a[10],$a[11],$a[12],$a[13],$a[14],$a[15],$a[16],$a[17],$a[18],$a[19],$a[20]
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
if (!(Test-Path -Path "C:\ProgramData\PFMG-Data\logs"))
{
	New-Item -Path "C:\ProgramData\PFMG-Data\logs" -ItemType "directory"
}
$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
if (!(Test-Path -Path $pathToJson))
{
	$defaultSettings = @"
{
  "exclude": "*.pst",
  "fsizeDesktop": null,
  "fsizeDownloads": null,
  "fsizeDocuments": null,
  "fsizePictures": null
  }
"@
	New-Item $pathToJson
	Set-Content $pathToJson $defaultSettings
}
$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
$fSize = @'
$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
$p = Get-Process -Name explorer
$procId = $p.Id[0]
$currentUser = (Get-WmiObject -Class Win32_Process -Filter "ProcessId=$($procId)").GetOwner().User
$currentUserProfile = "C:\Users\$($currentUser)"
$toExclude = $jsonSettings.exclude.Split(" ")
$fsizeDesktop = "{0:N2}" -f ((Get-ChildItem "$($currentUserProfile)\Desktop" -Recurse -Exclude $toExclude | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB)
$fsizeDownloads = "{0:N2}" -f ((Get-ChildItem "$($currentUserProfile)\Downloads" -Recurse -Exclude $toExclude | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB)
$fsizeDocuments = "{0:N2}" -f ((Get-ChildItem "$($currentUserProfile)\Documents" -Recurse -Exclude $toExclude | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB)
$fsizePictures = "{0:N2}" -f ((Get-ChildItem "$($currentUserProfile)\Pictures" -Recurse -Exclude $toExclude | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB)
$jsonSettings.fsizeDesktop = [math]::Round($fsizeDesktop,3)
$jsonSettings.fsizeDownloads = [math]::Round($fsizeDownloads,3)
$jsonSettings.fsizeDocuments = [math]::Round($fsizeDocuments,3)
$jsonSettings.fsizePictures = [math]::Round($fsizePictures,3)
$jsonSettings | ConvertTo-Json | Set-Content $pathToJson
'@
$pathTofSize = "C:\ProgramData\PFMG-Data\PFMG-fSize.ps1"
Set-Content $pathTofSize $fSize
###################
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration') | Out-Null
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\Microsoft.Uev.SyncController.exe")
######### CustomDialog
$FORM_PFMGMain = New-Object System.Windows.Forms.Form
Add-Type -AssemblyName System.Windows.Forms
$FORM_PFMGMain.Icon = $icon
$FORM_PFMGMain.FormBorderStyle = 'Fixed3D'
$FORM_PFMGMain.MaximizeBox = $false
$FORM_PFMGMain.MinimizeBox = $false
####################
[System.Windows.Forms.Application]::EnableVisualStyles()
$FORM_PFMGMain.ClientSize = '500,380'
$FORM_PFMGMain.text = "PFMG"
$FORM_PFMGMain.TopMost = $false
$GROUPBOX_MigrationPath = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_MigrationPath.height = 55
$GROUPBOX_MigrationPath.width = 480
$GROUPBOX_MigrationPath.text = "Migration Path"
$GROUPBOX_MigrationPath.location = New-Object System.Drawing.Point (10,15)
$TEXTBOX_BackupPath = New-Object system.Windows.Forms.TextBox
$TEXTBOX_BackupPath.multiline = $false
$TEXTBOX_BackupPath.width = 405
$TEXTBOX_BackupPath.height = 20
$TEXTBOX_BackupPath.location = New-Object System.Drawing.Point (15,20)
$TEXTBOX_BackupPath.Font = 'Microsoft Sans Serif,10'
$BUTTON_PathSelection = New-Object system.Windows.Forms.Button
$BUTTON_PathSelection.text = "..."
$BUTTON_PathSelection.width = 30
$BUTTON_PathSelection.height = 30
$BUTTON_PathSelection.location = New-Object System.Drawing.Point (435,15)
$BUTTON_PathSelection.Font = 'Microsoft Sans Serif,10'
$GROUPBOX_ProfileStats = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_ProfileStats.height = 90
$GROUPBOX_ProfileStats.width = 245
$GROUPBOX_ProfileStats.text = "Profile Information"
$GROUPBOX_ProfileStats.location = New-Object System.Drawing.Point (245,80)
$GROUPBOX_Folders = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Folders.height = 90
$GROUPBOX_Folders.width = 225
$GROUPBOX_Folders.text = "Folders"
$GROUPBOX_Folders.location = New-Object System.Drawing.Point (10,80)
$CHECKBOX_Desktop = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Desktop.text = "Desktop"
$CHECKBOX_Desktop.AutoSize = $false
$CHECKBOX_Desktop.width = 80
$CHECKBOX_Desktop.height = 20
$CHECKBOX_Desktop.location = New-Object System.Drawing.Point (20,20)
$CHECKBOX_Desktop.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Documents = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Documents.text = "Documents"
$CHECKBOX_Documents.AutoSize = $false
$CHECKBOX_Documents.width = 100
$CHECKBOX_Documents.height = 20
$CHECKBOX_Documents.location = New-Object System.Drawing.Point (20,55)
$CHECKBOX_Documents.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Pictures = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Pictures.text = "Pictures"
$CHECKBOX_Pictures.AutoSize = $false
$CHECKBOX_Pictures.width = 90
$CHECKBOX_Pictures.height = 20
$CHECKBOX_Pictures.location = New-Object System.Drawing.Point (130,55)
$CHECKBOX_Pictures.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Downloads = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Downloads.text = "Downloads"
$CHECKBOX_Downloads.AutoSize = $false
$CHECKBOX_Downloads.width = 90
$CHECKBOX_Downloads.height = 20
$CHECKBOX_Downloads.location = New-Object System.Drawing.Point (130,20)
$CHECKBOX_Downloads.Font = 'Microsoft Sans Serif,10'
$GROUPBOX_Bookmarks = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Bookmarks.height = 90
$GROUPBOX_Bookmarks.width = 225
$GROUPBOX_Bookmarks.text = "Bookmarks"
$GROUPBOX_Bookmarks.location = New-Object System.Drawing.Point (10,180)
$CHECKBOX_InternetExplorer = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_InternetExplorer.text = "Internet Explorer"
$CHECKBOX_InternetExplorer.AutoSize = $false
$CHECKBOX_InternetExplorer.width = 125
$CHECKBOX_InternetExplorer.height = 20
$CHECKBOX_InternetExplorer.location = New-Object System.Drawing.Point (20,20)
$CHECKBOX_InternetExplorer.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Edge = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Edge.text = "Edge"
$CHECKBOX_Edge.AutoSize = $false
$CHECKBOX_Edge.width = 60
$CHECKBOX_Edge.height = 20
$CHECKBOX_Edge.location = New-Object System.Drawing.Point (150,20)
$CHECKBOX_Edge.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_Firefox = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Firefox.text = "Firefox"
$CHECKBOX_Firefox.AutoSize = $false
$CHECKBOX_Firefox.width = 70
$CHECKBOX_Firefox.height = 20
$CHECKBOX_Firefox.location = New-Object System.Drawing.Point (20,55)
$CHECKBOX_Firefox.Font = 'Microsoft Sans Serif,10'
$CHECKBOX_GoogleChrome = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_GoogleChrome.text = "Google Chrome"
$CHECKBOX_GoogleChrome.AutoSize = $false
$CHECKBOX_GoogleChrome.width = 125
$CHECKBOX_GoogleChrome.height = 20
$CHECKBOX_GoogleChrome.location = New-Object System.Drawing.Point (95,55)
$CHECKBOX_GoogleChrome.Font = 'Microsoft Sans Serif,10'
$BUTTON_Exit = New-Object system.Windows.Forms.Button
$BUTTON_Exit.text = "Exit"
$BUTTON_Exit.width = 90
$BUTTON_Exit.height = 30
$BUTTON_Exit.location = New-Object System.Drawing.Point (400,340)
$BUTTON_Exit.Font = 'Microsoft Sans Serif,10'
$BUTTON_Migrate = New-Object system.Windows.Forms.Button
$BUTTON_Migrate.text = "Migrate"
$BUTTON_Migrate.width = 90
$BUTTON_Migrate.height = 30
$BUTTON_Migrate.location = New-Object System.Drawing.Point (285,340)
$BUTTON_Migrate.Font = 'Microsoft Sans Serif,10'
$LABEL_Username = New-Object system.Windows.Forms.Label
$LABEL_Username.text = "Username:"
$LABEL_Username.AutoSize = $true
$LABEL_Username.width = 40
$LABEL_Username.height = 10
$LABEL_Username.location = New-Object System.Drawing.Point (12,17)
$LABEL_Username.Font = 'Microsoft Sans Serif,10'
$LABEL_Domain = New-Object system.Windows.Forms.Label
$LABEL_Domain.text = "Domain:"
$LABEL_Domain.AutoSize = $true
$LABEL_Domain.width = 40
$LABEL_Domain.height = 10
$LABEL_Domain.location = New-Object System.Drawing.Point (28,42)
$LABEL_Domain.Font = 'Microsoft Sans Serif,10'
$LABEL_Hostname = New-Object system.Windows.Forms.Label
$LABEL_Hostname.text = "Hostname:"
$LABEL_Hostname.AutoSize = $true
$LABEL_Hostname.width = 40
$LABEL_Hostname.height = 10
$LABEL_Hostname.location = New-Object System.Drawing.Point (14,67)
$LABEL_Hostname.Font = 'Microsoft Sans Serif,10'
$LABEL_UsernameValue = New-Object system.Windows.Forms.Label
$LABEL_UsernameValue.AutoSize = $true
$LABEL_UsernameValue.width = 25
$LABEL_UsernameValue.height = 10
$LABEL_UsernameValue.location = New-Object System.Drawing.Point (90,17)
$LABEL_UsernameValue.Font = 'Microsoft Sans Serif,10'
$LABEL_DomainValue = New-Object system.Windows.Forms.Label
$LABEL_DomainValue.AutoSize = $true
$LABEL_DomainValue.width = 25
$LABEL_DomainValue.height = 10
$LABEL_DomainValue.location = New-Object System.Drawing.Point (90,42)
$LABEL_DomainValue.Font = 'Microsoft Sans Serif,10'
$LABEL_HostnameValue = New-Object system.Windows.Forms.Label
$LABEL_HostnameValue.AutoSize = $true
$LABEL_HostnameValue.width = 25
$LABEL_HostnameValue.height = 10
$LABEL_HostnameValue.location = New-Object System.Drawing.Point (90,67)
$LABEL_HostnameValue.Font = 'Microsoft Sans Serif,10'
$LABEL_Version = New-Object system.Windows.Forms.Label
$LABEL_Version.text = "v1.0.0"
$LABEL_Version.AutoSize = $true
$LABEL_Version.width = 25
$LABEL_Version.height = 10
$LABEL_Version.location = New-Object System.Drawing.Point (10,360)
$LABEL_Version.Font = 'Microsoft Sans Serif,10'
$GROUPBOX_Excluded = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Excluded.height = 50
$GROUPBOX_Excluded.width = 225
$GROUPBOX_Excluded.text = "Excluded"
$GROUPBOX_Excluded.location = New-Object System.Drawing.Point (10,280)
$LISTBOX_MigrateInfo = New-Object system.Windows.Forms.ListBox
$LISTBOX_MigrateInfo.text = "listBox"
$LISTBOX_MigrateInfo.width = 245
$LISTBOX_MigrateInfo.height = 150
$LISTBOX_MigrateInfo.location = New-Object System.Drawing.Point (245,180)
$TEXTBOX_Excluded = New-Object system.Windows.Forms.TextBox
$TEXTBOX_Excluded.multiline = $false
$TEXTBOX_Excluded.width = 205
$TEXTBOX_Excluded.height = 20
$TEXTBOX_Excluded.location = New-Object System.Drawing.Point (10,20)
$TEXTBOX_Excluded.Font = 'Microsoft Sans Serif,10'
$LABEL_ProfileFound = New-Object system.Windows.Forms.Label
$LABEL_ProfileFound.AutoSize = $true
$LABEL_ProfileFound.width = 40
$LABEL_ProfileFound.height = 10
$LABEL_ProfileFound.location = New-Object System.Drawing.Point (120,350)
$LABEL_ProfileFound.Font = 'Microsoft Sans Serif,10,style=Bold'
$FORM_PFMGMain.controls.AddRange(@($GROUPBOX_MigrationPath,$GROUPBOX_ProfileStats,$GROUPBOX_Folders,$GROUPBOX_Bookmarks,$BUTTON_Exit,$BUTTON_Migrate,$LABEL_Version,$GROUPBOX_Excluded,$LISTBOX_MigrateInfo,$LABEL_ProfileFound))
$GROUPBOX_MigrationPath.controls.AddRange(@($TEXTBOX_BackupPath,$BUTTON_PathSelection))
$GROUPBOX_Folders.controls.AddRange(@($CHECKBOX_Desktop,$CHECKBOX_Documents,$CHECKBOX_Pictures,$CHECKBOX_Downloads))
$GROUPBOX_Bookmarks.controls.AddRange(@($CHECKBOX_InternetExplorer,$CHECKBOX_Edge,$CHECKBOX_Firefox,$CHECKBOX_GoogleChrome))
$GROUPBOX_ProfileStats.controls.AddRange(@($LABEL_Username,$LABEL_Domain,$LABEL_Hostname,$LABEL_UsernameValue,$LABEL_DomainValue,$LABEL_HostnameValue))
$GROUPBOX_Excluded.controls.AddRange(@($TEXTBOX_Excluded))
#Write your logic code here
$LABEL_ProfileFound.ForeColor = 'Green'
$BUTTON_Migrate.text = 'Export'
Invoke-ScriptMultithreaded -Script "C:\ProgramData\PFMG-Data\PFMG-fSize.ps1" -Array 1
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 2000
$timer.add_tick({ UpdateUi })
function UpdateUi ()
{
	$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
	$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
	$LISTBOX_MigrateInfo.Items.Clear()
	if ($CHECKBOX_Desktop.Checked)
	{
		$LISTBOX_MigrateInfo.Items.Add("Desktop = $($jsonSettings.fsizeDesktop) GB")
		$fsizeTotal += [double]$jsonSettings.fsizeDesktop
	}
	if ($CHECKBOX_Downloads.Checked)
	{
		$LISTBOX_MigrateInfo.Items.Add("Downloads = $($jsonSettings.fsizeDownloads) GB")
		$fsizeTotal += [double]$jsonSettings.fsizeDownloads
	}
	if ($CHECKBOX_Documents.Checked)
	{
		$LISTBOX_MigrateInfo.Items.Add("Documents = $($jsonSettings.fsizeDocuments) GB")
		$fsizeTotal += [double]$jsonSettings.fsizeDocuments
	}
	if ($CHECKBOX_Pictures.Checked)
	{
		$LISTBOX_MigrateInfo.Items.Add("Pictures = $($jsonSettings.fsizePictures) GB")
		$fsizeTotal += [double]$jsonSettings.fsizePictures
	}
	$fsizeTotal = [math]::Round($fsizeTotal,3)
	$LISTBOX_MigrateInfo.Items.Add("")
	$LISTBOX_MigrateInfo.Items.Add("Total = $($fsizeTotal) GB")
}
$timer.start()
$CHECKBOX_Desktop.Checked = $True
$CHECKBOX_Documents.Checked = $True
$CHECKBOX_Pictures.Checked = $True
$CHECKBOX_InternetExplorer.Checked = $True
$CHECKBOX_Edge.Checked = $True
$CHECKBOX_Firefox.Checked = $True
$CHECKBOX_GoogleChrome.Checked = $True
$LABEL_UsernameValue.text = $currentUser
$LABEL_DomainValue.text = $env:USERDNSDOMAIN
$LABEL_HostnameValue.text = $env:COMPUTERNAME
$TEXTBOX_Excluded.text = $jsonSettings.exclude
$timerExclude = New-Object System.Windows.Forms.Timer
$timerExclude.Interval = 1000
$timerExclude.add_tick({ textExcludeChanged })
function textExcludeChanged ()
{
	Invoke-ScriptMultithreaded -Script "C:\ProgramData\PFMG-Data\PFMG-fSize.ps1" -Array 1
	$timerExclude.stop()
}
$TEXTBOX_BackupPath.Add_TextChanged({
		if (Test-Path -Path "$($TEXTBOX_BackupPath.text)\jsonProfile.json")
		{
			$BUTTON_Migrate.text = 'Import'
			$LABEL_ProfileFound.text = "Profile Found"
			$CHECKBOX_Desktop.Enabled = $False
			$CHECKBOX_Downloads.Enabled = $False
			$CHECKBOX_Documents.Enabled = $False
			$CHECKBOX_Pictures.Enabled = $False
			$CHECKBOX_InternetExplorer.Enabled = $False
			$CHECKBOX_Edge.Enabled = $False
			$CHECKBOX_Firefox.Enabled = $False
			$CHECKBOX_GoogleChrome.Enabled = $False
			$TEXTBOX_Excluded.Enabled = $False
			$pathToJsonProfile = "$($TEXTBOX_BackupPath.text)\jsonProfile.json"
			$jsonProfile = Get-Content -Path $pathToJsonProfile -Raw | ConvertFrom-Json
			$LABEL_UsernameValue.ForeColor = 'Green'
			$LABEL_UsernameValue.text = $jsonProfile.UsernameValue
			$LABEL_DomainValue.ForeColor = 'Green'
			$LABEL_DomainValue.text = $jsonProfile.DomainValue
			$LABEL_HostnameValue.ForeColor = 'Green'
			$LABEL_HostnameValue.text = $jsonProfile.HostnameValue
		}
		else
		{
			$BUTTON_Migrate.text = 'Export'
			$LABEL_ProfileFound.text = ""
			$CHECKBOX_Desktop.Enabled = $True
			$CHECKBOX_Downloads.Enabled = $True
			$CHECKBOX_Documents.Enabled = $True
			$CHECKBOX_Pictures.Enabled = $True
			$CHECKBOX_InternetExplorer.Enabled = $True
			$CHECKBOX_Edge.Enabled = $True
			$CHECKBOX_Firefox.Enabled = $True
			$CHECKBOX_GoogleChrome.Enabled = $True
			$TEXTBOX_Excluded.Enabled = $True
			$LABEL_UsernameValue.ForeColor = 'Black'
			$LABEL_DomainValue.ForeColor = 'Black'
			$LABEL_HostnameValue.ForeColor = 'Black'
		}
	})
$TEXTBOX_Excluded.Add_TextChanged({
		$timerExclude.stop()
		$pathToJson = "C:\ProgramData\PFMG-Data\PFMG.json"
		$jsonSettings = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
		$jsonSettings.exclude = $TEXTBOX_Excluded.text
		$jsonSettings | ConvertTo-Json | Set-Content $pathToJson
		$timerExclude.start()
	})
$CHECKBOX_Desktop.Add_CheckStateChanged({
		UpdateUi
	})
$CHECKBOX_Downloads.Add_CheckStateChanged({
		UpdateUi
	})
$CHECKBOX_Documents.Add_CheckStateChanged({
		UpdateUi
	})
$CHECKBOX_Pictures.Add_CheckStateChanged({
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
$BUTTON_PathSelection.Add_Click({
		$TEXTBOX_BackupPath.text = Get-Folder
	})
$BUTTON_Migrate.Add_Click({
		if (Test-Path -Path "$TEXTBOX_BackupPath.text\jsonProfile.json")
		{
			$pathToJsonProfile = "$($TEXTBOX_BackupPath.text)\jsonProfile.json"
			$jsonProfile = Get-Content -Path $pathToJsonProfile -Raw | ConvertFrom-Json
			#$($mFileName) = "$($jsonProfile.UsernameValue)_$($jsonProfile.HostnameValue)-$($jsonProfile.dateTime)PFMG"
			$FORM_PFMGMain.Hide()
			if ($CHECKBOX_Desktop.Checked)
			{
				robocopy "$($TEXTBOX_BackupPath.text)\$($mFileName)\Desktop" "$($currentUserProfile)\Desktop" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_Downloads.Checked)
			{
				robocopy "$($TEXTBOX_BackupPath.text)\$($mFileName)\Downloads" "$($currentUserProfile)\Downloads" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_Documents.Checked)
			{
				robocopy "$($TEXTBOX_BackupPath.text)\$($mFileName)\Documents" "$($currentUserProfile)\Documents" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_Pictures.Checked)
			{
				robocopy "$($TEXTBOX_BackupPath.text)\$($mFileName)\Pictures" "$($currentUserProfile)\Pictures" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_InternetExplorer.Checked)
			{
				robocopy "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Favorites" "$($currentUserProfile)\Favorites" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_Edge.Checked)
			{
				robocopy "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Edge" "$($currentUserProfile)\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\MicrosoftEdge\User" /s /np /eta /xf $toExclude | Write-Host
			}
			if ($CHECKBOX_GoogleChrome.Checked)
			{
				Copy-Item -Path "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\GoogleChrome" -Destination "$($currentUserProfile)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" -Force
			}
			if ($CHECKBOX_Firefox.Checked)
			{
				Stop-Process -Name firefox
				start "C:\Program Files\Mozilla Firefox\firefox.exe" "-headless"
				Sleep 3
				Stop-Process -Name firefox
				Sleep 2
				$firefoxProfile = Get-ChildItem -Path "$($currentUserProfile)\AppData\Roaming\Mozilla\Firefox\Profiles\" | Where-Object { $_.PSIsContainer } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
				Copy-Item -Path "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Firefox\" -Destination "$($currentUserProfile)\AppData\Roaming\Mozilla\Firefox\Profiles\$($firefoxProfile.Name)\places.sqlite" -Force
			}
			$FORM_PFMGMain.Show()
		}
		else
		{
			$dateTime = Get-Date -UFormat '+%Y-%m-%d'
			$mFileName = "$($currentUser)_$($env:COMPUTERNAME)_$($dateTime)PFMG"
			$toExclude = $TEXTBOX_Excluded.text.Split(" ")
			$FORM_PFMGMain.Hide()
			if ($CHECKBOX_Desktop.Checked)
			{
				robocopy "$($currentUserProfile)\Desktop" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Desktop" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_Downloads.Checked)
			{
				robocopy "$($currentUserProfile)\Downloads" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Downloads" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_Documents.Checked)
			{
				robocopy "$($currentUserProfile)\Documents" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Documents" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_Pictures.Checked)
			{
				robocopy "$($currentUserProfile)\Pictures" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Pictures" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_InternetExplorer.Checked)
			{
				robocopy "$($currentUserProfile)\Favorites" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Favorites" /s /np /eta /xf $toExclude desktop.ini | Write-Host
			}
			if ($CHECKBOX_Edge.Checked)
			{
				robocopy "$($currentUserProfile)\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\MicrosoftEdge\User" "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Edge" /s /np /eta /xf $toExclude | Write-Host
			}
			if ($CHECKBOX_GoogleChrome.Checked)
			{
				Copy-Item -Path "$($currentUserProfile)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" -Destination "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\GoogleChrome" -Force
			}
			if ($CHECKBOX_Firefox.Checked)
			{
				Stop-Process -Name firefox
				start "C:\Program Files\Mozilla Firefox\firefox.exe" "-headless"
				Sleep 3
				Stop-Process -Name firefox
				Sleep 2
				$firefoxProfile = Get-ChildItem -Path "$($currentUserProfile)\AppData\Roaming\Mozilla\Firefox\Profiles\" | Where-Object { $_.PSIsContainer } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
				New-Item -Path "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Firefox" -ItemType "directory"
				Copy-Item -Path "$($currentUserProfile)\AppData\Roaming\Mozilla\Firefox\Profiles\$($firefoxProfile.Name)\places.sqlite" -Destination "$($TEXTBOX_BackupPath.text)\$($mFileName)\Bookmarks\Firefox\" -Force
			}
			$pathToJsonProfile = "$($TEXTBOX_BackupPath.text)\$($mFileName)\jsonProfile.json"
			$jsonProfile = @"
{
  "UsernameValue": "*.pst",
  "DomainValue": null,
  "HostnameValue": null,
  "dateTime": null
  }
"@
			New-Item $pathToJsonProfile
			Set-Content $pathToJsonProfile $jsonProfile
			$jsonProfile = Get-Content -Path $pathToJsonProfile -Raw | ConvertFrom-Json
			$jsonProfile.UsernameValue = $currentUser
			$jsonProfile.DomainValue = $env:USERDNSDOMAIN
			$jsonProfile.HostnameValue = $env:COMPUTERNAME
			$jsonProfile.dateTime = $dateTime
			$jsonProfile | ConvertTo-Json | Set-Content $pathToJsonProfile
			$FORM_PFMGMain.Show()
		}
	})
####
$BUTTON_Exit.Add_Click({
		$window.Close()
		Stop-Process $pid
	})
$FORM_PFMGMain.ShowDialog()
[System.GC]::Collect()
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)
