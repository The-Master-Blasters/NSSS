

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  [string]$appinstaller,
  [Parameter(Mandatory=$false)]
  [string]$Foo
)

# Check if Script is run as Administrator. If not, elevate
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    Write-Host "Elevating to Administrator Privileges In 5 seconds"
    Start-Sleep 5
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit

}

Function InstallWinGet {

    'WinGet is not installed...'
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls13
    wget $appinstaller -OutFile ".\appinstaller.msixbundle"

    Add-AppPackage -Path ".\appinstaller.msixbundle"

}

Function InstallApps {

    #try {winget.exe install filezilla --silent}
    #catch { InstallWinGet }
    "Installing Applications..."

    # WinGet Install Apps
    winget.exe install filezilla --silent
    winget.exe install Google.Chrome --silent
    winget.exe install 7zip.7zip --silent
    winget.exe install PuTTY.PuTTY --silent
    winget.exe install Adobe.Acrobat.Reader.64-bit --silent

}


try { InstallApps } catch { InstallWinGet }
