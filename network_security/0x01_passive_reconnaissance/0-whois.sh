#!/bin/bash
whois "$1" | awk 'BEGIN { FS=": "; OFS="," } /^(Registrant|Admin|Tech)/ {print $1, $2}' > "$1.csv"
