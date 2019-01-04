<#
# Script de discovery dos vhosts e das filas do Rabbit
# Data : 21/12/2017
# Autor: Yuri Crisostomo Bernardo
#>

$start = Get-Date

$pwd  = ConvertTo-SecureString "5TH6zYwOyXNz99" -AsPlainText -Force
$cred = New-Object Management.Automation.PSCredential ('mon_zabbix', $pwd)
$server = "127.0.0.1"
$url  = $("http://$($server):15672/api/vhosts")

$vHost = Invoke-RestMethod  $url -ContentType "application/json" -cred $cred -DisableKeepAlive

$json = @()

foreach($vHostName in $vHost.name){
    
    if ($vHostName -ne "/"){

        $url2  = $("http://$($server):15672/api/queues/$($vHostName)")
        $qName = Invoke-RestMethod $url2 -ContentType "application/json" -cred $cred -DisableKeepAlive   
        
        foreach($vQueueName in $qName.name){
            
            $json += New-Object PSObject –Property @{"{#VHOSTNAME}"="$($vHostName)";"{#QUEUENAME}"="$($vQueueName)"}

        }

    }
}

#$($json | ConvertTo-Json -Compress) | ConvertFrom-Json

$jsonData = @{"data" = $json}
Write-Host $($jsonData | ConvertTo-Json -Compress) #| ConvertFrom-Json

$finish = Get-Date
$runTime = $finish - $start
$runTime.TotalSeconds