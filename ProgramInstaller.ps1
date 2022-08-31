

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  [string]$appinstaller,
  [Parameter(Mandatory=$true)]
  [string]$AppInstallList
)

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
    Invoke-WebRequest $appinstaller -OutFile ".\appinstaller.msixbundle"
    "Installing Winget"
    Add-AppPackage -Path ".\appinstaller.msixbundle"

}

Function InstallApps {

    #try {winget.exe install filezilla --silent}
    #catch { InstallWinGet }
    "Grabbing Application List"

    try {

        Invoke-WebRequest $AppInstallList -OutFile .\InstallApps.xml
        [xml]$applist = Get-Content ".\InstallApps.xml"

    } catch { "Unable to grab application list"}

    "Installing Applications..."

    foreach ($app in $applist.apps.app) {
        winget install [string]$app.id --silent
    }


    # WinGet Install Apps
    #winget.exe install filezilla --silent
    #winget.exe install Google.Chrome --silent
    #winget.exe install 7zip.7zip --silent
    #winget.exe install PuTTY.PuTTY --silent
    #winget.exe install Adobe.Acrobat.Reader.64-bit --silent

}


try { InstallApps } catch { InstallWinGet }
