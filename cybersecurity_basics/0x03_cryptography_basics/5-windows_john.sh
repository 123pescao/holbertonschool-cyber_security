#!/bin/bash
john --wordlist=./rockyou.txt --format=nt $1 && john --show --format=nt $1 | grep -v ":" | grep -v "Loaded" | grep -v "password hashes cracked" > 5-password.txt
