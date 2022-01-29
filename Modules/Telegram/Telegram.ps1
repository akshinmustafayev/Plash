function VASendTelegramMessage {
    <#
        .SYNOPSIS
        Sends message to telegram chat.

        .DESCRIPTION
        Sends message to telegram chat.

        .PARAMETER Message
        Specifies the text of the message.

        .PARAMETER ChatID
        Specifies chat id where message will be send.

        .INPUTS
        None.

        .OUTPUTS
        Boolean true or false of the operation.

        .EXAMPLE
        C:\PS> VASendTelegramMessage -ChatID "123456789" -Message "Hello World"

        .LINK
        https://github.com/akshinmustafayev
    #>

    param(
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] [string]$Message, #Message body
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] [int]$ChatID #ChatID
    ) 

    begin {
        # Configure TLS message
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        # Result
        $Result = $false
    }
    process {
        try {
            $Post = "chat_id=$ChatID&text=$Message"
            Invoke-WebRequest -Uri "https://api.telegram.org/bot$VATelegramBotToken/sendMessage" -Method Post -Body $Post | Out-Null
            $Result = $true
        }
        catch {
            $Result = $false
            Write-Output "Error occured: $_"
        }
    }
    end { 
        return $Result
    }
}