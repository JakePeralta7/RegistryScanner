function Get-RegistryValues ([String]$RegistryPath) {
    if ($RegistryPath -notmatch "^Registry::") {
        $RegistryPath = "Registry::$($RegistryPath)"
    }
    return (Get-Item -Path $RegistryPath | Select-Object -ExpandProperty Property)
}

function Get-RegistryValue ([String]$RegistryPath, [String]$RegistryValue) {
    if ($RegistryPath -notmatch "^Registry::") {
        $RegistryPath = "Registry::$($RegistryPath)"
    }
    return (Get-ItemProperty -Path $RegistryPath -Name $RegistryValue | Select-Object -ExpandProperty $RegistryValue)
}

function Get-RegistryKeys ([String]$RegistryPath) {
    if ($RegistryPath -notmatch "^Registry::") {
        $RegistryPath = "Registry::$($RegistryPath)"
    }
    return (Get-ChildItem -Path $RegistryPath | Select-Object -ExpandProperty Name)
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

# Scanning HKLM RunOnce
$hklmRunOncePath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
Write-Host "`t`t Scanning $($hklmRunOncePath)"

# Retrieving HKLM RunOnce Entries
$hklmRunOnceEntries = Get-RegistryValues -RegistryPath $hklmRunOncePath
foreach ($hklmRunOnceEntry in $hklmRunOnceEntries) {
    $hklmRunOnceValue = Get-RegistryValue -RegistryPath $hklmRunOncePath -RegistryValue $hklmRunOnceEntry
    Write-Host "`t`t`t Found $($hklmRunOnceEntry): $($hklmRunOnceValue)" -ForegroundColor Red
}

# Scanning Users Hive Run and RunOnce
Write-Host "`n`t`t Scanning All HKEY Users Hive"

$hkuKeys = Get-RegistryKeys -RegistryPath "HKEY_USERS"
foreach ($hkuKey in $hkuKeys) {
    $currentRegistryPath = "Registry::$($hkuKey)\Software\Microsoft\Windows\CurrentVersion\Run"
    if (Test-Path -Path $currentRegistryPath) {
        Write-Host "`t`t Scanning Run in $($hkuKey)"
        $hkuRunEntries = Get-RegistryValues -RegistryPath $currentRegistryPath
        foreach ($hkuRunEntry in $hkuRunEntries) {
            $hkuRunValue = Get-RegistryValue -RegistryPath $currentRegistryPath -RegistryValue $hkuRunEntry
            Write-Host "`t`t`t Found $($hkuRunEntry): $($hkuRunValue)" -ForegroundColor Red
        }
    }

    $currentRegistryPath = "Registry::$($hkuKey)\Software\Microsoft\Windows\CurrentVersion\RunOnce"
    if (Test-Path -Path $currentRegistryPath) {
        Write-Host "`t`t Scanning RunOnce in $($hkuKey)"
        $hkuRunOnceEntries = Get-RegistryValues -RegistryPath $currentRegistryPath
        foreach ($hkuRunOnceEntry in $hkuRunOnceEntries) {
            $hkuRunOnceValue = Get-RegistryValue -RegistryPath $currentRegistryPath -RegistryValue $hkuRunOnceEntry
            Write-Host "`t`t`t Found $($hkuRunOnceEntry): $($hkuRunOnceValue)" -ForegroundColor Red
        }
    }
}