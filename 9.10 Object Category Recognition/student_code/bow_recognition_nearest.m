function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  [n,~] = size(histogram);
  [m,~] = size(vBoWPos);
  Dist = zeros(n,1);
  
  %for each vector in histogram calculates the nearest neighbor in vBoWPos
  for i=1:n
      [Dist(i),~] = min(sum((vBoWPos-repmat(histogram(i,:),[m,1])).^2,2));
  end
  
  distPos = Dist;
  
  [m,~] = size(vBoWNeg);
  Dist1 = zeros(n,1);
  
  %for each vector in histogram calculates the nearest neighbor in vBoWNeg
  for i=1:n
      [Dist1(i),~] = min(sum((vBoWNeg-repmat(histogram(i,:),[m,1])).^2,2));
  end
  
  distNeg = Dist1;
  
  if (distPos<distNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
