%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization

% 1. compute centroid
[m,n] = size(xy)
[M,N] = size(XYZ)


%compute centroid for both xy and XYZ points
xy_centroid = [sum(xy')]/n;
XYZ_centroid = [sum(XYZ')]/n;


%shift the input points so that the centroid is at the origin
xy_shift = xy - (repmat(xy_centroid',1,n));
XYZ_shift = XYZ - (repmat(XYZ_centroid',1,N));


%compute the scale
d_xs = sum(sqrt(sum(xy_shift.^2)))/n;
d_Xs = sum(sqrt(sum(XYZ_shift.^2)))/N; 

%create T and U 
T = [sqrt(2) / d_xs, 0, -(xs_centroid(1)*sqrt(2))/d_xs;
        0 , sqrt(2) / d_xs, -(xs_centroid(2)*sqrt(2))/d_xs;
        0, 0, 1];

U = [sqrt(3)/d_Xs, 0, 0, -sqrt(3)*XYZ_centroid(1)/d_Xs; 
	0, sqrt(3)/d_Xs, 0, -sqrt(3)*XYZ_centroid(2)/d_Xs; 
	0, 0,sqrt(3)/d_Xs,-sqrt(3)*XYZ_centroid(3)/d_Xs; 		
	0,0,0, 1]

%normalize the points according to the transformation
xy_normalized = T * [xy; ones(1,n)];
XYZ_normalized = U * [XYZ; ones(1,N)];



end