# Global Configuration
$VAVersion = "v0.1"
$VADebugModeEnabled = $false

# Builtin variables
$VALogoPath = "$PSScriptRoot\vality.png"
$VAIcon = "$PSScriptRoot\icon.png"

#   Module Configurations
#       Email
$VAEmailSmtpServer = "mail.contoso.com"
$VAEmailPort = 587
$VAEmailEncoding = "UTF8"
#       EmailTemplate
$VAEmailTemplateCompanyName = "Contoso"
$VAEmailTemplateCompanyURL = "contoso.com"
$VAEmailTemplateCompanyAddress = "Country, City, Street 123, ZIP 123456"
$VAEmailTemplateSincereleyFrom = "Infrastructure and Operations Support Department"
$VAEmailTemplateShowCompanyLogo = $true
$VAEmailTemplateShowSocialLinks = $true
$VAEmailTemplateShowFacebookIcon = $true
$VAEmailTemplateShowFacebookURL = "https://facebook.com/"
$VAEmailTemplateShowLinkedInIcon = $true
$VAEmailTemplateShowLinkedInURL = "https://linkedin.com/"
$VAEmailTemplateShowInstagramIcon = $true
$VAEmailTemplateShowInstagramURL = "https://instagram.com/"
$VAEmailTemplateShowTwitterIcon = $true
$VAEmailTemplateShowTwitterURL = "https://twitter.com/"
$VAEmailTemplateShowGithubIcon = $true
$VAEmailTemplateShowGithubURL = "https://github.com/"
$VAEmailTemplateShowUsefulLinks = $true
$VAEmailTemplateUsefulLinks = @(
    @{Label = "IT ServiceDesk"; Url = "https://servicedesk.contoso.com" }
    @{Label = "Intranet Portal"; Url = "https://intranet.contoso.com" }
)
#       Telegram
$VATelegramBotToken = ""

# Loading Modules
$Modules = Get-ChildItem -Path "$PSScriptRoot\Modules\" -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue | Sort-Object FullName

# Loop through found modules and import them
foreach($Module in $Modules){
    . $Module.FullName
}