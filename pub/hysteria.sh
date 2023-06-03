#!/bin/bash
# Script to setup hysteria on Ubuntu VPS. Verified versions: 22.04.1 LTS.
# Requires sudo and docker environment (see vps.sh).
#
# Example usage: curl -L joyus.org/pub/hysteria.sh | bash -s ymattw vps.my.domain

set -o errexit
set -o nounset

GITHUB_ID="${1?:'Usage: $0 <github username> <domain name>'}"
DOMAIN="${2?:'Usage: $0 <github username> <domain name>'}"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

IMAGE="tobyxdd/hysteria:v1.3.4"
DIR="/opt/hysteria"
PORT="60077"
CONFIG="$DIR/config.json"
CONTAINER="hysteria"

function main
{
    setup_config
    setup_start
    start
}

function _find_cert_dir
{
    local home=$(eval echo ~${GITHUB_ID})

    local crt=$(sudo find $home/.local/share/caddy -type f -name ${DOMAIN}.crt)
    [[ -n $crt ]] || {
        echo "ERROR: unable to find ${DOMAIN}.crt, is caddy settled?" >&2
        return 1
    }

    local crt_dir=$(dirname $crt)
    local key=$crt_dir/${DOMAIN}.key
    [[ -f $key ]] || {
        echo "ERROR: $key not found, is caddy settled?" >&2
        return 1
    }

    echo $crt_dir
}

function _get_obfs
{
    local obfs

    # Read current obfs
    obfs=$(grep -w obfs $CONFIG 2>/dev/null | cut -d '"' -f4)
    if [[ -z $obfs ]] || [[ $obfs == __OBFS__ ]]; then
        obfs=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 24)
    fi
    echo "$obfs"
}

function setup_config
{
    local obfs crt_dir

    obfs=$(_get_obfs)
    crt_dir=$(_find_cert_dir)

    sudo mkdir -p $DIR

    echo "Writing $CONFIG with obfs '$obfs'"
    cat << EOT | sed -r 's/^ {4}//g' | sudo tee $CONFIG
    {
        "listen": ":$PORT",
        "cert": "$crt_dir/$DOMAIN.crt",
        "key": "$crt_dir/$DOMAIN.key",
        "obfs": "$obfs"
    }
EOT

    sudo chmod 600 $CONFIG
}

function setup_start
{
    local crt_dir

    crt_dir=$(_find_cert_dir)

    echo -e "#!/bin/sh\ndocker" \
        run --restart=unless-stopped -d \
        --name=$CONTAINER \
        -v $DIR:$DIR \
        -v $crt_dir:$crt_dir:ro \
        -p $PORT:$PORT/udp \
        $IMAGE \
        -c $CONFIG server \
        | sudo tee $DIR/start.sh

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
