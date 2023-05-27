#!/bin/bash
# Script to setup account on Ubuntu VPS. Verified versions: 22.04.
#
# Example usage: curl -L joyus.org/pub/vps.sh | bash -s ymattw

set -o errexit
set -o nounset

GITHUB_ID="${1?:'Usage: $0 <github username>'}"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

function main
{
    install_pkgs
    create_user
    modify_user
    setup_ssh
    setup_sshd
    setup_sudo
    setup_firewall
}

function install_pkgs
{
    sudo apt update -y
    [[ -x /bin/zsh ]] || sudo apt install -y zsh
    [[ -x /usr/bin/netstat ]] || sudo apt install -y net-tools
    [[ -x /usr/bin/docker ]] || sudo apt install -y docker.io
}

function create_user
{
    ! id $GITHUB_ID >& /dev/null || return 0

    echo "Creating user $GITHUB_ID"
    sudo useradd --home-dir /home/$GITHUB_ID --create-home \
        --shell /bin/bash $GITHUB_ID
    id $GITHUB_ID
}

function modify_user
{
    local home=$(eval echo ~${GITHUB_ID})
    local rc="https://raw.githubusercontent.com/ymattw/profiles/master/zsh/zshrc"

    sudo chsh -s /bin/zsh $GITHUB_ID
    sudo usermod -a -G docker $GITHUB_ID
    [[ -f $home/.zshrc ]] || {
        curl -SsL $rc | sudo tee $home/.zshrc > /dev/null
        sudo chown $GITHUB_ID $home/.zshrc
    }
}

function setup_ssh
{
    local home=$(eval echo ~${GITHUB_ID})
    local key_file=$home/.ssh/authorized_keys
    local key_line
    local tmpf

    sudo mkdir -p $home/.ssh
    sudo touch $key_file
    sudo chown $GITHUB_ID $home $home/.ssh $key_file
    sudo chmod go-w $home
    sudo chmod -R 700 $home/.ssh

    # Fix missing EOL
    [[ -z $(sudo tail -c 1 $key_file) ]] || echo | sudo tee -a $key_file

    tmpf=$(mktemp)
    trap "rm -f $tmpf" RETURN
    curl -SsL https://github.com/${GITHUB_ID}.keys > $tmpf

    while read -r key_line; do
        setup_public_key $key_file "$key_line"
    done < $tmpf

    sudo chmod 600 $home/.ssh/authorized_keys
}

function setup_public_key
{
    local key_file=${1:?}
    local pkey=${2:?}

    ! sudo grep -qF "$pkey" $key_file || return 0
    echo "Adding ssh public key: $pkey"
    echo "$pkey" | sudo tee -a $key_file
}

function setup_sshd
{
    ! grep -q '^Port 60022$' /etc/ssh/sshd_config || return 0

    echo "Updating ssh listening port from 22 to 60022 / disable root login"
    sudo sed -i'' -r \
        -e 's/^#?\s*Port 22$/Port 60022/' \
        -e 's/^#?\s*PermitRootLogin yes/PermitRootLogin no/' \
        /etc/ssh/sshd_config
    sudo service ssh restart
}

function setup_sudo
{
    ! sudo -l -U $GITHUB_ID | grep -Eq "NOPASSWD:[[:blank:]]*ALL" || return 0

    echo "Add sudoer entry file for $GITHUB_ID"
    echo "$GITHUB_ID ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$GITHUB_ID
    sudo chmod 440 /etc/sudoers.d/$GITHUB_ID
    sudo -l -U $GITHUB_ID
}

function setup_firewall
{
    sudo ufw default allow routed
    sudo ufw allow proto tcp from any to any port 22,80,443,60000:65535
    sudo ufw allow proto udp from any to any port 60000:65535
    sudo ufw --force enable
    sudo ufw reload
}

main "$@"
