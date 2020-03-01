% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)


%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

     
%Load images
imgName1 = '../data/house.000.pgm'; %first image
imgName2 = '../data/house.004.pgm'; %last image

tfundamental = 0.0001;
tproj = 0.09;

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);  
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

%in and outs
showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 50);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

x1 = fa(1:2, matches(1,:)); %only x and y coordinates 
x2 = fb(1:2, matches(2,:)); %only x and y coordinates

x1 = makehomogeneous(x1);
x2 = makehomogeneous(x2);

[F,inliers] = ransacfitfundmatrix(x1,x2,tfundamental);  %find F fundamental matrix
%show epipolar geometry of the initialization images. used code from lab4
x2inliers = x2(:,inliers); %x2inliers contains only the inliers
x1inliers = x1(:,inliers);


outliers = setdiff(1:size(matches,2),inliers); %returns the data in A that is not in inliers. so the matches that are not inliers --> outliers
%i add a new script that plots the inliers and outliers in the same image
%and with different colors
x1outliers = x1(:,outliers);
x2outliers = x2(:,outliers);
showInliersAndOutliers(img1, x1inliers(1:2,:), img2, x2inliers(1:2,:),x1outliers(1:2,:), x2outliers(1:2,:), 3);

figure(1);
figure(1), clf, imshow(img1, []); hold on, plot(x1(1,inliers), x1(2,inliers), '*r'); %in red asterisks the inliers of figure 1
%draw epipolar lines in figure 1 with code from lab 4
for i = 1:size(x2inliers, 2)
    drawEpipolarLines(F' * x2inliers(:,i), img1); %draws the epipolar lines with the code for the lab 4
end

figure(2);
figure(2), clf, imshow(img2, []); hold on, plot(x2(1,inliers), x2(2,inliers), '*r'); %In red asterisks the inliers of figure 2
%draw epipolar lines in figure 2 with code from lab 4
for i = 1:size(x1inliers, 2)
    drawEpipolarLines(F * x1inliers(:,i), img2); %draws the epipolar lines with the code for the lab 4
end


%we know that the Essential matrix is K'*F*K
E = K'*F*K;
x1_calibrated = K\x1(:,inliers); %it means x1/K, left division
x2_calibrated = K\x2(:,inliers);

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the inlier matches with the computed projection matrix
[X2, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);

%% Add an addtional view of the scene 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[matches3, scores3] = vl_ubcmatch(da(:,matches(1,inliers)), dc);
x3 = makehomogeneous(fc(1:2, matches3(2,:)));  %homogeneous. riga 2 implica che è la immagine 2
Xr = X2(:, matches3(1,:));

%run 6-point ransac
x3_calibrated = K \ x3; 
[Ps{3}, inliers3] = ransacfitprojmatrix(x3_calibrated, Xr, tproj);
outliers3 = setdiff(1:size(matches3,2),inliers3);
R = K \ Ps{3}(1:3,1:3);

%THE FOLLOWING LINES OF CODE ARE TAKEN FROM THE TXT TO FIX ORIENTATION OF CAMERAS 
if (det(R) < 0 )
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end
%x1new_calibrated = x1_calibrated(:, matches3(1,inliers3)); 
fa_in = fa(:,matches(1,inliers));
% Plot inliers and outliers
xa_in3 = makehomogeneous(fa_in(1:2, matches3(1,:)));
showInliersAndOutliers(img1, xa_in3(1:2,inliers3), img3, x3(1:2,inliers3), xa_in3(1:2,outliers3),x3(1:2,outliers3),10);


%take the inliers for the linear triangulation 
x3_calibrated = x3_calibrated(:,inliers3);
x3_calibrated3 = K\xa_in3;
x3_calibrated3 = x3_calibrated3(:,inliers3);
[X3, ~] = linearTriangulation(Ps{1}, x3_calibrated3, ...
                              Ps{3}, x3_calibrated);

%% Add an addtional view of the scene 

imgName3 = '../data/house.002.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[matches4, scores4] = vl_ubcmatch(da(:,matches(1,inliers)), dc);
x4 = makehomogeneous(fc(1:2, matches4(2,:)));  %homogeneous. riga 2 implica che è la immagine 2
Xr = X2(:, matches4(1,:));

%run 6-point ransac
x4_calibrated = K \ x4; 
[Ps{4}, inliers4] = ransacfitprojmatrix(x4_calibrated, Xr, tproj);
outliers4 = setdiff(1:size(matches4,2),inliers4);
R = K \ Ps{4}(1:3,1:3);

%THE FOLLOWING LINES OF CODE ARE TAKEN FROM THE TXT TO FIX ORIENTATION OF CAMERAS 
if (det(R) < 0 )
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end
%x1new_calibrated = x1_calibrated(:, matches4(1,inliers4)); 
% Plot inliers and outliers
xa_in4 = makehomogeneous(fa_in(1:2, matches4(1,:)));
showInliersAndOutliers(img1, xa_in4(1:2,inliers4), img3, x4(1:2,inliers4), xa_in4(1:2,outliers4),x4(1:2,outliers4),11);

%take the inliers for the linear triangulation 
x4_calibrated = x4_calibrated(:,inliers4);
x4_calibrated4 = K\xa_in4;
x4_calibrated4 = x4_calibrated4(:,inliers4);
[X4, ~] = linearTriangulation(Ps{1}, x4_calibrated4, ...
                              Ps{4}, x4_calibrated);

%% Add an addtional view of the scene 


imgName3 = '../data/house.003.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[matches5, scores5] = vl_ubcmatch(da(:,matches(1,inliers)), dc);
x5 = makehomogeneous(fc(1:2, matches5(2,:)));  %homogeneous. riga 2 implica che è la immagine 2
Xr = X2(:, matches5(1,:));

%run 6-point ransac
x5_calibrated = K \ x5; 
[Ps{5}, inliers5] = ransacfitprojmatrix(x5_calibrated, Xr, tproj);
outliers5 = setdiff(1:size(matches5,2),inliers5);
R = K \ Ps{5}(1:3,1:3);

%THE FOLLOWING LINES OF CODE ARE TAKEN FROM THE TXT TO FIX ORIENTATION OF CAMERAS 
if (det(R) < 0 )
    Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
    Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
end
%x1new_calibrated = x1_calibrated(:, matches5(1,inliers5)); 
% Plot inliers and outliers
xa_in5 = makehomogeneous(fa_in(1:2, matches5(1,:)));
showInliersAndOutliers(img1, xa_in5(1:2,inliers5), img3, x5(1:2,inliers5), xa_in5(1:2,outliers5),x5(1:2,outliers5),12);


%take the inliers for the linear triangulation 
x5_calibrated = x5_calibrated(:,inliers5);
x5_calibrated5 = K\xa_in5;
x5_calibrated5 = x5_calibrated5(:,inliers5);
[X5, ~] = linearTriangulation(Ps{1}, x5_calibrated5, ...
                              Ps{5}, x5_calibrated);


%% Plot stuff
fig=55; 
figure(fig)

%use plot3 to plot the triangulated 3D points
plot3(X2(1,:),X2(2,:),X2(3,:),'r.'); hold on;
plot3(X3(1,:),X3(2,:),X3(3,:),'b.'); hold on;
plot3(X4(1,:),X4(2,:),X4(3,:),'y.'); hold on;
plot3(X5(1,:),X5(2,:),X5(3,:),'g.'); hold on;


%draw cameras
drawCameras(Ps, fig)


%% BONUS: Dense reconstruction with inliers, working

%img = cat(3,img3,img3,img3)/255; %as written in matlab forum, treating a b&w img as rgb
%depth = zeros(size(img3)); %initializing the depth matrix as zeros 
%for i = 1:(size(inliers5,2))
%    depth(round(x5(2,inliers5(i))), round(x5(1,inliers5(i)))) = X5(3,i);
%end
%create3DModel(depth, img, 56)

%% BONUS: Dense reconstruction with stereo geometry, with stereo

imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.001.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = getRectifiedImages(img1, img2);

dispRange = -40:40;

dispStereoL = stereoDisparity(imgRectL, imgRectR, dispRange);
dispStereoR = stereoDisparity(imgRectR, imgRectL, dispRange);

dispStereoL = double(dispStereoL);
dispStereoR = double(dispStereoR);

rgbImage = double(cat(3, imgRectL, imgRectL, imgRectL)) / 255;


shiftedimage = zeros(size(imgRectL));
count = 1;
d
for i = 1:size(imgRectL,1)
    for j = 1:size(imgRectL,2)
        if dispStereoL(i,j)<0
            shiftedimage(:,1:end+dispStereoL(i,j),:) = imgRectL(:,-dispStereoL(i,j)+1:end,:);        
        else
            shiftedimage(:,dispStereoL(i,j)+1:end,:) = imgRectL(:,1:end-dispStereoL(i,j),:);
        end
        count = count + 1
    end
end

triangPoints = linearTriangulation(Ps{1}, imgRectL, Ps{3}, shiftedimage);

depth = zeros(size(imgRectL)); %initializing the depth matrix as zeros
width = size(imgRectL,2);
for i = 1:(size(triangPoints,2)) 
    term1 = round(triangPoints(2,i));
    term2 = round(triangPoints(1,i));
    if(term1 > 0 && term1 < width && term2 > 0 && term2 < width)
        depth(term1, term2) = triangPoints(3,i);
    end
end
create3DModel(depth, rgbImage, 56);

%scale = 1;
%S = [scale 0 0; 0 scale 0; 0 0 1];

%PL = Ps{1}; PL = PL(1:3, :);
%PR = Ps{3}; PR = PR(1:3, :);
%[coords2, ~, POINT] = generatePointCloudFromDisps(dispStereoL, Hleft, Hright, S*PL, S*PR);


%rgbImage = double(cat(3, imgRectL, imgRectL, imgRectL)) / 255;
%depth = zeros(size(imgRectL)); %initializing the depth matrix as zeros
%for i = 1:(size(x3,2)) 
%    depth(round(x3(2,i)), round(x3(1,i))) = POINT(3,i);
%end
%create3DModel(depth, rgbImage, 56);

