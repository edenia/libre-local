stake() {
    cleos push action eosio.token transfer '{"from": "<account>", "to": "stake.libre", "quantity": "100.0000 LIBRE", "memo": "stakefor:365"}' -p <account>@active
    cleos push action eosio.token transfer '{"from": "<account>", "to": "stake.libre", "quantity": "50.0000 LIBRE", "memo": "stakefor:365"}' -p <account>@active
}

unstake() {
    cleos push action stake.libre unstake '{"account": "<account>", "index": <number>}' -p <account>@active
}

claim() {
    cleos push action stake.libre claim '{"account": "<account>", "index": <number>}' -p <account>@active
}

remove_producer() {
    cleos push action eosio rmvproducer '{"producer":"bp2"}' -p eosio@active
}

claim_rewards() {
    cleos push action eosio claimrewards '{"owner": "bp2"}' -p bp2@active
    cleos push action eosio claimrewards '{"owner": "bp3"}' -p bp3@active
    cleos push action eosio claimrewards '{"owner": "bp4"}' -p bp4@active
    cleos push action eosio claimrewards '{"owner": "bp5"}' -p bp5@active
}