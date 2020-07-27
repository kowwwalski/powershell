# you can use it with accessible folders only
"{0} MB" -f ((Get-ChilItem 'path\to\folder' -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
