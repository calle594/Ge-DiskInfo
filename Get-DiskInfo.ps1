foreach ($domain in (Get-ADForest).domains) {
    Get-ADDomainController -filter * -server $domain |
    sort hostname  |
    foreach {
        Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName
        $psitem.Hostname |
        select @{name = "DomainController"; Expression = { $_.PSComputerName } },
        Manufacturer, Model, @{Name = "TotalPhysicalMemory(GB)"; Expression = { "{0:N0}"
                -f  ($_.TotalPhysicalMemory / 1Gb) }
        }
    }
}
  

function Get-DiskInfo {
    foreach ($domain in (Get-ADForest).domains) {
      $hosts = Get-ADDomainController -filter * -server $domain |
      Sort-Object -Prop hostname
      ForEach ($host in $hosts) {
       $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName
    $host
       $props = @{'ComputerName' = $host
                  'DomainController' = $host
                  'Manufacturer' = $cs.manufacturer
                  'Model' = $cs.model
                  'TotalPhysicalMemory(GB)'=$cs.totalphysicalmemory / 1GB}
        New-Object -Type PSObject -Prop $props
       } #foreach $host
     } #foreach $domain
   } #function
   