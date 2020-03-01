function vPoints = grid_points(img,nPointsX,nPointsY,border)

    [n,m] = size(img);
    
    x = floor((n-2*border-1)/(nPointsX-1)); %dimensione di una tacca
    X = (border+1):(x):(n-border); %spaces numbers from border+1 to n-border, equally distanced "x"
    
    y = floor((m-2*border-1)/(nPointsY-1)); %dimensione di una tacca
    Y = (border+1):(y):(m-border);  %spaces numbers from border+1 to n-border, equally distanced "y"
         
    vPoints = [];
 	for i= 1:nPointsX
     	for j= 1:nPointsY
 			vPoints = [vPoints; X(i), Y(j)];
     	end
 	end
end

