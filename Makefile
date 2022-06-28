.PHONY: build

CONDA_VERSION := 4.12.0
MINIDEB_VERSION := bullseye

build:
	docker build \
		--build-arg CONDA_VERSION=${CONDA_VERSION} \
		--build-arg MINIDEB_VERSION=${MINIDEB_VERSION} \
		-t slim-pkgs:latest \
		.

test: build
	docker run --rm -it slim-pkgs:latest /bin/bash
