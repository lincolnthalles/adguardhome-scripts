$DebugPreference = 'SilentlyContinue'
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Requesting privileges elevation ..." -ForegroundColor Yellow -BackgroundColor Black
    Start-Process (Get-Process -Id $pid).Path "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;    
    exit;
} else {
    Write-Host "This script is running with administrator privileges`n" -ForegroundColor Green -BackgroundColor Black
}
# 

Write-Host "Uninstalling service `"AdGuardHome`" ...`n" -ForegroundColor Magenta -BackgroundColor Black
$adguardBin = Join-Path -Path $PSScriptRoot -ChildPath 'AdGuardHome.exe'
&"$adguardBin" -s stop
&"$adguardBin" -s uninstall

timeout 10
