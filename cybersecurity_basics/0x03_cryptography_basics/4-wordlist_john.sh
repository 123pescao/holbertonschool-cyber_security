#!/bin/bash
john --wordlist=./rockyou.txt $1 && john --show $1 | grep -v ":" | grep -v "Loaded" | grep -v "password hashes cracked" > 4-password.txt
