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
$adguardCfg = Join-Path -Path $PSScriptRoot -ChildPath 'AdGuardHome.yaml'

# if (-not (Test-Path $adguardCfg)) {
#     $yaml = @'
# '@;
#     Set-Content -Path $adguardCfg -Value $yaml
# }

Write-Host "AdGuard Home will be installed to the same folder as this powershell script."
Write-Host 'Current folder: "' $PSScriptRoot '"' -ForegroundColor Yellow -BackgroundColor Black

Write-Host "`nPress any key to proceed."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host "Downloading AdGuard Home ..." -ForegroundColor Magenta -BackgroundColor Black
$outFile = Join-Path -Path $PSScriptRoot -ChildPath '.\AdGuardHome_windows_amd64.zip'
$aghUri = 'https://static.adguard.com/adguardhome/release/AdGuardHome_windows_amd64.zip'
Invoke-WebRequest -OutFile "$outFile" -Uri "$aghUri"

Write-Host 'Extracting "'$outFile'" to "'$PSScriptRoot'..."' -ForegroundColor Magenta -BackgroundColor Black
Expand-Archive $outFile $PSScriptRoot -Force

$extractedDir = Join-Path -Path $PSScriptRoot -ChildPath 'AdGuardHome'
Move-Item -Force -Path $extractedDir\* -Destination $PSScriptRoot
Remove-Item $extractedDir
Remove-Item $outFile

Write-Host 'Installing service "AdGuardHome"...' -ForegroundColor Magenta -BackgroundColor Black
&"$adguardBin" -s install -w "$PSScriptRoot" -c "$adguardCfg"

Write-Host 'Starting service "AdGuardHome"...' -ForegroundColor Magenta -BackgroundColor Black
&"$adguardBin" -s start

Write-Host "Management interface is available at http://127.0.0.1:3000/" -ForegroundColor Magenta -BackgroundColor Black
Start-Process "http://127.0.0.1:3000/"

timeout 10
