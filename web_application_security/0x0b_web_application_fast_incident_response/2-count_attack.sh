#!/bin/bash
attacker_ip=$(awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
grep -c "^$attacker_ip" logs.txt