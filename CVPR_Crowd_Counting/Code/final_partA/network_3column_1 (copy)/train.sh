#!/usr/bin/env sh

TOOLS=../../../build/tools

$TOOLS/caffe train \
    --solver=./solver_n1_1.prototxt \
    --weights=./weight/network1_iter_1080000.caffemodel,./weight/network2_iter_1080000.caffemodel,./weight/network3_iter_2754000.caffemodel

$TOOLS/caffe train \
    --solver=./solver_n1_2.prototxt \
    --snapshot=./model/network_iter_2160000.solverstate


