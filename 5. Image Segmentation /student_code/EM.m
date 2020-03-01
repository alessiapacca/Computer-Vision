function [map, cluster] = EM(img)

%transform to double 
img = im2double(img);

%choose K
K = 5;

%reshape Lx3
[n, m, ~] = size(img);
X = reshape(img, n*m, 3); 
%initialization
generation_vector = [max(X(:,1)), max(X(:,2)), max(X(:,3)); min(X(:,1)), min(X(:,2)), min(X(:,3))];
    
%initialize mu
mu = generate_mu(generation_vector, K);
%initialize covariance
covariance = generate_cov(generation_vector, K);
%initialize alfa
alpha = 1/K.*ones(1,K);

%maximization and expectation
keep = true;
while keep
    P = expectation(mu, covariance, alpha, X);
    [mu_, cov_, alpha_] = maximization(P, X);
    
    %check
    dist = mean(sqrt(sum(((mu_ - mu).^2),2)));
    if (dist <= 0.01)
        keep = false;
    end
    %update 
    mu = mu_;
    covariance = cov_;
    alpha = alpha_;
end

%size P
L = size(P,1);
map = [];
for i=1:L
    [~, index] = max(P(i,:)); %index of where i find the max value of the matrix
    map(i) = index; %for that pixel, i have that index 
end

alpha
covariance
mu
color = linspace(0,1,K)';  %3 points between 0 and 1 
cluster = [color, color, color]; %cluster will contain these 3 colors
map = reshape(map', n, m);  
end
