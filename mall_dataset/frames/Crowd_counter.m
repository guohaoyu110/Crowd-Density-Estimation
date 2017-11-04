  function Crowd_counter(img,r1,r2)

    img1 = imread(img                       %read the image
    img=im2bw(img1,graythresh(img1));         %convert into binary
    imgBW = edge(img);                        %'canny' edge detection
    count=0;
    % 
    FDetect = vision.C
    ascadeObjectDetector;    %for face detection
    BB = step(FDetect,img1);                   %bounding box for face detect

    for i=r1:r2
        [ydetect,xdetect,Accumulator] = houghcircle(imgBW,i,(i*pi)); %circular hough
        y{count+1}=ydetect;                     %storing y co-ordinates
        x{count+1}=xdetect;                     %storing x co-ordinates
        count=count+1;
        i=i+1;
    end
    %%
    % $ $ $x^2+e^{\pi i}$ $ $

    disp(count);
    figure;
    imshow(img1);                          %for visualizing detected heads
    hold on;
    crowd=0;
    for j=1:count
        crowd=crowd+length(x{j});          %for counting detected heads
        plot(x{j},y{j},'.','LineWidth',2,'Color','red');
        j=j+1;
    end

    disp('Number of heads:');
    disp(crowd);
    disp('Number of faces:');
    disp(size(BB,1));
    disp('Total');
    disp(crowd+size(BB,1));