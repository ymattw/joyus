#!/bin/bash
# Script to setup NaiveProxy on Ubuntu VPS. Verified versions: 22.04.1 LTS.
# Requires sudo and docker environment (see vps.sh).
#
# Example usage: curl -L joyus.org/pub/naive.sh | bash -s ymattw vps.my.domain

set -o errexit
set -o nounset

GITHUB_ID="${1?:'Usage: $0 <github username> <domain name>'}"
DOMAIN="${2?:'Usage: $0 <github username> <domain name>'}"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

NAIVE_DIR=/opt/naive
NAIVE_XZ="https://github.com/klzgrad/forwardproxy/releases/download/v2.6.4-caddy2-naive/caddy-forwardproxy-naive.tar.xz"
NAIVE_PASS=$(tr -dc 'A-Za-z0-9_' < /dev/urandom | head -c 16)
CADDYFILE="https://raw.githubusercontent.com/ymattw/joyus/gh-pages/pub/Caddyfile"

function main
{
    setup_naive
    setup_crontab
}

function setup_naive
{
    local config=$NAIVE_DIR/Caddyfile

    if [[ -f $config ]] && ! sudo grep -qE "__DOMAIN__" $config; then
        echo "NaiveProxy already configured in $NAIVE_DIR, skipping"
        return 0
    fi

    sudo mkdir -p $NAIVE_DIR/html
    echo 'Hello world!' | sudo tee $NAIVE_DIR/html/index.html

    curl -SsL "$NAIVE_XZ" | sudo tar -C $NAIVE_DIR --strip-components=1 -xJf -
    curl -SsL $CADDYFILE | sudo tee $config
    sudo sed -i"" \
        -e "s/__DOMAIN__/$DOMAIN/" \
        -e "s/__USER__/$GITHUB_ID/" \
        -e "s/__PASS__/$NAIVE_PASS/" \
        -e "s|__FILE_SERVER_PATH__|$NAIVE_DIR/html|" \
        $config
    sudo chmod 600 $config

    echo $NAIVE_DIR/caddy start | sudo tee $NAIVE_DIR/start.sh
    sudo chmod +x $NAIVE_DIR/start.sh

    sudo chown -R $GITHUB_ID $NAIVE_DIR
    sudo setcap cap_net_bind_service=+ep $NAIVE_DIR/caddy

    echo "Starting NaiveProxy with generated password '$NAIVE_PASS'"
    sudo -H -u $GITHUB_ID $NAIVE_DIR/start.sh
}

function setup_crontab
{
    ! sudo crontab -lu $GITHUB_ID | grep -wq "$NAIVE_DIR/start.sh" || return 0
    echo "Installing crontab entry"

    {
        sudo crontab -lu $GITHUB_ID
        echo "*/2 * * * * pgrep -f ^$NAIVE_DIR/caddy >/dev/null 2>&1 || $NAIVE_DIR/start.sh"
    } | sudo -u $GITHUB_ID crontab

    sudo crontab -lu $GITHUB_ID
}

main "$@"
