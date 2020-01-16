#!/usr/bin/env bash

docker run --rm -it --entrypoint /bin/sh	\
	-w /kapitan															\
	-v `pwd`:/kapitan												\
  kapitan-apstra:latest                   \
	-c "$*"
