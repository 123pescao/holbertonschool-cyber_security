#!/bin/bash
LOGFILE="./auth.log"
grep -i 'add.*rule' "$LOGFILE" | wc -l
