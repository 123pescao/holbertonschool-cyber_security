#!/bin/bash
ps -u "$1" | grep -v "^ *PID" | grep -v " 0 0 "
