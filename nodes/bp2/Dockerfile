FROM ubuntu:18.04 as base-stage

ENV WORK_DIR /opt/scripts
ENV EOSIO_PACKAGE_URL https://github.com/EOSIO/eos/releases/download/v2.0.13/eosio_2.0.13-1-ubuntu-18.04_amd64.deb

RUN apt-get update && apt-get install -y wget jq git build-essential cmake curl netcat zstd rsync

RUN wget -O /eosio.deb $EOSIO_PACKAGE_URL

RUN apt-get install -y /eosio.deb

# Remove all of the unnecessary files and apt cache
RUN rm -Rf /eosio*.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Define working directory
WORKDIR $WORK_DIR

# ------------------------------

FROM base-stage as prod-stage

ENV WORK_DIR /opt/scripts
# Define Environment params used by start.sh
ENV DATA_DIR /data/nodeos
ENV CONFIG_DIR $DATA_DIR/config

# RUN chmod +x $WORK_DIR/start.sh

CMD ["/opt/scripts/start.sh"]

# ------------------------------

FROM base-stage as local-stage

ENV WORK_DIR /opt/scripts

RUN apt-get update \
  && apt-get install -y --no-install-recommends jq curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Define Environment params used by start.sh
ENV DATA_DIR /data/nodeos
ENV CONFIG_DIR $DATA_DIR/config

RUN mkdir -p $DATA_DIR

# RUN chmod +x $WORK_DIR/start.sh

CMD ["/opt/scripts/start.sh"]
