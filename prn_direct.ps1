# I am running this one via external .bat with powershell.exe -ExecutionPolicy Bypass -file "%~dp0\path\to\this-file.ps1"
#set variables
$printer_name = #set desired printer display name
$printer_ip = #define printer ip-address
$port_name = #set port name (like ip-address by default)
$driver_name = #set driver name like in driver .INF file
$location = #set desired location (for properties menu)
#
#check driver in current system
# here I use external driver installation, cause of adm escalation:
# cscript "%windir%\System32\Printing_Admin_Scripts\en-US\prndrvr.vbs" -a -m "Canon Generic Plus UFR II" -i "%~dp0\path\to\CNLB0MA64.INF" #set your path to driver
# it's runnig from root dir
$drvscript = "$PSScriptRoot\add_driver.bat"
$drvcheck = Get-PrinterDriver -Name $driver_name -ErrorAction SilentlyContinue
if (-not $drvcheck) {
    Write-Host "Driver not found, installation..."
    Start-Process $drvscript -Verb runas
    sleep 30 # it's a bad workaround to wait for driver installation complete, sorry
}
else {
    Write-Host "Driver found in system. Next step in progress..."
}
sleep 2

#add printer port
$portcheck = Get-PrinterPort -Name $port_name -ErrorAction SilentlyContinue
if (-not $portcheck) {
    Write-Host "No port in system, configuring..."
    Add-PrinterPort -name $port_name -PrinterHostAddress $printer_ip
}
else {
    Write-Host "Port already configured. Next step in progress..."
}
sleep 2

#add printer
$prncheck = Get-Printer -Name $printer_name -ErrorAction SilentlyContinue
if (-not $prncheck) {
    Write-Host "Printer installation in progress..."
    Add-Printer -name $printer_name -DriverName $driver_name -PortName $port_name -Location $location
}
else {
    Write-Host "Printer already installed. Finishing..."
}
sleep 2

# and finally, ask about setting printer as default
#set as default
$default = Read-Host "Set $printer_name as default? (y/n)"
if ($default -eq 'y') {
    $printers = Get-WmiObject -ClassName win32_printer
    ($printers | Where-Object -FilterScript {$_.name -eq $printer_name}).setdefaultprinter() | Out-Null
    sleep 1
    Write-Host "Printer $printer_name set as default!"
}
elseif ($defaul -eq 'Y') {
    $printers = Get-WmiObject -ClassName win32_printer
    ($printers | Where-Object -FilterScript {$_.name -eq $printer_name}).setdefaultprinter() | Out-Null
    sleep 1
    Write-Host "Printer $printer_name set as default!"
}
else {
    Write-Host "Set your default printer manually"
}

Write-Host "$printer_name installation process finished!"
