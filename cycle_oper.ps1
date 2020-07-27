# cycle operation (for example, join2domain, until succeed), runs via external .bat (run as adm) with powershell.exe -ExecutionPolicy Bypass -file "%~dp0\path\to\this-file.ps1"
#specify credentials
$user_name = Read-Host -Prompt "Type your name"
$user_pass = Read-Host -Prompt "Type your password" -AsSecureString
$creds = New-Object System.Management.Automation.PSCredential($user_name,$user_pass)
#
# here you can set your check, it will be an exit case for loop
$check = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
#
#trying to run operation (I forgot to set DomainName as variable, my bad, set it right in cycle)
if (-not $check) {
    do {
        Write-Host "Not in domain, join needed"
        Add-Computer -DomainName %specify_domain_here% -Credential $creds -ErrorAction Continue
        sleep 5 # pause to avoid spamming DC
    } while($LASTEXITCODE -ne 0)
}
else {
    Write-Host "Already in domain"
}
#
# and here's reboot required after this operation, but ask interactively
$reboot = Read-Host "Reboot now? (y/n)"
if ($reboot -eq 'y') {
    Write-Host "PC will be rebooted in 5 sec"
    Restart-Computer -Timeout 5
}
elseif ($reboot -eq 'Y') {
    Write-Host "PC will be rebooted in 5 sec"
    Restart-Computer -TimeOut 5
}
else {
    Write-Host "Reboot PC manually"
}
