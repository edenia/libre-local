LATEST_TAG ?= latest
IMAGE_NAME=phoenix-local
DOCKER_REGISTRY=eoscostarica506
VERSION ?= $(shell git rev-parse --short HEAD)

run: ##@devops Run the docker image
run:
	make -B update-contract
	make -B blockchain

blockchain:
blockchain:
	@docker-compose stop blockchain
	@docker-compose up -d blockchain
	@echo "done blockchain"

build-docker: ##@devops Build the docker image
build-docker: ./Dockerfile
	echo "Building docker container ..."
	$(eval -include .env)

	@echo $(SSH_PRIVATE_KEY)
	
	@docker build \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME) \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME) \
		.

update-contract:
	$(eval -include .env)
	@echo "Update smart contract"
	@rm -rf ./contracts
	@git clone $(REPOSITORY_URL) ./contracts/phoenix-contracts
	@cd contracts/phoenix-contracts && ./build.sh -c /usr/local/eosio.cdt