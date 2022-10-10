[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$FileWebPath
)

$AppInstallList = "xml/InstallApps.xml?raw=true"
$AppInstaller = "installers/appinstaller.msixbundle"

# Check if Script is run as Administrator. If not, elevate
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    Write-Host "Elevating to Administrator Privileges In 5 seconds"
    Start-Sleep 5
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit

}

Function InstallApps {

    "Grabbing Application List"

    try {

        $xmlfilepath = ( -join ($FileWebPath, $AppInstallList))
        Invoke-WebRequest $xmlfilepath -OutFile .\InstallApps.xml
        [xml]$applist = Get-Content ".\InstallApps.xml"

    }
    catch { "Unable to grab application list" }

    "Installing Applications..."

    foreach ($app in $applist.apps.app.id) {
        Write-Host $app
        WriteLog "Installing $app..."
        try {winget install $app --silent} catch {WriteLog "An error has occured while downloading application"}   
    }


}


try { InstallApps } catch { InstallWinGet }
