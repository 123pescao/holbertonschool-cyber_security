#!/bin/bash
nmap --script=http-vuln-cve2017-5638,ssl-enum-ciphers,ftp-anon $1 > comprehensive_scan_results.txt
