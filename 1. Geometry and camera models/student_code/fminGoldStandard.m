%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)

%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];

%compute reprojection error 
computed_xy = P * XYZ_normalized;
difference = xy_normalized - computed_xy; 

f = sum(sum(diff.^2)); 

end