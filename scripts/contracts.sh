#!/bin/bash

if [ -f ../.env ]; then
    export $(cat ../.env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

CUSTOM_ACCOUNTS=(alice bob pip bitcoinlibre)
MAIN_ACCOUNTS=(stake.libre farm.libre reward.libre dao.libre)
BLOCK_PRODUCERS=(cryptobloksx edeniaedenia zenhash zuexeuz)
BLOCK_PRODUCERS_KEYS=($TESTNET_NODE_PUBLIC_KEY $TESTNET_NODE2_PUBLIC_KEY $TESTNET_NODE3_PUBLIC_KEY $TESTNET_NODE4_PUBLIC_KEY)

register_bps() {
    # TODO: check lenght of bps <= lenght of keys
    for (( i = 0; i < ${#BLOCK_PRODUCERS[@]}; i++ )); do
        cleos create account eosio "${BLOCK_PRODUCERS[$i]}" ${BLOCK_PRODUCERS_KEYS[$i]} 
        cleos push action eosio.libre setperm '{"acc": '"${BLOCK_PRODUCERS[$i]}"', "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
        cleos push action eosio regproducer '{"producer": '"${BLOCK_PRODUCERS[$i]}"', "producer_key": '"${BLOCK_PRODUCERS_KEYS[$i]}"', "url": "http://producer.com", "location": 123}' -p ${BLOCK_PRODUCERS[$i]}@active
    done
}

vote_producers() {
    cleos push action eosio voteproducer '{"voter": "stakingte111", "producer": "cryptobloksx"}' -p stakingte111@active
    cleos push action eosio voteproducer '{"voter": "stakingte112", "producer": "edeniaedenia"}' -p stakingte112@active
    cleos push action eosio voteproducer '{"voter": "stakingte113", "producer": "zenhash"}' -p stakingte113@active
    cleos push action eosio voteproducer '{"voter": "stakingte114", "producer": "zuexeuz"}' -p stakingte114@active
    cleos push action eosio voteproducer '{"voter": "stakingte115", "producer": "cryptobloksx"}' -p stakingte115@active
}

create_accounts() {
    echo "Start create accounts..."
    for account in ${CUSTOM_ACCOUNTS[*]}; do
        cleos create account eosio "$account" $DEFAULT_PK
        cleos push action eosio setalimits '{"authorizer": "eosio", "account": '"$account"', "ram": 10000000, "net": 2000, "cpu": 2000}' -p eosio@active
    done
    echo "Finish create accounts..."
}

add_eosio_code() {
    echo "Start adding eosio code permission..."
    for account in ${MAIN_ACCOUNTS[*]}; do
        cleos set account permission $account active --add-code -p $account@active
    done
    echo "Finish adding eosio code permission..."
}

setup_permission() {
    cleos set account permission eosio stake '{"threshold": 1, "keys": [], "accounts":[{"permission":{"actor": "reward.libre", "permission":"active"}, "weight": 1}, {"permission":{"actor": "stake.libre", "permission":"active"}, "weight": 1}], "waits": [] }' active -p eosio@active

    cleos set action permission eosio eosio.token issue stake -p eosio@active
    cleos set action permission eosio eosio.token transfer stake -p eosio@active

    cleos push action eosio.libre setperm '{"acc": "alice", "perms": [["createacc",1]]}' -p eosio.libre@active
}

add_referrals() {
    cleos push action accts.libre add '{"approver": "alice", "account": "stakingte111", "referrer": "alice"}' -p alice@active
    cleos push action accts.libre add '{"approver": "alice", "account": "stakingte112", "referrer": "alice"}' -p alice@active
    cleos push action accts.libre add '{"approver": "alice", "account": "stakingte113", "referrer": "alice"}' -p alice@active
}

fully_create_aux_accounts() {
    echo "Start create aux accounts..."
    for i in {1..5}
    do
        for j in {1..5}
        do
            for k in {1..5}
            do
                # create account
                cleos create account eosio stakingte$i$j$k $DEFAULT_PK
                cleos push action eosio setalimits '{"authorizer": "eosio", "account": '"stakingte$i$j$k"', "ram": 9000000, "net": 2000, "cpu": 2000}' -p eosio@active

                # fund account
                cleos push action eosio.token transfer '{"from": "eosio", "to": "stakingte'$i$j$k'", "quantity": "100.0000 LIBRE", "memo": "funding LIBRE"}' -p eosio@active
                cleos push action btc.ptokens transfer '{"from": "eosio", "to": "stakingte'$i$j$k'", "quantity": "100.000000000 PBTC", "memo": "funding PBTC"}' -p eosio@active
                cleos push action usdt.ptokens transfer '{"from": "eosio", "to": "stakingte'$i$j$k'", "quantity": "100.000000000 PUSDT", "memo": "funding PUSDT"}' -p eosio@active
            done
        done
    done
    echo "Finish create aux accounts..."
}

fund_custom_accounts() {
    echo "Start funding custom accounts..."
    for account in ${CUSTOM_ACCOUNTS[*]}; do
        cleos push action eosio.token transfer '{"from": "eosio", "to": "'$account'", "quantity": "100000.0000 LIBRE", "memo": "funding LIBRE"}' -p eosio@active
        cleos push action btc.ptokens transfer '{"from": "eosio", "to": "'$account'", "quantity": "1000000.000000000 PBTC", "memo": "funding PBTC"}' -p eosio@active
        cleos push action usdt.ptokens transfer '{"from": "eosio", "to": "'$account'", "quantity": "1000000.000000000 PUSDT", "memo": "funding PUSDT"}' -p eosio@active
    done
    echo "Finish funding custom accounts..."
}

init_staking_contract() {
    # date --utc '+%Y-%m-%dT%H:%M:00'
    CURRENT_DATE_SEC=$(date --utc '+%s')
    CURRENT_DATE_SEC=$((CURRENT_DATE_SEC + 1))
    CURRENT_DATE="$(date --utc -d @$CURRENT_DATE_SEC '+%Y-%m-%dT%H:%M:%S')"
    

    cleos push action stake.libre init '{"start_date": "'$CURRENT_DATE'", "total_days": 365}' -p stake.libre@active
}

init_reward_contract() {
  ONE_DAY_SEC=86400
  cleos push action reward.libre init '['$ONE_DAY_SEC', 10000, ["BTCLIB", "BTCUSDD"]]' -p reward.libre@active
}

init_dao_contract() {
    cleos push action dao.libre setparams '{"funding_account": "dao.libre", "vote_threshold": 3, "voting_days": 1, "minimum_balance_to_create_proposals": "10.0000 LIBRE", "proposal_cost": "3.000000000 PBTC", "approver": "dao.libre"}' -p dao.libre@active
}

setup_swap() {
    YOUR_ACCOUNT="alice"
    BTCCONTRACT="btc.ptokens"
    BTCSYMBOL="PBTC"
    BTCPRECISION="9"
    USDSYMBOL="PUSDT"
    USDCONTRACT="usdt.ptokens"
    USDPRECISION="9"
    CLEOS="cleos"
    DEXCONTRACT="swap.libre"

    $CLEOS push action swap.libre openext '["'"$YOUR_ACCOUNT"'", "'"$YOUR_ACCOUNT"'", {"contract":"'"$USDCONTRACT"'", "sym":"'"$USDPRECISION"','"$USDSYMBOL"'"}]' -p $YOUR_ACCOUNT
    $CLEOS push action swap.libre openext '["'"$YOUR_ACCOUNT"'", "'"$YOUR_ACCOUNT"'", {"contract":"'"$BTCCONTRACT"'", "sym":"'"$BTCPRECISION"','"$BTCSYMBOL"'"}]' -p $YOUR_ACCOUNT
    $CLEOS push action $BTCCONTRACT transfer '["'"$YOUR_ACCOUNT"'", "swap.libre", "1.000000000 '"$BTCSYMBOL"'", "memo"]' -p $YOUR_ACCOUNT
    $CLEOS push action $USDCONTRACT transfer '["'"$YOUR_ACCOUNT"'", "swap.libre", "20000.000000000 '"$USDSYMBOL"'", "memo"]' -p $YOUR_ACCOUNT
    $CLEOS push action swap.libre inittoken '["'"$YOUR_ACCOUNT"'", "9,BTCUSDD", {"contract":"'"$BTCCONTRACT"'", "quantity":"1.000000000 '"$BTCSYMBOL"'"}, {"contract":"'"$USDCONTRACT"'", "quantity":"20000.000000000 '"$USDSYMBOL"'"}, 10, "sfee.libre"]' -p $YOUR_ACCOUNT -p swap.libre
}

stake_for() {
    echo "Create staking..."
    for i in {1..5}
    do
        for j in {1..5}
        do
            for k in {1..5}
            do
                cleos push action eosio.token transfer '{"from": "stakingte'$i$j$k'", "to": "stake.libre", "quantity": "10.0000 LIBRE", "memo": "stakefor:365"}' -p stakingte$i$j$k@active
            done
        done
    done
    echo "Create staking completed..."
}

contribute_for() {
    echo "Create staking..."
    for i in {1..5}
    do
        for j in {1..5}
        do
            for k in {1..5}
            do
                cleos push action btc.ptokens transfer '{"from": "stakingte'$i$j$k'", "to": "stake.libre", "quantity": "0.010000000 PBTC", "memo": "contributefor:365"}' -p stakingte$i$j$k@active
            done
        done
    done
    echo "Create staking completed..."
}

swap() {
    cleos push action swap.libre transfer '["alice", "farm.libre", "3.421356237 BTCUSDD", "test farming"]' -p alice@active
    # cleos push action farm.libre withdraw '["alice", "3.421356237 BTCUSDD"]' -p alice@active
    # cleos push action reward.libre claim '["BTCUSDD", "alice"]' -p alice@active
}

create_dao_proposal() {    
    cleos push action dao.libre create '{"creator": "stakingte111", "receiver": "stakingte111", "name": "bigdeal", "title": "testing", "detail": "more info", "amount": "10.0000 LIBRE", "url": "test"}' -p stakingte111@active
    cleos push action eosio.token transfer '{"from": "stakingte111", "to": "dao.libre", "quantity": "3.000000000 PBTC", "memo": "payment:bigdeal"}' -p stakingte111@active
}

vote_for_dao_proposal() {
    cleos push action dao.libre votefor '{"voter": "stakingte112", "proposal": "bigdeal"}' -p stakingte112@active
}

init() {
    echo "Initializing contracts..."
    register_bps
    create_accounts
    fund_custom_accounts
    add_eosio_code
    setup_permission
    fully_create_aux_accounts
    stake_for
    vote_producers
    add_referrals
    init_staking_contract
    init_reward_contract
    # TODO: fix init_dao_contract
    sleep 1
    contribute_for
    setup_swap
    swap
    echo "Contracts are initialized"
}

init