LATEST_TAG ?= latest
IMAGE_NAME=libre-node
DOCKER_REGISTRY=leister
VERSION ?= $(shell git rev-parse --short HEAD)

pull-images:
	@docker compose pull

fast-run: pull-images ##@devops Run the docker image
	@docker-compose up -d --no-build

run: ##@devops Run the docker image
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

stop:
	@docker-compose stop

build-docker:
	@docker-compose build

push-image: ##@devops Push the docker image to the registry
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION)
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME)2:$(VERSION)
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME)3:$(VERSION)
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME)4:$(VERSION)
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME)5:$(VERSION)