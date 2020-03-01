% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)
       if size(xs,1) == 3 %if it's in homogeneous coordinates, i have to pay attention
            xs = xs./xs(3,:);
            xs = xs(1:2, :);
       end
       % 1. compute centroid
       [n,m] = size(xs);

       meansXY = mean(xs');

       % 2. shift the input points so that the centroid is at the origin
       xy_shifted = xs - meansXY';
       f = sqrt(2);
       s = mean(sqrt(sum(xy_shifted.^2)));
       T = [f/s, 0, -f*(meansXY(1)/s); 
            0, f/s,-f*(meansXY(2)/s); 
            0,0,1];

       [r,c]=size(xs);
       array_homogeneous = ones(1,c); % array of 1 with size 1*Nb_points
 
       coord_homogeneous = [xs; array_homogeneous]; % concatenate vertically to add a last row of ones

       nxs = T*coord_homogeneous;
end



