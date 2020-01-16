#!/usr/bin/env bash
{% set p = inventory.parameters %}

BASE_DIR=$(dirname "$0")
echo "$BASE_DIR"

docker build -f ./${BASE_DIR}/kapitan-abstract.Dockerfile -t {{ p.runtime.image }} .
