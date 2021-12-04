#!/usr/bin/env bash

# Deploy latest ss-server with silent_drop_replay customization to avoid easy detection.
# tcp_only, chacha20-ietf-poly1305, random pwd
# Ubuntu 20.04

green='\033[0;32m'
red='\033[0;31m'
yellow='\033[1;33m'
nc='\033[0m' # No Color'

port=443
if [ $# -eq 0 ]; then
    echo -e "${yellow}No port specified, using default 443${nc}"
else
    port=$1
fi

sudo apt update
sudo apt install docker.io --yes
sudo apt-get install rng-tools
sudo docker pull ghcr.io/shadowsocks/ssserver-rust:latest

pwd=$(openssl rand -base64 16)
enc="chacha20-ietf-poly1305"
dockername="ssserver-rust"

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
    \"method\":\"$enc\"
}" > ~/ss.conf

sudo docker run --name $dockername --restart always -p $port:$port/tcp -v ~/ss.conf:/etc/shadowsocks-rust/config.json -dit ghcr.io/shadowsocks/ssserver-rust:latest
ret=$?

# sudo docker container ls

if [ $ret -eq 0 ]; then
    containerid=$(sudo docker ps -f name=$dockername --format {{.ID}})
    echo -e "${yellow}Docker instance ${containerid} started.${nc}"

    echo -e "${yellow}Docker log:${nc}"
    sudo docker logs $containerid

    echo -e "
    ${green}Done${nc}!
    password:           ${yellow}${pwd}${nc},
    port:               ${yellow}${port}${nc},
    docker instance id: ${yellow}${containerid}${nc},
    encryption:         ${yellow}${enc}${nc}"
else
    echo -e "${red}Docker instance failed to start, ret ${ret} ${nc}"
fi

# on mac to test a port
# nc -vnz [ip] $port

# verify listening on specified port
# sudo lsof -i:$port

# stop and cleanup docker container
# sudo docker stop $containerid
# sudo docker rm $containerid
