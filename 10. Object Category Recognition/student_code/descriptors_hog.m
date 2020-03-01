function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nCellsW = 4; % number of cells for W dimension
    nCellsH = 4; % number of cells for H dimension 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    N = size(vPoints,1);
    descriptors = zeros(N,nBins*16); % one histogram for each of the 16 cells
    patches = zeros(N,pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x));

    nEdges = nBins + 1;
    edges = linspace(-pi,pi,nEdges);
    for i = (1:N) % for all local feature points
        hist = zeros(16,8);
        patch = img(vPoints(i,1)-2*w:vPoints(i,1)+2*w-1,vPoints(i,2)-2*h:vPoints(i,2)+2*h -1);
        patches(i,:) = patch(:);
        rowhist = 1;
        for x = (1:4)
            dx = vPoints(i,1) - 2*w + (x-1)*w;
            for y = (1:4)        
                dy = vPoints(i,2) - 2*h + (y-1)*h;
                cellangle = Gdir(dx : dx+w-1, dy : dy+h-1); %you look at the gradient matrix for every little patch, and then you calculate the histogram  
                hist(rowhist,:) = histcounts(cellangle,edges);
                rowhist = rowhist + 1;
             end
         end

         descriptors(i,:) = reshape(hist',[],1);
     end
end
