[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$FileWebPath,
    [Parameter(Mandatory = $true)]
    [string]$InstallerWebPath
)

$AppInstallList = "xml/InstallApps.xml"
$AppInstaller = "installers/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe%20.msixbundle"

# Check if Script is run as Administrator. If not, elevate
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    Write-Host "Elevating to Administrator Privileges In 5 seconds"
    Start-Sleep 5
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit

}

Function InstallWinGet {

    'Winget is not installed...'
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls13
    Invoke-WebRequest [string]$InstallerWebPath+[string]$AppInstaller -OutFile ".\appinstaller.msixbundle"
    "Installing Winget"
    Add-AppPackage -Path ".\appinstaller.msixbundle"

}

Function InstallApps {

    "Grabbing Application List"

    try {

        Invoke-WebRequest [string]$FileWebPath+[string]$AppInstallList -OutFile .\InstallApps.xml
        [xml]$applist = Get-Content ".\InstallApps.xml"

    }
    catch { "Unable to grab application list" }

    "Installing Applications..."

    foreach ($app in $applist.apps.app.id) {
        Write-Host $app
        winget install $app --silent
    }


}


try { InstallApps } catch { InstallWinGet }
