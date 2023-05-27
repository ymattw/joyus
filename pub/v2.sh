#!/bin/bash
# Script to setup v2ray on Ubuntu VPS. Verified versions: 22.04.1 LTS.
# Requires sudo and docker environment (see vps.sh).
#
# Example usage: curl -L joyus.org/pub/v2.sh | bash -s ymattw

set -o errexit
set -o nounset

GITHUB_ID="${1?:'Usage: $0 <github username>'}"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

V2_IMAGE="v2fly/v2fly-core:v4.45.2"
V2_JSON="https://raw.githubusercontent.com/ymattw/joyus/gh-pages/pub/v2.json"
V2_DIR=/opt/v2
V2_PORT=60066
V2_CONFIG=$V2_DIR/config.json

function main
{
    setup_v2_config
    setup_v2_start
    start_v2
}

function setup_v2_config
{
    if [[ -f $V2_CONFIG ]] && ! sudo grep -wq __UUID__ $V2_CONFIG; then
        echo "V2ray already configured in $V2_DIR, skipping writing $V2_CONFIG"
        return 0
    fi

    local uuid=$(cat /proc/sys/kernel/random/uuid)
    echo "Writing $V2_CONFIG with uuid '$uuid'"

    sudo mkdir -p $V2_DIR
    curl -SsL $V2_JSON | sudo tee $V2_CONFIG
    sudo sed -i"" \
        -e "s/__PORT__/$V2_PORT/" \
        -e "s/__UUID__/$uuid/" \
        $V2_CONFIG
    sudo chmod 600 $V2_CONFIG
}

function setup_v2_start
{
    echo -e "#!/bin/sh\ndocker" \
        run --restart=unless-stopped -d \
        --name=v2 \
        -v $V2_DIR:$V2_DIR \
        -p $V2_PORT:$V2_PORT \
        $V2_IMAGE \
        /usr/bin/v2ray -config=$V2_CONFIG \
        | sudo tee $V2_DIR/start.sh

    sudo touch $V2_DIR/{access,error}.log
    sudo chown -R $GITHUB_ID $V2_DIR
    sudo chmod +x $V2_DIR/start.sh
}

function start_v2
{
    if docker ps --format='{{.Names}}' | grep -wq v2 >&/dev/null; then
        echo "Docker container 'v2' is already up, removing..."
        docker stop v2
        docker rm v2
    fi

    echo "Starting v2ray server"
    sudo -H -u $GITHUB_ID $V2_DIR/start.sh
}

main "$@"
