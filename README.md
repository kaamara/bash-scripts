# server-performance-stats

chmod +x server-stats.sh
./server-stats.sh

# internet-stats

chmod +x internet-stats.sh
./internet-stats.sh

# security-check

chmod +x security-check.sh
./security-check.sh

Logged in users / last logins — kto siedzi na maszynie teraz i kto logował się ostatnio (who, last)
Failed login attempts — liczba nieudanych logowań SSH plus 3 ostatnie próby z adresem IP; czyta /var/log/auth.log (Debian/Ubuntu), a jak go nie ma, sięga do journalctl (Fedora/Arch)
Failed services — systemctl --failed; jak wszystko działa, wypisuje "OK"
Open ports — porty nasłuchujące z ss -tulnp, szybki sposób na wykrycie, że coś wystawiło się na świat, czego nie powinno być
Pending updates — liczba pakietów do aktualizacji, obsługuje apt i dnf
Reboot required — sprawdza /var/run/reboot-required (po aktualizacji kernela)
