#!/usr/bin/env bash

BASE_DIR=$(dirname "$0")
echo "$BASE_DIR"

docker build -f ./${BASE_DIR}/kapitan-abstract.Dockerfile -t kapitan-apstra:latest .