# I am running this one via external .bat with powershell.exe -ExecutionPolicy Bypass -file "%~dp0\path\to\this-file.ps1"
# create local account in proper format and add it to adm group
#
$name = Read-Host -Prompt "Input name"
$surname = Read-Host -Prompt "Input surname"
$user_name = "$name.$surname"
#
# username section
if (($user_name | Measure-Object -Character).Characters -gt 20) {
    $user_20sym = $user_name.Substring(0, 20)
    Write-Host "Account will be created with name $user_20sym"
}
else {
    $user_20sym = $user_name
    Write-Host "Account will be created with name $user_20sym"
}
#
# check if user already exists
$user_check = Get-LocalUser -Name $user_20sym -ErrorAction SilentlyContinue
    if (-not $user_check) {
        Write-Host "OK. Account can be created"
    }
    else {
        Write-Host "User exist! Check account manually or choose another name."
        Exit
    }
#
# full display name section
$fullname = $name.Substring(0,1).ToUpper()+$name.Substring(1).ToLower()
$fullsurname = $surname.Substring(0,1).ToUpper()+$surname.Substring(1).ToLower()
$full_display_name = "$fullsurname, $fullname"
Write-Host "The display name is $full_display_name"
#
#pwd section, yepp
$user_password = Read-Host -Prompt "Type password" -AsSecureString
$pass_confirm = Read-Host -Prompt "Confirm password" -AsSecureString
$user_password_txt = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($user_password))
$pass_confirm_txt = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass_confirm))
#
if ($user_password_txt -ceq $pass_confirm_txt) {
    New-LocalUser -Name $user_20sym -FullName $full_display_name -Password $user_password
    sleep 2
    Add-LocalGroupMember -Group "Users" -Member $user_20sym
    Add-LocalGroupMember -Group "Administrators" -Member $user_20sym
}
else {
    Write-Host "Confirmation failed. Passwords are not equal!"
    Exit
}
