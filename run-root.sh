#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit
fi

download() {
    echo Downloading "$1"
    apt install "$i"
}

install_if_not_installed() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        download "$1"
    fi
}

brave_source() {
    echo "Adding brave source..."
    apt install apt-transport-https curl
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list
}

add_repos() {
    apt-add-repository contrib
    apt-add-repository non-free
}

add_sources() {
    add_repos
    brave_source
    apt update
}

install_nvidia_drivers() {
    apt install linux-headers-amd64 nvidia-driver
}

add_sources

programs="neovim brave-browser"

for i in $programs; do
    install_if_not_installed "$i"
done

install_nvidia_drivers
