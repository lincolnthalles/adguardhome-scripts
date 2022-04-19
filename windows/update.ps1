$DebugPreference = 'SilentlyContinue'
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Requesting privileges elevation ..." -ForegroundColor Yellow -BackgroundColor Black
    Start-Process (Get-Process -Id $pid).Path "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;    
    exit;
} else {
    Write-Host "This script is running with administrator privileges`n" -ForegroundColor Green -BackgroundColor Black
}
#

$adguardBin = Join-Path -Path $PSScriptRoot -ChildPath 'AdGuardHome.exe'

Write-Host "Downloading current AdGuard Home version ..." -ForegroundColor Magenta -BackgroundColor Black
$outFile = Join-Path -Path $PSScriptRoot -ChildPath '.\AdGuardHome_windows_amd64.zip'
$aghUri = 'https://static.adguard.com/adguardhome/release/AdGuardHome_windows_amd64.zip'
Invoke-WebRequest -OutFile "$outFile" -Uri "$aghUri"

Write-Host "Stopping service `"AdGuardHome`" ...`n" -ForegroundColor Magenta -BackgroundColor Black
&"$adguardBin" -s stop

Write-Host 'Extracting "'$outFile'" to "'$PSScriptRoot'..."' -ForegroundColor Magenta -BackgroundColor Black
Expand-Archive $outFile $PSScriptRoot -Force

$extractedDir = Join-Path -Path $PSScriptRoot -ChildPath 'AdGuardHome'
Move-Item -Force -Path $extractedDir\* -Destination $PSScriptRoot
Remove-Item $extractedDir
Remove-Item $outFile

Write-Host "Starting service `"AdGuardHome`" ...`n" -ForegroundColor Magenta -BackgroundColor Black
&"$adguardBin" -s start

timeout 10
