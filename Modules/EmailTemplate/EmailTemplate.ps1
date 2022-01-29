$VAEmailTemplateHTMLTemplate = "$PSScriptRoot\template.html"
$VAEmailTemplateHTMLPartCompanyLogo = "$PSScriptRoot\part_company_logo.html"
$VAEmailTemplateHTMLPartSocialLinks = "$PSScriptRoot\part_sociallinks.html"
$VAEmailTemplateHTMLPartSocialLinksFB = "$PSScriptRoot\part_sociallinks_fb.html"
$VAEmailTemplateHTMLPartSocialLinksGithub = "$PSScriptRoot\part_sociallinks_github.html"
$VAEmailTemplateHTMLPartSocialLinksInstagram = "$PSScriptRoot\part_sociallinks_instagram.html"
$VAEmailTemplateHTMLPartSocialLinksLinkedIn = "$PSScriptRoot\part_sociallinks_linkedin.html"
$VAEmailTemplateHTMLPartSocialLinksTwitter = "$PSScriptRoot\part_sociallinks_twitter.html"
$VAEmailTemplateHTMLPartUsefulLinks = "$PSScriptRoot\part_usefullinks.html"

Add-Type -Path "$PSScriptRoot\Table.cs"

function VANewEmailTemplate {
    <#
        .SYNOPSIS
        Generates email template.

        .DESCRIPTION
        Generates email template and returns it as string.

        .PARAMETER Header
        Header of the mail.

        .PARAMETER Body
        Body of the mail.

        .INPUTS
        None.

        .OUTPUTS
        String value of the body.

        .EXAMPLE
        C:\PS> #If $VAEmailTemplateShowCompanyLogo and $VAEmailTemplateShowSocialLinks false, this script is enough
        C:\PS> $EmailBody = VANewEmailTemplate -Header "Text header" -Body "Some mail body"
        C:\PS> VASendEmail -EmailTo "user1@contoso.com" -EmailFrom "user2@contoso.com" -EmailSubject "Test" -EmailBody $EmailBody -BodyAsHTML $true

        .EXAMPLE
        C:\PS> #If $VAEmailTemplateShowCompanyLogo or\and $VAEmailTemplateShowSocialLinks true, this example is mandatory
        C:\PS> $EmailBody = VANewEmailTemplate -Header "Text header" -Body "Some mail body"
        C:\PS> $LogosAttachment = VANewEmailTemplateLogos
        C:\PS> VASendEmail -EmailTo "user1@contoso.com" -EmailFrom "user2@contoso.com" -EmailSubject "Test" -EmailBody $EmailBody -BodyAsHTML $true -EmailAttachments $LogosAttachment

        .LINK
        https://github.com/akshinmustafayev
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] $Header, #Header text
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] $Body #Body text
    ) 

    # Get Template Header part
    $Template = Get-Content $VAEmailTemplateHTMLTemplate -Raw
    $PartCompanyLogo = Get-Content $VAEmailTemplateHTMLPartCompanyLogo -Raw
    $PartSocialLinks = Get-Content $VAEmailTemplateHTMLPartSocialLinks -Raw
    $PartSocialLinksFB = Get-Content $VAEmailTemplateHTMLPartSocialLinksFB -Raw
    $PartSocialLinksGithub = Get-Content $VAEmailTemplateHTMLPartSocialLinksGithub -Raw
    $PartSocialLinksInstagram = Get-Content $VAEmailTemplateHTMLPartSocialLinksInstagram -Raw
    $PartSocialLinksLinkedIn = Get-Content $VAEmailTemplateHTMLPartSocialLinksLinkedIn -Raw
    $PartSocialLinksTwitter = Get-Content $VAEmailTemplateHTMLPartSocialLinksTwitter -Raw
    $PartUsefulLinks = Get-Content $VAEmailTemplateHTMLPartUsefulLinks -Raw

    # Set Template Header
    if($VAEmailTemplateShowCompanyLogo -eq $true) {
        # Set Company logo part data
        $PartCompanyLogo = $PartCompanyLogo.Replace('{BODY_HEADER_URL}', $VAEmailTemplateCompanyURL)
        $PartCompanyLogo = $PartCompanyLogo.Replace('{BODY_HEADER_COMPANY}', $VAEmailTemplateCompanyName)

        # Set Company logo part to template
        $Template = $Template.Replace('{PART_COMPANY_LOGO}', $PartCompanyLogo)
    }

    # Set Template Body
    $Template = $Template.Replace('{HEADER_TEXT}', $Header)
    $Template = $Template.Replace('{BODY_TEXT}', $Body)
    $Template = $Template.Replace('{BODY_SINCERELY}', $VAEmailTemplateSincereleyFrom)
    $Template = $Template.Replace('{FOOTER_COMPANY_NAME}', $VAEmailTemplateCompanyName)
    $Template = $Template.Replace('{FOOTER_COMPANY_ADDRESS}', $VAEmailTemplateCompanyAddress)

    # Set Template Social Links
    if($VAEmailTemplateShowSocialLinks -eq $true) {
        # If facebook link enabled
        if($VAEmailTemplateShowFacebookIcon -$true){
            # Set facebook logo
            $PartSocialLinksFB = $PartSocialLinksFB.Replace('{FOOTER_FACEBOOK_LINK}', $VAEmailTemplateShowFacebookURL)
        }

        # If linkedin link enabled
        if($VAEmailTemplateShowLinkedInIcon -$true){
            # Set linkedin logo
            $PartSocialLinksLinkedIn = $PartSocialLinksLinkedIn.Replace('{FOOTER_LINKEDIN_LINK}', $VAEmailTemplateShowLinkedInURL)
        }

        # If instagram link enabled
        if($VAEmailTemplateShowInstagramIcon -$true){
            # Set instagram logo
            $PartSocialLinksInstagram = $PartSocialLinksInstagram.Replace('{FOOTER_INSTAGRAM_LINK}', $VAEmailTemplateShowInstagramURL)
        }

        # If twitter link enabled
        if($VAEmailTemplateShowTwitterIcon -$true){
            # Set twitter logo
            $PartSocialLinksTwitter = $PartSocialLinksTwitter.Replace('{FOOTER_TWITTER_LINK}', $VAEmailTemplateShowTwitterURL)
        }

        # If github link enabled
        if($VAEmailTemplateShowGithubIcon -$true){
            # Set github logo
            $PartSocialLinksGithub = $PartSocialLinksGithub.Replace('{FOOTER_GITHUB_LINK}', $VAEmailTemplateShowGithubURL)
        }

        # Set Social Links part icons
        $PartSocialLinks = $PartSocialLinks.Replace('{PART_SOCIALLINKS_FB}', $PartSocialLinksFB)
        $PartSocialLinks = $PartSocialLinks.Replace('{PART_SOCIALLINKS_LINKEDIN}', $PartSocialLinksLinkedIn)
        $PartSocialLinks = $PartSocialLinks.Replace('{PART_SOCIALLINKS_INSTAGRAM}', $PartSocialLinksInstagram)
        $PartSocialLinks = $PartSocialLinks.Replace('{PART_SOCIALLINKS_TWITTER}', $PartSocialLinksTwitter)
        $PartSocialLinks = $PartSocialLinks.Replace('{PART_SOCIALLINKS_GITHUB}', $PartSocialLinksGithub)

        # Set Social Links part to template
        $Template = $Template.Replace('{PART_SOCIALLINKS}', $PartSocialLinks)
    }

    # Set Template Useful Links
    if($VAEmailTemplateShowUsefulLinks -eq $true){
        # Initiate empty string where we shall store our HTML
        $UsefulLinksHTML = ""

        # Loop through our list and add it to HTML variable
        foreach($VAEmailTemplateUsefulLink in $VAEmailTemplateUsefulLinks) {
            $UsefulLinksHTML = $UsefulLinksHTML + "<a href=`"$($VAEmailTemplateUsefulLink.Url)`" class=`"body text-primary`">$($VAEmailTemplateUsefulLink.Label)</a> | "
        }

        # Set HTML into useful links part
        $PartUsefulLinks = $PartUsefulLinks.Replace('{FOOTER_USEFUL_LINKS}', $UsefulLinksHTML)
        
        # Set Useful Links part to template
        $Template = $Template.Replace('{PART_USEFULLINKS}', $PartUsefulLinks)
    }

    return $Template
}

