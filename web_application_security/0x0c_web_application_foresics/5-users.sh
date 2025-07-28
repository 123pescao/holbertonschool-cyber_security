#!/bin/bash
LOGFILE="./auth.log"
grep "useradd" "$LOGFILE" | grep -oP 'name=\K[^,]+' | sort | uniq | paste -sd "," -
