function VAAddLog {
    <#
        .SYNOPSIS
        Adds log to the specified file.

        .DESCRIPTION
        Adds log to the specified file. Use this function if you need analyze log in ElasticSearch or use as CSV later

        .PARAMETER LogSeverity
        Specifies severity of the log message. Examples: "Information", "Warning", "Error"

        .PARAMETER LogSummary
        Specifies Text of the log

        .PARAMETER LogLocation
        Specifies file path where log should be written

        .PARAMETER OutputToConsole
        Specifies if output log to console

        .INPUTS
        None.

        .OUTPUTS
        None.
        
        .EXAMPLE
        C:\PS> VAAddLog -LogLocation ".\test.csv" -LogSeverity "Critical" -LogSummary "Something has just happened"

        .EXAMPLE
        C:\PS> VAAddLog -LogLocation "C:\output.log" -LogSeverity "Error" -LogSummary "Something has just happened 2"

        .LINK
        https://github.com/akshinmustafayev
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [ValidateNotNull()] [AllowEmptyString()] [string]$LogSeverity,
        [Parameter(Mandatory = $true)] [ValidateNotNull()] [AllowEmptyString()] [string]$LogSummary,
        [Parameter(Mandatory = $true)] [ValidateNotNull()] [string]$LogLocation,
        [Parameter(Mandatory = $false)] [ValidateNotNull()] [boolean]$OutputToConsole = $false
    )

    $LogSeverity = $LogSeverity.ToString()
    $LogSummary = $LogSummary.ToString()

    $LogDate = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    $LogDateString = $LogDate.ToString()
    $Rand = Get-Random -Minimum 1000 -Maximum 5000
    $LogDateString = $LogDateString + $Rand
    $LogHash = VAGetSHA256 -Text $LogDateString

    $LogSummary = $LogSummary.Replace("`"", "`'")
    $LogSeverity = $LogSeverity.Replace("`"", "`'")

    $Data = "`"$LogHash`", `"$LogDate`", `"$LogSeverity`", `"$LogSummary`""
    $Data | Out-File -FilePath $LogLocation -Encoding utf8 -Append -Force

    if ($OutputToConsole) {
        Write-Host "$(Get-Date) Written to log file ($LogLocation): "
        Write-Host "    LogHash: $LogHash"
        Write-Host "    LogDate: $LogDate"
        Write-Host "    LogSeverity: $LogSeverity"
        Write-Host "    LogSummary: $LogSummary"
    }
}

function VAAddSimpleLog {
    <#
        .SYNOPSIS
        Adds log to the specified file.

        .DESCRIPTION
        Adds log to the specified file. Log is more human readable compared with VAAddLog function

        .PARAMETER LogSeverity
        Specifies severity of the log message. Examples: "Information", "Warning", "Error"

        .PARAMETER LogSummary
        Specifies Text of the log

        .PARAMETER LogLocation
        Specifies file path where log should be written

        .PARAMETER OutputToConsole
        Specifies if output log to console

        .INPUTS
        None.

        .OUTPUTS
        None.
        
        .EXAMPLE
        C:\PS> VAAddSimpleLog -LogLocation ".\test.csv" -LogSeverity "Critical" -LogSummary "Something has just happened"

        .EXAMPLE
        C:\PS> VAAddSimpleLog -LogLocation "C:\output.log" -LogSeverity "Error" -LogSummary "Something has just happened 2"

        .LINK
        https://github.com/akshinmustafayev
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [ValidateNotNull()] [AllowEmptyString()] [string]$LogSeverity,
        [Parameter(Mandatory = $true)] [ValidateNotNull()] [AllowEmptyString()] [string]$LogSummary,
        [Parameter(Mandatory = $true)] [ValidateNotNull()] [string]$LogLocation,
        [Parameter(Mandatory = $false)] [ValidateNotNull()] [boolean]$OutputToConsole = $false
    )

    $LogSeverity = $LogSeverity.ToString()
    $LogSummary = $LogSummary.ToString()

    $LogDate = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    $LogDateString = $LogDate.ToString()

    if (($null -ne $LogSeverity) -and ($LogSeverity -ne "")) {
        $LogSeverity = "$LogSeverity "
    }

    if (($null -ne $LogInitiator) -and ($LogInitiator -ne "")) {
        $LogInitiator = " $LogInitiator"
    }

    $Data = "$LogDateString $LogSeverity`:$LogInitiator $LogSummary"
    $Data | Out-File -FilePath $LogLocation -Encoding utf8 -Append -Force

    if ($OutputToConsole) {
        Write-Host "$(Get-Date) Written to log file ($LogLocation): "
        Write-Host "    LogSummary: $LogSummary"
    }
}
