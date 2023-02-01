LATEST_TAG ?= latest
IMAGE_NAME=phoenix-local
DOCKER_REGISTRY=eoscostarica506
VERSION ?= $(shell git rev-parse --short HEAD)

run: ##@devops Run the docker image
	# make -B build-docker
	make -B genesis
	make -B bp2
	make -B bp3
	make -B bp4
	make -B bp5

genesis:
	@docker-compose stop genesis
	@docker-compose up -d --build genesis
	@echo "done genesis"

bp2:
	@docker-compose stop bp2
	@docker-compose up -d --build bp2
	@echo "done bp2"

bp3:
	@docker-compose stop bp3
	@docker-compose up -d --build bp3
	@echo "done bp3"

bp4:
	@docker-compose stop bp4
	@docker-compose up -d --build bp4
	@echo "done bp4"

bp5:
	@docker-compose stop bp5
	@docker-compose up -d --build bp5
	@echo "done bp5"

build-docker: ##@devops Build the docker image
build-docker: ./Dockerfile
	echo "Building docker container ..."
	$(eval -include .env)
	@echo $(SSH_PRIVATE_KEY)
	@docker build \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME) \
		-t $(DOCKER_REGISTRY)/$(IMAGE_NAME) \
		.

stop:
	@docker-compose stop