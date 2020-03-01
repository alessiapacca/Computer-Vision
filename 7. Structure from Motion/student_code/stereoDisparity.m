function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked
img1 = double(img1);
img2 = double(img2);

%choose the window size
window = 50;

%initialization of the values before entering the loop 
bestDISP = zeros(size(img1));
bestSSD = ones(size(img1)) .* 10^9;
%first of the disparities
start = dispRange(1);
%last of the disparities
finish = dispRange(end); 

%box filter
boxfilter = fspecial('average', window);

for d=start:finish 
    %shift the image 2 with the related function
    shift = shiftImage(img2, d); 
    %compute ssd
    ssd = (img1 - shift).^2;
 
    %convolve with box filter
    ssd = conv2(ssd, boxfilter, 'same');
    
    %remember the best disparity for every pixel
    mask = ssd < bestSSD;  %if ssd is minor than the best one. binary mask
    bestSSD = ssd .* mask + bestSSD .* ~mask;
    
    %best disparity
    actualDISP = mask .* d;
    bestDISP = bestDISP .* ~mask + actualDISP;
end
disp = bestDISP;
end
