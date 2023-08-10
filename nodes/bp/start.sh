#!/usr/bin/env bash
echo "Starting Libre Testnet Block Producer Node...";
set -ex;
ulimit -n 65535
ulimit -s 64000

# Set BP name
sed -i "s/BP_NAME/$BP_NAME/" config.ini

# Set server address
sed -i "s/P2P_SERVER_ADDRESS/$P2P_SERVER_ADDRESS/" config.ini

# Set peers
sed -i "s/P2P_PEER_ADDRESS/$P2P_PEER_ADDRESS/" config.ini
sed -i "s/P2P2_PEER_ADDRESS/$P2P2_PEER_ADDRESS/" config.ini
sed -i "s/P2P3_PEER_ADDRESS/$P2P3_PEER_ADDRESS/" config.ini

# Set initial key and chain id
sed -i "s/TESTNET_EOSIO_PUBLIC_KEY/$TESTNET_EOSIO_PUBLIC_KEY/" /opt/genesis/genesis.json
sed -i "s/INITIAL_CHAIN_ID/$INITIAL_CHAIN_ID/" /opt/genesis/genesis.json

mkdir -p $CONFIG_DIR
cp /opt/scripts/config.ini $CONFIG_DIR

pid=0;

nodeos=$"nodeos \
  --config-dir $CONFIG_DIR \
  --data-dir $DATA_DIR \
  --blocks-dir $DATA_DIR/blocks \
  --disable-replay-opts \
  --signature-provider $TESTNET_NODE_PUBLIC_KEY=KEY:$TESTNET_NODE_PRIVATE_KEY" ;

term_handler() {
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid";
    wait "$pid";
  fi
  exit 0;
}

start_nodeos() {
  $nodeos &
  sleep 10;
  if [ -z "$(pidof nodeos)" ]; then
    $nodeos --fix-reversible-blocks &
    rm -rf $DATA_DIR/state
    $nodeos &
  fi
  sleep 10;
  if [ -z "$(pidof nodeos)" ]; then
    $nodeos --hard-replay-blockchain &
  fi
}

start_fresh_nodeos() {
  echo 'Starting new chain from genesis JSON'
  $nodeos --delete-all-blocks --genesis-json /opt/genesis/genesis.json &
}

trap 'echo "Shutdown of EOSIO service...";kill ${!}; term_handler' 2 15;

# Validate that the signing keys are not empty
if [ -z "$TESTNET_NODE_PUBLIC_KEY" ] || [ -z "$TESTNET_NODE_PRIVATE_KEY" ]
then
  echo "Signing keys not set...";
  exit 1;
fi


if [ ! -d $DATA_DIR/blocks ]; then
  start_fresh_nodeos &
elif [ -d $DATA_DIR/blocks ]; then
  start_nodeos &
fi

pid="$(pidof nodeos)"

while true
do
  tail -f /dev/null & wait ${!}
done
