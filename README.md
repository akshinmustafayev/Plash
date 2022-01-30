<p align="center">
  <img src="vality.png" alt="infrabot-logo" width="900px"/>
</p>
<h1 align="center">Vality - PowerShell module for automation tasks</h1>
<p align="center">
  <a href="https://img.shields.io/github/license/akshinmustafayev/Vality">
    <img src="https://img.shields.io/github/license/akshinmustafayev/Vality" alt="License" />
  </a>&nbsp;
  <a href="https://img.shields.io/tokei/lines/github/infrabot-io/infrabot">
    <img src="https://img.shields.io/tokei/lines/github/akshinmustafayev/Vality" alt="Total lines" />
  </a>&nbsp;
  <a href="https://img.shields.io/github/downloads/akshinmustafayev/Vality/total">
    <img src="https://img.shields.io/github/downloads/akshinmustafayev/Vality/total" alt="Downloads" />
  </a>
</p>

<hr>

## About
Vality - is a PowerShell module for automation tasks.

### Functions
- [VASendEmail](Documentation/VASendEmail.md) - Sends email to the destination
- VANewEmailTemplate - Creates new email template
- VANewEmailTemplateLogos - This is an additional function which must be used if _$VAEmailTemplateShowCompanyLogo_ is _$true_
- VANewEmailTemplateTable - Create new table for the Email template
- VANewEmailTemplateUrl - Create new link for the Email template
- VAAddLog - Creates log file in the CSV format
- VAAddSimpleLog - Creates simple log with the additional information
- VATestServerPort - Checks if it is possible to connect to the specified server(s) with port
- VAGetSHA256 - Returns SHA256 from the specified string
- VAConvertToBase64 - Converts secified text to Base64
- VAConvertFromBase64 - Converts Base64 text to human readable text
- VASendTelegramMessage - Sends telegram message to the specified chat (Bot should be created)
- VAAbout - Shows plugin version information

## Setup

### Prerequisites
- PowerShell 5.1

### Download
Go to [Download Page](https://github.com/akshinmustafayev/Vality/releases) to download the latest release. 

### Installation
Extract contents of the archive and copy files to the _C:\Program Files\WindowsPowerShell\Modules_ directory

### Configuration
After installation you should configure necessary settings in the _Vality.psm1_ file. __Configuration for your setup is mandatory, otherwise module will not work!__

## Contributing
Contributing is very much appreciated. Feel free to open issues.
