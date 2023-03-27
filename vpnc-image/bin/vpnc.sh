#!/bin/sh

ip route add "${LOCAL_NETWORK}" dev eth0

cat > /etc/vpnc/default.conf <<EOF
IPSec gateway ${VPNC_GATEWAY}
IPSec ID ${VPNC_ID}
IPSec secret ${VPNC_SECRET}
Xauth username ${VPNC_USERNAME}
Xauth password ${VPNC_PASSWORD}
DPD idle timeout (our side) 300
EOF

cat > /etc/sockd.conf <<EOF
debug: 1
internal: 0.0.0.0 port = 1080
external: tun0

user.privileged: root
user.unprivileged: nobody

clientmethod: none
socksmethod: none

client pass {
  from: ${LOCAL_NETWORK} to: 0.0.0.0/0
  log: error # connect disconnect
}

#generic pass statement - bind/outgoing traffic
socks pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        command: bind connect udpassociate
        log: error # connect disconnect iooperation
}

#generic pass statement for incoming connections/packets
socks pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        command: bindreply udpreply
        log: error # connect disconnect iooperation
}
EOF

vpnc default --non-inter
exec sockd
