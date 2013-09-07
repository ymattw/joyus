#!/bin/bash
# Example output from w -h:
#
# mattw    pts/0    corp-nat.peking. 00:37    0.00s  0.08s  0.00s w mattw
# mattw    pts/1    corp-nat.peking. 22:08   59:19   0.39s  0.39s -bash
#
# Send a string to tty if user has idled for 5 min

export PATH=/bin:/usr/bin
while sleep 30; do
    w -u $USER |
    while read LINE; do
        set -- $LINE
        [[ $5 == *s ]] || [[ $5 == [0-5]:?? ]] || echo -n "@_@ " > /dev/$2
    done
done >& /dev/null < /dev/null &
