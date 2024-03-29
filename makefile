-include .env

LATEST_TAG ?= latest

pull-docker-images:
	@echo "Running Local Libre Chain..."
	@docker pull $(DOCKER_REGISTRY)/libre-node:$(LATEST_TAG)
	@docker pull $(DOCKER_REGISTRY)/libre-genesis-node:$(LATEST_TAG)

build-docker-images:
	@echo "Building docker containers..."

	@echo "1. genesis image..."
	@docker build -t $(DOCKER_REGISTRY)/libre-genesis-node:$(LATEST_TAG) -f ./nodes/genesis/Dockerfile ./nodes/genesis/

	@echo "2. node image..."
	@docker build -t $(DOCKER_REGISTRY)/libre-node:$(LATEST_TAG) -f ./nodes/bp/Dockerfile ./nodes/bp/

push-docker-images:
	@echo "Pushing docker containers..."

	@echo "1. Pushing genesis image..."
	@docker push $(DOCKER_REGISTRY)/libre-genesis-node:$(LATEST_TAG)

	@echo "2. Pushing node image..."
	@docker push $(DOCKER_REGISTRY)/libre-node:$(LATEST_TAG)
	