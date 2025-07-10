#!/bin/bash
sudo nmap -sX -p 440-450 --open --reason -packet-trace -vv $1
