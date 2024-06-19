Write-Host -BackgroundColor Black -ForegroundColor Green "Start OSDCloud ZTI"
Start-Sleep -Seconds 5

$message = [PSCustomObject] @{}; Clear-Variable serialNumber -ErrorAction:SilentlyContinue

$serialNumber = Get-WmiObject -Class Win32_BIOS | Select-Object -ExpandProperty SerialNumber
if ($serialNumber) {
    $message | Add-Member -MemberType NoteProperty -Name "serialNumber" -Value $serialNumber
} else {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show('You cannot continue because the device does not have a proper serial number.', 'Error', 'OK', 'Error')
    wpeutil reboot
}

Write-Host -BackgroundColor Black -ForegroundColor Green "Vertification on AutoPilot"
$body = $message | ConvertTo-Json -Depth 5
$uri = "https://prod-145.westus.logic.azure.com:443/workflows/dadfcaca1bcc4b069c998a99e82ee728/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=n0urWoGWa2OXN-4ba0U7UwfEM8i9vwTuSHx2PrSVtvU"
$result = Invoke-RestMethod -Uri $uri -Method POST -Body $body -ContentType "application/json; charset=utf-8" -UseBasicParsing    

if ($result) {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show('You cannot continue because the device is not ready for Windows AutoPilot provisioning.', 'Error', 'OK', 'Error')
    wpeutil reboot
}


Write-Host -BackgroundColor Black -ForegroundColor Green "Update OSD PowerShell Module"
Install-Module OSD -Force -SkippublisherCheck
Write-Host -BackgroundColor Black -ForegroundColor Green "Import OSD PowerShell Module"
Import-Module OSD -Force

Write-Host -BackgroundColor Black -ForegroundColor Green "Start OSDCloud"
Start-OSDCloud -ZTI -OSVersion 'Windows 11' -OSBuild 23H2 -OSEdition Enterprise -OSLanguage en-us -OSLicense Retail

Write-Host -BackgroundColor Black -ForegroundColor Green "Restart in 20 seconds"
Start-Sleep -Seconds 20
wpeutil reboot