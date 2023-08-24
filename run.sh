#!/bin/bash

if [ -f .env ]; then
    export $(cat .env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

unlock_wallet() {
    echo 'Unlocking Wallet...'
    cleos wallet unlock -n librewallet --password $(cat ./secrets/librewallet_wallet_password.txt) ||
    echo "Wallet has already been unlocked..."
}

create_wallet() {
    echo 'Creating Wallet...'
    mkdir -p ./secrets
    cleos wallet create -n librewallet --to-console |
        awk 'FNR > 3 { print $1 }' |
        tr -d '"' \
            >./secrets/librewallet_wallet_password.txt
    cleos wallet open -n librewallet
    unlock_wallet

    cleos wallet import -n librewallet --private-key $DEFAULT_PRIVATE_KEY
    cleos wallet import -n librewallet --private-key $TESTNET_EOSIO_PRIVATE_KEY
}

import_key() {
    echo 'Importing Key...'
    cleos wallet import -n librewallet --private-key $1
}

build_genesis() {
    docker build -t eoscostarica506/libre-genesis-node:latest -f ./nodes/genesis/Dockerfile ./nodes/genesis/
}

build_single_node() {
    docker build -t eoscostarica506/libre-node:latest -f ./nodes/bp/Dockerfile ./nodes/bp/
}

stop_network() {
    docker stop $(docker ps -a -q)
    docker rm $(docker ps --filter "status=exited" -q)
    # docker network rm libre-network
}

genesis() {
    rm secrets/*.priv secrets/*.pub

    docker run -d --name genesis --network libre-network -p 8888:8888 -p 8080:8080 -p 9876:9876 -p 9879:9879 \
    -e BP_NAME=genesis \
    -e INITIAL_CHAIN_ID=${INITIAL_CHAIN_ID} \
    -e TESTNET_EOSIO_PRIVATE_KEY=${TESTNET_EOSIO_PRIVATE_KEY} \
    -e TESTNET_EOSIO_PUBLIC_KEY=${TESTNET_EOSIO_PUBLIC_KEY} \
    -v $(pwd)/wasm/system-contracts:/eosio.contracts \
    -v $(pwd)/wasm/staking-contract:/staking-contract \
    -v $(pwd)/wasm/libre-referrals:/referral \
    -v $(pwd)/wasm/dao-contract:/btclgovernan \
    -v $(pwd)/wasm/swap-contract:/swap \
    -v $(pwd)/wasm/ordinals-contract:/ordinals \
    -v $(pwd)/wasm/inscription-contract:/inscription \
    eoscostarica506/libre-genesis-node:latest bash -c "./start.sh"
}

start_single_node() {
    NAME=$1
    PORT=$2
    PORT2=$3
    PORT3=$4
    P2P_SERVER_ADDRESS=$5
    P2P_PEER_ADDRESS=$6
    P2P2_PEER_ADDRESS=$7
    P2P3_PEER_ADDRESS=$8
    TESTNET_NODE_PRIVATE_KEY=$9
    TESTNET_NODE_PUBLIC_KEY=${10}

    docker run -d --name libre-$NAME --network libre-network -p $PORT -p $PORT2 -p $PORT3 \
    -e BP_NAME=$NAME \
    -e P2P_SERVER_ADDRESS=$P2P_SERVER_ADDRESS \
    -e P2P_PEER_ADDRESS=$P2P_PEER_ADDRESS \
    -e P2P2_PEER_ADDRESS= \
    -e P2P3_PEER_ADDRESS= \
    -e INITIAL_CHAIN_ID=${INITIAL_CHAIN_ID} \
    -e TESTNET_EOSIO_PUBLIC_KEY=${TESTNET_EOSIO_PUBLIC_KEY} \
    -e TESTNET_NODE_PRIVATE_KEY=${TESTNET_NODE_PRIVATE_KEY} \
    -e TESTNET_NODE_PUBLIC_KEY=${TESTNET_NODE_PUBLIC_KEY} \
    eoscostarica506/libre-node:latest bash -c "./start.sh"
}

start_api_history() {
    cd api-history/infra
    docker-compose up -d
    cd ../hyperion
    docker-compose up -d
    cd ..
}

create_network() {
    docker network create --driver bridge --subnet 192.168.0.0/24 libre-network
}

start_network() {
    # Check if the number of arguments is 2
    if [ $# -ne 2 ]; then
    echo "Usage: $0 label number"
    exit 1
    fi

    # Assign the arguments to variables
    label=$1
    number=$2

    # Check if the label is a word and not longer than 9 characters
    if ! [[ $label =~ ^[a-zA-Z]+$ ]] || [ ${#label} -gt 9 ]; then
    echo "Invalid label: $label"
    exit 2
    fi

    # Check if the number is an integer between 1 and 25
    if ! [[ $number =~ ^[0-9]+$ ]] || [ $number -lt 1 ] || [ $number -gt 25 ]; then
    echo "Max amount is 25 and you provided: $number"
    exit 3
    fi

    # Initialize the iterator variables
    i=1
    j=1
    k=1

    port1=8800
    port2=9800
    port3=9850

    # Loop until the number of names is reached
    while [ $k -le $number ]; do
    # Print the name with the label and the iterator
    echo "$label$i$j"

    keys=($(cleos create key --to-console))
    pub=${keys[6]}
    priv=${keys[3]}
    cleos wallet import -n librewallet --private-key $priv

    echo $pub >./secrets/$label$i$j.pub
    echo $priv >./secrets/$label$i$j.priv

    start_single_node $label$i$j $port1:8888 $port2:9876 $port3:9879 $label$i$j:9876 genesis:9876 NULL NULL $priv $pub

    # Increment the iterator
    j=$((j+1))
    k=$((k+1))

    # Increment the ports
    port1=$((port1+1))
    port2=$((port2+1))
    port3=$((port3+1))

    # Reset the iterator if it reaches 6
    if [ $j -eq 6 ]; then
        j=1
        i=$((i+1))
    fi
    done
}

func=$1 
shift

$func $@