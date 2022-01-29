function VAAbout {
    <#
        .SYNOPSIS
        Shows module About window.

        .DESCRIPTION
        Shows module About window.

        .INPUTS
        None.

        .OUTPUTS
        None.
        
        .EXAMPLE
        C:\PS> VAAbout

        .LINK
        https://github.com/akshinmustafayev
    #>

    # Init PowerShell Gui
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    
    # Create a new form
    $AboutForm = New-Object System.Windows.Forms.Form
    $AboutImage = New-Object System.Windows.Forms.PictureBox
    $AboutLabel1 = New-Object System.Windows.Forms.Label
    
    # Define the Main Form
    $AboutForm.ClientSize = '480, 270'
    $AboutForm.Text = "Vality $VAVersion - About"
    $AboutForm.BackColor = "#ffffff"
    $AboutForm.MinimizeBox = $false
    $AboutForm.MaximizeBox = $false
    $AboutForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $IconFileStream = [System.IO.File]::OpenRead($VAIcon)
    $AboutForm.Icon = New-Object System.Drawing.Icon($IconFileStream)
    
    # Define PictureBox
    $AboutImage.Size = '450, 150'
    $AboutImage.Location = New-Object System.Drawing.Point(20, 20)
    $AboutImage.Image = [System.Drawing.Image]::FromFile($VALogoPath)
    $AboutImage.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
    
    # Define Label
    $AboutLabel1.Location = New-Object System.Drawing.Point(20, 180)
    $AboutLabel1.Text = "Vality version: $VAVersion`nDebug mode enabled: $VADebugModeEnabled`nAuthor: Akshin Mustafayev`nGithub: https://github.com/akshinmustafayev"
    $AboutLabel1.AutoSize = $true

    # Display the form
    $AboutForm.Controls.Add($AboutImage)
    $AboutForm.Controls.Add($AboutLabel1)
    [void]$AboutForm.ShowDialog()
}
