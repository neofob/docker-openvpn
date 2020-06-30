# Original credit: https://github.com/jpetazzo/dockvpn

# Smallest base image
FROM alpine:3.12.0

LABEL maintainer="Kyle Manna <kyle@kylemanna.com>"
ENV EASYRSA_TAG=v3.0.7

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --update openvpn openssl iptables bash git openvpn-auth-pam google-authenticator pamtester

# Get easy-rsa
RUN git clone -b ${EASYRSA_TAG} https://github.com/OpenVPN/easy-rsa.git /tmp/easy-rsa && \
    cd && \
# Cleanup
    apk del git && \
    rm -rf /tmp/easy-rsa/.git && cp -a /tmp/easy-rsa /usr/local/share/ && \
    rm -rf /tmp/easy-rsa/ && \
    ln -s /usr/local/share/easy-rsa/easyrsa3/easyrsa /usr/local/bin && \
    chmod 774 /usr/local/bin/* && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/local/share/easy-rsa/easyrsa3 \
    EASYRSA_PKI=${OPENVPN}/pki

# Prevents refused client connection because of an expired CRL
ENV EASYRSA_CRL_DAYS 1460

# Need to set this with new easyrsa if you want it a bit longer
# than 825 days
# https://github.com/OpenVPN/easy-rsa/issues/333
ENV EASYRSA_CERT_EXPIRE 1460

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/
