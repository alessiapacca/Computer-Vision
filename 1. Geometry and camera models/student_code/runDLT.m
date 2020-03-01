%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)

%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

%denormalize projection matrix
[P] = T\(Pn*U)  %so to write the inverse T\ is ok

%factorize projection matrix into K, R and t
[K, R, C] = decompose(P);   

t = -R*C;
%compute average reprojection error
[~,N] = size(XYZ); %number of 3d points, then I calculate the computed ones throw the P matrix, but with homogeneous coordinates
computed_xy = P * [XYZ;ones(1,N)]; 

[n,m]=size(computed_xy);
for i=1:n
   for j=1:m
       computed_xy(i,j) = computed_xy(i,j) / computed_xy(end,j);
   end
end
error = sum(sqrt(sum((xy(1:2,:) - computed_xy(1:2,:)).^2)))/N


end