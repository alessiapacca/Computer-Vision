%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function

% 1. For each correspondence xi <-> Xi, computes matrix Ai

[n,m] = size(xyn) 
A = zeros(2*m, 12)

for i = 1:m
    A(2*(i-1)+1, 1:4) = (transpose(XYZn(:, i)))
    A(2*(i-1)+1, 5:8) = zeros(1,4)
    A(2*(i-1)+1, 9:12) = -xyn(1,i)*transpose(XYZn(:, i))
    A(2*i, 1:4) = zeros(1,4)
    A(2*i, 5:8) = -transpose(XYZn(:, i))
    A(2*i, 9:12) = xyn(2,i)*transpose(XYZn(:, i))
end

% 2. Compute the Singular Value Decomposition of A
[U,S,V] = svd(A) 

% 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)

[p,q] = size(V)
P_normalized = V(:,q)
P_normalized = [V(1:4,end)'; V(5:8,end)'; V(9:12,end)']
end
