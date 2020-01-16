#!/usr/bin/env bash
{% set p = inventory.parameters %}

docker run --rm -it --entrypoint /bin/sh	\
	-w /kapitan															\
	-v `pwd`:/kapitan												\
  {{ p.runtime.image }}                   \
	-c "$*"

