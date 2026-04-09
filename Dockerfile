# Original credit: https://github.com/jpetazzo/dockvpn

FROM alpine:3.23
LABEL maintainer="Kyle Manna <kyle@kylemanna.com>"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache openvpn openssl iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa
ENV EASYRSA_PKI=$OPENVPN/pki
ENV EASYRSA_CRL_DAYS=1460
ENV EASYRSA_CERT_EXPIRE=1460

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

COPY ./otp/openvpn /etc/pam.d/
