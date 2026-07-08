#!/bin/bash

echo "Generating Postfix regex maps for ${SENDER_ADDRESS}..."

# Create the files dynamically based on the environment variable
echo "/.+/    ${SENDER_ADDRESS}" > /etc/postfix/sender_canonical
echo "/From:.*/ REPLACE From: ${SENDER_ADDRESS}" > /etc/postfix/header_checks

# Fix missing aliases database error
echo "Generating aliases database..."
postalias lmdb:/etc/aliases

# Generate a self-signed certificate to support incoming TLS (like PMG does)
echo "Generating self-signed certificate for local TLS..."
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
  -subj "/CN=mailrelay.int.sdr.wtf" \
  -keyout /etc/ssl/private/postfix-inbound.key \
  -out /etc/ssl/certs/postfix-inbound.crt > /dev/null 2>&1

# Apply Postfix overrides for TLS
postconf -e "smtpd_tls_cert_file = /etc/ssl/certs/postfix-inbound.crt"
postconf -e "smtpd_tls_key_file = /etc/ssl/private/postfix-inbound.key"
postconf -e "smtpd_tls_security_level = may"

echo "Postfix initialization complete."
