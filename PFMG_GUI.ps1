<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    PFMG
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$FORM_PFMGMain                   = New-Object system.Windows.Forms.Form
$FORM_PFMGMain.ClientSize        = '500,350'
$FORM_PFMGMain.text              = "PFMG"
$FORM_PFMGMain.TopMost           = $false

$GROUPBOX_MigrationPath          = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_MigrationPath.height   = 75
$GROUPBOX_MigrationPath.width    = 480
$GROUPBOX_MigrationPath.text     = "Migration Path"
$GROUPBOX_MigrationPath.location  = New-Object System.Drawing.Point(10,15)

$TEXTBOX_BackupPath              = New-Object system.Windows.Forms.TextBox
$TEXTBOX_BackupPath.multiline    = $false
$TEXTBOX_BackupPath.width        = 360
$TEXTBOX_BackupPath.height       = 20
$TEXTBOX_BackupPath.location     = New-Object System.Drawing.Point(65,30)
$TEXTBOX_BackupPath.Font         = 'Microsoft Sans Serif,10'

$LABEL_Path                      = New-Object system.Windows.Forms.Label
$LABEL_Path.text                 = "Path"
$LABEL_Path.AutoSize             = $true
$LABEL_Path.width                = 25
$LABEL_Path.height               = 10
$LABEL_Path.location             = New-Object System.Drawing.Point(25,34)
$LABEL_Path.Font                 = 'Microsoft Sans Serif,10'

$BUTTON_PathSelection            = New-Object system.Windows.Forms.Button
$BUTTON_PathSelection.text       = "..."
$BUTTON_PathSelection.width      = 30
$BUTTON_PathSelection.height     = 30
$BUTTON_PathSelection.location   = New-Object System.Drawing.Point(435,25)
$BUTTON_PathSelection.Font       = 'Microsoft Sans Serif,10'

$GROUPBOX_ProfileStats           = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_ProfileStats.height    = 200
$GROUPBOX_ProfileStats.width     = 245
$GROUPBOX_ProfileStats.text      = "Profile Information"
$GROUPBOX_ProfileStats.location  = New-Object System.Drawing.Point(245,100)

$GROUPBOX_Folders                = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Folders.height         = 89
$GROUPBOX_Folders.width          = 225
$GROUPBOX_Folders.text           = "Folders"
$GROUPBOX_Folders.location       = New-Object System.Drawing.Point(10,100)

$CHECKBOX_Desktop                = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Desktop.text           = "Desktop"
$CHECKBOX_Desktop.AutoSize       = $false
$CHECKBOX_Desktop.width          = 80
$CHECKBOX_Desktop.height         = 20
$CHECKBOX_Desktop.location       = New-Object System.Drawing.Point(20,20)
$CHECKBOX_Desktop.Font           = 'Microsoft Sans Serif,10'

$CHECKBOX_Documents              = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Documents.text         = "Documents"
$CHECKBOX_Documents.AutoSize     = $false
$CHECKBOX_Documents.width        = 100
$CHECKBOX_Documents.height       = 20
$CHECKBOX_Documents.location     = New-Object System.Drawing.Point(20,55)
$CHECKBOX_Documents.Font         = 'Microsoft Sans Serif,10'

$CHECKBOX_Pictures               = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Pictures.text          = "Pictures"
$CHECKBOX_Pictures.AutoSize      = $false
$CHECKBOX_Pictures.width         = 90
$CHECKBOX_Pictures.height        = 20
$CHECKBOX_Pictures.location      = New-Object System.Drawing.Point(130,55)
$CHECKBOX_Pictures.Font          = 'Microsoft Sans Serif,10'

$CHECKBOX_Downloads              = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Downloads.text         = "Downloads"
$CHECKBOX_Downloads.AutoSize     = $false
$CHECKBOX_Downloads.width        = 90
$CHECKBOX_Downloads.height       = 20
$CHECKBOX_Downloads.location     = New-Object System.Drawing.Point(130,20)
$CHECKBOX_Downloads.Font         = 'Microsoft Sans Serif,10'

