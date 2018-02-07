FROM valentinchdock/docker-wallace:1.0.3
# Installing packages needed for check traffic on the container and kill if none

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -qq update && apt-get install --no-install-recommends -y python-pip && \
    pip install --upgrade pip && \
    pip install -U setuptools && \
    pip install bioblend galaxy-ie-helpers && \
    # Installing R package dedicated to the shniy app
    # Bash script to check traffic
    mkdir -p /opt/python/galaxy-export


# Adapt download function to export to history Galaxy
COPY ./ui.R /srv/shiny-server/sample-apps/SIG/wallace/shiny/ui.R
COPY ./server.R /srv/shiny-server/sample-apps/SIG/wallace/shiny/server.R
# Bash script to lauch all process needed
COPY shiny-server.sh /usr/bin/shiny-server.sh
# Python script to export data to history Galaxy
COPY ./export.py /opt/python/galaxy-export/export.py

CMD ["/usr/bin/shiny-server.sh"]
