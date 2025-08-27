#!/bin/bash

# System Monitoring Script
# Author: Yusuf Hussan
# Description: Collects CPU, memory, disk, and network usage
#              and logs results to /var/log/sys_monitor.log

LOG_FILE="/var/log/sys_monitor.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "================= System Report: $DATE =================" >> $LOG_FILE

# CPU Usage
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
echo "CPU Usage: $CPU%" >> $LOG_FILE

# Memory Usage
MEM=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
echo "Memory Usage: $MEM" >> $LOG_FILE

# Disk Usage
DISK=$(df -h / | awk 'NR==2 {print $5}')
echo "Disk Usage (root): $DISK" >> $LOG_FILE

# Network Usage (last 5s avg)
IFACE="eth0" # Change this if using different interface (use: ip a to check)
RX_BEFORE=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX_BEFORE=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
sleep 5
RX_AFTER=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX_AFTER=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
RX_RATE=$(( ($RX_AFTER - $RX_BEFORE) / 1024 / 5 ))
TX_RATE=$(( ($TX_AFTER - $TX_BEFORE) / 1024 / 5 ))
echo "Network Usage on $IFACE -> RX: ${RX_RATE}KB/s | TX: ${TX_RATE}KB/s" >> $LOG_FILE

echo "========================================================" >> $LOG_FILE
echo "" >> $LOG_FILE
