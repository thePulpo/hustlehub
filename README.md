# HustleHub

**HustleHub** is a comprehensive solution for managing your online services, providing a secure and flexible environment
for your applications. The system is based on a **Proxmox** hypervisor with all services running in separate **LXC** and
**Docker** containers, ensuring maximum isolation and security.

**Keycloak** is used to provide a robust authentication system with **SSO** capabilities using **OAuth**, while *
*Portainer** offers an intuitive web-based interface for managing and monitoring your **Docker** containers.

In addition to these tools, HustleHub includes other useful services such as **AdGuard** for ad-blocking and privacy
protection, and **Bitwarden** for password management. The **webserver** is set up using either **Apache** or **Nginx**,
with **Nginx Reverse Proxy Manager** enabling easy management of reverse proxies.

For user services, HustleHub offers **JupyterHub** for collaborative data science, and **Nextcloud** for file sharing
and synchronization. The entire system is designed to be as secure as possible, with regular updates and configurations
to mitigate potential vulnerabilities.
