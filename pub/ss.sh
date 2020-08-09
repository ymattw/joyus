#!/bin/bash
# Script to setup SS on Ubuntu VPS. Verified versions:16.04, 18.04, 19.04.
# Requires sudo and docker environment (see vps.sh).

set -o errexit
set -o nounset

GITHUB_ID="${1?:'Usage: $0 <github username>'}"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

SS_DIR=/opt/ss
SS_PORT=10800
SS_PASS=$(tr -dc 'A-Za-z0-9_' < /dev/urandom | head -c 16)

function main
{
    setup_ss
    setup_crontab
}

function setup_ss
{
    local config=$SS_DIR/config.json

    if [[ -f $config ]] && ! sudo grep -wq __PASSWORD__ $config; then
        echo "Shadowsocks already configured in $SS_DIR, skipping"
        return 0
    fi

    echo "Installing shadowsocks server"

    sudo mkdir -p $SS_DIR
    curl -SsLk https://ymattw.github.io/joyus/pub/ss.json | \
        sudo tee $config

    sudo sed -i"" \
        -e "s/__PORT__/$SS_PORT/" \
        -e "s/__PASSWORD__/$SS_PASS/" \
        $config
    sudo chmod 600 $config

    echo docker run --rm -d \
        --name ss \
        -u $(id -ur $GITHUB_ID) \
        -v $SS_DIR:$SS_DIR \
        -p $SS_PORT:$SS_PORT \
        shadowsocks/shadowsocks-libev \
        /usr/bin/ss-server -c $config \
        | sudo tee $SS_DIR/start.sh

    sudo chown -R $GITHUB_ID $SS_DIR
    sudo chmod +x $SS_DIR/start.sh

    echo "Starting shadowsocks server with generated password '$SS_PASS'"
    sudo -H -u $GITHUB_ID $SS_DIR/start.sh
}

function setup_crontab
{
    ! sudo crontab -lu $GITHUB_ID | grep -wq "$SS_DIR/start.sh" || return 0
    echo "Installing crontab entry"

    {
        sudo crontab -lu $GITHUB_ID
        echo "*/2 * * * * docker ps --format='{{.Names}}' | grep -wq ss >/dev/null 2>&1 || $SS_DIR/start.sh"
    } | sudo -u $GITHUB_ID crontab

    sudo crontab -lu $GITHUB_ID
}

main "$@"
