echo "------------------------------------------"
echo "       SYSTEM HEALTH & SECURITY CHECK     "
echo "------------------------------------------"

echo "======================"
echo "--- logged in users ---"
echo "======================"
who
echo ""

echo "======================"
echo "--- last 5 logins ----"
echo "======================"
last -n 5 | head -n 5
echo ""

echo "=========================="
echo "--- failed login attempts ---"
echo "=========================="
if [ -f /var/log/auth.log ]; then
    failed=$(grep -c "Failed password" /var/log/auth.log)
    echo "Failed logins (auth.log): $failed"
    grep "Failed password" /var/log/auth.log | tail -n 3 | awk '{print $1, $2, $3, "user:", $(NF-5), "from:", $(NF-3)}'
else
    failed=$(journalctl -u ssh -u sshd --since today 2>/dev/null | grep -c "Failed password")
    echo "Failed logins today (journal): $failed"
fi
echo ""

echo "========================"
echo "--- failed services ---"
echo "========================"
failed_services=$(systemctl --failed --no-legend | awk '{print $1}')
if [ -z "$failed_services" ]; then
    echo "All services:  OK"
else
    echo "FAILED services:"
    echo "$failed_services"
fi
echo ""

echo "=========================="
echo "--- open ports (listen) ---"
echo "=========================="
ss -tulnp 2>/dev/null | awk 'NR>1 {print $1 "\t" $5}' | sort -u
echo ""

echo "========================"
echo "--- pending updates ---"
echo "========================"
if command -v apt >/dev/null; then
    updates=$(apt list --upgradable 2>/dev/null | grep -c "upgradable")
    echo "Packages to upgrade: $updates"
elif command -v dnf >/dev/null; then
    updates=$(dnf check-update -q 2>/dev/null | grep -c "^[a-zA-Z]")
    echo "Packages to upgrade: $updates"
else
    echo "No supported package manager found"
fi
echo ""

echo "=========================="
echo "--- reboot required? ---"
echo "=========================="
if [ -f /var/run/reboot-required ]; then
    echo "Reboot:  REQUIRED"
else
    echo "Reboot:  not needed"
fi
echo "------------------------------------------"
