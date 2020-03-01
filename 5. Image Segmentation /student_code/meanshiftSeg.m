function [map, peak] = meanshiftSeg(img)
img = im2double(img);  %transform input to double
[n, m, ~] = size(img);

L = n * m;
X = reshape (img, L, 3); %reshape

%initialization
r = 0.04;
map = zeros(L,1);
id = 1;

%find the first peak 
map(1,1) = 1;
peak = [findpeak(X, X(1,:), r)]; % it returns the peak point, giving him as input the first pixel

for i = 2:L
    newpeak = findpeak(X, X(i,:), r); %the i-pixel 
    dist = sqrt(sum((peak -  newpeak).^2,2));
    [mindistance, index] = min(dist); %calculate the min of the distances between the prior ones and the new peak

    if (mindistance > r/2) %ok
        peak = [peak; newpeak];
        id = id + 1;
        map(i) = id;
    else %just merge it
       map(i) = index; 
    end
end

%reshape
map = reshape(map', n,m);
end