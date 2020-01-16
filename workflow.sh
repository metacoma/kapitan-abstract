#!/bin/sh
set -xe

./compile.sh
compiled/abstract/runtime/build.sh
compiled/abstract/runtime/run.sh lua ./check.lua
