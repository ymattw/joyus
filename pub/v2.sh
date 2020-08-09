#!/bin/bash
# Script to setup v2ray on Ubuntu VPS. Verified versions:16.04, 18.04, 19.04.
# Requires sudo and docker environment (see vps.sh).

set -o errexit
set -o nounset

GITHUB_ID="${1?:'Usage: $0 <github username>'}"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

V2_DIR=/opt/v2
V2_PORT=8964
V2_UUID=$(cat /proc/sys/kernel/random/uuid)

function main
{
    setup_v2
    setup_crontab
}

function setup_v2
{
    local config=$V2_DIR/config.json

    if [[ -f $config ]] && ! sudo grep -wq __UUID__ $config; then
        echo "V2ray already configured in $V2_DIR, skipping"
        return 0
    fi

    echo "Installing v2ray server"

    sudo mkdir -p $V2_DIR
    curl -SsLk https://ymattw.github.io/joyus/pub/v2.json | \
        sudo tee $config

    sudo sed -i "" \
        -e "s/__PORT__/$V2_PORT/" \
        -e "s/__UUID__/$V2_UUID/" \
        $config
    sudo chmod 600 $config

    echo docker run --rm -d \
        --name v2 \
        -u $(id -ur $GITHUB_ID) \
        -v $V2_DIR:$V2_DIR \
        -p $V2_PORT:$V2_PORT \
        v2ray/official \
        /usr/bin/v2ray/v2ray -config=$config \
        | sudo tee $V2_DIR/start.sh

    sudo chown -R $GITHUB_ID $V2_DIR
    sudo chmod +x $V2_DIR/start.sh

    echo "Starting v2ray server with uuid '$V2_UUID'"
    sudo -H -u $GITHUB_ID $V2_DIR/start.sh
}

function setup_crontab
{
    ! sudo crontab -lu $GITHUB_ID | grep -wq "$SS_DIR/start.sh" || return 0
    echo "Installing crontab entry"

    {
        sudo crontab -lu $GITHUB_ID
        echo "*/2 * * * * docker ps --format='{{.Names}}' | grep -wq v2 >/dev/null 2>&1 || $V2_DIR/start.sh"
    } | sudo -u $GITHUB_ID crontab

    sudo crontab -lu $GITHUB_ID
}

main "$@"
