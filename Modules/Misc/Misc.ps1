
function VATestServerPort {  
    <#    
        .SYNOPSIS    
            Tests port on computer.  
            
        .DESCRIPTION  
            Tests port on computer. 
            
        .PARAMETER ComputerName  
            Name of server to test the port connection on.
            
        .PARAMETER Port  
            Port to test 
                
        .PARAMETER TCP  
            Use tcp port 
            
        .PARAMETER UDP  
            Use udp port  
            
        .PARAMETER UDPTimeOut 
            Sets a timeout for UDP port query. (In milliseconds, Default is 500)  
            
        .PARAMETER TCPTimeOut 
            Sets a timeout for TCP port query. (In milliseconds, Default is 500)
            
        .EXAMPLE    
        C:\PS> VATestServerPort -ComputerName server01 -Port 3389  
        C:\PS> Checks port 3389 on server 'server01' to see if it is listening  
            
        .EXAMPLE    
        C:\PS> 'server01' | VATestServerPort -Port 3389  
        C:\PS> Checks port 3389 on server 'server01' to see if it is listening 
            
        .EXAMPLE    
        C:\PS> VATestServerPort -ComputerName @("server01","server02") -Port 3389  
        C:\PS> Checks port 3389 on server01 and server02 to see if it is listening  
            
        .EXAMPLE
        C:\PS> VATestServerPort -ComputerName server01 -port 3389 -UDP -UDPtimeout 10000
        C:\PS> Queries port 3389 on the UDP port and returns whether port is open or not
                
        .EXAMPLE    
        C:\PS> @("server01","server02") | VATestServerPort -Port 3389  
        C:\PS> Checks port 3389 on server01 and server02 to see if it is listening  
            
        .EXAMPLE    
        C:\PS> (Get-Content hosts.txt) | VATestServerPort -Port 3389  
        C:\PS> Checks port 3389 on servers in host file to see if it is listening 
            
        .EXAMPLE    
        C:\PS> VATestServerPort -ComputerName (Get-Content hosts.txt) -Port 3389  
        C:\PS> Checks port 3389 on servers in host file to see if it is listening 
                
        .EXAMPLE    
        C:\PS> VATestServerPort -ComputerName (Get-Content hosts.txt) -Port @(1..59)  
        C:\PS> Checks a range of ports from 1-59 on all servers in the hosts.txt file      
        
        .LINK
        https://github.com/akshinmustafayev

    #>  

    [cmdletbinding(  
        DefaultParameterSetName = '',  
        ConfirmImpact = 'low'  
    )]
    Param(  
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = '', ValueFromPipeline = $True)] [array]$ComputerName,  
        [Parameter(Mandatory = $True, Position = 1, ParameterSetName = '')] [array]$Port,  
        [Parameter(Mandatory = $False, ParameterSetName = '')] [int]$TCPtimeout = 500,  
        [Parameter(Mandatory = $False, ParameterSetName = '')] [int]$UDPtimeout = 500,             
        [Parameter(Mandatory = $False, ParameterSetName = '')] [switch]$TCP,  
        [Parameter(Mandatory = $False, ParameterSetName = '')] [switch]$UDP                                    
    )  
    Begin {  
        If (!$tcp -AND !$udp) { $tcp = $true }
        $ErrorActionPreference = "SilentlyContinue"
    }  
    Process {     
        ForEach ($c in $ComputerName) {  
            ForEach ($p in $port) {  
                If ($tcp) {    
                    $tcpobject = new-Object system.Net.Sockets.TcpClient  
                    $connect = $tcpobject.BeginConnect($c, $p, $null, $null) 
                    $wait = $connect.AsyncWaitHandle.WaitOne($TCPtimeout, $false)  
                    If (!$wait) {  
                        $tcpobject.Close()  
                        return $false
                    }
                    Else {  
                        $error.Clear()  
                        $tcpobject.EndConnect($connect) | out-Null  
                        If ($error[0]) {  
                            return $false
                        }  
                        $tcpobject.Close()  
                        If ($failed) {  
                            return $false 
                        }
                        Else {  
                            return $true
                        }  
                    }
                }      
                If ($udp) {                                     
                    $udpobject = new-Object system.Net.Sockets.Udpclient
                    $udpobject.client.ReceiveTimeout = $UDPTimeout  
                    $udpobject.Connect("$c", $p) 
                    $a = new-object system.text.asciiencoding 
                    $byte = $a.GetBytes("$(Get-Date)") 
                    [void]$udpobject.Send($byte, $byte.length) 
                    $remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any, 0) 
                    Try { 
                        $receivebytes = $udpobject.Receive([ref]$remoteendpoint) 
                        [string]$returndata = $a.GetString($receivebytes)
                        If ($returndata) {
                            return $true
                        }                       
                    }
                    Catch { 
                        return $false
                        
                        #If ($Error[0].ToString() -match "\bRespond after a period of time\b") { 
                        #    $udpobject.Close()  
                        #    If (Test-Connection -comp $c -count 1 -quiet) { 
                        #        return $true
                        #    }
                        #    Else { 
                        #        return $false                               
                        #    }                         
                        #}
                        #ElseIf ($Error[0].ToString() -match "forcibly closed by the remote host" ) {
                        #    $udpobject.Close()  
                        #    return $false                      
                        #}
                        #Else {                      
                        #    $udpobject.close() 
                        #} 
                    }
                }                                  
            }  
        }                  
    }  
    End {  }
}

