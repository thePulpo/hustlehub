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

# Proxmox
## Connect to Keycloak (OpenID)

https://gist.github.com/jakoberpf/d6f519459f7dad3b30f509facdc22445

# Portainer
## Connect to Keycloak (OpenID)

Token Claim Name preferred_username

# Nextcloud

use docker compose (no ssl, since we will use nginx proxy manager)
http://nextcloud:8080/login?clear=1
## Connect to Keycloak (OpenID)

https://janikvonrotz.ch/2020/10/20/openid-connect-with-nextcloud-and-keycloak/

# Jupyterhub

#dockerspawner
https://github.com/jupyterhub/dockerspawner

## Connect to Keycloak (OpenID)

https://github.com/jupyterhub/oauthenticator/tree/main/examples/generic
https://oauthenticator.readthedocs.io/en/latest/reference/api/gen/oauthenticator.generic.html
https://z2jh.jupyter.org/en/stable/administrator/authentication.html

