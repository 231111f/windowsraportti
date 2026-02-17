# Ladataan systeminfo.ps1 (sisältää Get-SystemInfo funktion)
. .\systeminfo.ps1

# Päivämäärä tiedoston nimeen
$date = Get-Date -Format "yyyy-MM-dd_HH-mm"

# Raportin tallennus työpöydälle
$report = "$env:USERPROFILE\Desktop\WindowsReport_$date.txt"

# ===============================
# REPORT HEADER
# ===============================

"===== WINDOWS SYSTEM REPORT =====" | Out-File $report
"Created: $(Get-Date)" | Out-File $report -Append
"" | Out-File $report -Append

# ===============================
# SYSTEM INFORMATION
# ===============================

"--- System Information ---" | Out-File $report -Append

$info = Get-SystemInfo

"Computer Name: $($info.ComputerName)" | Out-File $report -Append
"Windows Version: $($info.WindowsVersion)" | Out-File $report -Append
"Total RAM (GB): $($info.RAM)" | Out-File $report -Append
"CPU: $($info.CPU)" | Out-File $report -Append
"CPU Cores: $($info.Cores)" | Out-File $report -Append
"GPU: $($info.GPU)" | Out-File $report -Append
"" | Out-File $report -Append

# ===============================
# LOCAL USERS
# ===============================

"--- Local Users ---" | Out-File $report -Append

Get-LocalUser |
Select Name, Enabled |
Out-File $report -Append

"" | Out-File $report -Append

# ===============================
# DISK SPACE (C:)
# ===============================

"--- Disk Space (C:) ---" | Out-File $report -Append

$disk = Get-PSDrive C

$usedGB = [math]::Round($disk.Used / 1GB, 2)
$freeGB = [math]::Round($disk.Free / 1GB, 2)
$totalGB = [math]::Round(($disk.Used + $disk.Free) / 1GB, 2)

"Total Space (GB): $totalGB" | Out-File $report -Append
"Used Space (GB): $usedGB" | Out-File $report -Append
"Free Space (GB): $freeGB" | Out-File $report -Append

"" | Out-File $report -Append

# ===============================
# TOP PROCESSES
# ===============================

"--- Top Processes (Memory Usage) ---" | Out-File $report -Append

Get-Process |
Sort-Object WorkingSet -Descending |
Select-Object -First 3 Name,
@{Name="Memory(MB)";Expression={[math]::Round($_.WorkingSet/1MB,2)}} |
Out-File $report -Append

"" | Out-File $report -Append

# ===============================
# REPORT END
# ===============================

"===== END OF REPORT =====" | Out-File $report -Append

Write-Host "Raportti tallennettu." 


