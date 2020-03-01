function vCenters = kmeans1(vFeatures,k,numiter)
  N  = size(vFeatures,1);
  N2 = size(vFeatures,2);

  %every cluster center is a random point.
  vCenters = vFeatures(randperm(N,k),:);
  %for numiter iterations
  for i=1:numiter
    %finds for each point the closest cluster      
      [n,~] = size(vFeatures);
      [m,~] = size(vCenters);
 
      closest_cluster = kmeans(vFeatures,k); 
      
      %calculate the mean of the points and then shift the center of the
      %cluster
      for j=1:k
          vCenters(j,:) = mean(vFeatures(find(closest_cluster == j),:));
      end
  end
 
 
end