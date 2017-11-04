NETWORK="pretrain3"
DATASET="Part_A"
SOLVER="network/$DATASET/$NETWORK/solver.prototxt"
CAFFE="../caffe/build/tools/caffe"
#SNAPSHOT="trainedmodel/$DATASET/$NETWORK/$NETWORK_iter_40000.solverstate"
GPU_LIST="0,1"
LOG="log/$DATASET/$NETWORK.log"

if [ -f $LOG ];
then
rm $LOG
fi
$CAFFE train --solver=$SOLVER --gpu=$GPU_LIST 2>&1 | tee $LOG
