#!/bin/bash
# Script to setup v2ray on Ubuntu VPS. Verified versions: 22.04.1 LTS.
# Requires sudo and docker environment (see vps.sh).
#
# Example usage: curl -L joyus.org/pub/v2.sh | bash -s ymattw

set -o errexit
set -o nounset

GITHUB_ID="${1?:'Usage: $0 <github username>'}"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

IMAGE="v2fly/v2fly-core:v4.45.2"
JSON="https://raw.githubusercontent.com/ymattw/joyus/gh-pages/pub/v2.json"
DIR="/opt/v2"
PORT="60066"
CONFIG="$DIR/config.json"
CONTAINER="v2"

function main
{
    setup_config
    setup_start
    start
}

function _get_uuid
{
    # Read current uuid
    local uuid=$(grep -Eo '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' $CONFIG 2>/dev/null)
    if [[ -z $uuid ]] || [[ $uuid == __UUID__ ]]; then
        uuid=$(cat /proc/sys/kernel/random/uuid)
    fi
    echo "$uuid"
}

function setup_config
{
    local uuid

    uuid=$(_get_uuid)
    echo "Writing $CONFIG with uuid '$uuid'"
    sudo mkdir -p $DIR
    curl -SsL $JSON | sudo tee $CONFIG
    sudo sed -i"" \
        -e "s/__PORT__/$PORT/" \
        -e "s/__UUID__/$uuid/" \
        $CONFIG
    sudo chmod 600 $CONFIG
}

function setup_start
{
    echo -e "#!/bin/sh\ndocker" \
        run --restart=unless-stopped -d \
        --name=$CONTAINER \
        -v $DIR:$DIR \
        -p $PORT:$PORT \
        $IMAGE \
        /usr/bin/v2ray -config=$CONFIG \
        | sudo tee $DIR/start.sh

    sudo touch $DIR/{access,error}.log
    sudo chown -R $GITHUB_ID $DIR
    sudo chmod +x $DIR/start.sh
}

function start
{
    if docker ps --format='{{.Names}}' | grep -wq $CONTAINER >&/dev/null; then
        echo "Docker container '$CONTAINER' is already up, removing..."
        docker stop $CONTAINER
        docker rm $CONTAINER
    fi

    echo "Starting container '$CONTAINER'"
    sudo -H -u $GITHUB_ID $DIR/start.sh
}

main "$@"
