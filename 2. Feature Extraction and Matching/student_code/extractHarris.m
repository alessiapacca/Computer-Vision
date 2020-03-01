% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)

img = imgaussfilt(img,sigma);

%compute gradients
opx = [0,0,0; -1,0,1; 0,0,0];
opy = [0,-1,0; 0,0,0; 0,1,0];
Ix = conv2(img,opx,'same');
Iy = conv2(img,opy,'same');

%quiver(Iy,Ix) %abbiamo un nuovo valore per ogni per ogni pixel 

%harris detector non è invariante allo scaling quindi ha senso che non
%tutti gli angoli siano rilevati
%con questo invece ci calcoliamo le componenti di H per ogni pixel, tramite
%un filtro a tutti i vicini
Ix_n = imgaussfilt(Ix.^2, 4); %con una sigma piu grande troviamo i corners piu grandi, non quelli piu piccoli
Iy_n = imgaussfilt(Iy.^2, 4); 
Ixy_n = imgaussfilt(Ix.*Iy, 4); 

R = (Ix_n.* Iy_n - Ixy_n.^2 - k*(Ix_n + Iy_n).^2)

%Threshold R
M = R;
M(M<thresh) = 0;
% M = (M>tresh).*M
%Z = imabsdiff(C1,M)
%image(Z)
%image(M)

localMax = imregionalmax(M,8);
C = localMax.*M;

[r,c] = find(C)
corners = [r';c'];
 
end