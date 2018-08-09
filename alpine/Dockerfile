FROM alpine:3.8
MAINTAINER Seb Ospina <kraige@gmail.com>
RUN apk add --update alpine-sdk sudo \
  && adduser -D -G abuild -u 1000 builder \
  && echo "builder      ALL=(ALL) ALL" >> /etc/sudoers \
  && chown -R builder /var/cache/distfiles/
USER builder
