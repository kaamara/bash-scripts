# sysadmin-scripts

Trzy skrypty diagnostyczne do szybkiego sprawdzenia stanu maszyny, każdy
w dwóch wersjach: Bash dla Linuksa i PowerShell dla Windowsa. Obie wersje
robią to samo i wypisują te same sekcje.

## Skrypty

| Skrypt | Co pokazuje |
|---|---|
| `server-stats` | system i uptime, obciążenie CPU, pamięć, dysk, top 5 procesów wg CPU i wg pamięci |
| `internet-stats` | adres IP i interfejs, brama domyślna, serwery DNS, test połączenia |
| `security-check` | zalogowani użytkownicy, nieudane logowania SSH, nieudane usługi, otwarte porty, dostępne aktualizacje, wymagany restart |

## Uruchomienie

Linux:

```bash
chmod +x bash/*.sh
./bash/server-stats.sh
```

Windows:

```powershell
.\powershell\server-stats.ps1
```

Gdy PowerShell odmówi uruchomienia skryptu, odblokuj to na czas bieżącej
sesji: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`

## Uwagi

`security-check` po stronie Linuksa czyta `/var/log/auth.log` (Debian,
Ubuntu), a gdy go nie znajdzie, sięga do `journalctl` (Fedora, Arch).
Liczbę pakietów do aktualizacji sprawdza przez `apt` albo `dnf`.
