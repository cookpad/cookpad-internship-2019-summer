#!/bin/sh
origin_dir=`pwd`
cd `dirname $0`
yarn
yarn generate
cd $origin_dir
