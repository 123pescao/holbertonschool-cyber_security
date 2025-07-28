#!/bin/bash
LOGFILE="./auth.log"
grep 'COMMAND=/sbin/iptables -A' "$LOGFILE" | wc -l
