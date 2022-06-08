 unlock_wallet() {
    cleos wallet unlock --password $(cat ~/default.pwd)
}

setup() {
    cleos set account permission stake.libre active --add-code -p stake.libre@active

    cleos create account eosio stakingtest1 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos create account eosio stakingtest2 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos create account eosio stakingtest3 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos create account eosio stakingtest4 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos create account eosio stakingtest5 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
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
    cleos -u http://localhost:8891 create account eosio stakingtest1 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos -u http://localhost:8891 create account eosio stakingtest2 EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
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

add_producers() {
    cleos create account eosio cryptobloksx EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "cryptobloksx", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "cryptobloksx", "producer_key": "EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna", "url": "url removed", "location": 123}' -p cryptobloksx@active
    
    cleos create account eosio edeniaedenia EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "edeniaedenia", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "edeniaedenia", "producer_key": "EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna", "url": "url removed", "location": 123}' -p edeniaedenia@active

    cleos create account eosio zenhash EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "zenhash", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "zenhash", "producer_key": "EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna", "url": "url removed", "location": 123}' -p zenhash@active

    cleos create account eosio zuexeuz EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "zuexeuz", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "zuexeuz", "producer_key": "EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna", "url": "url removed", "location": 123}' -p zuexeuz@active
}

vote_producers() {
    cleos push action eosio voteproducer '{"voter": "stakingtest1", "producer": "cryptobloksx"}' -p stakingtest1@active
    cleos push action eosio voteproducer '{"voter": "stakingtest2", "producer": "edeniaedenia"}' -p stakingtest2@active
    cleos push action eosio voteproducer '{"voter": "stakingtest3", "producer": "zenhash"}' -p stakingtest3@active
    cleos push action eosio voteproducer '{"voter": "stakingtest4", "producer": "zuexeuz"}' -p stakingtest4@active
}

register_bp1() {
    cleos create account eosio cryptobloksx EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "cryptobloksx", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "cryptobloksx", "producer_key": "EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna", "url": "url removed", "location": 123}' -p cryptobloksx@active

    cleos push action eosio voteproducer '{"voter": "stakingtest1", "producer": "cryptobloksx"}' -p stakingtest1@active
}

register_bp2() {
    cleos create account eosio edeniaedenia EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "edeniaedenia", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "edeniaedenia", "producer_key": "EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna", "url": "url removed", "location": 123}' -p edeniaedenia@active

    cleos push action eosio voteproducer '{"voter": "stakingtest2", "producer": "edeniaedenia"}' -p stakingtest2@active
}

register_bp3() {
    cleos create account eosio zenhash EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "zenhash", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "zenhash", "producer_key": "EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna", "url": "url removed", "location": 123}' -p zenhash@active

    cleos push action eosio voteproducer '{"voter": "stakingtest3", "producer": "zenhash"}' -p stakingtest3@active
}

register_bp4() {
    cleos create account eosio zuexeuz EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
    cleos push action eosio.libre setperm '{"acc": "zuexeuz", "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
    cleos push action eosio regproducer '{"producer": "zuexeuz", "producer_key": "EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna", "url": "url removed", "location": 123}' -p zuexeuz@active

    cleos push action eosio voteproducer '{"voter": "stakingtest4", "producer": "zuexeuz"}' -p stakingtest4@active
}

remove_producer() {
    cleos push action eosio rmvproducer '{"producer":"cryptobloksx"}' -p eosio@active
}

# setup
# transfer
# add_code_permission