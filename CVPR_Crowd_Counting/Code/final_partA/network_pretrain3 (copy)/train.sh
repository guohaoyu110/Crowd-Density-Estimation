#!/usr/bin/env sh

TOOLS=../../../build/tools

$TOOLS/caffe train \
    --solver=./solver_n1_1.prototxt \
    --snapshot=./model/network_iter_1404000.solverstate

$TOOLS/caffe train \
    --solver=./solver_n1_2.prototxt \
    --snapshot=./model/network_iter_2160000.solverstate


