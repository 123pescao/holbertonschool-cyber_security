#!/bin/bash
attacker=$(awk '{print $1}' $1 | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
grep "^$attacker " $1 | wc -l
