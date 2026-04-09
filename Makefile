# A wrapper to build neofob/openvpn docker
#
# __author__: tuan t. pham

NEOFOB_BRANCH ?=3.23
DOCKER_NAME ?=neofob/openvpn
DOCKER_TAG ?=$(NEOFOB_BRANCH)

docker:
	docker build --no-cache -t $(DOCKER_NAME):$(DOCKER_TAG) .
