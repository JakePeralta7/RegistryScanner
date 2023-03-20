function Get-RegistryValues ([String]$RegistryPath) {
    return (Get-Item -Path "Registry::$($RegistryPath)" | Select-Object -ExpandProperty Property)
}

function Get-RegistryValue ([String]$RegistryPath, [String]$RegistryValue) {
    return (Get-ItemProperty -Path "Registry::$($RegistryPath)" -Name $RegistryValue | Select-Object -ExpandProperty $RegistryValue)
}

function Get-RegistryKeys ([String]$RegistryPath) {
    return (Get-ChildItem -Path "Registry::$($RegistryPath)" | Select-Object -ExpandProperty Name)
}

# Scanning for possible persistencies
Write-Host "[+] Scanning for possible persistencies"

Write-Host "`t Scanning Run and RunOnce"

# Scanning HKLM Run
$hklmRunPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
Write-Host "`t`t Scanning $($hklmRunPath)"

# Retrieving HKLM Run Entries
$hklmRunEntries = Get-RegistryValues -RegistryPath $hklmRunPath
foreach ($hklmRunEntry in $hklmRunEntries) {
    $hklmRunValue = Get-RegistryValue -RegistryPath $hklmRunPath -RegistryValue $hklmRunEntry
    Write-Host "`t`t`t Found $($hklmRunEntry): $($hklmRunValue)" -ForegroundColor Red
}

# Scanning Users Hive Run
Write-Host "`t`t Scanning All HKEY Users Hive"

$hkuKeys = Get-RegistryKeys -RegistryPath "HKEY_USERS"
foreach ($hkuKey in $hkuKeys) {
    
}