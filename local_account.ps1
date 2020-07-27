# I am running this one via external .bat with powershell.exe -ExecutionPolicy Bypass -file "%~dp0\path\to\this-file.ps1"
#add local account with adm privileges
$user_name = Read-Host -Prompt "Type username"
$user_fname = Read-Host -Prompt "Type full display name"
#
#pwd section with decryption
$user_password = Read-Host -Prompt "Type password" -AsSecureString
$pass_confirm = Read-Host -Prompt "Confirm password" -AsSecureString
$user_password_txt = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($user_password))
$pass_confirm_txt = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass_confirm))
#
if ($user_password_txt -ceq $pass_confirm_txt) {
    $user_check = Get-LocalUser -Name $user_name -ErrorAction SilentlyContinue
    if (-not $user_check) {
        Write-Host "User not found, configuring..."
        New-LocalUser -Name $user_name -FullName $user_fname -Password $user_password
    }
    else {
        Write-Host "User exist! Check account manually or choose another name."
        Exit
    }
    sleep 2
    #
    #add to local groups
    Add-LocalGroupMember -Group "Users" -Member $user_name
    Add-LocalGroupMember -Group "Administrators" -Member $user_name
}
else {
    Write-Host "Confirmation failed. Passwords are not equal!"
    Exit
}
