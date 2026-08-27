#!/bin/bash
# System Information Script
# Display comprehensive system info

echo "=== System Information ==="
echo "Hostname: $(hostname)"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo ""

echo "=== CPU ==="
lscpu | grep -E "Model name|CPU\(s\)|Thread|Core"
echo "Load: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
echo ""

echo "=== Memory ==="
free -h
echo ""

echo "=== Disk ==="
df -h | grep -E "Filesystem|/dev/"
echo ""

echo "=== Network ==="
ip -4 addr show | grep -E "inet " | awk '{print $2, $NF}'
echo ""

echo "=== Docker ==="
if command -v docker &>/dev/null; then
    echo "Containers: $(docker ps -q | wc -l) running"
    echo "Images: $(docker images -q | wc -l)"
    echo "Volumes: $(docker volume ls -q | wc -l)"
else
    echo "Docker not installed"
fi
echo ""

echo "=== Temperature ==="
if command -v sensors &>/dev/null; then
    sensors | grep -E "Core|temp"
else
    cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | while read t; do
        echo "$((t/1000))°C"
    done
fi
