#!/bin/bash
set -ex

if [ -f .env ]; then
    export $(cat .env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

CUSTOM_ACCOUNTS=(alice bob pip bitcoinlibre)
MAIN_ACCOUNTS=(stake.libre farm.libre reward.libre dao.libre)
BLOCK_PRODUCERS=($(ls secrets/*.priv | cut -d. -f1 | xargs -n 1 basename))
BLOCK_PRODUCERS_KEYS=($(cat secrets/*.pub))

register_bps() {
    # TODO: check lenght of bps <= lenght of keys
    for (( i = 0; i < ${#BLOCK_PRODUCERS[@]}; i++ )); do
        cleos create account eosio "${BLOCK_PRODUCERS[$i]}" ${BLOCK_PRODUCERS_KEYS[$i]}
        cleos push action eosio.libre setperm '{"acc": '"${BLOCK_PRODUCERS[$i]}"', "perms": [["createacc",1],["regprod",1]]}' -p eosio.libre@active
        cleos push action eosio regproducer '{"producer": '"${BLOCK_PRODUCERS[$i]}"', "producer_key": '"${BLOCK_PRODUCERS_KEYS[$i]}"', "url": "http://producer.com", "location": 123}' -p ${BLOCK_PRODUCERS[$i]}@active
    done
}

vote_producers() {
    echo "Start voting for producers..."
    i=1
    j=1

    for producer in ${BLOCK_PRODUCERS[@]}
    do
        cleos push action eosio voteproducer '{"voter": "libreacco1'$i$j'", "producers": ['$producer']}' -p libreacco1$i$j@active

        j=$((j+1))

        # Reset the iterator if it reaches 6
        if [ $j -eq 6 ]; then
            j=1
            i=$((i+1))
        fi
    done
    echo "Finish  voting for producers..."
}

create_account() {
    if [ "$#" -eq 2 ]; then
        pk2=$2
    else
        pk2=$3
    fi
    
    account=$1
    pk=$2

    cleos create account eosio "$account" "$pk" "$pk2"
    cleos push action eosio setalimits '{"authorizer": "eosio", "account": '"$account"', "ram": 10000000, "net": 2000, "cpu": 2000}' -p eosio@active
}

create_accounts() {
    echo "Start create accounts..."
    for account in ${CUSTOM_ACCOUNTS[*]}; do
        create_account $account $DEFAULT_PUBLIC_KEY
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
    cleos push action accts.libre add '{"approver": "alice", "account": "libreacco111", "referrer": "alice"}' -p alice@active
    cleos push action accts.libre add '{"approver": "alice", "account": "libreacco112", "referrer": "alice"}' -p alice@active
    cleos push action accts.libre add '{"approver": "alice", "account": "libreacco113", "referrer": "alice"}' -p alice@active
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
                cleos create account eosio libreacco$i$j$k $DEFAULT_PUBLIC_KEY
                cleos push action eosio setalimits '{"authorizer": "eosio", "account": '"libreacco$i$j$k"', "ram": 9000000, "net": 2000, "cpu": 2000}' -p eosio@active

                # fund account
                cleos push action eosio.token transfer '{"from": "eosio", "to": "libreacco'$i$j$k'", "quantity": "100.0000 LIBRE", "memo": "funding LIBRE"}' -p eosio@active
                cleos push action btc.ptokens transfer '{"from": "eosio", "to": "libreacco'$i$j$k'", "quantity": "100.000000000 PBTC", "memo": "funding PBTC"}' -p eosio@active
                cleos push action usdt.ptokens transfer '{"from": "eosio", "to": "libreacco'$i$j$k'", "quantity": "100.000000000 PUSDT", "memo": "funding PUSDT"}' -p eosio@active
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
    cleos push action dao.libre setparams '{"funding_account": "dao.libre", "vote_threshold": 3, "voting_days": 1, "minimum_vp_to_create_proposals": 10, "proposal_cost": "5.0000 LIBRE", "approver": "dao.libre"}' -p dao.libre@active
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
    $CLEOS push action swap.libre inittoken '["'"$YOUR_ACCOUNT"'", "9,BTCUSD", {"contract":"'"$BTCCONTRACT"'", "quantity":"1.000000000 '"$BTCSYMBOL"'"}, {"contract":"'"$USDCONTRACT"'", "quantity":"20000.000000000 '"$USDSYMBOL"'"}, 10, "sfee.libre"]' -p $YOUR_ACCOUNT -p swap.libre
}

stake_for() {
    echo "Create staking..."
    for i in {1..5}
    do
        for j in {1..5}
        do
            for k in {1..5}
            do
                cleos push action eosio.token transfer '{"from": "libreacco'$i$j$k'", "to": "stake.libre", "quantity": "10.0000 LIBRE", "memo": "stakefor:365"}' -p libreacco$i$j$k@active
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
                cleos push action btc.ptokens transfer '{"from": "libreacco'$i$j$k'", "to": "stake.libre", "quantity": "0.010000000 PBTC", "memo": "contributefor:365"}' -p libreacco$i$j$k@active
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
    # proposal 1
    cleos push action dao.libre create '{"creator": "libreacco111", "receiver": "alice", "name": "librelocal", "title": "testing", "detail": "more info", "amount": "100.0000 LIBRE", "url": "libre.org"}' -p libreacco111@active
    cleos push action eosio.token transfer '{"from": "libreacco111", "to": "dao.libre", "quantity": "5.0000 LIBRE", "memo": "payment:librelocal"}' -p libreacco111@active

    # proposal 2
    cleos push action dao.libre create '{"creator": "libreacco112", "receiver": "alice", "name": "librelocal2", "title": "testing", "detail": "more info", "amount": "100.0000 LIBRE", "url": "libre.org"}' -p libreacco112@active
    cleos push action eosio.token transfer '{"from": "libreacco112", "to": "dao.libre", "quantity": "5.0000 LIBRE", "memo": "payment:librelocal2"}' -p libreacco112@active

    # proposal 3
    cleos push action dao.libre create '{"creator": "libreacco113", "receiver": "alice", "name": "librelocal3", "title": "testing", "detail": "more info", "amount": "100.0000 LIBRE", "url": "libre.org"}' -p libreacco113@active
    cleos push action eosio.token transfer '{"from": "libreacco113", "to": "dao.libre", "quantity": "5.0000 LIBRE", "memo": "payment:librelocal3"}' -p libreacco113@active

    # proposal 4
    cleos push action dao.libre create '{"creator": "libreacco114", "receiver": "alice", "name": "librelocal4", "title": "testing", "detail": "more info", "amount": "100.0000 LIBRE", "url": "libre.org"}' -p libreacco114@active
    cleos push action eosio.token transfer '{"from": "libreacco114", "to": "dao.libre", "quantity": "5.0000 LIBRE", "memo": "payment:librelocal4"}' -p libreacco114@active

    # proposal 5
    cleos push action dao.libre create '{"creator": "libreacco115", "receiver": "alice", "name": "librelocal5", "title": "testing", "detail": "more info", "amount": "100.0000 LIBRE", "url": "libre.org"}' -p libreacco115@active
    cleos push action eosio.token transfer '{"from": "libreacco115", "to": "dao.libre", "quantity": "5.0000 LIBRE", "memo": "payment:librelocal5"}' -p libreacco115@active
}

vote_for_dao_proposal() {
    cleos push action dao.libre votefor '{"voter": "libreacco111", "proposal": "librelocal4"}' -p libreacco111@active
    cleos push action dao.libre votefor '{"voter": "libreacco112", "proposal": "librelocal4"}' -p libreacco112@active
    cleos push action dao.libre votefor '{"voter": "libreacco113", "proposal": "librelocal4"}' -p libreacco113@active
    cleos push action dao.libre votefor '{"voter": "libreacco114", "proposal": "librelocal4"}' -p libreacco114@active
    cleos push action dao.libre votefor '{"voter": "libreacco115", "proposal": "librelocal4"}' -p libreacco115@active
    cleos push action dao.libre votefor '{"voter": "libreacco121", "proposal": "librelocal4"}' -p libreacco121@active
    cleos push action dao.libre votefor '{"voter": "libreacco122", "proposal": "librelocal4"}' -p libreacco122@active
    cleos push action dao.libre votefor '{"voter": "libreacco123", "proposal": "librelocal4"}' -p libreacco123@active
    cleos push action dao.libre votefor '{"voter": "libreacco124", "proposal": "librelocal4"}' -p libreacco124@active
    cleos push action dao.libre votefor '{"voter": "libreacco125", "proposal": "librelocal4"}' -p libreacco125@active
    cleos push action dao.libre votefor '{"voter": "libreacco131", "proposal": "librelocal4"}' -p libreacco131@active
    cleos push action dao.libre votefor '{"voter": "libreacco132", "proposal": "librelocal4"}' -p libreacco132@active
    cleos push action dao.libre votefor '{"voter": "libreacco133", "proposal": "librelocal4"}' -p libreacco133@active
    cleos push action dao.libre votefor '{"voter": "libreacco134", "proposal": "librelocal4"}' -p libreacco134@active
    cleos push action dao.libre votefor '{"voter": "libreacco135", "proposal": "librelocal4"}' -p libreacco135@active
    cleos push action dao.libre votefor '{"voter": "libreacco141", "proposal": "librelocal4"}' -p libreacco141@active
    cleos push action dao.libre votefor '{"voter": "libreacco142", "proposal": "librelocal4"}' -p libreacco142@active
    cleos push action dao.libre votefor '{"voter": "libreacco143", "proposal": "librelocal4"}' -p libreacco143@active
    cleos push action dao.libre votefor '{"voter": "libreacco144", "proposal": "librelocal4"}' -p libreacco144@active
    cleos push action dao.libre votefor '{"voter": "libreacco145", "proposal": "librelocal4"}' -p libreacco145@active
    cleos push action dao.libre votefor '{"voter": "libreacco151", "proposal": "librelocal4"}' -p libreacco151@active
    cleos push action dao.libre votefor '{"voter": "libreacco152", "proposal": "librelocal4"}' -p libreacco152@active
    cleos push action dao.libre votefor '{"voter": "libreacco153", "proposal": "librelocal4"}' -p libreacco153@active
    cleos push action dao.libre votefor '{"voter": "libreacco154", "proposal": "librelocal4"}' -p libreacco154@active
    cleos push action dao.libre votefor '{"voter": "libreacco155", "proposal": "librelocal4"}' -p libreacco155@active
}

setup_board() {
    AUTHORITY='{"threshold": 2, "keys": [], "accounts":[{"permission":{"actor": "alice", "permission":"active"}, "weight": 1}, {"permission":{"actor": "bob", "permission":"active"}, "weight": 1}, {"permission":{"actor": "pip", "permission":"active"}, "weight": 1}], "waits": [] }'
    create_account "board.libre" $DEFAULT_PUBLIC_KEY
    cleos set account permission "board.libre" active "$AUTHORITY" owner -p board.libre@owner
    cleos set account permission "board.libre" owner "$AUTHORITY" -p board.libre@owner
}

udpate_multisig_permissions() {
    AUTHORITY='{"threshold": 1, "keys": [], "accounts":[{"permission":{"actor": "board.libre", "permission":"active"}, "weight": 1}], "waits": [] }'
    AUTHORITY2='{"threshold": 1, "keys": [], "accounts":[{"permission":{"actor": "board.libre", "permission":"active"}, "weight": 1}, {"permission":{"actor": "stake.libre", "permission":"eosio.code"}, "weight": 1}], "waits": [] }'
    cleos set account permission "stake.libre" owner "$AUTHORITY" -p stake.libre@owner
    cleos set account permission "stake.libre" active "$AUTHORITY2" owner -p stake.libre@owner

    AUTHORITY_DAO='{"threshold": 1, "keys": [], "accounts":[{"permission":{"actor": "eosio.prods", "permission":"active"}, "weight": 1}], "waits": [] }'
    AUTHORITY_DAO2='{"threshold": 1, "keys": [], "accounts":[{"permission":{"actor": "dao.libre", "permission":"eosio.code"}, "weight": 1}, {"permission":{"actor": "eosio.prods", "permission":"active"}, "weight": 1}], "waits": [] }'
    cleos set account permission "dao.libre" active "$AUTHORITY_DAO2" owner -p dao.libre@owner
    cleos set account permission "dao.libre" owner "$AUTHORITY_DAO" -p dao.libre@owner

    # cleos push action eosio.msig approve '{"proposer": "alice", "proposal_name": "prop3", "level": {"actor": "alice", "permission":"active"}}' -p alice@active
    # cleos push action eosio.msig approve '{"proposer": "alice", "proposal_name": "prop3", "level": {"actor":"bob","permission":"active"}}' -p bob@active
    # cleos push action eosio.msig approve '{"proposer": "alice", "proposal_name": "prop3", "level": {"actor":"pip","permission":"active"}}' -p pip@active

    # cleos push action eosio.msig exec '{"proposer": "alice", "proposal_name": "prop3", "executer": "alice"}' -p alice@active
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
    init_dao_contract
    create_dao_proposal
    vote_for_dao_proposal
    sleep 1
    contribute_for
    setup_swap
    swap
    setup_board
    udpate_multisig_permissions

    echo "Contracts are initialized"
}

init