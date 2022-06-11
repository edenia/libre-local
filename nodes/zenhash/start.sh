#!/usr/bin/env bash
echo "Starting Phoenix Testnet Block Producer Node...";
set -ex;
ulimit -n 65535
ulimit -s 64000

mkdir -p $CONFIG_DIR
cp /opt/scripts/config.ini $CONFIG_DIR

pid=0;

nodeos=$"nodeos \
  --config-dir $CONFIG_DIR \
  --data-dir $DATA_DIR \
  --blocks-dir $DATA_DIR/blocks \
  --signature-provider $TESTNET_NODE3_PUBLIC_KEY=KEY:$TESTNET_NODE3_PRIVATE_KEY" ;

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
if [ -z "$TESTNET_NODE3_PUBLIC_KEY" ] || [ -z "$TESTNET_NODE3_PRIVATE_KEY" ]
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
