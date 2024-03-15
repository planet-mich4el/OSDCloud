Write-Host -ForegroundColor Green "Starting OSDCloud ZTI"
Start-Sleep -Seconds 5

Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force
Write-Host -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force

Write-Host -ForegroundColor Green "Start OSDCloud"
Start-OSDCloud -ZTI -OSVersion 'Windows 11' -OSBuild 23H2 -OSEdition Enterprise -OSLanguage en-us -OSLicense Retail

Write-Host -ForegroundColor Green "Restarting in 20 seconds"
Start-Sleep -Seconds 20
wpeutil reboot