$GROUPBOX_Bookmarks              = New-Object system.Windows.Forms.Groupbox
$GROUPBOX_Bookmarks.height       = 90
$GROUPBOX_Bookmarks.width        = 225
$GROUPBOX_Bookmarks.text         = "Bookmarks"
$GROUPBOX_Bookmarks.location     = New-Object System.Drawing.Point(10,200)

$CHECKBOX_InternetExplorer       = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_InternetExplorer.text  = "Internet Explorer"
$CHECKBOX_InternetExplorer.AutoSize  = $false
$CHECKBOX_InternetExplorer.width  = 125
$CHECKBOX_InternetExplorer.height  = 20
$CHECKBOX_InternetExplorer.location  = New-Object System.Drawing.Point(20,20)
$CHECKBOX_InternetExplorer.Font  = 'Microsoft Sans Serif,10'

$CHECKBOX_Edge                   = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Edge.text              = "Edge"
$CHECKBOX_Edge.AutoSize          = $false
$CHECKBOX_Edge.width             = 60
$CHECKBOX_Edge.height            = 20
$CHECKBOX_Edge.location          = New-Object System.Drawing.Point(150,20)
$CHECKBOX_Edge.Font              = 'Microsoft Sans Serif,10'

$CHECKBOX_Firefox                = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_Firefox.text           = "Firefox"
$CHECKBOX_Firefox.AutoSize       = $false
$CHECKBOX_Firefox.width          = 70
$CHECKBOX_Firefox.height         = 20
$CHECKBOX_Firefox.location       = New-Object System.Drawing.Point(20,55)
$CHECKBOX_Firefox.Font           = 'Microsoft Sans Serif,10'

$CHECKBOX_GoogleChrome           = New-Object system.Windows.Forms.CheckBox
$CHECKBOX_GoogleChrome.text      = "Google Chrome"
$CHECKBOX_GoogleChrome.AutoSize  = $false
$CHECKBOX_GoogleChrome.width     = 125
$CHECKBOX_GoogleChrome.height    = 20
$CHECKBOX_GoogleChrome.location  = New-Object System.Drawing.Point(95,55)
$CHECKBOX_GoogleChrome.Font      = 'Microsoft Sans Serif,10'

$BUTTON_Exit                     = New-Object system.Windows.Forms.Button
$BUTTON_Exit.text                = "Exit"
$BUTTON_Exit.width               = 90
$BUTTON_Exit.height              = 30
$BUTTON_Exit.location            = New-Object System.Drawing.Point(400,310)
$BUTTON_Exit.Font                = 'Microsoft Sans Serif,10'

$BUTTON_Migrate                  = New-Object system.Windows.Forms.Button
$BUTTON_Migrate.text             = "Migrate"
$BUTTON_Migrate.width            = 90
$BUTTON_Migrate.height           = 30
$BUTTON_Migrate.location         = New-Object System.Drawing.Point(285,310)
$BUTTON_Migrate.Font             = 'Microsoft Sans Serif,10'

$LABEL_Desktop                   = New-Object system.Windows.Forms.Label
$LABEL_Desktop.text              = "Desktop:"
$LABEL_Desktop.AutoSize          = $true
$LABEL_Desktop.width             = 25
$LABEL_Desktop.height            = 10
$LABEL_Desktop.location          = New-Object System.Drawing.Point(27,100)
$LABEL_Desktop.Font              = 'Microsoft Sans Serif,10'

$LABEL_DesktopValue              = New-Object system.Windows.Forms.Label
$LABEL_DesktopValue.text         = "null"
$LABEL_DesktopValue.AutoSize     = $true
$LABEL_DesktopValue.width        = 25
$LABEL_DesktopValue.height       = 10
$LABEL_DesktopValue.location     = New-Object System.Drawing.Point(90,100)
$LABEL_DesktopValue.Font         = 'Microsoft Sans Serif,10'

