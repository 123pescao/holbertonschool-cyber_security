#!/bin/bash
LOGFILE="./auth.log"
grep -oP '\b\w+(?=\[\d+\]:)' "$LOGFILE" | sort | uniq -c | sort -nr | head -10
