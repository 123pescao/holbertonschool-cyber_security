#!/bin/bash
john --wordlist=./rockyou.txt --format=raw-sha256 $1 && john --show --format=raw-sha256 $1 | grep -v ":" | grep -v "Loaded" | grep -v "password hashes cracked" > 6-password.txt
