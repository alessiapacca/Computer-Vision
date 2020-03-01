function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  %to compute the his- togram to be returned, 
  %assign the descriptors to the cluster centers 
  %and count how many descriptors are assigned to each cluster
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
  %based on minimum distance
  
  [n,~] = size(vCenters);
  histo = zeros(1,n);
  
  for i=1:size(vFeatures,1)
      [~,match] = min(sum((vCenters - repmat(vFeatures(i,:),n,1)).^2,2));
      histo(match) = histo(match) + 1;
  end
end
