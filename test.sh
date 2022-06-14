if [ -f .env ]; then
    export $(cat .env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

 unlock_wallet() {
    cleos wallet unlock --password $(cat ~/default.pwd)
}

setup() {
    cleos set account permission stake.libre active --add-code -p stake.libre@active

    cleos create account eosio stakingtest1 EOS54XsQUccmfiaLFybXogaqGSApbBNWFkKqUa7595KC91PyNG7xu
    cleos create account eosio stakingtest2 EOS54XsQUccmfiaLFybXogaqGSApbBNWFkKqUa7595KC91PyNG7xu
    cleos create account eosio stakingtest3 EOS54XsQUccmfiaLFybXogaqGSApbBNWFkKqUa7595KC91PyNG7xu
    cleos create account eosio stakingtest4 EOS54XsQUccmfiaLFybXogaqGSApbBNWFkKqUa7595KC91PyNG7xu
    cleos create account eosio stakingtest5 EOS54XsQUccmfiaLFybXogaqGSApbBNWFkKqUa7595KC91PyNG7xu
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest1", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest2", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest3", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest4", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest5", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active

    # Stake
    cleos push action eosio.token transfer '{"from": "stakingtest1", "to": "stake.libre", "quantity": "100 LIBRE", "memo": "stakefor:365"}' -p stakingtest1@active
    cleos push action eosio.token transfer '{"from": "stakingtest2", "to": "stake.libre", "quantity": "150 LIBRE", "memo": "stakefor:365"}' -p stakingtest2@active
    cleos push action eosio.token transfer '{"from": "stakingtest3", "to": "stake.libre", "quantity": "200 LIBRE", "memo": "stakefor:365"}' -p stakingtest3@active
    cleos push action eosio.token transfer '{"from": "stakingtest4", "to": "stake.libre", "quantity": "250 LIBRE", "memo": "stakefor:365"}' -p stakingtest4@active
    cleos push action eosio.token transfer '{"from": "stakingtest5", "to": "stake.libre", "quantity": "300 LIBRE", "memo": "stakefor:365"}' -p stakingtest5@active
}

stake() {
    cleos push action eosio.token transfer '{"from": "stakingtest1", "to": "stake.libre", "quantity": "100 LIBRE", "memo": "stakefor:365"}' -p stakingtest1@active
    cleos push action eosio.token transfer '{"from": "stakingtest2", "to": "stake.libre", "quantity": "50 LIBRE", "memo": "stakefor:365"}' -p stakingtest2@active
}

unstake() {
    cleos push action stake.libre unstake '{"account": "stakingtest2", "index": 4}' -p stakingtest2@active
}

claim() {
    cleos push action stake.libre claim '{"account": "stakingtest2"}' -p stakingtest2@active
}

faucet() {
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest1", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest2", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active
}

create_account() {
    cleos create account eosio stakingtest1 EOS54XsQUccmfiaLFybXogaqGSApbBNWFkKqUa7595KC91PyNG7xu
    cleos create account eosio stakingtest2 EOS54XsQUccmfiaLFybXogaqGSApbBNWFkKqUa7595KC91PyNG7xu
}

transfer() {
    cleos push action eosio.token transfer '{"from": "stakingtest1", "to": "stake.libre", "quantity": "30 LIBRE", "memo": "stakefor:365"}' -p stakingtest1@active
    cleos push action eosio.token transfer '{"from": "stakingtest2", "to": "stake.libre", "quantity": "100 LIBRE", "memo": "stakefor:365"}' -p stakingtest2@active
}

add_code_permission() {
    cleos set account permission stake.libre active --add-code -p stake.libre@active
}

read_table() {
    cleos get table stake.libre stake.libre stake -l 100
}

vote() {
    cleos push action eosio voteproducer '{"voter": "stakingtest1", "producer": "cryptobloksx"}' -p stakingtest1@active
    cleos push action eosio voteproducer '{"voter": "stakingtest2", "producer": "edeniaedenia"}' -p stakingtest2@active
}

add_producers() {
    cleos create account eosio cryptobloksx $TESTNET_NODE_PUBLIC_KEY
    cleos push action eosio.libre setperm '{"acc": "cryptobloksx", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "cryptobloksx", "producer_key": '$TESTNET_NODE_PUBLIC_KEY', "url": "http://producer.com", "location": 123}' -p cryptobloksx@active
    
    cleos create account eosio edeniaedenia $TESTNET_NODE2_PUBLIC_KEY
    cleos push action eosio.libre setperm '{"acc": "edeniaedenia", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "edeniaedenia", "producer_key": '$TESTNET_NODE2_PUBLIC_KEY', "url": "http://producer.com", "location": 123}' -p edeniaedenia@active

    cleos create account eosio zenhash $TESTNET_NODE3_PUBLIC_KEY
    cleos push action eosio.libre setperm '{"acc": "zenhash", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "zenhash", "producer_key": '$TESTNET_NODE3_PUBLIC_KEY', "url": "http://producer.com", "location": 123}' -p zenhash@active

    cleos create account eosio zuexeuz $TESTNET_NODE4_PUBLIC_KEY
    cleos push action eosio.libre setperm '{"acc": "zuexeuz", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "zuexeuz", "producer_key": '$TESTNET_NODE4_PUBLIC_KEY', "url": "http://producer.com", "location": 123}' -p zuexeuz@active
}

vote_producers() {
    cleos push action eosio voteproducer '{"voter": "stakingtest1", "producer": "cryptobloksx"}' -p stakingtest1@active
    cleos push action eosio voteproducer '{"voter": "stakingtest2", "producer": "edeniaedenia"}' -p stakingtest2@active
    cleos push action eosio voteproducer '{"voter": "stakingtest3", "producer": "zenhash"}' -p stakingtest3@active
    cleos push action eosio voteproducer '{"voter": "stakingtest4", "producer": "zuexeuz"}' -p stakingtest4@active
}

register_bp1() {
    cleos create account eosio cryptobloksx $TESTNET_NODE_PUBLIC_KEY
    cleos push action eosio.libre setperm '{"acc": "cryptobloksx", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "cryptobloksx", "producer_key": '$TESTNET_NODE_PUBLIC_KEY', "url": "http://producer.com", "location": 123}' -p cryptobloksx@active

    cleos push action eosio voteproducer '{"voter": "stakingtest1", "producer": "cryptobloksx"}' -p stakingtest1@active
}

register_bp2() {
    cleos create account eosio edeniaedenia $TESTNET_NODE2_PUBLIC_KEY
    cleos push action eosio.libre setperm '{"acc": "edeniaedenia", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "edeniaedenia", "producer_key": '$TESTNET_NODE2_PUBLIC_KEY', "url": "http://producer.com", "location": 123}' -p edeniaedenia@active

    cleos push action eosio voteproducer '{"voter": "stakingtest2", "producer": "edeniaedenia"}' -p stakingtest2@active
}

register_bp3() {
    cleos create account eosio zenhash $TESTNET_NODE3_PUBLIC_KEY
    cleos push action eosio.libre setperm '{"acc": "zenhash", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "zenhash", "producer_key": '$TESTNET_NODE3_PUBLIC_KEY', "url": "http://producer.com", "location": 123}' -p zenhash@active

    cleos push action eosio voteproducer '{"voter": "stakingtest3", "producer": "zenhash"}' -p stakingtest3@active
}

register_bp4() {
    cleos create account eosio zuexeuz $TESTNET_NODE4_PUBLIC_KEY
    cleos push action eosio.libre setperm '{"acc": "zuexeuz", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "zuexeuz", "producer_key": '$TESTNET_NODE4_PUBLIC_KEY', "url": "http://producer.com", "location": 123}' -p zuexeuz@active

    cleos push action eosio voteproducer '{"voter": "stakingtest4", "producer": "zuexeuz"}' -p stakingtest4@active
}

remove_producer() {
    cleos push action eosio rmvproducer '{"producer":"cryptobloksx"}' -p eosio@active
}