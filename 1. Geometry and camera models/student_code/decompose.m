%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition

% Compute R, K with QR decomposition such M=K*R 

M = P(1:3, 1:3) 
[invR, invK] = qr(M^-1) 
K = (invK)^-1
R = (invR)^-1 

% Compute camera center C=(cx,cy,cz) such P*C=0 
[~,~,V] = svd(P);
C = V(:,end);
C = hom2cart(C')' %C = C./C(4)
C = C(1:3)


% normalize K such K(3,3)=1
K = K./K(3,3)

% Adjust matrices R and Q so that the diagonal elements of K = intrinsic matrix are non-negative values and R = rotation matrix = orthogonal has det(R)=1

sig = sign(diag(K))
K = sig .* K;
R = sig .* R; %cause if you change K then M is gonna be different 
det(R)

% Compute translation t=-R*C
t = -R*C

end