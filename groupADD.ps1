#Create csv-file with user credentials(FIO) & get samaccount (insert "name" in 1st row)
import-csv -path %credenlist%.csv
ForEach-Object{get-adobject -filter "name -like '*$($_.name)*'" -properties *}
Select-Object samaccountname|export-csv %output%.csv
#convert to txt without first row (name) & put it into the var
$var = Get-Content %somedir%\yourlist.txt
#add users from txt to ADgroup
Add-ADGroupMember "group" -Member $var
