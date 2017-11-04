#!/usr/bin/en sh
DATA=Users/haoyuguo/Desktop/mall_dataset/frames
rm -rf $DATA/img_train_lmdb
Users/haoyuguo/caffe/build/tools/convert_imageset --shuffle \
--resize_height=256 --resize_width=256 \
/Users/haoyuguo/Desktop/mall_dataset/frames/ $DATA/train.txt $DATA/img_train_lmdb

