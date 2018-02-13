FROM valentinchdock/docker-wallace:1.0.4
# Installing packages needed for check traffic on the container and kill if none

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -qq update && apt-get install --no-install-recommends -y python-pip  python-dev && \
    pip install --upgrade pip && \
    pip install -U setuptools && \
    pip install bioblend galaxy-ie-helpers && \
    Rscript -e "install.packages('rPython')" && \
    # Installing R package dedicated to the shniy app
    # Bash script to check traffic
    mkdir -p /opt/python/galaxy-export


# Adapt download function to export to history Galaxy
COPY ./ui.R /srv/shiny-server/sample-apps/SIG/wallace/shiny/ui.R
COPY ./server.R /srv/shiny-server/sample-apps/SIG/wallace/shiny/server.R
COPY ./gtext_comp1_galaxyOccs.Rmd /srv/shiny-server/sample-apps/SIG/wallace/shiny/Rmd/gtext_comp1_galaxyOccs.Rmd
COPY ./mod_c1_galaxyOccs.R /srv/shiny-server/sample-apps/SIG/wallace/shiny/modules/mod_c1_galaxyOccs.R


# Bash script to lauch all process needed
COPY shiny-server.sh /usr/bin/shiny-server.sh
# Python script to export data to history Galaxy
COPY ./export.py /opt/python/galaxy-export/export.py


# TEMP python import
COPY ./__init__.py /usr/local/lib/python2.7/dist-packages/galaxy_ie_helpers/__init__.py
COPY ./import_list_history.py /import_list_history.py
COPY ./global.r /srv/shiny-server/sample-apps/SIG/wallace/shiny/
RUN apt-get install -y vim
CMD ["/usr/bin/shiny-server.sh"]
