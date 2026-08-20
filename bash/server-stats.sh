
echo "------------------------------------------"
echo "        SERVER PERFORMANCE STATS          "
echo "------------------------------------------"

echo "==================="
echo "--- system info ---"
echo "==================="
echo "$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2)"
echo "$(uptime -p)"
echo "$(cat /proc/loadavg | awk '{print $1, $2, $3}')"
echo ""

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
echo "=================="
echo "--- cpu usage ---"
echo "=================="
echo "total cpu usage: $cpu_usage"
echo ""

echo "===================="
echo "--- memory usage ---"
echo "===================="
free -m | awk 'NR==2{printf "used: %sMB | free: %sMB | usage: %.2f%%\n", $3, $4, $3*100/$2}'
echo ""

echo "==================="
echo "--- disk usage ---"
echo "==================="
df -h --total | grep 'total' | awk '{printf "Used: %s | Free: %s | Usage: %s\n", $3, $4, $5}'
echo ""

echo "===================================="
echo "--- top 5 processes by cpu usage ---"
echo "===================================="
ps aux --sort=-%cpu | head -n 6 | awk '{print $1 "\t" $2 "\t" $3 "\t" $11}'
echo ""

echo "========================================"
echo "--- top 5 Processes by memory usage ---"
echo "========================================"
ps aux --sort=-%mem | head -n 6 | awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'
echo ""

echo "------------------------------------------"