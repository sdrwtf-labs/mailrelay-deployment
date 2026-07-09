# Mail Relay Deployment

Deploys a lightweight Postfix mail relay based on `mwader/postfix-relay`. It accepts unauthenticated local emails on port 25, rewrites all sender addresses to a defined address, and securely relays the emails to an upstream SMTP provider.

## Features
- Accepts unqualified senders and all recipients from internal networks.
- Accepts SMTP requests without TLS and authentication.
- Optionally accepts inbound TLS requests (generates a self-signed certificate on startup).
- Relays outbound emails via authenticated SMTP over TLS.
- Rewrites envelope senders and `From:` headers dynamically based on `.env` configuration.

## Prerequisites
- A working Docker host.
- Port 25 must be available. On Debian hosts, disable the default MTA:
  ```bash
  sudo systemctl stop exim4
  sudo systemctl disable exim4
  ```

## Deployment
1. Prepare the deployment directory:
   ```bash
   sudo mkdir -p /opt/mailrelay
   sudo chown $USER:$USER /opt/mailrelay
   cd /opt/mailrelay

   git clone git@github.com:sdrwtf-labs/mailrelay-deployment.git .
   ```
2. Make the wrapper script executable:
   ```bash
   chmod +x wrapper.sh
   ```
3. Configure the environment variables:
   ```bash
   cp .env.example .env
   nano .env
   ```
4. Start the service:
   ```bash
   docker compose up -d
   ```

## Continuous Deployment
This repository is configured for automated deployments via GitHub Actions. Pushes to the `main` branch will trigger an SSH action to pull the latest code and recreate the container.
Ensure the `SSH_PRIVATE_KEY` secret is configured in the repository settings.
