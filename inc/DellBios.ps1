(CmdletBinding())
Param(
    [Parameter(Mandatory = $true)]
    [string]$FileWebPath
)

$DellBiosList = "xml/DellBios.xml?raw=true"

# Check if Script is run as Administrator. If not, elevate
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    Write-Host "Elevating to Administrator Privileges In 5 seconds"
    Start-Sleep 5
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit

}

Function CheckDellPowerShellModule {

    If ( Get-InstalledModule -Name "DellBIOSProvider" ) {

        # Module is installed :D
        Write-Host "DellBIOSProvider Module Installed :D"
        Write-Host "Importing Module & Custom Functions"
        Start-Sleep 3
        Import-Module DellBIOSProvider
        Write-Host "Setting Dell Bios..."
        Start-Sleep 3

    } else {
        
        Write-Host "Installing DellBIOSProvider Module"

        # Module isn't installed
        # Set Repository to Trusted ( Prevents Popup window ) & Install Module
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
        Install-Module DellBIOSProvider
        # Rerunning Check
        CheckDellPowerShellModule

    }


    Get-InstalledModule -Name "DellBIOSProvider"

}
