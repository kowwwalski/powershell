"{0} MB" -f ((Get-ChildItem %path2folder% -recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
