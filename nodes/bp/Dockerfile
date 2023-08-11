FROM ghcr.io/edenia/eosio-nodeos:antelope-leap-v4.0.4
ENV WORK_DIR /opt/scripts
ENV DATA_DIR /data/nodeos
ENV CONFIG_DIR $DATA_DIR/config

WORKDIR $WORK_DIR

# install dependencies
RUN apt-get update \
    && apt-get install -y \
        wget \
        git \
        build-essential \
        cmake --no-install-recommends \
        libcurl4-gnutls-dev
RUN rm -rf /var/lib/apt/lists/*

# install eosio.cdt
RUN wget https://github.com/AntelopeIO/cdt/releases/download/v4.0.0/cdt_4.0.0_amd64.deb
RUN apt install ./cdt_4.0.0_amd64.deb

COPY ./start.sh ./
COPY ./config.ini ./
COPY ./genesis.json /opt/genesis/

RUN mkdir -p $DATA_DIR

RUN chmod +x ./start.sh