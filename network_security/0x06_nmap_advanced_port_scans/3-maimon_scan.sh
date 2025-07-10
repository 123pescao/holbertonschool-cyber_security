#!/bin/bash
sudo nmap -sM -p http https ssh 21,22,23,8-,443 -vv $1
