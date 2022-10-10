# A Remake of Nates "System Setup Script"

$FileWebPath = "https://github.com/The-Master-Blasters/NSSS/blob/main/"

# Check if Script is run as Administrator. If not, elevate
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    Write-Host "Elevating to Administrator Privileges In 5 seconds"
    Start-Sleep 5
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit


}

# Logging
$Logfile = "C:\Temp\proc_$env:computername.log"
function WriteLog {
    Param ([string]$LogString)
    $Stamp = (Get-Date).toString("MM/dd/yyyy HH:mm:ss")
    $LogMessage = "$Stamp $LogString"
    Add-content $LogFile -value $LogMessage
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

#Function to start request of installing Base Applications
Function InstallBaseApps {

    $ProgramScriptPath = ( -join ($FileWebPath, "inc/ProgramInstaller.ps1?raw=true"))
    
    # Download Program Installer
    try {
        WriteLog "Downloading ProgramInstaller.ps1 from $ProgramScriptPath"
        Invoke-WebRequest -Uri $ProgramScriptPath -OutFile ".\ProgramInstaller.ps1" | Select-Object -Expand StatusCode
    }
    catch {
        $WebError = + $_.Exception.Response.StatusCode
        WriteLog "Web Request Error: $WebError" 
    }
    
    
    try {
        # Run App Installer Script
        WriteLog "Starting Program Installer"
        .\ProgramInstaller.ps1 $FileWebPath 
        
    }
    catch [System.Net.WebException], [System.Exception] {
        WriteLog $_.System.Exception
    }

}

Function InstallWinGet {

    'Winget is not installed...'
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls13
    $ProgramInstallerPath = ( -join ($FileWebPath, $AppInstaller))
    Write-Host $ProgramInstallerPath
    Invoke-WebRequest $ProgramInstallerPath -OutFile ".\appinstaller.msixbundle"
    "Installing Winget"
    Add-AppPackage -Path ".\appinstaller.msixbundle"

}


# Check which Vendor the computer comes from (this is for BIOS)
Function checkMan {

    $vendor = wmic csproduct get vendor
    switch ($vendor) {
        'Dell Inc.' {
            $ProgramScriptPath = ( -join ($FileWebPath, "inc/DellBios.ps1?raw=true"))
            WriteLog "Dell PC, Downloading Dell BIOs Script from : $ProgramScriptPath"
            try {
                WriteLog "Running DellBios.ps1"
                .\DellBios.ps1 $FileWebPath
            }
            catch [System.Net.WebException], [System.Exception] {
                WriteLog $_.System.Exception
            }
        }
        'LENOVO' {

        }
    }

}

# Cleaning Function ( Remove downloaded files )
function clean($method) {

    switch ($method) {

        'InstallBaseApps' {
            "Cleaning..."
            WriteLog "Cleaning..."
            WriteLog "Removing appinstaller.msixbundle"
            try { Remove-Item .\appinstaller.msixbundle } catch { WriteLog "Unable to remove appinstaller.msixbundle" }
            WriteLog "Removing ProgramInstaller.ps1"
            try { Remove-Item .\ProgramInstaller.ps1 } catch { WriteLog "Unable to remove ProgramInstaller.ps1" }
            WriteLog "Removing InstallApps.xml"
            try { Remove-Item .\InstallApps.xml } catch { WriteLog "Unable to remove InstallApps.xml" }
        }

        'SystemWideChanges' {
            "Cleaning..."
        }

        'RemoveBloatWare' {
            "Cleaning..."

        }
    }

}

Show-Menu
do {
    $selection = Read-Host "Please make a selection"
    switch ($selection) {
        '1' {
            # System Wide Changes
            Remove-Bloatware
            clean("RemoveBloatWare")
        }
        '2' {
            # User-Specific Changes
        }
        '3' {
            # Both System Wide & User-Specific Changes

        }   
        '4' {
            # Apply Lenovo BIOs
            checkMan
            clean("Bios")
        }
        '5' {
            # Apply Dell BIOs
            checkMan
            clean("Bios")
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