$LABEL_Downloads                 = New-Object system.Windows.Forms.Label
$LABEL_Downloads.text            = "Downloads:"
$LABEL_Downloads.AutoSize        = $true
$LABEL_Downloads.width           = 25
$LABEL_Downloads.height          = 10
$LABEL_Downloads.location        = New-Object System.Drawing.Point(10,125)
$LABEL_Downloads.Font            = 'Microsoft Sans Serif,10'

$LABEL_Username                  = New-Object system.Windows.Forms.Label
$LABEL_Username.text             = "Username:"
$LABEL_Username.AutoSize         = $true
$LABEL_Username.width            = 40
$LABEL_Username.height           = 10
$LABEL_Username.location         = New-Object System.Drawing.Point(12,20)
$LABEL_Username.Font             = 'Microsoft Sans Serif,10'

$LABEL_Domain                    = New-Object system.Windows.Forms.Label
$LABEL_Domain.text               = "Domain:"
$LABEL_Domain.AutoSize           = $true
$LABEL_Domain.width              = 40
$LABEL_Domain.height             = 10
$LABEL_Domain.location           = New-Object System.Drawing.Point(28,45)
$LABEL_Domain.Font               = 'Microsoft Sans Serif,10'

$LABEL_Hostname                  = New-Object system.Windows.Forms.Label
$LABEL_Hostname.text             = "Hostname:"
$LABEL_Hostname.AutoSize         = $true
$LABEL_Hostname.width            = 40
$LABEL_Hostname.height           = 10
$LABEL_Hostname.location         = New-Object System.Drawing.Point(14,70)
$LABEL_Hostname.Font             = 'Microsoft Sans Serif,10'

$LABEL_Documents                 = New-Object system.Windows.Forms.Label
$LABEL_Documents.text            = "Documents:"
$LABEL_Documents.AutoSize        = $true
$LABEL_Documents.width           = 25
$LABEL_Documents.height          = 10
$LABEL_Documents.location        = New-Object System.Drawing.Point(10,150)
$LABEL_Documents.Font            = 'Microsoft Sans Serif,10'

$LABEL_Pictures                  = New-Object system.Windows.Forms.Label
$LABEL_Pictures.text             = "Pictures:"
$LABEL_Pictures.AutoSize         = $true
$LABEL_Pictures.width            = 25
$LABEL_Pictures.height           = 10
$LABEL_Pictures.location         = New-Object System.Drawing.Point(31,175)
$LABEL_Pictures.Font             = 'Microsoft Sans Serif,10'

$LABEL_DownloadsValue            = New-Object system.Windows.Forms.Label
$LABEL_DownloadsValue.text       = "null"
$LABEL_DownloadsValue.AutoSize   = $true
$LABEL_DownloadsValue.width      = 25
$LABEL_DownloadsValue.height     = 10
$LABEL_DownloadsValue.location   = New-Object System.Drawing.Point(90,125)
$LABEL_DownloadsValue.Font       = 'Microsoft Sans Serif,10'

$LABEL_DocumentsValue            = New-Object system.Windows.Forms.Label
$LABEL_DocumentsValue.text       = "null"
$LABEL_DocumentsValue.AutoSize   = $true
$LABEL_DocumentsValue.width      = 25
$LABEL_DocumentsValue.height     = 10
$LABEL_DocumentsValue.location   = New-Object System.Drawing.Point(90,150)
$LABEL_DocumentsValue.Font       = 'Microsoft Sans Serif,10'

$LABEL_PicturesValue             = New-Object system.Windows.Forms.Label
$LABEL_PicturesValue.text        = "null"
$LABEL_PicturesValue.AutoSize    = $true
$LABEL_PicturesValue.width       = 25
$LABEL_PicturesValue.height      = 10
$LABEL_PicturesValue.location    = New-Object System.Drawing.Point(90,175)
$LABEL_PicturesValue.Font        = 'Microsoft Sans Serif,10'

