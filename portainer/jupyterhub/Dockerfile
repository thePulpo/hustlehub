# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Remove cache
ARG CACHEBUST=1

ARG JUPYTERHUB_VERSION
FROM jupyterhub/jupyterhub:$JUPYTERHUB_VERSION

# try this!
# Copy Nextcloud mount script to a temporary directory
#COPY nextcloud_mount.sh /tmp/
#RUN #chmod +x /tmp/nextcloud_mount.sh


# Install dockerspawner, nativeauthenticator
RUN python3 -m pip install --no-cache-dir \
    dockerspawner \
    oauthenticator
#    jupyterhub-nativeauthenticator

#newly added
#CMD mount home/jovyan/nextcloud &&
COPY jupyterhub_config.py /srv/jupyterhub/
CMD jupyterhub -f /srv/jupyterhub/jupyterhub_config.py

#CMD ["mount", "home/jovyan/nextcloud"]
#OG CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]