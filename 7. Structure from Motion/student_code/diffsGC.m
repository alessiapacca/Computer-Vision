function diffs = diffsGC(img1, img2, dispRange)

% get data costs for graph cut
img1 = double(img1);
img2 = double(img2);

%window size
w = 50;

%initialize values
[m,n] = size(img1);
[q,r] = size(dispRange);

%intialize the final matrix mxnxr
finalmatrix = zeros(m,n,r);
index = 1;

%filter
boxfilter = fspecial('average', w);
start = dispRange(1);
finish = dispRange(end);

%here it computes and saves the SSD for every disparity
for d=start:finish 
    shift = shiftImage(img2, d);
    
    ssd = (img1 - shift).^2;
    ssd = conv2(ssd, boxfilter, 'same');
    
    finalmatrix(:,:,index) = ssd;
    index = index + 1;
end
diffs = finalmatrix;
end
