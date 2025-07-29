#!/bin/bash
nmap -A --script=banner,ssl-enum-ciphers,default,smb-enum-domains $1 > service_enumeration_results.txt
