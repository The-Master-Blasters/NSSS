# A Remake of Nates "System Setup Script"

# Check if Script is run as Administrator. If not, elevate
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.Windows.BuiltInRole]'Administrator')) {

    Write-Host "Elevating to Administrator Privileges In 5 seconds"
    Start-Sleep 5
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit

}