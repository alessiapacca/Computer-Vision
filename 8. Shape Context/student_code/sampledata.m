function [Xsample,Ysample] = sampledata(x,y,n)
Y1 = x(:,2); %Y coordinate
X1 = x(:,1); %X coordinate
point = randperm(length(x)); %random sequence of size number of points
point = point(1:min(2*n,length(x))); %take until minimum of 2*sample and the number of points

xi=X1(point); 
yi=Y1(point);
xi=xi(:); 
yi=yi(:);
distx=dist2([xi yi],[xi yi]) + diag(999*ones(min(length(x),2*n),1)); %matrix of pair distances, and puts in the diagonal eye matrix*a very big number, cause then we take the minimum 

while size(distx,1) ~= n
   [rowx,~]=min(distx); %finds pair with minimum distance
   [~,colx]=min(rowx);
   distx(:,colx)=[];  %removes the point from the pair distance matrix 
   distx(colx,:)=[];  %removes the point from the pair distance matrix 
   xi(colx)=[];   %removes it also from the matrix to ensure to take just one of the two that are too much close to each other. 
   yi(colx)=[];   %removes it also from the matrix to ensure to take just one of the two that are too much close to each other. 
end
Xsample(:,1) = xi;
Xsample(:,2) = yi;


Y2 = y(:,2); %Y coordinate
X2 = y(:,1); %X coordinate
point2 = randperm(length(y)); %random sequence of size number of points
point2 = point2(1:min(2*n,length(y))); %take until minimum of 2*sample and the number of points

xi2=X2(point2); 
yi2=Y2(point2);
xi2=xi2(:); %column
yi2=yi2(:); %column
disty=dist2([xi2 yi2],[xi2 yi2]) + diag(999*ones(min(2*n,length(y)),1)); %matrix of pair distances, and puts in the diagonal eye matrix*a very big number, then we take the minimum and in the diagonal we have the zero distance  

while size(disty,1) ~= n
   [rowy,~]=min(disty); %finds pair with minimum distance
   [~,coly]=min(rowy);
   disty(:,coly)=[];  
   disty(coly,:)=[];  
   xi2(coly)=[];  
   yi2(coly)=[];  
end
Ysample(:,1) = xi2;
Ysample(:,2) = yi2;