# A Remake of Nates "System Setup Script"

$BloatPath = "https://raw.githubusercontent.com/periurium/NSSS/main/xml/Bloatware.xml"
$AppPath = "https://raw.githubusercontent.com/periurium/NSSS/main/xml/AppAssociations.xml"
$AppInstallList = "https://raw.githubusercontent.com/periurium/NSSS/main/xml/InstallApps.xml"
$programinstaller = "https://raw.githubusercontent.com/periurium/NSSS/main/ProgramInstaller.ps1"
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

    Invoke-WebRequest -Uri $programinstaller -OutFile ".\ProgramInstaller.ps1"
    # Run App Installer Script
    .\ProgramInstaller.ps1 $appinstaller $AppInstallList

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


# Cleaning Function ( Remove downloaded files )
function clean($method) {

    switch ($method) 
    {

        'InstallBaseApps' {
            "Cleaning Apps"
            Remove-Item .\appinstaller.msixbundle
            Remove-Item .\ProgramInstaller.ps1
            Remove-Item .\InstallApps.xml
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
            InstallBaseApps
            # Clean Up Files
            clean("InstallBaseApps")

        }
        'q' {
            # Close Application

        }
    } pause 
    
}
until ($selection -eq 'q')