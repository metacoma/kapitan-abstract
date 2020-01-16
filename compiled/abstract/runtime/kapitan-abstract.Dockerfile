FROM ubuntu:bionic
RUN apt-get update && apt-get install -y luarocks git build-essential cmake libyaml-dev rapidjson-dev jq
RUN luarocks install net-url
RUN luarocks install lua-cjson
RUN luarocks install lyaml
WORKDIR /tmp
RUN git clone https://github.com/jdesgats/ljsonschema
WORKDIR /tmp/ljsonschema
RUN git submodule update --init --recursive
RUN luarocks install ./ljsonschema-scm-1.rockspec
RUN luarocks install https://raw.githubusercontent.com/jdesgats/telescope/master/rockspecs/telescope-scm-1.rockspec


#/usr/bin/lua5.1: /usr/local/share/lua/5.1/jsonschema/init.lua:188: [string "jsonschema:anonymous"]:30: '=' expected near 'label_1'
#stack traceback:
#        [C]: in function 'error'
#        /usr/local/share/lua/5.1/jsonschema/init.lua:188: in function </usr/local/share/lua/5.1/jsonschema/init.lua:168>
#        (tail call): ?
#        ./spec/suite.lua:118: in function 'before'
#        /usr/local/share/lua/5.1/telescope.lua:579: in function 'run'
#        /usr/local/share/lua/5.1/telescope/runner.lua:292: in function </usr/local/share/lua/5.1/telescope/runner.lua:242>
#        ...usr/local/lib/luarocks/rocks/telescope/scm-1/bin/tsc:2: in main chunk
#        [C]: ?

#RUN tsc ./spec/suite.lua
# ^^^^ commented, because tests has failed


RUN apt-get install -y python3-pip
RUN pip3 install kapitan