function VANewEmailTemplateLogos {
    <#
        .SYNOPSIS
        Returns paths of images which should be sent as attachment.

        .DESCRIPTION
        Returns paths of images which should be sent as attachment. Must be used if $VAEmailTemplateShowCompanyLogo or\and $VAEmailTemplateShowSocialLinks true

        .INPUTS
        None.

        .OUTPUTS
        String value of the body.
        
        .EXAMPLE
        C:\PS> #If $VAEmailTemplateShowCompanyLogo or\and $VAEmailTemplateShowSocialLinks true, this example is mandatory
        C:\PS> $EmailBody = VANewEmailTemplate -Header "Text header" -Body "Some mail body"
        C:\PS> $LogosAttachment = VANewEmailTemplateLogos
        C:\PS> VASendEmail -EmailTo "user1@contoso.com" -EmailFrom "user2@contoso.com" -EmailSubject "Test" -EmailBody $EmailBody -BodyAsHTML $true -EmailAttachments $LogosAttachment

        .LINK
        https://github.com/akshinmustafayev
    #>

    # Empty array list
    $LogoList = @()

    # Add to array if Facebook icon enabled
    if($VAEmailTemplateShowFacebookIcon){
        $LogoList += "$PSScriptRoot\fb.jpg"
    }

    # Add to array if LinkedIn icon enabled
    if($VAEmailTemplateShowLinkedInIcon){
        $LogoList += "$PSScriptRoot\linkedin.jpg"
    }

    # Add to array if Instagram icon enabled
    if($VAEmailTemplateShowInstagramIcon){
        $LogoList += "$PSScriptRoot\instagram.jpg"
    }

    # Add to array if Twitter icon enabled
    if($VAEmailTemplateShowTwitterIcon){
        $LogoList += "$PSScriptRoot\twitter.jpg"
    }

    # Add to array if Github icon enabled
    if($VAEmailTemplateShowGithubIcon){
        $LogoList += "$PSScriptRoot\github.jpg"
    }

    # Add to array if Show Company Logo icon enabled
    if($VAEmailTemplateShowCompanyLogo){
        $LogoList += "$PSScriptRoot\logo.png"
    }

    return $LogoList
}

