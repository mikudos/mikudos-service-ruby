#!/bin/bash
PROTOPATH=$PWD/proto
PROTOPROJ=language_master_protos
pushd ../$PROTOPROJ
echo "update proto files in: $(pwd)"
git pull
sleep 1
cp -r ./proto/* $PROTOPATH
popd
tree ./proto/
echo "proto files are up to date!"