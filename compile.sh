#!/bin/bash

LOADER_ROOT=`dirname ${BASH_SOURCE[0]}`

cd ${LOADER_ROOT}

if [ ! -d pgloader ]; then
  git clone https://github.com/dimitri/pgloader.git
fi

cd pgloader

git pull

make DYNSIZE=10240

