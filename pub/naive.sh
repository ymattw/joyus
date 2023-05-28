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

DIR="/opt/naive"
IMAGE="https://github.com/klzgrad/forwardproxy/releases/download/v2.6.4-caddy2-naive/caddy-forwardproxy-naive.tar.xz"
CADDYFILE="https://raw.githubusercontent.com/ymattw/joyus/gh-pages/pub/Caddyfile"
CONFIG="$DIR/Caddyfile"

function main
{
    setup_config
    setup_start
    start
    setup_crontab
}

function _get_pass
{
    # Read current pass
    local pass=$(grep -w basic_auth $CONFIG 2>/dev/null | awk '{print $3}')

    if [[ -z $pass ]] || [[ $pass == __PASS__ ]]; then
        pass=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 24)
    fi
    echo "$pass"
}

function setup_config
{
    local pass

    pass=$(_get_pass)

    echo "Writing $CONFIG with password '$pass'"
    sudo mkdir -p $DIR/html
    echo 'Hello world!' | sudo tee $DIR/html/index.html

    curl -SsL "$IMAGE" | sudo tar -C $DIR --strip-components=1 -xJf -
    curl -SsL $CADDYFILE | sudo tee $CONFIG
    sudo sed -i"" \
        -e "s/__DOMAIN__/$DOMAIN/" \
        -e "s/__USER__/$GITHUB_ID/" \
        -e "s/__PASS__/$pass/" \
        -e "s|__FILE_SERVER_PATH__|$DIR/html|" \
        $CONFIG
    sudo chmod 600 $CONFIG
}

function setup_start
{
    # NOTE! caddy always loads Caddyfile from current dir.
    echo -e "#/bin/sh\ncd $DIR && ./caddy start" | sudo tee $DIR/start.sh
    sudo chmod +x $DIR/start.sh

    sudo chown -R $GITHUB_ID $DIR
    sudo setcap cap_net_bind_service=+ep $DIR/caddy
}

function start
{
    echo "Starting NaiveProxy"
    sudo pkill caddy || true
    sudo -H -u $GITHUB_ID $DIR/start.sh
}

function setup_crontab
{
    echo "Installing crontab entry"

    {
        sudo crontab -lu $GITHUB_ID | grep -vw "$DIR/start.sh" || true
        echo "*/2 * * * * pgrep -f ^$DIR/caddy >/dev/null 2>&1 || $DIR/start.sh 2>&1 | logger -it caddy"
    } | sudo -u $GITHUB_ID crontab

    sudo crontab -lu $GITHUB_ID
}

main "$@"
