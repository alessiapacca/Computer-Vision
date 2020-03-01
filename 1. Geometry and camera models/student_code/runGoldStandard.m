%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

%update new found solution
P_normalized = [pn(1:4);pn(5:8);pn(9:12)];

%denormalize projection matrix
P = T\(P_normalized*U);

%factorize prokection matrix into K, R and t
[K, R, C] = decompose(P);

t = -R*C;

[~,N] = size(XYZ);
computed_xy = P * [XYZ;ones(1,N)]; 

[n,m]=size(computed_xy);
for i=1:n
   for j=1:m
       computed_xy(i,j) = computed_xy(i,j) / computed_xy(end,j);
   end
end
error = sum(sqrt(sum((xy(1:2,:) - computed_xy(1:2,:)).^2)))/N
end