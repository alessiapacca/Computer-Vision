function vCenters = create_codebook(nameDirPos,nameDirNeg,k,numiter)
  
  vImgNames = dir(fullfile(nameDirPos,'*.png'));
  vImgNames = [vImgNames; dir(fullfile(nameDirNeg,'*.png'))];
  
  nImgs = length(vImgNames);
  vFeatures = zeros(0,128); % 16 histograms containing 8 bins
  vPatches = zeros(0,16*16); % 16*16 image patches 
  
  cellWidth = 4;
  cellHeight = 4;
  nPointsX = 10;
  nPointsY = 10;
  border = 8;
  
  % Extract features for all images
  for i=1:nImgs
    
    disp(strcat('  Processing image ', num2str(i),'...'));
    
    % load the image
    img = double(rgb2gray(imread(fullfile(vImgNames(i).folder,vImgNames(i).name))));

    % Collect local feature points for each image
    % and compute a descriptor for each local feature point
    % ...
    % create hog descriptors and patches
    % ...	

    vPoints = grid_points(img,nPointsX,nPointsY,border);
    [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight);
    vFeatures = [vFeatures; descriptors];
    vPatches = [vPatches; patches];
    % every row has a different patch and descriptor. 128 descrittori per ogni patch 
 
  end
  
   vCenters = kmeans1(vFeatures, k, numiter);
   visualize_codebook(vCenters,vFeatures,vPatches,cellWidth,cellHeight);
  
end