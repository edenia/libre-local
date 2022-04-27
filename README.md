# Phoenix Testnet Local Network

## Description
Phoenix Testnet Local provides a quick way to setup a Local Testnet network for development.

The primary benefits of containers are consistency across different environments and deployment ease.

This project works along with a [full-stack-boilerplate](https://github.com/eoscostarica/full-stack-boilerplate) to help you build your EOS dApp.

### Why to use a local environment?
Having a local environment provides a series of benefits that you cannot in a public network, for example, with Phoenix locally, transaction costs are avoided since they are carried out in a development environment and not in production, also, they are accessed to system contracts to modify them as appropriate.

In a Blockchain network every transaction creates an immutable record and everything that is modified can affect both positively and negatively the users within it, it is for this reason that it is essential to have an environment premises where functionality tests, performance tests, stress tests, among others, can be carried out without the risk of producing a failure that affects users.

Finally, a factor to consider is the time that is reduced in the initial configuration of any network, this image allows directly, with only two commands to have the network installed and ready to perform functionality tests as necessary.

### Contracts
The EOSIO image is based on the `eosio.system`, `eosio.token` and `eosio.msig` contracts for its configuration. Your code can be found at [this link](https://github.com/EOSIO/eosio.contracts/tree/master/contracts).
1. **eosio.system**: Defines the structures and actions needed for blockchain's core functionality.
2. **eosio.token**: Defines the structures and actions that allow users to create, issue, and manage tokens for EOSIO-based blockchains.
3. **eosio.msig**: Allows the creation of proposed transactions that require authorization from a list of accounts.

### Deployable projects
As Phoenix Local Network is based on EOSIO protocol, some already smart contract production projects can be deployed on our local network due to the local dev environment setup. Some of them are:
1. Eden: Take a look at the smart contract code [here](https://github.com/eoscommunity/Eden/tree/main/contracts).
2. simpleassets: A simple standard for digital assets on EOSIO blockchains: Non-Fungible Tokens (NFTs), Fungible Tokens (FTs), and Non-Transferable Tokens (NTTs). Take a look at the smart contract code [here](https://github.com/CryptoLions/SimpleAssets).
3. atomicassets: AtomicAssets is a Non Fungible Token (NFT) standard for eosio blockchains developed by pink.network. Take a look at the smart contract code [here](https://github.com/pinknetworkx/atomicassets-contract).
4. dgoods: dGoods is an open source and free standard for handling the virtual representation of items, both digital and physical, on the EOS blockchain led by Mythical Games. Take a look at the smart contract code [here](https://github.com/MythicalGames/dgoods).

### Prerequisites
- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/en/)
- [Docker](https://www.docker.com/)
- [Eosio](https://developers.eos.io/welcome/latest/getting-started-guide/local-development-environment/index)
- [Make](https://www.gnu.org/software/make/)

## Get started
- Create you `.env` running `cp .env.example .env`
- Update your `.env` with is respective values. For `REPOSITORY_URL` assign the repository url
- Run `update-contract`. *This step make request for credentials*
- Build the smart contracts and run the blockchain `make run`
- Run the command `cleos get info` or check the link in the browser `http://127.0.0.1:8888/v1/chain/get_info`

If you run the command `cleos get info` or go to `http://127.0.0.1:8888/v1/chain/get_info` and get information like the following it is because you already have the environment ready to work.

```
{"server_version":"e57a1eab","chain_id":"981453d176ddca32aa278ff7b8af9bf4632de00ab49db273db03115705d90c5a","head_block_num":66,"last_irreversible_block_num":65,"last_irreversible_block_id":"00000041fcc36403c71cebfc95810f610412b474f60735639fcaa2d241fe5ffa","head_block_id":"00000042a08478812c642d311f5ff22b9212559eeb9ee1042925742d8b46dd7f","head_block_time":"2021-07-08T05:48:45.500","head_block_producer":"eosio","virtual_block_cpu_limit":213407,"virtual_block_net_limit":1118998,"block_cpu_limit":199900,"block_net_limit":1048576,"server_version_string":"v2.0.12","fork_db_head_block_num":66,"fork_db_head_block_id":"00000042a08478812c642d311f5ff22b9212559eeb9ee1042925742d8b46dd7f","server_full_version_string":"v2.0.12-e57a1eab619edffc25afa7eceb05a01ab575c34a"}
```

**Note:** As it is a quick start, you can use the following generated keys for `TESTNET_EOSIO_PRIVATE_KEY` and `TESTNET_EOSIO_PUBLIC_KEY`.

```
Private key: 5JZSuHernxdc6NHG2vV1XrAz61kvQmz71S473hQQdmdc4AwSP6a
Public key: EOS7tJAV8DPN5Q3byKeKzWax6BDmPbWN1i64YaDAr7g8NhPDPKcfN
```

> Don't use these keys in production environments, as it's just for easy getting started.

## Instructions for creating Phoenix Local Network image locally
To create the Docker image locally, you must run the following commands:
- Clone the local Eos repository `https://github.com/eoscostarica/phoenix-local`
- Enter to the cloned repository folder `cd <path/phoenix-local>`
- Build the Dockerfile image with env variables `make build-docker` or `docker build -t phoenix-local --build-arg testnet_eosio_public_key="<public_key>" --build-arg testnet_eosio_private_key="<private_key>" .`
- Run the Dockerfile image `make run` or `docker run -dp 8888:8888 phoenix-local`
- Run the command `cleos get info` or check the link in the browser `http://127.0.0.1:8888/v1/chain/get_info`

By this point, you already have the Phoenix Local Network image running locally.

## File structure
```text title="./phoenix-local"
/
.
├── .github
│   └── workflows
│       └── publish-docker-image.yml
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── Dockerfile ............... Contains instructions for building the Phoenix Local Network image
├── LICENSE .................. Terms and Conditions
├── README.md ................ Repository specification
├── config.ini ............... Nodeos configuration file
├── docker-compose.yaml ...... Container definition
├── docs ..................... Some media content for README
├── genesis.json ............. Specifies the network genesis node parameters
├── makefile ................. Shell commands
└── start.sh ................. Instructions for configuring contracts and usage characteristics
```

## License
MIT © [EOS Costa Rica](https://eoscostarica.io/)

## Contributing
If you want to contribute to this repository, please follow the steps below:

1. Fork the project
2. Create a new branch (`git checkout -b feat/sometodo`)
3. Commit changes (`git commit -m '<type>(<scope>): <subject>'`)
4. Push the commit (`git push origin feat/sometodo`)
5. Open a Pull Request

Read the EOS Costa Rica open source [contribution guidelines](https://guide.eoscostarica.io/docs/open-source-guidelines/) for more information on scheduling conventions.

If you find any bugs, please report them by opening an issue at [this link](https://github.com/eoscostarica/phoenix-local/issues).


## What is EOSIO?
EOSIO is a highly performant open-source blockchain platform, built to support and operate safe, compliant, and predictable digital infrastructures.

## About EOS Costa Rica
<br>
<center>
<img src="https://raw.githubusercontent.com/eoscostarica/design-assets/master/logos/eosCR/fullColor-horizontal-transparent-white.png" width="400" >
</center>
<br>

EOS Costa Rica is an independently-owned, self-funded, bare-metal Genesis block producer that provides stable and secure infrastructure for EOSIO blockchains. We support open source software for our community while offering enterprise solutions and custom smart contract development for our clients.

[eoscostarica.io](https://eoscostarica.io/)