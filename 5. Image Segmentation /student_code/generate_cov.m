function cov = generate_cov(ranges, K)
maxL = ranges(1,1);
maxa = ranges(1,2);
maxb = ranges(1,3);
minL = ranges(2,1);
mina = ranges(2,2);
minb = ranges(2,3);

L = (maxL - minL).*rand(1) + minL;
a = (maxa - mina).*rand(1) + mina;
b = (maxb - minb).*rand(1) + minb;

%i have this matrix of diagonal matrixes
cov = zeros(3,3*K);
for i=1:K
    m = [L, a, b];
    index_min = (i-1)*3+1;
    cov(:,index_min:index_min + 2) = diag(m);
end

end





