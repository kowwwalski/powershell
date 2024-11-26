Get-Eventlog -LogName application -EntryType Error,Warning | Export-csv $PSScriptRoot\application_logs.csv
#
Get-Eventlog -LogName System -EntryType Error,Warning | Export-Clixml $PSScriptRoot\system_logs.csv
