#!/bin/bash

echo "Generating Postfix regex maps for ${SENDER_ADDRESS}..."

# Create the files dynamically based on the environment variable
echo "/.+/    ${SENDER_ADDRESS}" > /etc/postfix/sender_canonical
echo "/From:.*/ REPLACE From: ${SENDER_ADDRESS}" > /etc/postfix/header_checks

# Fix missing aliases database error
echo "Generating aliases database..."
postalias lmdb:/etc/aliases

echo "Postfix maps generated successfully."
