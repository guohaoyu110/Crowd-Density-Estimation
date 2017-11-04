if [ -f ../../../log/Part_A/pretrain2.log ];
then
rm ../../../log/Part_A/pretrain2.log
fi

../caffe/build/tools/caffe train     --solver=network/Part_A/pretrain3/solver.prototxt     --gpu=0,1     2>&1 | tee log/Part_A/pretrain3.log
