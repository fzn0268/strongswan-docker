#!/bin/sh -e
#
# entrypoint for strongswan
#
# env |grep vpn_ | while read line; do echo $line| cut -d= -f2- >> /etc/ipsec.d/secrets.local.conf ; done

# add iptables rules if IPTABLES=true
  iptables -t nat -A POSTROUTING -s 10.11.0.0/16 -o eth0 -j MASQUERADE
  iptables -A FORWARD -s 10.11.0.0/16 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360

_revipt() {
    echo "Removing iptables rules..."
    iptables -t nat -D POSTROUTING -s 10.11.0.0/16 -o eth0 -j MASQUERADE
    iptables -D FORWARD -s 10.11.0.0/16 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360
}

# function to use when this script recieves a SIGTERM.
_term() {
  echo "Caught SIGTERM signal! Stopping ipsec..."
  #kill -TERM "$child" 2>/dev/null
  ipsec stop
  # remove iptable rules
  _revipt
}

# catch the SIGTERM
trap _term SIGTERM

echo "Copying certs and privkeys..."
cp /etc/ipsec.docker/ipsec.d/certs/fullchain.pem /etc/ipsec.d/certs/
cp /etc/ipsec.docker/ipsec.d/private/privkey.pem /etc/ipsec.d/private/

echo "Starting strongSwan/ipsec..."
ipsec start --nofork "$@" &

child=$!
# wait for child process to exit
wait "$child"

# remove iptable rules
_revipt
