% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 1000;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;

for i=1:iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    random_index_points = randperm(num_pts,8);

    rp1 = x1(:,random_index_points);
    rp2 = x2(:,random_index_points);
    [~, F1] = fundamentalMatrix(rp1, rp2);
    Fx1 = F1 * x1;
    Ftx2 = F1' * x2;

    % compute the Sampson error.
    
    distance = [];
    distance = distPointsLines(x2, Fx1) + distPointsLines(x1, Ftx2);
    
    
    % compute the inliers with errors smaller than the threshold.
    inliers = (distance < threshold);
    %inliers2 = (distance < threshold);
    %inliers = inliers1 | inliers2;

        
    % update the number of inliers and fitting model if the current model
    % is better.
    if (sum(inliers) > best_num_inliers)
        best_num_inliers = sum(inliers);
        best_inliers = inliers;
        best_F = F1;
    end
    best_num_inliers;
    mean(distance(distance < threshold));
     
     %adaptive ransac
     r = best_num_inliers/num_pts;
     m = i;
     p = 1 - (1 - r ^ 8)^m;
     if (p >= 0.99)
         break;
     end
    
     
end

end


