#!/bin/bash
find / -xdev -type d -perm -0002 -print 2>/dev/null | tee /dev/tty | xargs chmod o-w
