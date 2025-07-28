#!/bin/bash
LOGFILE="./auth.log"
tail -n 1000 "$LOGFILE" > last1000.tmp
FAILED_USERS=$(grep "Failed password for" last1000.tmp | awk '{print $(NF-5)}' | sort | uniq)
SUCCESS_USERS=$(grep "Accepted password for" last1000.tmp | awk '{print $(NF-5)}' | sort | uniq)


for user in $FAILED_USERS; do
    if echo "$SUCCESS_USERS" | grep -qw "$user"; then
        echo "$user"
    fi
done

rm last1000.tmp
