#!/bin/bash
# Kernel tuning
set -euo pipefail
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w kernel.randomize_va_space=2
sysctl -w net.core.rmem_max=16777216
echo "Kernel tuned"