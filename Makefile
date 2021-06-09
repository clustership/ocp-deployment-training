IMAGE_TAG=$(shell ./tools/image-tag)
IMAGE_BRANCH_TAG=$(shell ./tools/image-tag branch)
NS ?= xymox
REPOSITORY ?= quay.io
PORT=8080:8080

IMAGE_NAME ?= vue-todos
DOCKER = docker

DOCKERFILE = Dockerfile

.PHONY: build push shell release

build-nocache: Dockerfile
	$(DOCKER) build --rm --no-cache -t $(NS)/$(IMAGE_NAME):$(IMAGE_TAG) -f $(DOCKERFILE) .

build: Dockerfile
	$(DOCKER) build -t $(NS)/$(IMAGE_NAME):$(IMAGE_TAG) -f $(DOCKERFILE) .
	$(DOCKER) tag $(NS)/$(IMAGE_NAME):$(IMAGE_TAG) $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(IMAGE_TAG)
	$(DOCKER) tag $(NS)/$(IMAGE_NAME):$(IMAGE_TAG) $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(IMAGE_BRANCH_TAG)

build-ubi8: Dockerfile
	$(DOCKER) build -t $(NS)/$(IMAGE_NAME)-ubi8:$(IMAGE_TAG) -f $(DOCKERFILE).ubi8 .
	$(DOCKER) tag $(NS)/$(IMAGE_NAME)-ubi8:$(IMAGE_TAG) $(REPOSITORY)/$(NS)/$(IMAGE_NAME)-ubi8:$(IMAGE_TAG)
	$(DOCKER) tag $(NS)/$(IMAGE_NAME)-ubi8:$(IMAGE_TAG) $(REPOSITORY)/$(NS)/$(IMAGE_NAME)-ubi8:$(IMAGE_BRANCH_TAG)

push: build
	$(DOCKER) push $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(IMAGE_TAG)
	$(DOCKER) push $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(IMAGE_BRANCH_TAG)

push-ubi8: build-ubi8
	$(DOCKER) push $(REPOSITORY)/$(NS)/$(IMAGE_NAME)-ubi8:$(IMAGE_TAG)
	$(DOCKER) push $(REPOSITORY)/$(NS)/$(IMAGE_NAME)-ubi8:$(IMAGE_BRANCH_TAG)

run:
	$(DOCKER) run --rm --name $(IMAGE_NAME) -p $(PORT) $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(IMAGE_TAG)

shell:
	$(DOCKER) run --rm --name $(IMAGE_NAME) -ti $(REPOSITORY)/$(NS)/$(IMAGE_NAME):$(IMAGE_TAG) /bin/bash

tag-latest: tag
	$(DOCKER) tag $(NS)/$(IMAGE_NAME):$(IMAGE_TAG) $(REPOSITORY)/$(NS)/$(IMAGE_NAME):latest
  
push-latest: tag-latest
	$(DOCKER) tag $(NS)/$(IMAGE_NAME):$(IMAGE_TAG) $(REPOSITORY)/$(NS)/$(IMAGE_NAME):latest
	$(DOCKER) push $(REPOSITORY)/$(NS)/$(IMAGE_NAME):latest

release: push-latest push tag build

default: build
