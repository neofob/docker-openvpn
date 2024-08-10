# A wrapper to build neofob/openvpn docker
#
# __author__: tuan t. pham

NEOFOB_BRANCH ?=3.20
DOCKER_NAME ?=neofob/openvpn
DOCKER_TAG ?=$(NEOFOB_BRANCH)

docker:
	docker build -t $(DOCKER_NAME):$(DOCKER_TAG) .
