LATEST_TAG ?= latest
IMAGE_NAME=phoenix-local
DOCKER_REGISTRY=eoscostarica506
VERSION ?= $(shell git rev-parse --short HEAD)

run: ##@devops Run the docker image
run:
	make compile
	# make -B build-docker
	make -B genesis
	make -B cryptobloksx
	make -B edeniaedenia
	make -B zenhash
	make -B zuexeuz

genesis:
genesis:
	@docker-compose stop genesis
	@docker-compose up -d --build genesis
	@echo "done genesis"

cryptobloksx:
cryptobloksx:
	@docker-compose stop cryptobloksx
	@docker-compose up -d --build cryptobloksx
	@echo "done cryptobloksx"

edeniaedenia:
edeniaedenia:
	@docker-compose stop edeniaedenia
	@docker-compose up -d --build edeniaedenia
	@echo "done edeniaedenia"

zenhash:
zenhash:
	@docker-compose stop zenhash
	@docker-compose up -d --build zenhash
	@echo "done zenhash"

zuexeuz:
zuexeuz:
	@docker-compose stop zuexeuz
	@docker-compose up -d --build zuexeuz
	@echo "done zuexeuz"

build-docker: ##@devops Build the docker image
build-docker: ./Dockerfile
	echo "Building docker container ..."
	$(eval -include .env)
	@echo $(SSH_PRIVATE_KEY)
	@docker build \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME) \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME) \
		.

update-system-contract:
	$(eval -include .env)
	@echo "Update smart contract"
	@rm -rf ./contracts/phoenix-contracts
	@git clone $(REPOSITORY_URL) ./contracts/phoenix-contracts
	@cd contracts/phoenix-contracts && ./build.sh -c /usr/local/eosio.cdt

update-staking-contract:
	$(eval -include .env)
	@echo "Update smart contract"
	@rm -rf ./contracts/staking-contract
	@git clone $(REPOSITOR_STAKING_CONTRACT_URL) ./contracts/staking-contract
	@cd contracts/staking-contract && mkdir -p build
	@cd contracts/staking-contract && eosio-cpp -I include -contract stakingtoken -o build/staking-contract.wasm src/stakingtoken.cpp

compile:
	@make compile-system-contract
	@make compile-staking-contract

compile-system-contract:
	@cd contracts/phoenix-contracts && ./build.sh -c /usr/local/eosio.cdt

compile-staking-contract:
	@cd contracts/staking-contract && mkdir -p build
	@cd contracts/staking-contract && eosio-cpp -I include -contract stakingtoken -o build/staking-contract.wasm src/stakingtoken.cpp

stop:
	@docker-compose stop