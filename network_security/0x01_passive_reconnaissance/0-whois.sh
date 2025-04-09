#!/bin/bash
whois "$1" | awk -F": " '/^(Registrant Organization|Registrant State\/Province|Registrant Country|Registrant Email|Admin Organization|Admin State\/Province|Admin Country|Admin Email|Tech Organization|Tech State\/Province|Tech Country|Tech Email)/ {print $1","$2}' > "$1.csv"
