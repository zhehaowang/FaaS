#!/usr/bin/env bash

# Deploy latest ss-server with silent_drop_replay customization to avoid easy detection.
# tcp_only, chacha20-ietf-poly1305, random pwd
# Ubuntu 20.04
# wget -O - https://raw.githubusercontent.com/zhehaowang/FaaS/master/ssrust.sh | bash -s "-p 443 -s aws"

green='\033[0;32m'
red='\033[0;31m'
yellow='\033[1;33m'
nc='\033[0m' # No Color'

port=443
source="aws"
while getopts ":s:p:" opt; do
  case $opt in
    s) source="$OPTARG"
    ;;
    p) port="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

sudo apt update
sudo apt install docker.io --yes
sudo apt-get install rng-tools
sudo docker pull ghcr.io/shadowsocks/ssserver-rust:latest

pwd=$(openssl rand -base64 16)
enc="chacha20-ietf-poly1305"
dockername="ssserver-rust-$port"

serveraddr="0.0.0.0"
if [ $source = "aws" ]; then
    # this way of getting server public IP address is unique to aws
    serveraddr=$(curl http://checkip.amazonaws.com)
    echo -e "${yellow}On AWS, using ${serveraddr} to generate ss url ${nc}"
else
    echo -e "${yellow}Not on AWS, using ${serveraddr} to generate ss url ${nc}"
fi


# as of 20211204, silently dropping replay packets seemed to have made shadowsocks easily detectable:
# https://github.com/shadowsocks/shadowsocks-rust/pull/556
# https://github.com/net4people/bbs/issues/69
# https://github.com/net4people/bbs/issues/22
# for this reason we set silent_drop_replay false by default
# \"silent_drop_replay\": false,
mkdir -p ~/ss/
echo "
{
    \"server\":\"0.0.0.0\",
    \"mode\":\"tcp_only\",
    \"server_port\":$port,
    \"local_port\":1080,
    \"password\":\"$pwd\",
    \"timeout\":120,
    \"method\":\"$enc\",
    \"plugin\":\"\"
}" > ~/ss/$dockername.conf

sudo docker run --name $dockername --restart always -p $port:$port/tcp -v ~/ss/$dockername.conf:/etc/shadowsocks-rust/config.json -dit ghcr.io/shadowsocks/ssserver-rust:latest
ret=$?

# sudo docker container ls

if [ $ret -eq 0 ]; then
    containerid=$(sudo docker ps -f name=$dockername --format {{.ID}})
    echo -e "${yellow}Docker instance ${containerid} started.${nc}"

    echo -e "${yellow}Docker log:${nc}"
    sudo docker logs $containerid

    if [ ! -f ~/geturl.py ]; then
        wget -O - https://raw.githubusercontent.com/Drickle/ss-uri-generator/master/ssuri-gen.py > ~/geturl.py
    fi

    ssurl=$(python3 ~/geturl.py <(sed "s/\"server\":\"0.0.0.0\"/\"server\":\"$serveraddr\"/g" ~/ss/$dockername.conf) | tail -1)
    
    echo -e "
    ${green}Done${nc}!
    password:           ${yellow}${pwd}${nc},
    port:               ${yellow}${port}${nc},
    docker instance id: ${yellow}${containerid}${nc},
    encryption:         ${yellow}${enc}${nc},
    ss-url:             ${yellow}${ssurl}${nc}"

    echo ${ssurl} > ~/ss/$dockername.url
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
