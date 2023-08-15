# Libre Testnet Local Network

## Description

Libre Local provides a quick way to setup a Local Testnet network for development.
The primary benefits of containers are consistency across different environments and deployment ease.

## Why to use a local environment?

A local environment provides a series of benefits that you cannot in a public network, for example, with Libre Local, transaction costs are avoided since they are carried out in a development environment and not in production, also, they are access to system contracts to modify them as appropriate.

In a Blockchain network every transaction creates an immutable record and everything that is modified can affect both positively and negatively the users within it, for this reason it is essential to have an environment premises where functionality tests, performance tests, stress tests, among others, can be carried out without the risk of producing a failures that can affects users.

Finally, a factor to consider is the initial reduced time in configuration of any network, this image allows directly, with only two commands to have the network installed and ready to perform functionality tests as necessary.

## Contracts

The AntelopeIO image is based on the `eosio.system`, `eosio.token` and `eosio.msig` contracts for its configuration. The code can be found at [this link](https://github.com/AntelopeIO/reference-contracts/tree/main/contracts).

1. **eosio.system**: Defines the structures and actions needed for blockchain's core functionality.
2. **eosio.token**: Defines the structures and actions that allow users to create, issue, and manage tokens for AntelopeIO-based blockchains.
3. **eosio.msig**: Allows the creation of proposed transactions that require authorization from a list of accounts.

### Prerequisites

- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/en/)
- [Docker](https://www.docker.com/)
- [Leap](https://github.com/AntelopeIO/leap/releases/tag/v4.0.4)
- [Make](https://www.gnu.org/software/make/)

## Get started

- Create you `.env` by running `cp .env.example .env`
- Start the network with `make pull-docker-images && source run.sh create_wallet && source run.sh genesis && source run.sh start_network bp 3`. This will download the images if you don't have them and start the network
- Run the command `cleos get info` or check the link in the browser `http://127.0.0.1:8888/v1/chain/get_info`

If you run the command `cleos get info` or go to `http://127.0.0.1:8888/v1/chain/get_info` and if the information you received is like the following then you are ready to go.

```sh
{
    "server_version":"e57a1eab","chain_id":"981453d176ddca32aa278ff7b8af9bf4632de00ab49db273db03115705d90c5a","head_block_num":66,"last_irreversible_block_num":65,"last_irreversible_block_id":"00000041fcc36403c71cebfc95810f610412b474f60735639fcaa2d241fe5ffa","head_block_id":"00000042a08478812c642d311f5ff22b9212559eeb9ee1042925742d8b46dd7f","head_block_time":"2021-07-08T05:48:45.500","head_block_producer":"eosio","virtual_block_cpu_limit":213407,"virtual_block_net_limit":1118998,"block_cpu_limit":199900,"block_net_limit":1048576,"server_version_string":"v2.0.12","fork_db_head_block_num":66,"fork_db_head_block_id":"00000042a08478812c642d311f5ff22b9212559eeb9ee1042925742d8b46dd7f","server_full_version_string":"v2.0.12-e57a1eab619edffc25afa7eceb05a01ab575c34a"
}
```

**Note:** As it is a quick start, you can use the `.env.example` file with the key there provided.

> Don't use these keys in production environments, since they are public and it's just to start easily. Also consider that you will need to import your `own keys` to your wallet or the one provided in the `.env.example` file.

## Instructions for compiling Libre Local Network image locally

To create the Docker image locally, you must run the following commands:

- Clone the local Eos repository `https://github.com/edenia/libre-local`
- Enter to the cloned repository folder `cd <path/libre-local>`
- Create your `.env` file `cp .env.example .env`
- Run the Dockerfile image `make build-docker-images && source run.sh create_wallet && source run.sh genesis && source run.sh start_network bp 3`, this will use the Dockerfiles to build the images and start the network according to the information in the nodes directory.
- Run the command `cleos get info` or check the link in the browser `http://127.0.0.1:8888/v1/chain/get_info`

In this point, you already have the Libre Local Network image running locally.

If you wish to use the Smart Contracts currently running on Libre Mainnet or Libre Testnet, you can use the following command in the root folder of the repository to set them up:

```sh
./scripts/contracts.sh
```

> **Note:** To run a modified version of the contracts, you can update them, get the wasm and put them in the `./wasm` folder with their respective contract name, reset the network and run the previous command.

## Setup Network

### Only the first time

1. Create a working wallet

```sh
source run.sh create_wallet
```

2. Create a docker network for the containers

```sh
source run.sh create_network
```

### On every new working session

1. Unlock the working wallet

```sh
source run.sh unlock_wallet
```

2. Start genesis node

```sh
source run.sh genesis
```

3. Start peering nodes `source run.sh start_network <bp_label> <total_bps>`

```sh
source run.sh start_network bp 5
```

4. Setup the network witht the current official Libre Contracts

```sh
./scripts/contracts.sh
```

## File structure

```text title="./libre-local"
/
.
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── approve.json
├── makefile
├── nodes
│   ├── bp
│   └── genesis
├── run.sh
├── scripts
│   ├── contracts.sh
│   └── optional.sh
└── wasm
    ├── dao-contract
    ├── inscription-contract
    ├── libre-referrals
    ├── ordinals-contract
    ├── staking-contract
    ├── swap-contract
    └── system-contracts
```

## Contributing

If you want to contribute to this repository, please follow the steps below:

1. Fork the project
2. Create a new branch (`git checkout -b feat/sometodo`)
3. Commit changes (`git commit -m '<type>(<scope>): <subject>'`)
4. Push the commit (`git push origin feat/sometodo`)
5. Open a Pull Request

Read the EOS Costa Rica open source [contribution guidelines](https://guide.eoscostarica.io/docs/open-source-guidelines/) for more information on scheduling conventions.

If you find any bugs, please report them by opening an issue at [this link](https://github.com/edenia/libre-local/issues).

## What is AntelopeIO?

AntelopeIO is a highly performant open-source blockchain platform, built to support and operate safe, compliant, and predictable digital infrastructures.

<span align="center">

<a href="https://edenia.com"><img width="400" alt="image" src="https://raw.githubusercontent.com/edenia/.github/master/.github/workflows/images/edenia-logo.png"></img></a>

[![Twitter](https://img.shields.io/twitter/follow/EdeniaWeb3?style=for-the-badge)](https://twitter.com/EdeniaWeb3)
![Discord](https://img.shields.io/discord/946500573677625344?color=black&label=discord&logo=discord&logoColor=white&style=for-the-badge)

Edenia runs independent blockchain infrastructure and develops web3 solutions. Our team of technology-agnostic builders has been operating since 1987, leveraging the newest technologies to make the internet safer, more efficient, and more transparent.

[edenia.com](https://edenia.com)
</span>
