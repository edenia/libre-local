FROM eosio/eosio:release_2.1.x
ENV WORK_DIR /opt/scripts
ENV DATA_DIR /data/nodeos
ENV CONFIG_DIR $DATA_DIR/config

WORKDIR $WORK_DIR

# install dependencies
RUN apt-get update
RUN apt-get install -y wget git build-essential cmake --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

# install eosio.cdt
RUN wget https://github.com/eosio/eosio.cdt/releases/download/v1.8.1/eosio.cdt_1.8.1-1-ubuntu-18.04_amd64.deb
RUN apt install ./eosio.cdt_1.8.1-1-ubuntu-18.04_amd64.deb

COPY ./start.sh ./
COPY ./config.ini ./
COPY ./genesis.json /opt/genesis/

RUN mkdir -p $DATA_DIR

RUN chmod +x ./start.sh