$LABEL_UsernameValue             = New-Object system.Windows.Forms.Label
$LABEL_UsernameValue.text        = "null"
$LABEL_UsernameValue.AutoSize    = $true
$LABEL_UsernameValue.width       = 25
$LABEL_UsernameValue.height      = 10
$LABEL_UsernameValue.location    = New-Object System.Drawing.Point(90,20)
$LABEL_UsernameValue.Font        = 'Microsoft Sans Serif,10'

$LABEL_DomainValue               = New-Object system.Windows.Forms.Label
$LABEL_DomainValue.text          = "null"
$LABEL_DomainValue.AutoSize      = $true
$LABEL_DomainValue.width         = 25
$LABEL_DomainValue.height        = 10
$LABEL_DomainValue.location      = New-Object System.Drawing.Point(90,45)
$LABEL_DomainValue.Font          = 'Microsoft Sans Serif,10'

$LABEL_HostnameValue             = New-Object system.Windows.Forms.Label
$LABEL_HostnameValue.text        = "null"
$LABEL_HostnameValue.AutoSize    = $true
$LABEL_HostnameValue.width       = 25
$LABEL_HostnameValue.height      = 10
$LABEL_HostnameValue.location    = New-Object System.Drawing.Point(90,70)
$LABEL_HostnameValue.Font        = 'Microsoft Sans Serif,10'

$LABEL_Version                   = New-Object system.Windows.Forms.Label
$LABEL_Version.text              = "null"
$LABEL_Version.AutoSize          = $true
$LABEL_Version.width             = 25
$LABEL_Version.height            = 10
$LABEL_Version.location          = New-Object System.Drawing.Point(15,325)
$LABEL_Version.Font              = 'Microsoft Sans Serif,10'

$LABEL_TotalSize                 = New-Object system.Windows.Forms.Label
$LABEL_TotalSize.text            = "Total Size:"
$LABEL_TotalSize.AutoSize        = $true
$LABEL_TotalSize.width           = 25
$LABEL_TotalSize.height          = 10
$LABEL_TotalSize.location        = New-Object System.Drawing.Point(100,315)
$LABEL_TotalSize.Font            = 'Microsoft Sans Serif,10'

$LABEL_TotalSizeValue            = New-Object system.Windows.Forms.Label
$LABEL_TotalSizeValue.text       = "null"
$LABEL_TotalSizeValue.AutoSize   = $true
$LABEL_TotalSizeValue.width      = 25
$LABEL_TotalSizeValue.height     = 10
$LABEL_TotalSizeValue.location   = New-Object System.Drawing.Point(170,315)
$LABEL_TotalSizeValue.Font       = 'Microsoft Sans Serif,10'

$FORM_PFMGMain.controls.AddRange(@($GROUPBOX_MigrationPath,$GROUPBOX_ProfileStats,$GROUPBOX_Folders,$GROUPBOX_Bookmarks,$BUTTON_Exit,$BUTTON_Migrate,$LABEL_Version,$LABEL_TotalSize,$LABEL_TotalSizeValue))
$GROUPBOX_MigrationPath.controls.AddRange(@($TEXTBOX_BackupPath,$LABEL_Path,$BUTTON_PathSelection))
$GROUPBOX_Folders.controls.AddRange(@($CHECKBOX_Desktop,$CHECKBOX_Documents,$CHECKBOX_Pictures,$CHECKBOX_Downloads))
$GROUPBOX_Bookmarks.controls.AddRange(@($CHECKBOX_InternetExplorer,$CHECKBOX_Edge,$CHECKBOX_Firefox,$CHECKBOX_GoogleChrome))
$GROUPBOX_ProfileStats.controls.AddRange(@($LABEL_Desktop,$LABEL_DesktopValue,$LABEL_Downloads,$LABEL_Username,$LABEL_Domain,$LABEL_Hostname,$LABEL_Documents,$LABEL_Pictures,$LABEL_DownloadsValue,$LABEL_DocumentsValue,$LABEL_PicturesValue,$LABEL_UsernameValue,$LABEL_DomainValue,$LABEL_HostnameValue))




#Write your logic code here

[void]$FORM_PFMGMain.ShowDialog()