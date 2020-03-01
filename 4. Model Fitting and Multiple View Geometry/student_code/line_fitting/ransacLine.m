function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    x = randperm(num_pts,2); 
    sample = data(:,x);   
    while abs(sample(1,1)-sample(1,2)) < eps
            x = randperm(num_pts,2); 
            sample = data(:,x);   
    end

    
    % Compute the distances between all points with the fitting line
     line = sample(:,2) - sample(:,1);
     lineNormalized = line/norm(line);
     normalVector = [-lineNormalized(2),lineNormalized(1)];
     distance = normalVector * (data - repmat(sample(:,1),1,num_pts));
    % Compute the inliers with distances smaller than the threshold
     inlierNum = length(find(abs(distance)<=threshold));
        
    % Update the number of inliers and fitting model if the current model is better.
     if (inlierNum > best_num_inliers) %cioe ho piu inliers ora che prima
         term1 = (sample(2,2)-sample(2,1)); %(y2 - y1)
         term2 = (sample(1,2)-sample(1,1)); %(x2 - x1)
         best_k = term1/term2; 
         best_b = sample(2,1)-best_k*sample(1,1); % y1 - (y2-y1/x2-x1)x1
         best_num_inliers = inlierNum; % i obtain the k and b of that line
     end
       
end
