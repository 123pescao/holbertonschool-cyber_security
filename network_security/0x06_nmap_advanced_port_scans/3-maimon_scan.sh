#!/bin/bash
sudo nmap -sM -p http 21,22,23,8-,443 -vv $1
