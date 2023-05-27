#!/bin/bash
# Script to setup SS on Ubuntu VPS. Verified versions:16.04, 18.04, 19.04.
# Requires sudo and docker environment (see vps.sh).
#
# Example usage: curl -L joyus.org/pub/ss.sh | bash -s ymattw

set -o errexit
set -o nounset

GITHUB_ID="${1?:'Usage: $0 <github username>'}"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

SS_JSON="https://raw.githubusercontent.com/ymattw/joyus/gh-pages/pub/ss.json"
SS_DIR=/opt/ss
SS_PORT=60055
SS_PASS=$(tr -dc 'A-Za-z0-9_' < /dev/urandom | head -c 16)

function main
{
    setup_ss
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
    curl -SsL $SS_JSON | sudo tee $config

    sudo sed -i"" \
        -e "s/__PORT__/$SS_PORT/" \
        -e "s/__PASSWORD__/$SS_PASS/" \
        $config
    sudo chmod 600 $config

    echo -e "#!/bin/sh\n" \
        docker run --restart=unless-stopped -d \
        --name=ss \
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

main "$@"
