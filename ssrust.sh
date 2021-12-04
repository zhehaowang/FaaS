#!/usr/bin/env bash

# Ubuntu 20.04

port=443
if [ $# -eq 0 ]; then
    echo "No port specified, using default 443"
else
    port=$1
fi

sudo apt update
sudo apt install docker.io
sudo docker pull ghcr.io/shadowsocks/ssserver-rust:latest

pwd=$(openssl rand -base64 16)
echo "
password: $pwd,
port:     $port"

# as of 20211204, silently dropping replay packets seemed to have made shadowsocks easily detectable:
# https://github.com/shadowsocks/shadowsocks-rust/pull/556
# https://github.com/net4people/bbs/issues/69
# https://github.com/net4people/bbs/issues/22
# for this reason we set silent_drop_replay false by default
echo "
{
    \"server\":\"0.0.0.0\",
    \"mode\":\"tcp_only\",
    \"server_port\":$port,
    \"local_port\":1080,
    \"password\":\"$pwd\",
    \"silent_drop_replay\": false,
    \"timeout\":120,
    \"method\":\"chacha20-ietf-poly1305\"
}" > ~/ss.conf

sudo docker run --name ssserver-rust --restart always -p 443:443/tcp -v ~/ss.conf:/etc/shadowsocks-rust/config.json -dit ghcr.io/shadowsocks/ssserver-rust:latest
sudo docker container ls

# on mac to test a port
# nc -vnz [ip] $port
