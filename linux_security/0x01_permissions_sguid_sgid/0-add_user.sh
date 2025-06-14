#!/bin/bash
useradd "$1"
passwd "$1"
$2
$2
EOF
