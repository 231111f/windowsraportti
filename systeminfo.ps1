function Get-SystemInfo {

    # Haetaan käyttöjärjestelmän tiedot
    $os = Get-WmiObject Win32_OperatingSystem

    # Haetaan CPU (ensimmäinen prosessori)
    $cpu = Get-WmiObject Win32_Processor | Select-Object -First 1

    # Haetaan GPU (ensimmäinen näytönohjain)
    $gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1

    # Lasketaan RAM gigatavuiksi
    $ramGB = [math]::Round(($os.TotalVisibleMemorySize / 1MB), 2)

    return @{
        ComputerName   = $env:COMPUTERNAME
        WindowsVersion = $os.Caption
        RAM            = $ramGB
        CPU            = $cpu.Name
        Cores          = $cpu.NumberOfCores
        GPU            = $gpu.Name
    }
}

