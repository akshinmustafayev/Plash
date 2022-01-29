function VASendEmail {
    <#
        .SYNOPSIS
        Sends email to the specified address.

        .DESCRIPTION
        Sends email to the selected address. You should specify from, to, subject and other parameters.

        .PARAMETER EmailTo
        Specifies the destination of the email.

        .PARAMETER EmailFrom
        Specifies the from adress of the email.

        .PARAMETER EmailSubject
        Specifies subject of the email.

        .PARAMETER EmailBody
        Specifies the body of the email.

        .PARAMETER EmailAttachments
        Specifies the attachments of the email.

        .PARAMETER BodyAsHTML
        Specifies if body should be sent in HTML format.

        .PARAMETER Credential
        Specifies credential using which email should be sent by.

        .PARAMETER EmailCc
        Specifies the email addresses to which a copy of the email message is sent.

        .PARAMETER EmailBcc
        pecifies the email addresses that receive a copy of the mail but are not listed as recipients of the message.

        .INPUTS
        None.

        .OUTPUTS
        Boolean true or false result of the operation.

        .EXAMPLE
        C:\PS> VASendEmail -EmailTo "destination@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "Mail text"
        
        .EXAMPLE
        C:\PS> VASendEmail -EmailTo "destination@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "<h1>Mail text</h1>" -BodyAsHTML $true
        
        .EXAMPLE
        C:\PS> VASendEmail -EmailTo "destination@mail.com", "destination2@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "Mail text"

        .EXAMPLE
        C:\PS> VASendEmail -EmailTo "destination@mail.com", "destination2@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "Mail text" -EmailCc "copyuser@mail.com", "copyuser2@mail.com"

        .EXAMPLE
        C:\PS> $CredentialUser = "contoso.com\someuser"
        C:\PS> $CredentialPassword = ConvertTo-SecureString "some_password" -AsPlainText -Force
        C:\PS> $Credential = New-Object System.Management.Automation.PSCredential ($CredentialUser, $CredentialPassword)
        C:\PS> VASendEmail -EmailTo "destination@mail.com", "destination2@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "Mail text" -EmailCc "copyuser@mail.com", "copyuser2@mail.com" -Credential $Credential

        .LINK
        https://github.com/akshinmustafayev
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] $EmailTo, #Address where to send Email
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] $EmailFrom, #From where to send Email
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [string]$EmailSubject, #Subject of the Email
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [string]$EmailBody, #Body of the Email
        [Parameter(Mandatory = $false)] $EmailAttachments, #Attachemtns to the Email
        [Parameter(Mandatory = $false)] [bool]$BodyAsHTML = $false, #Body as HTML
        [Parameter(Mandatory = $false)] [pscredential]$Credential, #Credential to use while sending
        [Parameter(Mandatory = $false)] $EmailCc, #Cc
        [Parameter(Mandatory = $false)] $EmailBcc #Bcc
    ) 
    
    begin{
        $Result = $false
        $ArgumentsList = @{}

        switch ($PSBoundParameters.Keys)
        {
            'EmailTo'
            {
                $ArgumentsList += @{"To" = $EmailTo}
            }
            'EmailFrom'
            {
                $ArgumentsList += @{"From" = $EmailFrom}
            }
            'EmailSubject'
            {
                $ArgumentsList += @{"Subject" = $EmailSubject}
            }
            'EmailBody'
            {
                $ArgumentsList += @{"Body" = $EmailBody}
            }
            'EmailAttachments'
            {
                $ArgumentsList += @{"Attachments" = $EmailAttachments}
            }
            'BodyAsHTML'
            {
                $ArgumentsList += @{"BodyAsHtml" = $true}
            }
            'Credential'
            {
                $ArgumentsList += @{"Credential" = $Credential}
            }
            'EmailCc'
            {
                $ArgumentsList += @{"Cc" = $EmailCc}
            }
            'EmailBcc'
            {
                $ArgumentsList += @{"Bcc" = $EmailBcc}
            }
        }

        $ArgumentsList += @{"SmtpServer" = $VAEmailSmtpServer}
        $ArgumentsList += @{"Port" = $VAEmailPort}
        $ArgumentsList += @{"Encoding" = $VAEmailEncoding}
    }
    process{
        try{
            Send-MailMessage @ArgumentsList
            $Result = $true  
        }
        catch{
            $Result = $false
            Write-Output "Error: $_"
        }
    }
    end{
        return $Result
    }
}
