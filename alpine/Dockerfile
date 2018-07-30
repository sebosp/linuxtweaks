FROM alpine:3.8
MAINTAINER Seb Ospina <kraige@gmail.com>
RUN apk add --update alpine-sdk sudo \
  && adduser -D -g builder builder \
  && echo "builder      ALL=(ALL) ALL" >> /etc/sudoers
