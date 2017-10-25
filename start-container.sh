#!/bin/bash

sudo docker run -d --cap-add=NET_ADMIN \
  -v '/lib/modules:/lib/modules:ro' \
  -v '/etc/localtime:/etc/localtime:ro' \
  -v '/etc/letsencrypt:/etc/letsencrypt:ro' \
  -v '/usr/local/etc/ipsec.docker:/etc/ipsec.docker:ro' \
  -v '/usr/local/etc/strongswan.docker:/etc/strongswan.docker:ro' \
  -p 500:500/udp -p 4500:4500/udp \
  --name strongswan-alpine fzn/strongswan
