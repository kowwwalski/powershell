#get currently logged-in user on the remote machine
Get-WmiObject Win32_ComputerSystem -ComputerName %pcname% | Select-Object -ExpandProperty username