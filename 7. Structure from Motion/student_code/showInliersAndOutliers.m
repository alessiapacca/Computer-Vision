function showFeatureMatches(img1, corner1, img2, corner2, out1, out2, id)
    [sx, sy, sz] = size(img1);
    img = [img1, img2];
    
    corner2 = corner2 + repmat([sy, 0]', [1, size(corner2, 2)]);
    out2 = out2 + repmat([sy, 0]', [1, size(out2, 2)]);

    
        figure(id), imshow(img, []);    
        hold on, plot(corner1(1,:), corner1(2,:), '+b');
        hold on, plot(corner2(1,:), corner2(2,:), '+b');    
        hold on, plot([corner1(1,:); corner2(1,:)], [corner1(2,:); corner2(2,:)], 'b');
    
        %figure(fig), imshow(img, []);    
        hold on, plot(out1(1,:), out1(2,:), '+r');
        hold on, plot(out2(1,:), out2(2,:), '+r');    
        hold on, plot([out1(1,:); out2(1,:)], [out1(2,:); out2(2,:)], 'r'); 
        
   
    
end
    