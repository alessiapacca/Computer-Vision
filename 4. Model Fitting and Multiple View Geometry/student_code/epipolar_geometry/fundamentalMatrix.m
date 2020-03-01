% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
[normalizedx1s, T1] = normalizePoints2d(x1s);
[normalizedx2s, T2] = normalizePoints2d(x2s);


%separate xs and ys
x1 = normalizedx1s(1,:)'; %prima riga, trasposta
y1 = normalizedx1s(2,:)'; %seconda riga, trasposta
x2 = normalizedx2s(1,:)'; %prima riga seconda matrice, trasposta
y2 = normalizedx2s(2,:)'; %seconda riga seconda matrice, 

%size
n = size(normalizedx1s,2);

%construct matrix like in the slides
M = [x2.*x1, x2.*y1, x2, y2.*x1, y2.*y1, y2, x1, y1, ones(n,1)];

%svd to get rhs null v
[~,~,V] = svd(M);
f = V(:,end); %l'ultima colonna dovrebbe essere il null vector (soluzione di A) 

%normalize
f = f/norm(f);

%construct F
F = [f(1:3), f(4:6), f(7:9)]'; %costruisco F, 3x3

[U,S,V] = svd(F);
%apply constraints: set last singular value to zero
S(3,3) = 0;

Fh = U * S * V';

%denormalize
F = T2'*F*T1;
Fh = T2'*Fh*T1;


end