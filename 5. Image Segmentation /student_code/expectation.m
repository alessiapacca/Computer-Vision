function P = expectation(mu,var,alpha,X)

K = length(alpha); 
L = size(X,1);

P = zeros(L,K);
for i=1:L
    %take one pixel (one row of X) 
    xl = X(i,:);
    %denominator initialization
    s = 0;
    %segment for the specific value of l, 1xK
    p_segment = zeros(1,K); 
    
    for j=1:K
        %mu k 
        muk = mu(:,j);
        %covar k
        index = (j-1)*3+1;
        covar = var(1:3,index:index+2); 
        n = 3;
      
        %prob term (numerator)
        term = 1/(((2*pi)^(n/2))*sqrt(det(covar))) * exp(-0.5*(xl - muk')*(covar\(xl' - muk))); % \ operator is better for inverse        
        p_segment(j) = alpha(j) * term;
        s = s+p_segment(j);
    end
    %divide for the denominator (s is the sum of all the prior ones)
    p_segment = p_segment./s;
    P(i,:) = p_segment;
end
end