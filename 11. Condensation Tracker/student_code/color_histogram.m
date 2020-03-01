function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)
%inputs: xmin bbox,ymin bbox,xmax bbox,ymax bbox,hist_bin);
heightFrame = size(frame,1);
widthFrame = size(frame,2);

%attention: if the bounding box is outside the frame, we have to cut it
xMin = round(max(1,xMin)); %no less than 1
yMin = round(max(1,yMin)); %no less than 1
xMax = round(min(xMax,widthFrame)); %no more than width frame
yMax = round(min(yMax,heightFrame)); %no more than height frame

%imhist function creates a histogram plot by defining n equally spaced bins
%the first parameter is the selected bbox
%the return value is the count
[yRed, x] = imhist(frame(yMin:yMax , xMin:xMax , 1), hist_bin);
[yGreen, ~] = imhist(frame(yMin:yMax , xMin:xMax , 2), hist_bin);
[yBlue, ~] = imhist(frame(yMin:yMax , xMin:xMax , 3), hist_bin);

hist = [yRed; yGreen; yBlue];
%divide for 255
hist = hist/sum(hist);

end

