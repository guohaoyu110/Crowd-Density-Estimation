# Crowd-Density-Estimation
## 复现过程:

首先当然是准备数据集，我没有用论文作者的shanghaitech数据集，准备了malldataset数据集，反正都是大同小异啦。这篇文章的label有一点区别的就是它不是像很多分类的问题一样是0 1 啥的，而是整张图像，这还是我第一次遇到这样的问题，还是蛮新鲜的。

malldataset数据集下载

然后参见人群密度估计之MCNN密度图的生成，在MATLAB上写了程序：

```
clear; 
load('perspective_roi.mat'); 
load('mall_gt.mat'); 
 
m=480;n=640; 
m=m/4; 
n=n/4; 
mask = imresize(roi.mask,0.25);  %图像缩小4倍
for i=1:2000  %2000幅图像
   gt = frame{i}.loc; %第一个frame结构体的loc字段
   gt = gt/4; 
   d_map = zeros(m,n); 
   for j=1:size(gt,1) 
       ksize = ceil(25/sqrt(pMapN(floor(gt(j,2)),1)));
       ksize = max(ksize,7); 
       ksize = min(ksize,25); 
       radius = ceil(ksize/2); 
       sigma = ksize/2.5; 
       h = fspecial('gaussian',ksize,sigma); 
       x_ = max(1,floor(gt(j,1))); 
       y_ = max(1,floor(gt(j,2))); 
       if (x_-radius+1<1) 
              for ra = 0:radius-x_-1 
                   h(:,end-ra) = h(:,end-ra)+h(:,1); 
                   h(:,1)=[]; 
              end 
       end 
       if (y_-radius+1<1) 
           for ra = 0:radius-y_-1 
               h(end-ra,:) = h(end-ra,:)+h(1,:); 
               h(1,:)=[]; 
           end 
       end 
      if (y_-radius+1<1) 
           for ra = 0:radius-y_-1 
               h(end-ra,:) = h(end-ra,:)+h(1,:); 
               h(1,:)=[]; 
           end 
       end 
       if (x_+ksize-radius>n) 
           for ra = 0:x_+ksize-radius-n-1 
               h (:,1+ra) = h(:,1+ra)+h(:,end); 
               h(:,end) = []; 
           end 
       end 
       if(y_+ksize-radius>m) 
            for ra = 0:y_+ksize-radius-m-1 
                h (1+ra,:) = h(1+ra,:)+h(end,:); 
                h(end,:) = []; 
            end 
       end 
          d_map(max(y_-radius+1,1):min(y_+ksize-radius,m),max(x_-radius+1,1):min(x_+ksize-radius,n))... 
             = d_map(max(y_-radius+1,1):min(y_+ksize-radius,m),max(x_-radius+1,1):min(x_+ksize-radius,n))... 
              + h; 
   end 
 map0_255 = Normalize(d_map)
% %方法1，保存为图片，再转为LMDB 
% %把数组A中的数转换成字符串表示形式
str=num2str(i,'./density/seq_%06d.jpg'); 
%imwrite(d_map,str); 
 imshow( map0_255); 
%方法2，直接转为HDF5 
%  trainLabels=permute(d_map,[2 1]); 
%  str=num2str(i,'./density_map/seq_%06d.h5'); 
%   h5create(str,'/label',size(trainLabels),'Datatype','double'); 
%   h5write(str,'/label',trainLabels); 
 
end 
```
 
 
最后得到的图像规到0-255后输出为：

说明：在pMapN中存的是透视变化的加权值，Roi表示在图像中定义的ROI区域，mask掩码可以实现只对ROI区域操作。

 

我用的深度学习框架是caffe。提取label是整个实验完成的第一关，前面说了，这个实验比较特殊，label是整张图像。一开始考虑用hdf5传输数据，然而事实证明速度太慢，所以就考虑用两个lmdb，一个装数据，另一个装label，只需要模仿着tools/convert_imageset.cpp 写一个data和label分开存放到两个LMDB里的代码，训练的时候用两个data layer读两个LMDB。


## 测试阶段:

这里为了加速模型的收敛，我进行了减均值和归一化操作。由于数据集只有2000，并不像imagenet那样的大数据，为了提高泛化能力，适应不同的数据集，我这里的均值没有取2000个图片的均值，而是直接设置为127.5，归一化则除以128。

最终的测试程序如下：

```
clear;clc;  
addpath('/home/caffe/matlab');  
caffe.reset_all();  
  
caffe.set_device(0);  
caffe.set_mode_gpu();  
  
model = 'deploy.prototxt';  
weights = 'network.caffemodel';  
net = caffe.Net(model, weights, 'test');  
  
cropImg=imread('IMG_12.jpg');  //cropImg是图像裁剪
  
cropImg = cropImg(:, :, [3, 2, 1]);  
cropImg = permute(cropImg, [2, 1, 3]);  //permute(多维数组，[维数的组合])  
cropImg = single(cropImg);  
  
cropImg=imresize(cropImg,[480 640]);  
cropImg=(cropImg-127.5)/128;  
  
res = net.forward({cropImg});  
figure,imshow(cropImg,[]);  
figure,imagesc(res{1,1});  
count = sum(sum(res{1,1}))  
caffe.reset_all();  
```