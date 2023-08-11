FROM ghcr.io/edenia/eosio-nodeos:antelope-leap-v4.0.4
WORKDIR /app

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

# build boot contract
RUN git clone https://github.com/AntelopeIO/reference-contracts.git
RUN cd /app/reference-contracts/ \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF ..  \
  && make -j $(nproc)

COPY ./start.sh ./
COPY ./config.ini ./config/
COPY ./genesis.json ./
RUN cp -r /app/reference-contracts/build/contracts/eosio.boot /eosio.boot

RUN chmod +x ./start.sh