function VANewEmailTemplateTable {
    <#
        .SYNOPSIS
        Creates new Email Template Table.

        .DESCRIPTION
        Creates new Email Template Table. You can use this table to add it to your body as html

        .INPUTS
        None.

        .OUTPUTS
        HTML String.
        
        .EXAMPLE
        C:\PS> $MyTable = VANewEmailTemplateTable
        C:\PS> $MyTable.AddHeader(@("Name", "Surname")) #Adds Table headers
        C:\PS> $MyTable.AddRow(@("John","Addiman")) #Adds Row
        C:\PS> $MyTable.GetTable() #Gets HTML table
        C:\PS> $MyTable.ClearTableData() #Clears table data. Header is left untouched
        C:\PS> $MyTable.RemoveTableHeader() #Removes Table header. Table data is left untouched
        C:\PS> $MyTable.SetTableStyleHTML("color:red;padding-left:50px;margin-right:10px;") #Sets CSS HTML style to table

        .EXAMPLE
        C:\PS> #If $VAEmailTemplateShowCompanyLogo or\and $VAEmailTemplateShowSocialLinks true, this example is mandatory
        C:\PS> $MyTable = VANewEmailTemplateTable
        C:\PS> $MyTable.AddHeader(@("Name", "Surname"))
        C:\PS> $MyTable.AddRow(@("John","Addiman"))
        C:\PS> $MyTable.AddRow(@("Sarah","Bernsteen"))
        C:\PS> $MyTable.AddRow(@("Karen","Keating"))
        C:\PS> $MyTable.AddRow(@("Michael","Talmay"))
        C:\PS> $MyTable.AddRow(@("Ben","Renforth"))
        C:\PS> $EmailBody = VANewEmailTemplate -Header "Text header" -Body "Here is a list of our emplyees: <br> $($MyTable.GetTable())"
        C:\PS> $LogosAttachment = VANewEmailTemplateLogos
        C:\PS> VASendEmail -EmailTo "user1@contoso.com" -EmailFrom "user2@contoso.com" -EmailSubject "Test" -EmailBody $EmailBody -BodyAsHTML $true -EmailAttachments $LogosAttachment

        .LINK
        https://github.com/akshinmustafayev
    #>

    # Create new Table object
    $Table = New-Object Table

    return $Table
}

function VANewEmailTemplateUrl {
    <#
        .SYNOPSIS
        Creates new Email Template URL.

        .DESCRIPTION
        Creates new Email Template URL. You can use this url to add it to your body as html

        .PARAMETER Text
        Specifies text of the link.

        .PARAMETER Url
        Specifies URL address of the link.

        .INPUTS
        None.

        .OUTPUTS
        HTML String.
        
        .EXAMPLE
        C:\PS> #If $VAEmailTemplateShowCompanyLogo or\and $VAEmailTemplateShowSocialLinks true, this example is mandatory
        C:\PS> $MyUrl = VANewEmailTemplateUrl -Text "Go to my website" -Url "https://akshinmustafayev.com"
        C:\PS> $EmailBody = VANewEmailTemplate -Header "Text header" -Body "Here is a link - $MyUrl"
        C:\PS> $LogosAttachment = VANewEmailTemplateLogos
        C:\PS> VASendEmail -EmailTo "user1@contoso.com" -EmailFrom "user2@contoso.com" -EmailSubject "Test" -EmailBody $EmailBody -BodyAsHTML $true -EmailAttachments $LogosAttachment

        .EXAMPLE
        C:\PS> #If $VAEmailTemplateShowCompanyLogo or\and $VAEmailTemplateShowSocialLinks true, this example is mandatory
        C:\PS> $EmailBody = VANewEmailTemplate -Header "Text header" -Body "Here is a link - $(VANewEmailTemplateUrl -Text "Go to my website" -Url "https://akshinmustafayev.com")"
        C:\PS> $LogosAttachment = VANewEmailTemplateLogos
        C:\PS> VASendEmail -EmailTo "user1@contoso.com" -EmailFrom "user2@contoso.com" -EmailSubject "Test" -EmailBody $EmailBody -BodyAsHTML $true -EmailAttachments $LogosAttachment

        .LINK
        https://github.com/akshinmustafayev
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] $Text, #Header text
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] $Url #Body text
    )

    return "<a href=`"$Url`">$Text</a>"
}
