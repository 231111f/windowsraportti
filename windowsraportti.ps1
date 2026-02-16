# Windows System Report

$date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$report = "$env:USERPROFILE\Desktop\WindowsReport_$date.txt"

"===== WINDOWS SYSTEM REPORT =====" | Out-File $report
"Created: $(Get-Date)" | Out-File $report -Append
"" | Out-File $report -Append

# --- System Information ---
"--- System Information ---" | Out-File $report -Append

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$gpu = Get-CimInstance Win32_VideoController

"Computer Name: $env:COMPUTERNAME" | Out-File $report -Append
"Windows Version: $($os.Caption)" | Out-File $report -Append
"Total RAM (GB): $([math]::Round($os.TotalVisibleMemorySize/1MB,2))" | Out-File $report -Append
"CPU: $($cpu.Name)" | Out-File $report -Append
"CPU Cores: $($cpu.NumberOfCores)" | Out-File $report -Append
"GPU: $($gpu.Name)" | Out-File $report -Append
"" | Out-File $report -Append

# --- Local Users ---
"--- Local Users ---" | Out-File $report -Append
Get-LocalUser | Select Name, Enabled | Out-File $report -Append
"" | Out-File $report -Append

# --- Disk Space (C:) ---
"--- Disk Space (C:) ---" | Out-File $report -Append
Get-PSDrive C | Select Used, Free | Out-File $report -Append
"" | Out-File $report -Append

# --- Top 3 Processes (Memory Usage) ---
"--- Top Processes ---" | Out-File $report -Append
Get-Process |
Sort-Object WorkingSet -Descending |
Select-Object -First 3 Name, @{Name="Memory(MB)";Expression={[math]::Round($_.WorkingSet/1MB,2)}} |
Out-File $report -Append
"" | Out-File $report -Append

"===== END OF REPORT =====" | Out-File $report -Append

Write-Host "Report saved to Desktop."
