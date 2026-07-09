#!/bin/sh
# wrapper.sh: Pre-initialization script for mwader/postfix-relay

echo "Installing openssl for certificate generation..."
apk add --no-cache openssl > /dev/null

echo "Configuring SASL authentication for upstream relay..."
echo "[${SMTP_SERVER}]:${SMTP_PORT} ${SMTP_USER}:${SMTP_PASS}" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

echo "Generating Postfix regex maps for ${SENDER_ADDRESS}..."
echo "/.+/    ${SENDER_ADDRESS}" > /etc/postfix/sender_canonical
echo "/From:.*/ REPLACE From: ${SENDER_ADDRESS}" > /etc/postfix/header_checks

echo "Generating self-signed certificate for local inbound TLS..."
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
  -subj "/CN=mailrelay.local" \
  -keyout /etc/ssl/private/postfix-inbound.key \
  -out /etc/ssl/certs/postfix-inbound.crt > /dev/null 2>&1

echo "Executing original postfix-relay entrypoint..."
exec /root/run.sh
