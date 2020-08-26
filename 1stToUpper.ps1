# convert to upper case just 1st symbol of string (name + surname, just for example)
#
$name = Read-Host -Prompt "Type your name"
$surname = Read-Host -Prompt "Type your surname"
#
$name_upper = $name.Substring(0,1).ToUpper()+$name.Substring(1).ToLower()
$surname_upper = $surname.Substring(0,1).ToUpper+$surname.Substring(1).ToLower()
Write-Host "$name_upper $surname_upper"
