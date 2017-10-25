strongSwan
==========

This docker container runs [strongSwan](https://strongswan.org/) on [alpine Linux](https://alpinelinux.org/).

### Configuration
This cookbook uses two volumes `/etc/ipsec.docker` and `/etc/strongswan.docker`.

* `/etc/ipsec.conf` includes `/etc/ipsec.docker/ipsec.*.conf`
* `/etc/ipsec.secrets` includes `/etc/ipsec.docker/ipsec.*.secrets`
* `/etc/strongswan.conf` includes `/etc/strongswan.docker/*.conf`

So put your configuration files accordingly and mount the needed volumes.

##### ipsec.conf: leftfirewall
If you intend to use `leftfirewall=yes` in your configuration, you should use `leftupdown=sudo -E ipsec _updown iptables` instead. Reason being that *strongSwan* runs *charon* daemon as a non-privileged user. sudo have been setup to allow ipsec group to run the ipsec command.

### Usage

##### build
```bash
docker build -t yourself/strongswan
```

##### run
```bash
  docker run -d --cap-add=NET_ADMIN \
  -v '/lib/modules:/lib/modules:ro' \
  -v '/etc/localtime:/etc/localtime:ro' \
  -v '/etc/letsencrypt:/etc/letsencrypt:ro' \
  -v '/etc/ipsec.docker:/etc/ipsec.docker:ro' \
  -v '/etc/strongswan.docker:/etc/strongswan.docker:ro' \
  -p 500:500/udp -p 4500:4500/udp \
  --name strongswan-alpine fzn/strongswan
```

