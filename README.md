# Mail Relay Deployment

This repository deploys a lightweight Postfix mail relay in a Docker container. It is designed to accept unauthenticated local emails (e.g., from printers, scanners, or IoT devices) on port 25, dynamically rewrite the sender addresses, and securely relay the emails to an upstream SMTP provider (e.g., ProtonMail).

## Features
- Listens on standard SMTP port 25 for maximum compatibility with legacy devices.
- Uses an initialization script (`init.sh`) to dynamically generate Postfix mapping rules, rewriting all `From` headers and envelope senders to the configured `SENDER_ADDRESS`.
- Secures outbound traffic to the upstream provider via TLS.

## Prerequisites
- A working Docker host.
- Port 25 must be completely free on the host. If you are running Debian, you usually need to disable the pre-installed `exim4` service first:
  ```bash
  sudo systemctl stop exim4
  sudo systemctl disable exim4
  ```

## Initial Deployment

1. Prepare the deployment directory on the host:
   ```bash
   sudo mkdir -p /opt/mailrelay
   sudo chown $USER:$USER /opt/mailrelay
   cd /opt/mailrelay

   git clone git@github.com:sdrwtf-labs/mailrelay-deployment.git .
   ```

2. Configure the environment variables:
   ```bash
   cp .env.example .env
   ```

   Edit the `.env` file and insert your upstream SMTP credentials, host IP, and the desired sender address.

3. Make the initialization script executable (if not already done via git permissions):
   ```bash
   chmod +x init.sh
   ```

4. Start the service:
   ```bash
   docker compose up -d
   ```

## Usage

Configure your local network devices (e.g., scanners, 3D printers) with the following SMTP settings:

* **SMTP Server:** `IP-of-your-docker-host`
* **Port:** `25`
* **Authentication:** None / Disabled
* **Encryption:** None (The relay handles TLS for the outbound connection)

## Continuous Deployment

This repository includes a GitHub Actions workflow (`.github/workflows/deploy.yml`) for automated deployment. Pushing changes to the `main` branch triggers a remote SSH execution that pulls the latest code and restarts the container on the target host.

**To use this workflow:**
Configure a repository secret named `SSH_PRIVATE_KEY` (or adjust the name in the workflow file) containing the private SSH key authorized to access your Docker host.
