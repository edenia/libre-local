 unlock_wallet() {
    cleos wallet unlock --password $(cat ~/default.pwd)
}

setup() {
    cleos create account eosio smart EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "smart", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "smart", "producer_key": "EOS5pxUxHki4s5QYaHkFRi9hwykKn2Kk1bz7Kd6YMsDEUtMX5j48Z", "url": "url removed", "location": 123}' -p smart@active

    cleos set account permission stake.libre active --add-code -p stake.libre@active

    cleos create account eosio stakingtest1 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos create account eosio stakingtest2 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest1", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active
    cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingtest2", "quantity": "100000 LIBRE", "memo": "faucet"}' -p eosio@active

    # Stake
    cleos push action eosio.token transfer '{"from": "stakingtest1", "to": "stake.libre", "quantity": "100 LIBRE", "memo": "stakefor:365"}' -p stakingtest1@active
    cleos push action eosio.token transfer '{"from": "stakingtest2", "to": "stake.libre", "quantity": "100 LIBRE", "memo": "stakefor:365"}' -p stakingtest2@active
}

stake() {
    # cleos push action eosio.token transfer '{"from": "stakingtest1", "to": "stake.libre", "quantity": "100 LIBRE", "memo": "stakefor:365"}' -p stakingtest1@active
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
    cleos create account eosio stakingtest1 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos create account eosio stakingtest2 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
}

transfer() {
    cleos push action eosio.token transfer '{"from": "stakingtest1", "to": "stake.libre", "quantity": "30 LIBRE", "memo": "stakefor:365"}' -p stakingtest1@active
    # cleos push action eosio.token transfer '{"from": "stakingtest2", "to": "stake.libre", "quantity": "100 LIBRE", "memo": "stakefor:365"}' -p stakingtest2@active
}

add_code_permission() {
    cleos set account permission stake.libre active --add-code -p stake.libre@active
}

read_table() {
    cleos get table stake.libre stake.libre stake -l 100
}

vote() {
    cleos push action eosio voteproducer '{"voter": "stakingtest1", "producer": "smart"}' -p stakingtest1@active
    cleos push action eosio voteproducer '{"voter": "stakingtest2", "producer": "smart"}' -p stakingtest2@active
}

vote2() {
    # cleos push action eosio voteproducer '{"voter": "stakingtest1", "producer": "smart"}' -p stakingtest1@active
    # cleos push action eosio voteproducer '{"voter": "stakingtest2", "producer": "smart2"}' -p stakingtest2@active
}

add_producer2() {
    cleos create account eosio smart2 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "smart2", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "smart2", "producer_key": "EOS5pxUxHki4s5QYaHkFRi9hwykKn2Kk1bz7Kd6YMsDEUtMX5j48Z", "url": "url removed", "location": 123}' -p smart2@active
}

# setup
# transfer
# add_code_permission