function VAGetSHA256 {
    <#
        .SYNOPSIS
        Gets SHA256 of the given text.

        .DESCRIPTION
        Gets SHA256 of the given text.

        .PARAMETER Text
        Specifies Text, SHA256 hash of which should be calculated.

        .INPUTS
        None.

        .OUTPUTS
        String.
        
        .EXAMPLE
        C:\PS> VAGetSHA256 -Text "Hello World"

        .EXAMPLE
        C:\PS> $HashText = VAGetSHA256 -Text "Hello World"
        C:\PS> Write-Host $HashText

        .LINK
        https://github.com/akshinmustafayev
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [string]$Text
    )

    $SHA256 = New-Object -TypeName System.Security.Cryptography.SHA256CryptoServiceProvider
    $UTF8 = New-Object -TypeName System.Text.UTF8Encoding
    $Hash = [System.BitConverter]::ToString($SHA256.ComputeHash($UTF8.GetBytes($Text)))
    $Hash = $Hash.Replace("-", "")
    
    return $Hash
}

function VAConvertToBase64{
    <#
        .SYNOPSIS
        Converts given text to Base64.

        .DESCRIPTION
        Converts given text to Base64.

        .PARAMETER Text
        Specifies Text, which should be converted to Base64.

        .INPUTS
        None.

        .OUTPUTS
        String.
        
        .EXAMPLE
        C:\PS> VAConvertToBase64 -Text "Hello World"

        .EXAMPLE
        C:\PS> $Base64Text = VAConvertToBase64 -Text "Hello World"
        C:\PS> Write-Host $Base64Text

        .LINK
        https://github.com/akshinmustafayev
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [string]$Text #Text
    )

    $Base64Text = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Text))
 
    return $Base64Text
}

function VAConvertFromBase64{
    <#
        .SYNOPSIS
        Converts Base64 string to human readable text.

        .DESCRIPTION
        Converts Base64 string to human readable text.

        .PARAMETER Base64Text
        Specifies Base64 Text, which should be converted to human readable text.

        .INPUTS
        None.

        .OUTPUTS
        String.
        
        .EXAMPLE
        C:\PS> VAConvertFromBase64 -Base64Text "aGVsbG8gd29ybGQ="

        .EXAMPLE
        C:\PS> $Text = VAConvertFromBase64 -Base64Text "aGVsbG8gd29ybGQ="
        C:\PS> Write-Host $Text

        .LINK
        https://github.com/akshinmustafayev
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [string]$Base64Text #Base 64 encoded text
    )

    $Text = ""

    try {
        $Text = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Base64Text))
    }
    catch {
        Write-Host "Error: $_"
    }
 
    return $Text
}
