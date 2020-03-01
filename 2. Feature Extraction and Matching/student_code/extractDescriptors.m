% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)

[p,q] = size(img)

indices = find(keypoints(1,:)<=4)  %in the matrix keypoints i have the first row that tells me the row index and the second row that tells me the column index
keypoints(:,indices) = []; 
indices = find(keypoints(2,:)<=4)  
keypoints(:,indices) = []; 
indices = find(keypoints(1,:)>= q-4)  
keypoints(:,indices) = []; 
indices = find(keypoints(2,:)>= p-4)  
keypoints(:,indices) = []; 

descriptors = extractPatches(img, keypoints, 9);
[p,q] = size(keypoints)   %210 number of keypoints, 9x9 patch for each one so they will be 81 and 210




 
end