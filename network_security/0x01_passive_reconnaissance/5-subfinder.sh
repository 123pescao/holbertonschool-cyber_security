#!/bin/bash
subfinder -d "$1" -silent | tee >(while IFS= read -r sub; do echo "$sub,$(host "$sub" | awk '/has address/ {print $4; exit}')"; done > "$1.txt")
