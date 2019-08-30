#define srv
[int]$prnumber = Read-Host "Type printer number (digits only)"
if ($prnumber % 2 -eq 0) {
    $srv = 'srv2'
}
else {
    $srv = 'srv1'
}
$prname = Get-Printer -ComputerName $srv |? {$_.name -like "$prnumber -*"} | select name
#
$srv = $srv.ToString()
$prname = $prname.name.ToString()
Add-Printer -ConnectionName \\$srv\$prname
