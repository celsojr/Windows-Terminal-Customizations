$modules = @( "MSTerminalSettings", "posh-git",  "oh-my-posh" )
foreach ($element in $modules) {
    Write-Host "Verifying module $($element)..."
    if (-not (Get-Module -Name $element -ListAvailable))
    {
        Write-Host "Installing module $($element)..."
        Install-Module $element -Scope CurrentUser
    }
}

Write-Host "Installing the required ttf font..."
$objShell = new-object -comobject shell.application
$fontsFolder = $objShell.NameSpace(0x14)
$fontsFolder.CopyHere(".\src\Fonts\Meslo LG M Regular for Powerline.ttf")

$splat = @{
    useAcrylic = $true
    acrylicOpacity = 0.3
    background = "#000000"
    fontFace = "Meslo LG M for Powerline"
    fontSize = 10
}

Write-Host "Applying Windows Terminal settings..."
$terminalProfile = Get-MSTerminalProfile -Name "Windows PowerShell"
$terminalProfile | Set-MSTerminalProfile @splat

Write-Host "Verifying the profile..."
if (-not (Test-Path -Path $PROFILE)) {
    Write-Host "Creating a new profile..."
    New-Item -Path $PROFILE -ItemType File
}
Write-Host "Writing to the profile..."
Add-Content $PROFILE "Import-Module posh-git"
Add-Content $PROFILE "Import-Module oh-my-posh"
Add-Content $PROFILE "Set-Theme ParadoxLight"

Import-Module posh-git
Import-Module oh-my-posh

Write-Host "Verifying if the themes folder does exists..."
if (-not $(Try { Test-Path -Path $ThemeSettings.MyThemesLocation } Catch { $false }) ) {
    Write-Host "Creating themes folder..."
    New-Item -ItemType Directory -Path $ThemeSettings.MyThemesLocation
}

Write-Host "Copying the ParadoxLight theme to the themes folder..."
Copy-Item `
 -Path ".\src\Theme\ParadoxLight.psm1" `
 -Destination $ThemeSettings.MyThemesLocation

 Set-Theme ParadoxLight

 Write-Host "Process completed!"