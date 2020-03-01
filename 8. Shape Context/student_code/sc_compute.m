function d = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)
%   d - vector containing descriptors for all input points
   
%   X - set of points
%   nbBins_theta - number of bins in the angular dimension
%   nbBins_r - number of bins in the radial dimension
%   smallest_r - the length of the smallest radius
%   biggest_r - the length of the biggest radius

X = X';
[n,~] = size(X);

%angles for checking the whole circle

%Mean distance between all pair of points
%pdist gives pairwise distance between all points
pair_dist = squareform(pdist(X));
norm = mean(squareform(pair_dist));

%Compute the edges
edges = {logspace(log10(smallest_r), log10(biggest_r), nbBins_r), linspace(-180, 180, nbBins_theta)};

numberOfBins =  nbBins_r * nbBins_theta;
d = zeros(n, numberOfBins);

for i=1:n
    otherpoints = zeros(n-1,2);
    counter = 1;
    for j=1:n
        %only if they are different pixels, calculate the distance between
        %them, normalize the radial distance for robustness.
        %then calculate the angular distance with the tan.
        if i~=j
            dist = pair_dist(i,j)/ norm;
            vec = X(j,:) - X(i,:);
            
            angle = atan2d(vec(2), vec(1));
            otherpoints(counter, :) = [dist, angle];
            counter = counter+1;
        end
    end
    hi = hist3(otherpoints, 'Edges', edges);
    d(i,:) = hi(:);
    %otherpoints, the first parameter that i pass, is the data to distribute among the bins (radial and angular), 
    %specified as an (n-1)-by-2 numeric matrix, (n-1) is the number of data points. 
    %Corresponding elements in X(:,1) and X(:,2) 
    %specify the x and y coordinates of 2-D data points.
end

end

