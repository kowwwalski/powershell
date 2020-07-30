# I am running this one via external .bat with powershell.exe -ExecutionPolicy Bypass -file "%~dp0\path\to\this-file.ps1"
#add local account with adm privileges
$user_name = Read-Host -Prompt "Type username"
$user_fname = Read-Host -Prompt "Type full display name"
#
#check username for limit (20 symbols)
if (($user_name | Measure-Object -Character).Characters -gt 20) {
    $user_20sym = $user_name.Substring(0, 20)
    Write-Host "Account will be created with name $user_20sym"
}
else {
    $user_20sym = $user_name
    Write-Host "Account will be created with name $user_20sym"
}
#
#pwd section, yepp
$user_password = Read-Host -Prompt "Type password" -AsSecureString
$pass_confirm = Read-Host -Prompt "Confirm password" -AsSecureString
$user_password_txt = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($user_password))
$pass_confirm_txt = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass_confirm))
#
if ($user_password_txt -ceq $pass_confirm_txt) {
    $user_check = Get-LocalUser -Name $user_20sym -ErrorAction SilentlyContinue
    if (-not $user_check) {
        Write-Host "User not found, configuring..."
        New-LocalUser -Name $user_20sym -FullName $user_fname -Password $user_password
    }
    else {
        Write-Host "User exist! Check account manually or choose another name."
    }
    sleep 2
    #
    #add to local groups
    Add-LocalGroupMember -Group "Users" -Member $user_20sym
    Add-LocalGroupMember -Group "Administrators" -Member $user_20sym
}
else {
    Write-Host "Confirmation failed. Passwords are not equal!"
    Exit
}
