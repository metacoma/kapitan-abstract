FROM ubuntu:bionic
RUN apt-get update && apt-get install -y luarocks git build-essential cmake libyaml-dev rapidjson-dev
RUN luarocks install rapidjson
RUN luarocks install lyaml
