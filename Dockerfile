# shadowsocks
#
# VERSION 0.0.3

FROM ubuntu:20.04
MAINTAINER Zhehao Wang <wangzhehao410305@gmail.com>

RUN apt update && \
    apt install shadowsocks-libev

ENV SS_SERVER_ADDR 0.0.0.0
ENV SS_SERVER_PORT 9001
ENV SS_PASSWORD password
ENV SS_METHOD xchacha20-ietf-poly1305

# Configure container to run as an executable
ENTRYPOINT ["ss-server -p $SS_SERVER_PORT -k $SS_PASSWORD -m $SS_METHOD"]


docker run --name ssserver-rust \
  --restart always \
  -p 9002:9002/tcp \
  -p 9002:9002/udp \
  -v /etc/shadowsocks-libev/config1.json:/etc/shadowsocks-rust/config.json \
  -dit ghcr.io/shadowsocks/ssserver-rust:latest