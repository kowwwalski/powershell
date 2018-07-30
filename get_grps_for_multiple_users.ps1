$userlist = Get-Content 'list.txt'


Get-ADUser -Filter '*' -Properties memberof | Where-Object {
 
	$userlist -contains $_.SamAccountName

} | ForEach-Object {
 
	$username = $_.SamAccountName
 
	$groups = $_ | Select-Object -Expand memberof |

		ForEach-Object { (Get-ADGroup $_).Name }
 
	"{0}; {1}" -f $username, ($groups -join '; ')

} | Out-File 'output.csv'
