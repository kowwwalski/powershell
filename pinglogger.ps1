Test-Connection -ComputerName (get-content %pinglist%.txt) -count 1 -delay 2|select-object address, ipv4address|export-csv %logfile%.csv
