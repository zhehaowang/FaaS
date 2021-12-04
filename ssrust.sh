#!/usr/bin/env bash

# Deploy latest ss-server with silent_drop_replay customization to avoid easy detection.
# Ubuntu 20.04

port=443
if [ $# -eq 0 ]; then
    echo "No port specified, using default 443"
else
    port=$1
fi

sudo apt update
sudo apt install docker.io
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
# sudo docker container ls
containerid=$(sudo docker ps -f name=$dockername --format {{.ID}})

sudo docker logs $containerid

echo "
Done!
password:           $pwd,
port:               $port,
docker instance id: $containerid,
encryption:         $enc"

# on mac to test a port
# nc -vnz [ip] $port

# verify listening on specified port
# sudo lsof -i:$port

# stop and cleanup docker container
# sudo docker stop $containerid
# sudo docker rm $containerid
