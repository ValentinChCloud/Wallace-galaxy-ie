FROM rocker/shiny:latest

# Installing packages needed for check traffic on the container and kill if none

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -qq update && apt-get install --no-install-recommends -y libgdal-dev libproj-dev net-tools procps libcurl4-openssl-dev libxml2-dev libssl-dev openjdk-8-jdk libgeos-dev python-pip && \
    pip install --upgrade pip && \
    pip install -U setuptools && \
    pip install bioblend galaxy-ie-helpers && \
    # Installing R package dedicated to the shniy app
    R CMD javareconf && \
    Rscript -e "install.packages('wallace')" && \
    # Bash script to check traffic
    mkdir /srv/shiny-server/sample-apps/SIG

# Wallace stuff
ADD ./wallace/inst/ /srv/shiny-server/sample-apps/SIG/wallace/

# Galaxy ie stuff
ADD ./monitor_traffic.sh /monitor_traffic.sh

# Adapt download function to export to history Galaxy
COPY ./global.r /srv/shiny-server/sample-apps/SIG/wallace/shiny/
COPY ./ui.R /srv/shiny-server/sample-apps/SIG/wallace/shiny/ui.R
COPY ./server.R /srv/shiny-server/sample-apps/SIG/wallace/shiny/server.R
COPY ./shiny-server.conf /etc/shiny-server/shiny-server.conf


# Bahs script to lauch all process needed
COPY shiny-server.sh /usr/bin/shiny-server.sh

# Python script to export data to history Galaxy
COPY ./export.py /var/log/shiny-server/export.py

CMD ["/usr/bin/shiny-server.sh"]
