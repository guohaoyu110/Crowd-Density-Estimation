# /usr/bin/env sh 
DATA=/Users/haoyuguo/Desktop/mall_dataset/frames
echo "Create train.txt..."
rm -rf $DATA/train.txt # 删除train.txt这个文件
find $DATA -name *.jpg>>$DATA/train.txt
cat $DATA/train.txt
echo "Done.."

