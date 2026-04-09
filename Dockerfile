# Original credit: https://github.com/jpetazzo/dockvpn

FROM debian:testing-slim
LABEL maintainer="Tuan T. Pham <tuan at vt dot edu>"

ENV DEBIAN_FRONTEND=noninteractive TZ=UTC

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openvpn \
        openssl \
        iptables \
        bash \
        easy-rsa \
        libpam-google-authenticator \
        pamtester && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
