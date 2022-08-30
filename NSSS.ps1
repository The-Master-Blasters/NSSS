# A Remake of Nates "System Setup Script"

$BloatPath = "https://raw.githubusercontent.com/periurium/NSSS/main/Bloatware.xml"
$AppPath = "https://raw.githubusercontent.com/periurium/NSSS/main/AppAssociations.xml"
$AppInstaller = "https://github.com/The-Master-Blasters/NSSS/blob/main/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe%20.msixbundle"


# Check if Script is run as Administrator. If not, elevate
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    Write-Host "Elevating to Administrator Privileges In 5 seconds"
    Start-Sleep 5
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit

}

# Menu 
Function Show-Menu { 
    Write-Host "
  ██████████████████████████████████████████████████
  ██████████████████████████████████████████████████
  ██XXXXXXXXX██                        ██XXXXXXXXX██
  ██XXXXXXXXX██    System Setup Tool   ██XXXXXXXXX██
  ██XXXXXXXXX██                        ██XXXXXXXXX██  
  ██████████████████████████████████████████████████
  ██████████████████████████████████████████████████
  
  1: Select '1' for System-Wide changes
  2: Select '2' for User-Specific changes
  3: Select '3' for both System and User changes
  4: Select '4' to apply the current Lenovo BIOS configuration
  5: Select '5' to apply the current Dell BIOS configuration
  6: Select '6' to start Windows Explorer
  7: Select '7' to install base applications
  Q: Select 'Q' to exit
  
  "
}


# Check if Dell Command Powershell Module is Installed ( This is for Dell BIOs Changes )
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


# Set BIOS Settings through DellBIOSProvider Module
Function SetDellBIOSSettings {

    # Run through BIOs Settings


}


Function GetBloat {

    # Download Bloatware XML File
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/periurium/NSSS/main/Bloatware.xml" -outfile ".\Bloatware.xml"
    # Handle XML File
    $xmlBloat = Select-Xml -Path .\Bloatware.xml -XPath '/DefaultBloatware/Bloatware' | ForEach-Object {$_.Node}
        

}

Function InstallBaseApps {

    # Run App Installer Script
    .\ProgramInstaller.ps1 $appinstaller 

}


# Check which Vendor the computer comes from (this is for BIOS and Bloatware)
Function checkMan {

    $vendor = wmic csproduct get vendor
    switch ($vendor)
    {
        'Dell Inc.' {
            CheckDellPowerShellModule
        }
        'LENOVO' {

        }
    }

}

Show-Menu
do
{
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
        '1' {
            # System Wide Changes

        }
        '2' {
            # User-Specific Changes
        }
        '3' {
            # Both System Wide & User-Specific Changes

        }   
        '4'{
            # Apply Lenovo BIOs

        }
        '5' {
            # Apply Dell BIOs

        }
        '6' {
            # Start Windows Explorer

        }
        '7' {
            # Install Base Applications

        }
        'q' {
            # Close Application

        }
    } pause 
    
}
until ($selection -eq 'q')