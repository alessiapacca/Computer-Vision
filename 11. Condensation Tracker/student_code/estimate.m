function meanState = estimate(particles,particles_w)

n = size(particles,2);
meanState = zeros(1,n);
for i = 1:n
    res = (particles_w .* particles(:,i));
    meanState(i) = sum(res);
end

end

