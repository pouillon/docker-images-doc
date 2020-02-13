#
# Makefile for the Docker images to produce documentation on Debian
#

all all_targets default: doc-debian

doc-debian: debian/Dockerfile debian/packages.txt debian/requirements.txt
	cd debian && docker build --no-cache -t doc-debian:latest .
	docker tag doc-debian:latest pouillon/doc:debian-latest

upload:
	docker push pouillon/doc:debian-latest

clean:
	@echo "Nothing to do."

.PHONY: all all_targets clean default doc-debian upload
