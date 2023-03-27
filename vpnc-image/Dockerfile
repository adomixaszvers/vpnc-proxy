from alpine:3.17

CMD ["/etc/service/vpnc/run"]

RUN apk add --no-cache vpnc dante-server

RUN mkdir -p /etc/service/vpnc
COPY bin/vpnc.sh /etc/service/vpnc/run
RUN chmod 500 /etc/service/vpnc/run
