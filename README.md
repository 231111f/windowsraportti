# Windows System Report Script

## Tarkoitus

Tämä PowerShell-skripti luo automaattisen järjestelmäraportin Windows-koneesta.

Skripti kerää seuraavat tiedot:
- Tietokoneen nimi
- Windows-versio
- RAM-muistin määrä
- CPU:n nimi ja ytimien määrä
- GPU (näytönohjain)
- Paikalliset käyttäjät
- C-aseman levytila
- Eniten muistia käyttävät prosessit

Raportti tallennetaan automaattisesti käyttäjän työpöydälle .txt-tiedostona.
Tiedoston nimessä on päivämäärä ja kellonaika.

---

## Järjestelmävaatimukset

- Windows 10 tai Windows 11
- PowerShell 5.1 tai uudempi
- Ei vaadi lisäasennuksia

---

## Käyttö

1. Avaa PowerShell
2. Siirry skriptin kansioon
3. Suorita komento:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

4. Käynnistä skripti:

.\windowsraportti.ps1

---

## Siirrettävyys

Skripti toimii kaikilla Windows-koneilla, joissa on PowerShell.
Ei vaadi konekohtaisia muutoksia.

---

## Rajoitteet

- Tarkistaa vain C-aseman
- Ei tee muutoksia järjestelmään, ainoastaan raportoi tiedot
- Execution Policy täytyy sallia ajon ajaksi

---

## Kehitysideoita

- HTML-muotoinen raportti
- RAM- ja CPU-käyttöprosentin lisääminen
- Useamman levyaseman tarkistus
- Automaattinen ajastus Windows Task Schedulerilla
- Raportin lähetys sähköpostiin
