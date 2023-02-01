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
    cleos push action eosio rmvproducer '{"producer":"cryptobloksx"}' -p eosio@active
}

claim_rewards() {
    cleos push action eosio claimrewards '{"owner": "cryptobloksx"}' -p cryptobloksx@active
    cleos push action eosio claimrewards '{"owner": "edeniaedenia"}' -p edeniaedenia@active
    cleos push action eosio claimrewards '{"owner": "zenhash"}' -p zenhash@active
    cleos push action eosio claimrewards '{"owner": "zuexeuz"}' -p zuexeuz@active
}