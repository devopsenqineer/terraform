function Set-Hostname {
    param
    (
        [string] $VMName,
        [string] $User,
        [string] $Password,
        [string] $NewName 
    )

    $PWord = ConvertTo-SecureString -String $Password -AsPlainText -Force 
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
            
    Start-Sleep -Seconds 60 

    Invoke-Command -VMName $VMName -Credential $Credential -ArgumentList $NewName -ScriptBlock {

        Rename-Computer -NewName $args[0]

    }
    Start-Sleep -Seconds 60 
    
    Stop-VM $VMName

    $mac = (Get-VMNetworkAdapter -VMName $VMName | Select-Object -ExpandProperty MacAddress)

    if ($mac -ne $null) {
        Set-VMNetworkAdapter -VMName $VMName -StaticMacAddress $mac
    }
    else {
        Write-Host "Fehler beim Abrufen der Mac-Adresse."
    }

    Start-VM $VMName
}