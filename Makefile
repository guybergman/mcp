.PHONY: build-docker push-docker delete-docker docker login test

DOCKER_REGISTRY ?= ger-is-registry.caas.intel.com
IMAGE_SERVER ?= $(DOCKER_REGISTRY)/fw-common/snic-images/mcp/mariadb-mcp

BUILD_DATE = $(shell date -u -Idate)
COMMIT_SHA = $(shell git rev-parse --short=8 HEAD)
DOCKER_TAG = $(BUILD_DATE)_$(COMMIT_SHA)
DOCKER_IMAGE ?= $(IMAGE_SERVER):$(DOCKER_TAG)
LATEST_IMAGE ?= $(IMAGE_SERVER):latest

$(info == Building with the following configuration:)
$(info DOCKER_REGISTRY:  $(DOCKER_REGISTRY))
$(info BUILD_DATE:       $(BUILD_DATE))
$(info DOCKER_TAG:       $(DOCKER_TAG))

login:
	docker login $(DOCKER_REGISTRY)

build-docker: Dockerfile
	docker build --pull -t $(DOCKER_IMAGE) .

push-docker:
	docker tag $(DOCKER_IMAGE) $(LATEST_IMAGE)
	docker push $(DOCKER_IMAGE)
	docker push $(LATEST_IMAGE)

delete-docker:
	docker rmi -f $(shell docker images -f=reference="$(DOCKER_IMAGE)" -q)

docker: build-docker

test: build-docker delete-docker
