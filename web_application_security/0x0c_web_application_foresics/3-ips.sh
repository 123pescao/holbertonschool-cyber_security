#!/bin/bash
LOGFILE="./auth.log"
grep "Accepted password for" "$LOGFILE" | awk '{print $(NF-3)}' | sort | uniq | wc -l
