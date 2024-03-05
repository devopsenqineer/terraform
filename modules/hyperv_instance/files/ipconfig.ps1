function Set-IP {
    param
    (
        [string] $IP,
        [string] $MaskBits,
        [string] $Gateway,
        [string] $Dns = "8.8.8.8",
        [string] $IPType = "IPv4",
        [string] $VMName,
        [string] $User,
        [string] $Password
    )

    $PWord = ConvertTo-SecureString -String $Password -AsPlainText -Force 
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
    
    Invoke-Command -VMName $VMName -Credential $Credential -ArgumentList $IP, $MaskBits, $Gateway, $Dns, $IPType -ScriptBlock {

        param(
            $IP,
            $MaskBits,
            $Gateway,
            $Dns,
            $IPType
        )
 
        $adapter = Get-NetAdapter | ? { $_.Status -eq "up" }

        If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
            $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
        }
        If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
            $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
        }

        $adapter | New-NetIPAddress `
            -AddressFamily $IPType `
            -IPAddress $IP `
            -PrefixLength $MaskBits `
            -DefaultGateway $Gateway `
 
        $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS 
    }
}