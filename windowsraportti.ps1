
# Ladataan systeminfo.ps1, joka sisältää Get-SystemInfo -funktion
# Dot sourcing tekee funktion käyttöön tässä skriptissä
. .\systeminfo.ps1


# Haetaan nykyinen päivämäärä ja kellonaika tiedoston nimeä varten
$date = Get-Date -Format "yyyy-MM-dd_HH-mm"


# Määritellään raportin tallennuspolku (käyttäjän työpöytä)
$report = "$env:USERPROFILE\Desktop\WindowsReport_$date.txt"


# Luodaan raportin alku ja kirjoitetaan otsikko tiedostoon
"===== WINDOWS SYSTEM REPORT =====" | Out-File $report
"Created: $(Get-Date)" | Out-File $report -Append
"" | Out-File $report -Append


# Kirjoitetaan järjestelmätiedot
"--- System Information ---" | Out-File $report -Append

# Kutsutaan Get-SystemInfo -funktiota
$info = Get-SystemInfo

# Lisätään haetut tiedot raporttiin
"Computer Name: $($info.ComputerName)" | Out-File $report -Append
"Windows Version: $($info.WindowsVersion)" | Out-File $report -Append
"Total RAM (GB): $($info.RAM)" | Out-File $report -Append
"CPU: $($info.CPU)" | Out-File $report -Append
"CPU Cores: $($info.Cores)" | Out-File $report -Append
"GPU: $($info.GPU)" | Out-File $report -Append
"" | Out-File $report -Append


# Haetaan paikalliset käyttäjät ja heidän Enabled-tilansa
"--- Local Users ---" | Out-File $report -Append

Get-LocalUser |
Select Name, Enabled |
Out-File $report -Append

"" | Out-File $report -Append


# Haetaan C-aseman levytila
"--- Disk Space (C:) ---" | Out-File $report -Append

$disk = Get-PSDrive C

# Muutetaan tavut gigatavuiksi ja pyöristetään
$usedGB  = [math]::Round($disk.Used / 1GB, 2)
$freeGB  = [math]::Round($disk.Free / 1GB, 2)
$totalGB = [math]::Round(($disk.Used + $disk.Free) / 1GB, 2)

# Kirjoitetaan levytilat raporttiin
"Total Space (GB): $totalGB" | Out-File $report -Append
"Used Space (GB): $usedGB" | Out-File $report -Append
"Free Space (GB): $freeGB" | Out-File $report -Append

"" | Out-File $report -Append


# Haetaan kolme eniten muistia käyttävää prosessia
"--- Top Processes (Memory Usage) ---" | Out-File $report -Append

Get-Process |
Sort-Object WorkingSet -Descending |
Select-Object -First 3 Name,
@{Name="Memory(MB)";Expression={[math]::Round($_.WorkingSet/1MB,2)}} |
Out-File $report -Append

"" | Out-File $report -Append


# Lisätään raportin lopetusmerkintä
"===== END OF REPORT =====" | Out-File $report -Append


# Ilmoitus käyttäjälle, että raportti on luotu
Write-Host "Raportti tallennettu työpöydälle."
