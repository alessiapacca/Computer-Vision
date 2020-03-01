% Compute the distance for pairs of points and lines
% Input
%   points    Homogeneous 2D points 3xN
%   lines     2D homogeneous line equation 3xN
% 
% Output
%   d         Distances from each point to the corresponding line N
function d = distPointsLines(points, lines)
n = size(points,2);
d = zeros(1,n);
for i = 1:n
    d(i) = abs(lines(1,i)*points(1,i) + lines(2,i)*points(2,i) + lines(3,i))/(sqrt(lines(1,i)^2 + lines(2,i)^2));
end
end

