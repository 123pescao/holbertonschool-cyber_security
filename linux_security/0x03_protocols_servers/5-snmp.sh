#!/bin/bash
grep -Ei 'community|public' /etc/snmp/snmpd.conf 2>/dev/null
