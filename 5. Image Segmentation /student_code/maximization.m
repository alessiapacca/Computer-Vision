function [mu, var, alpha] = maximization(P, X)

L = size(X,1);
g = sum(P,1); % sum of I for every pixel 
alpha = g./L; % just as defined in the slides

K = size(P,2); %number of segments

% compute mu
mu = zeros(3,K);
for i=1:K
    temp = [P(:,i), P(:,i), P(:,i)]; %so i can multiply every pixel of X to the correspondent value
    mu(:, i) = sum(X.*temp)';
    mu(:, i) = mu(:,i)./g(i);
end

% compute var
var = zeros(3,3*K);
for i=1:K
    indexmin = (i-1)*3+1;
    covk = zeros(3,3);
    for j=1:L
        t = (X(j,:)' - mu(:,i)) * (X(j,:)' - mu(:,i))'.*P(j,i);
        covk = covk + t; %sum 
    end
    covk = covk./g(i);
    var(:,indexmin:indexmin+2) = covk;
end

end