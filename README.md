# HustleHub

HustleHub is an all-in-one solution, providing a comprehensive product for managing online services in a secure and
flexible environment. The system is built on the Proxmox hypervisor, which enables maximum isolation and security by
running all services in separate LXC and Docker containers.

It includes Keycloak for authentication with Single Sign-On capabilities using OAuth, as well as Portainer, an intuitive
web-based interface for managing and monitoring Docker containers. With Nginx Reverse Proxy Manager, setting up and
managing reverse proxies for all web services, including JupyterHub and Nextcloud is made easy. HustleHub also provides
additional useful services, such as AdGuard for ad-blocking and privacy protection, and Bitwarden for password
management. For collaborative data science, JupyterHub is available, while Nextcloud offers file sharing and
synchronization.

The entire system is designed to be as secure as possible, with regular updates and configurations to mitigate potential
vulnerabilities. HustleHub is a comprehensive product, intended for educational purposes, and provides an all-in-one
solution for learning about secure server systems and experimenting with different technologies in a safe and controlled
environment.

# Nextcloud

use docker compose

## Connect to Keycloak (OpenID)

https://www.schiessle.org/articles/2020/07/26/nextcloud-and-openid-connect/