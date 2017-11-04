NETWORK="MCNN"
DATASET="Part_B"
GPU_LIST="0,1"

SOLVER="network/$DATASET/$NETWORK/solver.prototxt"
CAFFE="../caffe/build/tools/caffe"
LOG="log/$DATASET/MCNN_c.log"
SNAPSHOT="trainedmodel/$DATASET/MCNN/MCNN_iter_230000.solverstate"
WEIGHT1="trainedmodel/$DATASET/pretrain1/pretrain1_iter_1500000.caffemodel"
WEIGHT2="trainedmodel/$DATASET/pretrain2/pretrain2_iter_1500000.caffemodel"
WEIGHT3="trainedmodel/$DATASET/pretrain3/pretrain3_iter_1500000.caffemodel"
WEIGHTS="$WEIGHT1,$WEIGHT2,$WEIGHT3"

if [ -f $LOG ];
then
rm $LOG
fi
#$CAFFE train --solver=$SOLVER --weights=$WEIGHTS --gpu=$GPU_LIST 2>&1 | tee $LOG
$CAFFE train --solver=$SOLVER --snapshot=$SNAPSHOT --gpu=$GPU_LIST 2>&1 | tee $LOG