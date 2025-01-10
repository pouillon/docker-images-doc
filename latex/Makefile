#
# Makefile for the documentation builder container
#

container_version = 2024.1
container_registry = pouillon
container_tag_version = $(container_registry)/doc-latex:$(container_version)
container_tag_latest = $(container_registry)/doc-latex:latest

container_srcs = \
  Dockerfile \
  packages-doc.txt \
  packages-system.txt \
  requirements.txt

DEBUG ?= 0
ifeq ($(DEBUG),1)
  docker_opts = --progress=plain
else
  docker_opts = --progress=auto
endif

all all_targets default: build-image

upload-image: .upload-stamp

.upload-stamp: .build-stamp
	docker push $(container_tag_version)
	docker push $(container_tag_latest)
	touch .upload-stamp

build-image: .build-stamp

.build-stamp: $(container_srcs)
	DOCKER_BUILDKIT=1 \
	  docker build $(docker_opts) --tag $(container_tag_version) .
	docker tag $(container_tag_version) $(container_tag_latest)
	touch .build-stamp

clean distclean:
	rm -f .build-stamp .upload-stamp

.PHONY: all all_targets clean default distclean build-image upload-image
