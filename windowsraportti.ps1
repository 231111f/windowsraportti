
param(
    # Käyttäjä voi määrittää raportin tallennuspolun.
    # Jos ei määritä, raportti tallennetaan työpöydälle.
    [string]$ReportPath = "$env:USERPROFILE\Desktop\WindowsReport_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').txt"
)

# Ladataan systeminfo.ps1, jotta Get-SystemInfo -funktio on käytettävissä
. .\systeminfo.ps1


function Write-Section {
    param([string]$Title)

    try {
        # Kirjoittaa osio-otsikon raporttiin
        "=== $Title ===" | Out-File $ReportPath -Append
    }
    catch {
        # Jos kirjoittaminen epäonnistuu, näytetään varoitus
        Write-Warning "Otsikon kirjoittaminen epäonnistui: $Title"
    }
}


function Get-DiskInfo {
    try {
        # Hakee C-aseman tiedot
        $disk = Get-PSDrive C -ErrorAction Stop

        # Palauttaa levytilat gigatavuina
        return [PSCustomObject]@{
            TotalGB = [math]::Round(($disk.Used + $disk.Free) / 1GB, 2)
            UsedGB  = [math]::Round($disk.Used / 1GB, 2)
            FreeGB  = [math]::Round($disk.Free / 1GB, 2)
        }
    }
    catch {
        # Jos haku epäonnistuu, palautetaan null ja näytetään varoitus
        Write-Warning "Levytilan hakeminen epäonnistui."
        return $null
    }
}


function Get-TopProcesses {
    try {
        # Hakee käynnissä olevat prosessit,
        # lajittelee ne muistinkäytön mukaan
        # ja valitsee 3 eniten muistia käyttävää
        return Get-Process -ErrorAction Stop |
        Sort-Object WorkingSet -Descending |
        Select-Object -First 3 Name,
        @{Name="Memory(MB)";Expression={[math]::Round($_.WorkingSet/1MB,2)}}
    }
    catch {
        Write-Warning "Prosessien hakeminen epäonnistui."
        return $null
    }
}


function Get-LocalUsersInfo {
    try {
        # Hakee paikalliset käyttäjät ja heidän Enabled-tilansa
        return Get-LocalUser -ErrorAction Stop |
        Select Name, Enabled
    }
    catch {
        Write-Warning "Käyttäjien hakeminen epäonnistui."
        return $null
    }
}


try {

    # Luodaan uusi raporttitiedosto ja kirjoitetaan otsikko
    "===== WINDOWS SYSTEM REPORT =====" | Out-File $ReportPath
    "Created: $(Get-Date)" | Out-File $ReportPath -Append
    "" | Out-File $ReportPath -Append

    # Haetaan järjestelmätiedot systeminfo.ps1-funktiosta
    Write-Section "System Information"
    $system = Get-SystemInfo

    # Tarkistetaan että tiedot saatiin ennen kirjoittamista
    if ($system) {
        "Computer Name: $($system.ComputerName)" | Out-File $ReportPath -Append
        "Windows Version: $($system.WindowsVersion)" | Out-File $ReportPath -Append
        "Total RAM (GB): $($system.RAM)" | Out-File $ReportPath -Append
        "CPU: $($system.CPU)" | Out-File $ReportPath -Append
        "CPU Cores: $($system.Cores)" | Out-File $ReportPath -Append
        "GPU: $($system.GPU)" | Out-File $ReportPath -Append
    }

    "" | Out-File $ReportPath -Append

    # Haetaan paikalliset käyttäjät
    Write-Section "Local Users"
    $users = Get-LocalUsersInfo

    if ($users) {
        $users | Out-File $ReportPath -Append
    }

    "" | Out-File $ReportPath -Append

    # Haetaan levytilat
    Write-Section "Disk Space (C:)"
    $disk = Get-DiskInfo

    if ($disk) {
        "Total Space (GB): $($disk.TotalGB)" | Out-File $ReportPath -Append
        "Used Space (GB): $($disk.UsedGB)" | Out-File $ReportPath -Append
        "Free Space (GB): $($disk.FreeGB)" | Out-File $ReportPath -Append
    }

    "" | Out-File $ReportPath -Append

    # Haetaan kolme eniten muistia käyttävää prosessia
    Write-Section "Top Processes"
    $procs = Get-TopProcesses

    if ($procs) {
        $procs | Out-File $ReportPath -Append
    }

    "" | Out-File $ReportPath -Append
    "===== END OF REPORT =====" | Out-File $ReportPath -Append

    # Ilmoitus käyttäjälle että raportti luotiin onnistuneesti
    Write-Host "Raportti luotu: $ReportPath"
}
catch {
    # Jos koko raportin luonti epäonnistuu, näytetään virheilmoitus
    Write-Error "Raportin luonti epäonnistui: $_"
}


