#!/bin/bash
sudo nmap -sX -p 440-450 --open --reason -vv $1
