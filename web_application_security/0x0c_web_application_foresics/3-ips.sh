#!/bin/bash
LOGFILE="./auth.log"
grep "Accepted password for root" "$LOGFILE" | awk '{print $(NF-3)}' | sort | uniq | wc -l
