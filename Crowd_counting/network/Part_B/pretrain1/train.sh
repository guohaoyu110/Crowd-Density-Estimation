SOLVER="network/Part_B/pretrain1/solver.prototxt"
CAFFE="../caffe/build/tools/caffe"
SNAPSHOT="trainedmodel/Part_B/pretrain1/pretrain1_iter_40000.solverstate"
GPU_LIST="2,3"
LOG="log/Part_B/pretrain1.log"

if [ -f $LOG ];
then
rm $LOG
fi
$CAFFE train --solver=$SOLVER --gpu=$GPU_LIST 2>&1 | tee $LOG