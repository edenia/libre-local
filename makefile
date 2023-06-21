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
	
	# $(call run-bp,bp,1,1,2)
	# $(call run-bp,bp,1,1,3)
	# $(call run-bp,bp,1,1,4)
	# $(call run-bp,bp,1,1,5)
	# $(call run-bp,bp,1,2,1)
	# $(call run-bp,bp,1,2,2)
	# $(call run-bp,bp,1,2,3)
	# $(call run-bp,bp,1,2,4)
	# $(call run-bp,bp,1,2,5)
	# $(call run-bp,bp,1,3,1)
	# $(call run-bp,bp,1,3,2)
	# $(call run-bp,bp,1,3,3)
	# $(call run-bp,bp,1,3,4)
	# $(call run-bp,bp,1,4,1)
	# $(call run-bp,bp,1,4,2)
	# $(call run-bp,bp,1,4,3)
	# $(call run-bp,bp,1,4,4)
	# $(call run-bp,bp,1,4,5)
	# $(call run-bp,bp,1,5,1)
	# $(call run-bp,bp,1,5,2)
	# $(call run-bp,bp,1,5,3)

genesis:
	@docker-compose stop genesis
	@docker-compose up -d --build genesis
	@echo "done genesis"

define run-bp
	@docker-compose stop $(1)$(2)$(3)$(4)
	@docker-compose up -d --build $(1)$(2)$(3)$(4)
	@echo "done $(1)$(2)$(3)$(4)"
endef

stop:
	@docker-compose stop

build-docker:
	@docker-compose build

push-image: ##@devops Push the docker image to the registry
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION)