Get-Command | where { $_.parameters.keys -contains "ComputerName" -and $_.parameters.keys -notcontains "Session"}

Enter-PSSession Server01

Exit-PSSession


Invoke-Command -ComputerName dc02, srv01 -ScriptBlock {Get-UICulture}


$s = New-PSSession -ComputerName Server01, Server02


Invoke-Command -Session $s {$h = Get-HotFix}


Invoke-Command -Session $s {$h | where {$_.InstalledBy -ne "NTAUTHORITY\SYSTEM"}}