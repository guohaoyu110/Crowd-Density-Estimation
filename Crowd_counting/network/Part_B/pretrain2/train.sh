SOLVER="network/Part_B/pretrain2/solver.prototxt"
CAFFE="../caffe/build/tools/caffe"
SNAPSHOT="trainedmodel/Part_B/pretrain2/pretrain2_iter_40000.solverstate"
GPU_LIST="0,1"
LOG="log/Part_B/pretrain2.log"

if [ -f $LOG ];BB
then
rm $LOG
fi
$CAFFE train --solver=$SOLVER --gpu=$GPU_LIST 2>&1 | tee $LOG
