function C = chi2_cost(s1,s2)

%{
Write a function which computes a cost matrix 
between two sets of shape context descriptors. 
The cost matrix should be an n × m matrix giving 
the cost of matching two sets of points based on 
their shape context descriptors. 
We use the one from the slides. 

Cgh is the shape matching costs between two points 
with shape context descriptors g and h, 
each made up of K = nbBinstheta × nbBinsr bins.
%}

n = size(s1,1);
m = size(s2,1);
C = zeros(n,m);


%check not to divide for zero 
for i = 1:n
    for j = 1:m
        %k elements sum 
        C(i,j) = sum(( ((s1(i,:) - s2(j,:)).^2) ./ (s1(i,:)+s2(j,:)+eps) ));
        C(i,j) = 0.5 * C(i,j);
    end
end
end

