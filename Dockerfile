FROM eosio/eosio:release_2.1.x
WORKDIR /app

# install dependencies
RUN apt-get update
RUN apt-get install -y wget git build-essential cmake --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

# install eosio.cdt
RUN wget https://github.com/eosio/eosio.cdt/releases/download/v1.8.1/eosio.cdt_1.8.1-1-ubuntu-18.04_amd64.deb
RUN apt install ./eosio.cdt_1.8.1-1-ubuntu-18.04_amd64.deb

# build boot contract
RUN git clone -b release/2.1.x https://github.com/EOSIO/eos.git
RUN cd /app/eos/contracts/contracts/eosio.boot/ \
  && mkdir build \
  && cd build \
  && cmake ..  \
  && make

COPY ./start.sh ./
COPY ./config.ini ./config/
COPY ./genesis.json ./
COPY ./contracts/phoenix-contracts/build/contracts ./eosio.contracts
RUN cp -r /app/eos/contracts/contracts/eosio.boot/build /eosio.boot

RUN chmod +x ./start.sh