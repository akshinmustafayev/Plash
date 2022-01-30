# VASendEmail

Sends email to the specified mail address.

## Syntax

```
VASendEmail
    [-EmailTo <String[]>]
    [-EmailFrom <String>]
    [-EmailSubject <String>]
    [-EmailBody <String>]
    [-EmailAttachments <String[]>]
    [-BodyAsHTML <Boolean>]
    [-Credential <PSCredential>]
    [-EmailCc <String[]>]
    [-EmailBcc <String[]>]
```

```
VASendEmail
    [-EmailTo <String[]>]
    [-EmailFrom <String>]
    [-EmailSubject <String>]
    [-EmailBody <String>]
```

```
VASendEmail
    [-EmailTo <String[]>]
    [-EmailFrom <String>]
    [-EmailSubject <String>]
    [-EmailBody <String>]
    [-EmailAttachments <String[]>]
```

## Description

The VASendEmail cmdlet sends an email message from within PowerShell. You must specify a SMTP server (_$VAEmailSmtpServer_) and Port (_$VAEmailPort_) in the Vality.psm1 or the VASendEmail command fails. UTF-8 encoding is a default encoding which used to send mails (_VAEmailEncoding_) with.

## Examples

### Example 1
```
VASendEmail -EmailTo "destination@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "Mail text"
```

### Example 2
```
VASendEmail -EmailTo "destination@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "<h1>Mail text</h1>" -BodyAsHTML $true
```

### Example 3
```
VASendEmail -EmailTo "destination@mail.com", "destination2@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "Mail text"
```

### Example 4
```
VASendEmail -EmailTo "destination@mail.com", "destination2@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "Mail text" -EmailCc "copyuser@mail.com", "copyuser2@mail.com"
```

### Example 5
```
$CredentialUser = "contoso.com\someuser"
$CredentialPassword = ConvertTo-SecureString "some_password" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($CredentialUser, $CredentialPassword)
VASendEmail -EmailTo "destination@mail.com", "destination2@mail.com" -EmailFrom "emailfrom@mail.com" -EmailSubject "Some subject" -EmailBody "Mail text" -EmailCc "copyuser@mail.com", "copyuser2@mail.com" -Credential $Credential
```

## Parameters

__-EmailTo__
The EmailTo parameter is required. This parameter specifies the recipient's email address. If there are multiple recipients, separate their addresses with a comma (,)

__-EmailFrom__
The EmailFrom parameter is required. This parameter specifies the sender's email address. Enter a name (optional) and email address, such as Name <someuser@contoso.com>.

__-EmailSubject__
The EmailSubject parameter is required. This parameter specifies the subject of the email message.

__-EmailBody__
The EmailBody parameter is required. Specifies the content of the email message.

__-EmailAttachments__
The EmailAttachments parameter is not required. Specifies the path and file names of files to be attached to the email message.

__-BodyAsHTML__
The BodyAsHTML parameter is not required. Specifies that the value of the Body parameter contains HTML.

__-Credential__
The Credential parameter is not required. Specifies a user account that has permission to perform this action. The default is the current user.

__-EmailCc__
The EmailCc parameter is not required. Specifies the email addresses to which a carbon copy (CC) of the email message is sent. Enter names (optional) and the email address, such as Name <someuser@contoso.com>.

__-EmailBcc__
The EmailBcc parameter is not required. Specifies the email addresses that receive a copy of the mail but are not listed as recipients of the message. Enter names (optional) and the email address, such as Name <someuser@contoso.com>.

## Outputs
Retuns boolean True or False value of the operation
