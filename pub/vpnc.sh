#!/bin/bash

function vpnc_status
{
    local line
    local ip

    line=$(/sbin/ifconfig tun0 2>/dev/null | /bin/grep 'inet addr:')
    line=${line#*:}
    ip=${line%% *}
    echo $ip
    [[ -n "$ip" ]]
    return $?
}

function vpnc_stop
{
    /usr/sbin/VPNC-disconnect
}

function vpnc_start
{
    local key=$1
    local prefix=xxxx

    /bin/cat << CONF_END | /usr/sbin/VPNC - || return 1
IPSec gateway 12.34.56.78
IPSec ID CorpVPN
IPSec secret grouppassword
Xauth username myusername
Xauth password ${prefix}${key}
Target networks 10.0.0.0/8 192.168.0.0/24
DNSUpdate no
CONF_END

    return 0
}

# Main Proc
#
exec 2>&1

echo "Content-type: text/plain"
echo

if [[ $PATH_INFO == /q ]]; then
    vpnc_status
elif [[ $PATH_INFO == /d ]] && vpnc_status > /dev/null; then
    vpnc_stop
elif [[ $PATH_INFO =~ /[0-9]{6} ]]; then
    if ! vpnc_status; then
        vpnc_start ${PATH_INFO#/} || exit 1
        vpnc_status
    fi
else
    echo "404 Not Found" >&2
    exit 1
fi

exit 0
